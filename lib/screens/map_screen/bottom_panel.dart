import 'package:flutter/material.dart';

class MapPanelWidget extends StatelessWidget {
  const MapPanelWidget({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: ListView.separated(
        itemBuilder: (_, index) {
          return SizedBox(
            width: width,
            height: 25,
          );
        },
        separatorBuilder: (_, index) {
          return const Divider(
            height: 10,
          );
        },
        itemCount: 10,
      ),
    );
  }
}
