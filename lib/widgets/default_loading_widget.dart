import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        height: 60,
        width: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
