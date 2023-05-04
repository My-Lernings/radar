import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:locale/controllers/initial_data_controller.dart';
import 'package:locale/controllers/marker_locations_controller.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarkersController>(builder: (val) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              getAllLocation();
            },
            child: Icon(Icons.add),
          ),
          appBar: AppBar(
            title: Text(val.markers.length.toString()),
          ),
          body: ListView.separated(
            itemCount: val.markers.length,
            itemBuilder: (_, index) {
              return Text(val.markers[index].toString());
            },
            separatorBuilder: (_, i) {
              return const Divider(
                thickness: 1,
              );
            },
          ));
    });
  }
}
