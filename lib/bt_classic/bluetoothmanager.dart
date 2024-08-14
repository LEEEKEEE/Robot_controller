import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:robotarm_controller/global.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  BluetoothConnection? _connection;
  StreamSubscription<BluetoothState>? _stateSubscription;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  Function(BluetoothState)? onStateChanged;
  Function(String)? onDataReceived; // 데이터 수신 콜백 추가
  String _messageBuffer = '';

  BluetoothManager._internal() {
    _initialize();
  }

  factory BluetoothManager() {
    return _instance;
  }

  void _initialize() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    _stateSubscription = FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      _bluetoothState = state;
      onStateChanged?.call(state);
    });
  }

  bool get isConnected => _connection != null && _connection!.isConnected;
  BluetoothConnection? get connection => _connection;

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

      connection!.input!.listen(_onDataReceived).onDone(() {});

      return true;
    } catch (e) {
      print('Cannot connect, exception occurred: $e');

      bool reconnected = false;
      for (int i = 0; i < 3; i++) {
        print('Retrying connection (${i + 1}/3)...');

        await Future.delayed(const Duration(seconds: 2)); // 재시도 전 대기

        try {
          _connection = await BluetoothConnection.toAddress(address);

          print('Reconnected to the device');
          connection!.input!.listen(_onDataReceived).onDone(() {});

          reconnected = true;
          break;
        } catch (retryException) {
          print('Retry failed: $retryException');
        }
      }
      return reconnected;
    }
  }

  Future<void> disconnect() async {
    if (_connection != null) {
      await _connection!.close();
      print('Disconnected from the device');
    }
    _connection = null;
  }

  Future<bool> disconnectdevice(String address) async {
    if (_connection != null) {
      await disconnect();
    }
    return false;
  }

  BluetoothState get bluetoothState => _bluetoothState;

  void dispose() {
    _stateSubscription?.cancel();
    disconnect();
  }

  Future<void> sendMessage(List<int> message) async {
    if (isConnected) {
      message = TxData_Check(message);
      _connection!.output.add(Uint8List.fromList(message));
      await _connection!.output.allSent; // 비동기 전송 완료 대기
      print('Data sent: $message');
    } else {
      print('No connection to send data.');
    }
  }

  List<int> TxData_Check(List<int> data) {
    if (data.length > 1) {
      data[1] = (SetTxData.pressed_btn_num & 0xFF);
    }
    return data;
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString.substring(0, index);
      print(_messageBuffer + dataString.substring(0, index));
      _messageBuffer = dataString.substring(index);
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }
}
