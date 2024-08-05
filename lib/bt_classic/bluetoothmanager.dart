import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:robotarm_controller/global.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  BluetoothConnection? _connection;
  StreamSubscription<BluetoothState>? _stateSubscription;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  Function(BluetoothState)? onStateChanged;

  BluetoothManager._internal() {
    _stateSubscription = FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      _bluetoothState = state;
      if (onStateChanged != null) {
        onStateChanged!(state);
      }
    });
  }

  factory BluetoothManager() {
    return _instance;
  }

  bool get isConnected => _connection != null && _connection!.isConnected;

  Future<bool> connect(String address) async {
    if (_connection != null) {
      await disconnect();
    }

    try {
      final BluetoothState state = await FlutterBluetoothSerial.instance.state;
      if (state != BluetoothState.STATE_ON) {
        print('Bluetooth is not enabled.');
        return false;
      }

      _connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
      return true;
    } catch (e) {
      print('Cannot connect, exception occurred: $e');

      // 연결 실패 시 재시도 로직 추가
      bool reconnected = false;
      for (int i = 0; i < 3; i++) {
        print('Retrying connection (${i + 1}/3)...');

        await Future.delayed(const Duration(seconds: 2)); // 재시도 전 대기
        try {
          _connection = await BluetoothConnection.toAddress(address);

          print('Reconnected to the device');
          reconnected = true;
          break;
        } catch (retryException) {
          print('Retry failed: $retryException');
        }
      }
      return reconnected;
    }
  }

  Future<bool> disconnectdevice(String address) async {
    if (_connection != null) {
      await disconnect();
    }
    return false;
  }

  Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
  }

  BluetoothState get bluetoothState => _bluetoothState;

  void dispose() {
    _stateSubscription?.cancel();
    disconnect();
    _connection = null; // Dispose 후 null로 설정
  }

  Future<void> sendMessage(List<int> message) async {
    if (_connection != null && _connection!.isConnected) {
      message = TxData_Check(message);
      _connection!.output.add(Uint8List.fromList(message));
      await _connection!.output.allSent; // 비동기 전송 완료 대기
      print('Data sent: $message');
    }
  }

  void listenForMessages(Function(String) onDataReceived) {
    if (_connection != null && _connection!.isConnected) {
      _connection!.input?.listen((Uint8List data) {
        String message = String.fromCharCodes(data);
        onDataReceived(message);
      });
    }
  }

  List<int> TxData_Check(List<int> data) {
    if (data.length > 1) {
      data[1] = (SetTxData.pressed_btn_num & 0xFF);
    }
    return data;
  }
}
