import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_multi_topic/controller/battery_controller.dart';
import 'package:mqtt_multi_topic/controller/connection_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  //BatteryController batteryController = Get.put(BatteryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: GetBuilder<BatteryController>(
              init: BatteryController(),
              builder: (controller) {
                try {
                  return Text("${controller.doc["battery"]}");
                } catch (e) {
                  return Text("Error: ${e.toString()}");
                }
              },
            ),
          ),
          Center(
            child: GetBuilder<ConnectionController>(
              init: ConnectionController(),
              builder: (controller) {
                try {
                  return Text("${controller.dd["connection"]}");
                } catch (e) {
                  return Text("Error: ${e.toString()}");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
