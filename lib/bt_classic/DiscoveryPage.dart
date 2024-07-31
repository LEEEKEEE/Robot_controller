import 'dart:async'; // 비동기 프로그래밍을 위한 패키지
import 'package:flutter/material.dart'; // Flutter UI 라이브러리
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'; // Bluetooth 패키지

import './BluetoothDeviceListEntry.dart'; // 블루투스 장치 목록 항목 위젯
import './bluetoothmanager.dart';
import 'package:robotarm_controller/global.dart';

// 블루투스 장치 검색 페이지를 나타내는 StatefulWidget 클래스
class DiscoveryPage extends StatefulWidget {
  // 페이지 시작 시 검색을 자동으로 시작할지 여부를 나타내는 플래그
  final bool start;

  // 생성자: start 매개변수는 기본값으로 true를 가집니다.
  const DiscoveryPage({super.key, this.start = true});

  @override
  _DiscoveryPage createState() => _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  StreamSubscription<BluetoothDiscoveryResult>?
      _streamSubscription; // 블루투스 검색 스트림 구독
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true); // 검색된 블루투스 장치 결과 목록
  bool isDiscovering = false; // 현재 검색 중인지 여부
  final BluetoothManager _bluetoothManager = BluetoothManager();

  _DiscoveryPage(); // 생성자

  @override
  void initState() {
    super.initState();

    // 초기 검색 상태 설정
    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery(); // 검색 시작
    }
  }

  // 검색을 재시작하는 메서드
  void _restartDiscovery() {
    setState(() {
      results.clear(); // 결과 목록 초기화
      isDiscovering = true; // 검색 상태 설정
    });

    _startDiscovery(); // 검색 시작
  }

  // 블루투스 장치 검색을 시작하는 메서드
  void _startDiscovery() {
    // 블루투스 장치 검색 스트림 구독
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        // 이미 존재하는 장치인지 확인
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0) {
          results[existingIndex] = r; // 이미 존재하면 업데이트
        } else {
          results.add(r); // 새로 추가
        }
      });
    });

    // 검색 완료 시 호출되는 콜백
    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false; // 검색 완료 상태로 변경
      });
    });
  }

  @override
  void dispose() {
    // 메모리 누수를 방지하기 위해 dispose 시 스트림 구독 취소
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isDiscovering
            ? const Text('Discovering devices') // 검색 중일 때 제목
            : const Text('Discovered devices'), // 검색 완료 시 제목
        actions: <Widget>[
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white), // 검색 중일 때 로딩 인디케이터
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: _restartDiscovery, // 검색 재시작 버튼
                )
        ],
      ),
      body: ListView.builder(
        itemCount: results.length, // 검색된 장치 수
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          final device = result.device;
          final address = device.address;
          return BluetoothDeviceListEntry(
            device: device,
            rssi: result.rssi,
            onTap: () async {
              try {
                bool bonded = false;
                if (device.isBonded) {
                  print('Unbonding from ${device.address}...');
                  await FlutterBluetoothSerial.instance
                      .removeDeviceBondWithAddress(address); // 페어링 해제
                  print('Unbonding from ${device.address} has succed');
                } else {
                  print('Bonding with ${device.address}...');
                  bonded = (await FlutterBluetoothSerial.instance
                      .bondDeviceAtAddress(address))!; // 페어링
                  print(
                      'Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
                }

                setState(() {
                  // 페어링 상태 업데이트
                  results[results.indexOf(result)] = BluetoothDiscoveryResult(
                      device: BluetoothDevice(
                        name: device.name ?? '',
                        address: address,
                        type: device.type,
                        bondState: bonded
                            ? BluetoothBondState.bonded
                            : BluetoothBondState.none,
                      ),
                      rssi: result.rssi);
                });

                if (bonded) {
                  bool isConnected =
                      await _bluetoothManager.connect(address); // 연결 시도
                  print(
                      'Connected to ${device.address} has ${isConnected ? 'succeeded' : 'failed'}');
                  if (isConnected) {
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Connect succeeded.'),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(), // 팝업 닫기
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      setState(() {
                        GlobalVariables.communityConnect.value = true;
                        GlobalVariables.btdevice_name =
                            device.name ?? 'Unknown';
                        GlobalVariables.btdeviceNameNotifier.value =
                            device.name ?? 'Unknown';
                        GlobalVariables.btdevice_adress = device.address;
                      });
                    }
                  } else {
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Connect failed.'),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(), // 팝업 닫기
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                }
              } catch (ex) {
                // 페어링 중 에러 발생 시 다이얼로그 표시
                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error occured while bonding'),
                        content: Text(ex.toString()),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
