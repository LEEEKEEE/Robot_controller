import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:network_info_plus/network_info_plus.dart';

import './global.dart';

class TCPClient {
  Socket? _socket;

  static final TCPClient _instance = TCPClient._internal();

  factory TCPClient() {
    return _instance;
  }

  TCPClient._internal();

  Future<String?> getIpAddress() async {
    final info = NetworkInfo();
    String? wifiIP = await info.getWifiIP(); // Wi-Fi 연결 시의 IP 주소
    return wifiIP;
  }

  Future<void> connectToServer(String address, int port) async {
    try {
      _socket = await Socket.connect(address, port);
      print('Connected to server: $address:$port');
      GlobalVariables.isTCPConnected.value = true;
      SetRxData.armError.value = true;

      String? ip = await getIpAddress();
      sendIPMessage(ip!);

      List<int> buffer = [];

      // StreamSubscription을 사용해 소켓 데이터를 관리
      StreamSubscription<List<int>>? subscription;

      subscription = _socket?.listen((data) {
        print('received: $data');
        buffer.addAll(data);
        while (buffer.isNotEmpty) {
          if (buffer[0] != 0xAA) {
            buffer.removeAt(0);
            continue;
          }
          if (buffer.length < 6) break; // 최소 패킷 길이

          int dataLength = buffer[4];
          int packetLength =
              5 + dataLength + 1; // 헤더(1) + 플래그(3) + 길이(1) + 데이터(n) + 테일(1)

          if (buffer.length < packetLength) break;

          if (buffer[packetLength - 1] != 0xDD) {
            buffer.removeAt(0);
            continue;
          }

          List<int> packet = buffer.sublist(0, packetLength);
          try {
            processPacket(packet);
          } catch (e) {
            print('Error processing packet: $e');
          }

          buffer = buffer.sublist(packetLength);
        }
      }, onError: (error) {
        print('Socket error: $error');
        GlobalVariables.isTCPConnected.value = false;
        subscription?.cancel(); // 스트림 구독 취소
        _socket?.destroy(); // 소켓 연결 해제
        SetRxData.armError.value = false;
      }, onDone: () {
        print('Connection closed by server.');
        GlobalVariables.isTCPConnected.value = false;
        subscription?.cancel(); // 스트림 구독 취소
        // 여기서 재연결 시도 로직을 넣을 수 있습니다.
        _socket?.destroy(); // 소켓 연결 해제
        SetRxData.armError.value = false;
      }, cancelOnError: true // 에러 발생 시 자동으로 스트림 구독 취소
          );
    } on SocketException catch (e) {
      print('SocketException: ${e.message}');
      // 예외 상황 처리: 재시도 로직을 추가하거나, 사용자에게 알림
      SetRxData.armError.value = false;
      GlobalVariables.isTCPConnected.value = false;
    } catch (e) {
      print("Connection error, $e");
      SetRxData.armError.value = false;
      GlobalVariables.isTCPConnected.value = false;
    }
  }

  void processPacket(List<int> packet) {
    int flag1 = packet[1];
    int flag2 = packet[2];
    int flag3 = packet[3];
    int dataLength = packet[4];

    print('Received packet:');
    print('Flag1: $flag1');
    print('Flag2: $flag2');
    print('Flag2: $flag3');

    if (flag1 == 1) {
      SetRxData.armError.value = true;
    } else if (flag1 == 2) {
      SetRxData.armError.value = false;
    }

    if (flag2 == 1) {
      SetRxData.itemExist.value = true;
      if (dataLength > 0) {
        SetRxData.itemName.value =
            utf8.decode(packet.sublist(5, 5 + dataLength));
      } else {
        SetRxData.itemName.value = ''; // 데이터 길이가 0일 때 빈 문자열로 설정
      }
    } else if (flag2 == 2) {
      SetRxData.itemExist.value = false;
      SetRxData.itemName.value = '';
    }

    if (flag3 == 1) {
      SetRxData.angleError.value = true;
    } else if (flag3 == 2) {
      SetRxData.angleError.value = false;
    }
  }

  void sendMessage(Uint8List message) async {
    if (_socket == null) {
      print('Not connected to a server');
      return;
    }
    if (!SetRxData.armError.value) {
      print('Arm is working');
      return;
    }
    final encodedMessage = message;

    _socket?.add(encodedMessage);
    await _socket?.done;
    print('Sent to server: $message');
  }

  void sendIPMessage(String message) {
    if (_socket == null) {
      print('Not connected to a server');
      return;
    }

    _socket?.write(message);
    print('Sent to server: $message');
  }

  void closeConnection() {
    _socket?.close();
    print('Connection closed');
    GlobalVariables.isTCPConnected.value = false;
    SetRxData.armError.value = false;
  }
}
