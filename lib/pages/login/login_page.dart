import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/pages/login/login_controller.dart';
import 'package:tcc_project/pages/login/widgets/signin/signin_widget.dart';
import 'package:tcc_project/pages/login/widgets/signup/signup_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: SingleChildScrollView(
              child: GetX<LoginController>(builder: (_) {
                if (loginController.loading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 80,
                          child: Center(
                            child: Container(
                              child: Text(
                                "DVDR",
                                style: GoogleFonts.acme(
                                  letterSpacing: 15,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FlatButton(
                              child: Container(
                                decoration: !loginController.firstScreen.value
                                    ? BoxDecoration()
                                    : BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              onPressed: () {
                                loginController.setFirstScreen(true);
                              },
                            ),
                            FlatButton(
                              child: Container(
                                decoration: loginController.firstScreen.value
                                    ? BoxDecoration()
                                    : BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                child: Text("Cadastre-se",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20)),
                              ),
                              onPressed: () {
                                loginController.setFirstScreen(false);
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        loginController.firstScreen.value
                            ? SignInWidget()
                            : SignUpWidget(),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
