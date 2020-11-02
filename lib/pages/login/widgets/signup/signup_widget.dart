import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/pages/login/widgets/signup/signup_controller.dart';
import 'package:tcc_project/pages/login/widgets/success/success.dart';
import 'package:tcc_project/widgets/default_loading_widget.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  SignUpController suc = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    Widget _buildEmailTF() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'EMAIL',
            style: kLabelStyle,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              onChanged: suc.setEmail,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                  color: Colors.black, fontFamily: 'OpenSans', fontSize: 16),
            ),
          ),
        ],
      );
    }

    Widget _buildNameTF() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'NOME COMPLETO',
            style: kLabelStyle,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              onChanged: suc.setName,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                  color: Colors.black, fontFamily: 'OpenSans', fontSize: 16),
            ),
          ),
        ],
      );
    }

    Widget _buildPasswordTF() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'SENHA',
            style: kLabelStyle,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              onChanged: suc.setPassword,
              obscureText: true,
              style: TextStyle(
                  color: Colors.black, fontFamily: 'OpenSans', fontSize: 16),
            ),
          ),
        ],
      );
    }

    Widget _buildButton() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RaisedButton(
          onPressed: suc.isValid
              ? () async {
                  suc.setLoading(true);
                  var response = await suc.signUp();
                  suc.setLoading(false);
                  if (response) {
                    Get.to(SuccessPage());
                  }
                }
              : null,
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Theme.of(context).primaryColor,
          child: Text(
            'CADASTRAR',
            style: TextStyle(
              color: Colors.black87,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      );
    }

    return GetX<SignUpController>(builder: (_) {
      if (suc.loading.value) {
        return DefaultLoadingWidget();
      }

      return Column(
        children: <Widget>[
          _buildNameTF(),
          SizedBox(
            height: 15,
          ),
          _buildEmailTF(),
          SizedBox(
            height: 15,
          ),
          _buildPasswordTF(),
          SizedBox(
            height: 15,
          ),
          _buildButton(),
        ],
      );
    });
  }
}
