import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart';

import 'package:uuid/uuid.dart';

import './global.dart';

class MqttService {
  final String brokerUri = 'broker.able-ai.kr';
  final int port = 18883;
  final String clientId = 'aicon';
  final String subTopic = 'disab/2app';
  final String pubTopic = 'disab/2edge';

  MqttServerClient? client;
  final ValueNotifier<MqttConnectionState> connectionState =
      ValueNotifier(MqttConnectionState.disconnected);

  int reconnectAttempts = 0;
  static const int maxReconnectAttempts = 3;
  static const Duration reconnectInterval = Duration(seconds: 5);

  static final MqttService _instance = MqttService._internal();

  factory MqttService() {
    return _instance;
  }

  MqttService._internal();

  Future<void> connect() async {
    client = MqttServerClient.withPort(brokerUri, clientId, port);
    client!.logging(on: false);
    client!.setProtocolV311();
    client!.keepAlivePeriod = 20;
    client!.onConnected = onConnected;
    client!.onDisconnected = onDisconnected;

    //  client!.pongCallback = pong;

    /*  final connectOptions =
        MqttConnectMessage().withWillQos(MqttQos.atLeastOnce);
    client!.connectionMessage = connectOptions;*/

    try {
      await client!.connect();
    } catch (e) {
      print('Exception: $e');
      connectionState.value = MqttConnectionState.disconnected;
    }
  }

  /* void _scheduleReconnect() {
    if (reconnectAttempts < maxReconnectAttempts) {
      reconnectAttempts++;
      Timer(reconnectInterval, () => connect());
    } else {
      print(
          'Max reconnection attempts reached. Please check your connection and try again later.');
      reconnectAttempts = 0;
    }
  }*/

  void disconnect() {
    client?.disconnect();
    connectionState.value = MqttConnectionState.disconnected;
    print('MQTT Disconnected');
  }

  void onConnected() {
    connectionState.value = MqttConnectionState.connected;
    reconnectAttempts = 0;
    print('MQTT Connected');
    subscribe(subTopic);
  }

  void onDisconnected() {
    connectionState.value = MqttConnectionState.disconnected;
    print('MQTT Disconnected');
    // _scheduleReconnect();
  }

  void pong() {
    print('Ping response received');
  }

  void subscribe(String topic) {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      client!.subscribe(topic, MqttQos.atLeastOnce);
      client!.updates!
          .listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final MqttPublishMessage message =
            messages[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);

        try {
          final decoded = jsonDecode(payload);
          print('Received message on $topic: $decoded');
        } catch (e) {
          print('Error decoding message: $e');
        }
      });
      // sendMqttStart();
    } else {
      print('MQTT client is not connected. Cannot subscribe.');
    }
  }

  void sendMessage(String topic, Map<String, dynamic> jsonData) {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(jsonEncode(jsonData));

      try {
        client!.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
        );
        print('Sent message to $topic: $jsonData');
      } catch (e) {
        print('Error sending message: $e');
      }
    } else {
      print('MQTT client is not connected. Cannot send message.');
    }
  }

  Future<void> sendMqttStart() async {
    String macAddress;

    try {
      macAddress = const Uuid().v4();
      print(macAddress);
    } catch (e) {
      macAddress = '00:00:00:00:00:00';
    }

    final data = {
      'mac': macAddress,
      'timestamp': DateTime.now().toIso8601String(),
      'client': clientId,
      'cmd': 'stt_start',
      'action': 'req_start',
    };

    sendMessage(pubTopic, data);
  }

  Future<void> sendMqttACK() async {
    String macAddress;

    try {
      macAddress = const Uuid().v4();
    } catch (e) {
      macAddress = '00:00:00:00:00:00'; // 실패 시 기본값
    }

    final data = {
      'mac': macAddress,
      'timestamp': DateTime.now().toIso8601String(),
      'client': clientId,
      'cmd': 'stt_start',
      'action': 'ack',
    };

    sendMessage(pubTopic, data);
  }

  bool isConnected() {
    return connectionState.value == MqttConnectionState.connected;
  }
}
