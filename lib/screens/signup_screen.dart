import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/model/user.dart';
import 'package:my_app/reusable_widgets/reusable_widget.dart';
import 'package:my_app/screens/signin_screen.dart';
import 'package:my_app/services/database_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final DatabaseService _databaseService = DatabaseService();

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _addressTeTextController = TextEditingController();
  TextEditingController _mobileTeTextController = TextEditingController();

  String _selectedRole = 'Customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign In",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // First Container - 35%
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(255, 238, 129, 4),
                      Color.fromARGB(255, 228, 208, 29),
                      Color.fromARGB(255, 236, 222, 143),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.27,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Welcome Back",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Create new account",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Second Container - 65%
              Container(
                height: MediaQuery.of(context).size.height * 0.73,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                    Colors.white,
                    Color.fromRGBO(245, 243, 240, 1),
                    Color(0xFFC5D4D8)
                  ]),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 15,
                      ),
                      reusableTextField("Enter UserName", Icons.person_outline,
                          false, _userNameTextController),
                      const SizedBox(
                        height: 15,
                      ),
                      reusableTextField("Enter Address", Icons.location_city,
                          false, _addressTeTextController),
                      const SizedBox(
                        height: 15,
                      ),
                      reusableTextField(
                          "Enter Mobile Number",
                          Icons.mobile_friendly,
                          false,
                          _mobileTeTextController),
                      const SizedBox(
                        height: 15,
                      ),
                      reusableTextField("Enter Email Address",
                          Icons.email_outlined, false, _emailTextController),
                      const SizedBox(
                        height: 15,
                      ),
                      ReusablePasswordField(
                          controller: _passwordTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      // Role selection widget
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Role",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Customer',
                                groupValue: _selectedRole,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRole = value!;
                                  });
                                },
                              ),
                              Text(
                                'Customer',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(width: 20),
                              Radio<String>(
                                value: 'Farm owner',
                                groupValue: _selectedRole,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRole = value!;
                                  });
                                },
                              ),
                              Text(
                                'Farm owner',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SignupButton(context, "Sign Up", () async {
                        User user = User(
                          userName: _userNameTextController.text,
                          address: _addressTeTextController.text,
                          mobileNumber: _mobileTeTextController.text,
                          email: _emailTextController.text,
                          password: _passwordTextController.text,
                          role: _selectedRole,
                        );

                        bool isRegistered =
                            await _databaseService.addUser(user);

                        if (isRegistered) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User registered successfully'),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SigninScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Registration failed'),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
