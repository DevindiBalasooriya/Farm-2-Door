import 'package:flutter/material.dart';
import 'package:my_app/model/user.dart';
import 'package:my_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerProfile extends StatefulWidget {
  const OwnerProfile({super.key});

  @override
  State<OwnerProfile> createState() => _OwnerProfileState();
}

class _OwnerProfileState extends State<OwnerProfile> {
  String? _useremail;
  String? _role;

  final DatabaseService _databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _passwordController;
  late TextEditingController _addressController;
  late TextEditingController _feedbackController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _addressController = TextEditingController();
    _feedbackController = TextEditingController();

    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _useremail = prefs.getString('email');
      _role = prefs.getString('role');
    });

    if (_useremail != null) {
      try {
        String email = _useremail!;
        User? user = await _databaseService.getUserByEmail(email);
        if (user != null) {
          setState(() {
            _usernameController.text = user.userName;
            _mobileNumberController.text = user.mobileNumber;
            _addressController.text = user.address;
            _passwordController.text = user.password;
          });
        }
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }
  }

  Future<void> _updateUserDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        String email = _useremail!;
        User? user = await _databaseService.getUserByEmail(email);
        if (user != null) {
          User updatedUser = User(
            id: user.id,
            userName: _usernameController.text,
            mobileNumber: _mobileNumberController.text,
            address: _addressController.text,
            email: email,
            password: _passwordController.text,
            role: _role!,
          );
          String userid = user.id!;
          await _databaseService.updateUser(userid, updatedUser);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );
        }
      } catch (e) {
        print('Error updating user details: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isNotEmpty) {
      try {
        await _databaseService.addFeedback(
            _useremail!, _feedbackController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );
        _feedbackController
            .clear(); // Clear the feedback field after submission
      } catch (e) {
        print('Error submitting feedback: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting feedback: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your feedback')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Profile'),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 16.0),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 187, 206, 101),
              Color.fromARGB(255, 187, 206, 101),
              Color.fromARGB(255, 238, 172, 49),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/logo.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.person),
                          onPressed: () {
                            // Handle profile picture change
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField('Username', _usernameController),
                SizedBox(height: 5),
                _buildTextField('Address', _addressController),
                SizedBox(height: 5),
                _buildTextField('Mobile Number', _mobileNumberController),
                SizedBox(height: 5),
                _buildTextField('Password', _passwordController,
                    obscureText: true),
                SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: _updateUserDetails,
                      child: Text('Save'),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Feedback',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write your feedback here...',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: _submitFeedback,
                      child: Text('Send'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        fillColor: Colors.orange,
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }
}
