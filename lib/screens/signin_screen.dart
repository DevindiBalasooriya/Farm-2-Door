import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/reusable_widgets/reusable_widget.dart';
import 'package:my_app/screens/admin/admin_screen.dart';
import 'package:my_app/screens/customer/customer_screen.dart';
import 'package:my_app/screens/farmowner/Farm_owner_screen.dart';
import 'package:my_app/screens/reset_password.dart';
import 'package:my_app/screens/signup_screen.dart';
import 'package:my_app/services/database_service.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final DatabaseService _databaseService = DatabaseService();

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Color.fromARGB(255, 238, 129, 4),
                Color.fromARGB(255, 228, 208, 29),
                Color.fromARGB(255, 236, 222, 143),
              ]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.1, 10, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome ",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Sign into your account",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  ClipOval(
                    child: Image.asset(
                      'assets/b.png',
                      height: 120,
                      width: 120,
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                  Colors.white,
                  Color.fromRGBO(245, 243, 240, 1),
                  Color(0xFFC5D4D8)
                ]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  children: [
                    reusableTextField("Enter Email Address",
                        Icons.person_outline, false, _emailTextController),
                    SizedBox(height: 20),
                    ReusablePasswordField(controller: _passwordTextController),
                    SizedBox(height: 20),
                    forgetPassword(context),
                    SignupButton(context, "Log In", () async {
                      String userRole =
                          await _databaseService.userAuthentication(
                              _emailTextController.text,
                              _passwordTextController.text);

                      if (userRole != 'none') {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString(
                            'email', _emailTextController.text);
                        await prefs.setString('role', userRole);

                        if (userRole == 'Admin') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminDashboad()));
                        } else if (userRole == 'Customer') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerHomeScreen()));
                        } else if (userRole == 'Farm owner') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FarmownerHomeScreen()));
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('User authenticated successfully'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Authentication failed'),
                          ),
                        );
                      }
                    }),
                    SizedBox(height: 20),
                    signUpOption(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignupScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      alignment: Alignment.bottomCenter,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.black54),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
