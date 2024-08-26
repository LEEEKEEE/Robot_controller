import 'dart:io';
import 'dart:async';
import 'dart:convert';
import './global.dart';
import 'dart:typed_data';

class TCPClient {
  Socket? _socket;

  static final TCPClient _instance = TCPClient._internal();

  factory TCPClient() {
    return _instance;
  }

  TCPClient._internal();

  Future<void> connectToServer(String address, int port) async {
    try {
      _socket = await Socket.connect(address, port);
      print('Connected to server: $address:$port');
      GlobalVariables.isTCPConnected.value = true;

      _socket?.listen((data) {
        final message = String.fromCharCodes(data);
        print('Received from server: $message');
      });
    } catch (e) {
      print("Connection error, $e");
      GlobalVariables.isTCPConnected.value = false;
    }
  }

  void sendMessage(Uint8List message) {
    if (_socket == null) {
      print('Not connected to a server');
      return;
    }
    final encodedMessage = message;

    _socket?.add(encodedMessage);

    print('Sent to server: $message');
  }

  void closeConnection() {
    _socket?.close();
    print('Connection closed');
    GlobalVariables.isTCPConnected.value = false;
  }

  void testsendMessage(String message) {
    if (_socket == null) {
      print('Not connected to a server');
      return;
    }
    final encodedMessage = utf8.encode(message);
    _socket?.add(encodedMessage);
    //_socket?.write(message);
    print('Sent to server: $message');
  }
}
