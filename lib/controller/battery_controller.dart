import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_multi_topic/const.dart';

class BatteryController extends GetxController {
  late MqttServerClient client;

  // battery json string
  RxString battery = "{}".obs;

  @override
  void onInit() {
    super.onInit();
    log("onInit");
    mqttSubscribe();
  }

  void mqttSubscribe() async {
    client = MqttServerClient.withPort(mqttHost, mqttClientId + "_battery", mqttPort);
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
      client.subscribe("battery", MqttQos.exactlyOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess2 = c[0].payload as MqttPublishMessage;
        final jsonString = MqttPublishPayload.bytesToStringAsString(recMess2.payload.message);
        log("message payload 2 => " + jsonString);

        // sample message
        // '{ "batteryLevel" : 82, "batteryStatus": "ok" }'

        // sample command
        // mosquitto_pub -h 192.168.1.40 -r  -t "battery" -m '{ "batteryLevel" : 82, "batteryStatus": "ok" }'

        // update to controller
        this.battery.value = jsonString;
        update(['battery']);
      });
    }
  }
}
