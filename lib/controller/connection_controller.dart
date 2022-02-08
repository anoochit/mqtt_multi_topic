import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_multi_topic/const.dart';

class ConnectionController extends GetxController {
  late MqttServerClient client;

  RxString connection = "{}".obs;

  @override
  void onInit() {
    super.onInit();
    mqttSubscribe();
  }

  void mqttSubscribe() async {
    client = MqttServerClient.withPort(mqttHost, mqttClientId + "_connection", mqttPort);
    client.keepAlivePeriod = 30;
    client.autoReconnect = true;

    await client.connect();

    client.onConnected = () {
      log('MQTT connected');
    };

    client.onDisconnected = () {
      log('MQTT disconnected');
    };

    client.onSubscribed = (String topic) {
      log('MQTT subscribed to $topic');
    };

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe("connection", MqttQos.exactlyOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess2 = c[0].payload as MqttPublishMessage;
        final jsonString = MqttPublishPayload.bytesToStringAsString(recMess2.payload.message);
        log("message payload 2 => " + jsonString);

        // sample message
        // '{ "lastConnection" : 1644291803676  }'

        // sample command
        // mosquitto_pub -h 192.168.1.40 -r  -t "connection" -m '{ "lastConnection" : 1644291803676 }'

        // update to controller
        connection.value = jsonString;
        update(['connection']);
      });
    }
  }
}
