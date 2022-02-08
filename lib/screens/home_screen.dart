import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_multi_topic/controller/battery_controller.dart';
import 'package:mqtt_multi_topic/controller/connection_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // battery data
            GetBuilder<BatteryController>(
              init: BatteryController(),
              id: 'battery',
              builder: (batteryController) {
                return Text(batteryController.battery.value);
              },
            ),

            // connection data
            GetBuilder<ConnectionController>(
              init: ConnectionController(),
              id: 'connection',
              builder: (connectionController) {
                return Text(connectionController.connection.value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
