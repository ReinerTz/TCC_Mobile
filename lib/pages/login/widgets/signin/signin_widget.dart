import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/bindings/home/home_binding.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/pages/home/home_page.dart';
import 'package:tcc_project/pages/login/widgets/signin/signin_controller.dart';
import 'package:tcc_project/routes/app_routes.dart';

class SignInWidget extends StatefulWidget {
  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final SignInController signInController = Get.put(SignInController());

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
              onChanged: signInController.setEmail,
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
              onChanged: signInController.setPassword,
              obscureText: true,
              style: TextStyle(
                  color: Colors.black, fontFamily: 'OpenSans', fontSize: 16),
            ),
          ),
        ],
      );
    }

    Widget _buildForgotPassword() {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {},
            child: Text(
              "Esqueci minha senha",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    Widget _buildButton() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RaisedButton(
          onPressed: () async {
            signInController.setLoading(true);
            var response = await signInController.signIn();
            signInController.setLoading(false);
            if (response != null) {
              Get.offAllNamed(Routes.HOME,
                  arguments: {"user": response.toMap()});
            }
          },
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Theme.of(context).primaryColor,
          child: Text(
            'LOGIN',
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

    return GetX<SignInController>(builder: (_) {
      if (signInController.loading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Column(
        children: <Widget>[
          _buildEmailTF(),
          SizedBox(
            height: 15,
          ),
          _buildPasswordTF(),
          _buildForgotPassword(),
          SizedBox(
            height: 15,
          ),
          _buildButton(),
        ],
      );
    });
  }
}
