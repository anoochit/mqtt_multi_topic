import 'dart:convert';

import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_multi_topic/const.dart';

class BatteryController extends GetxController {
  late MqttServerClient client;
  
  // RxString battery ="0".obs;
  var doc;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    mqttSubscribe();
  }

  void mqttSubscribe() async {
    client = MqttServerClient.withPort(mqttHost, mqttClientId, mqttPort);
    client.keepAlivePeriod = 30;
    client.autoReconnect = true;

    await client.connect();

    client.onConnected = () {
      print('MQTT connected');
    };

    client.onDisconnected = () {
      print('MQTT disconnected');
    };

    client.onSubscribed = (String topic) {
      print('MQTT subscribed to $topic');
    };

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe("battery", MqttQos.exactlyOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess2 = c[0].payload as MqttPublishMessage;
        final pt2 =
            MqttPublishPayload.bytesToStringAsString(recMess2.payload.message);
        print("message payload 2 => " + pt2);
        doc = json.decode(pt2);
        print("Battery .... ${doc.runtimeType}");
        update();
      });
    }
  }
}
