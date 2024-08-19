import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui'; // Import for BackdropFilter
import 'data_api.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _usernameError = '';
  String _passwordError = '';
  String sessionID = '';
  final ApiService _apiService = ApiService();

  // Sign in logic
  void _signIn() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    sessionID = globals.APP_SESSION;

    setState(() {
      _usernameError = '';
      _passwordError = '';
      sessionID = globals.APP_SESSION;
    });

    if (username.isEmpty) {
      setState(() {
        _usernameError = 'Please enter your username.';
      });
    }
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password.';
      });
    }
    if (username.isNotEmpty && password.isNotEmpty) {
      if (username == '1234' && password == '12345678') {
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: sessionID, // ส่ง sessionID เป็น arguments
        );
        print(
            'sessionID in Login : $sessionID Type : ${sessionID.runtimeType}');
      } else {
        _passwordController.clear();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _apiService.fetchSessionid().then((_) {
      setState(() {
        // sessionID = globals.APP_SESSION;
      });
    });
  }

  // Handle forgot password action
  void _forgotPassword() {
    Navigator.pushNamed(
        context, '/forgotPassword'); // Replace with your actual route
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 231, 231, 231), // White
              const Color.fromARGB(255, 17, 0, 56), // Purple
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0, 0.6],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/app-logo.png',
                                height: screenHeight * 0.2,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _usernameController,
                                style: TextStyle(
                                    color: Colors
                                        .white), // Change text color to white
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 112, 112, 112),
                                      size: 20,
                                    ),
                                  ),
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 112, 112, 112),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(
                                          255, 112, 112, 112), // Border color
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 112, 112, 112),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 17, 0,
                                          56), // Focused border color
                                    ),
                                  ),
                                  errorText: _usernameError.isNotEmpty
                                      ? _usernameError
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: TextStyle(
                                    color: Colors
                                        .white), // Change text color to white
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: FaIcon(
                                      FontAwesomeIcons.key,
                                      color: Color.fromARGB(255, 112, 112, 112),
                                      size: 15,
                                    ),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 112, 112, 112),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 112, 112, 112),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 112, 112, 112),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 17, 0, 56),
                                    ),
                                  ),
                                  errorText: _passwordError.isNotEmpty
                                      ? _passwordError
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _signIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 17, 0, 56),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: _forgotPassword,
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 17, 0, 56),
                                    decoration: TextDecoration
                                        .underline, // Underline text
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
