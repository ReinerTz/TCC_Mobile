import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kHintTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'OpenSans',
);

final kAppBar = AppBar(
  title: Text("DVDR"),
  centerTitle: true,
);

class Constants {
  static final api = "https://dvdr.herokuapp.com/api";
}

class FriendShipStatusEnum {
  static const ACCEPT = 'ACCEPT';
  static const SENT = 'SENT';
  static const RECEIVED = 'RECEIVED';
  static const NONE = 'NONE';
}
