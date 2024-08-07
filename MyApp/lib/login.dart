import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberUsername = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get _isButtonEnabled {
    return _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  void _signIn() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'SS-STAFF' && password == 'Soft2') {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      // Clear the password field
      _passwordController.clear();
    }
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
              const Color.fromARGB(255, 103, 58, 183), // Purple
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0, 0.6],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.85, // Adjust width relative to screen size
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 230, 226, 237),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8.0,
                          offset: const Offset(20, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo-WMS.png', // Replace with your image asset path
                          height: screenHeight * 0.2, // Adjust height relative to screen size
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 255, 255, 255), // Light gray background
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(13), // Adjust icon padding
                              child: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 112, 112, 112),
                                size: 26.0, // Adjust icon size
                              ),
                            ),
                            hintText: 'Username',
                            hintStyle: TextStyle(
                              fontSize: 18.0, // Adjust label font size
                              color: Color.fromARGB(255, 112, 112, 112), // Adjust label color
                              fontWeight: FontWeight.bold, // Make label text bold
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 255, 255, 255), // Light gray background
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(13), // Adjust icon padding
                              child: FaIcon(
                                FontAwesomeIcons.key,
                                color: Color.fromARGB(255, 112, 112, 112),
                                size: 20.0, // Adjust icon size
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontSize: 18.0, // Adjust label font size
                              color: Color.fromARGB(255, 112, 112, 112), // Adjust label color
                              fontWeight: FontWeight.bold, // Make label text bold
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberUsername,
                              onChanged: (value) {
                                setState(() {
                                  _rememberUsername = value!;
                                });
                              },
                            ),
                            const Text(
                              'Remember Username',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(255, 49, 49, 49),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isButtonEnabled
                                ? _signIn
                                : null, // Call _signIn method
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 103, 58, 183), // Button color
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0), // Adjust button size
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 18.0, // Adjust text size
                                color: Colors.white, // Text color
                                fontWeight: FontWeight.bold, // Make text bold
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle change password action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 255, 255, 255), // Button color
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0), // Adjust button size
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                    color: Color.fromARGB(255, 49, 49, 49)), // Add border
                              ),
                            ),
                            child: const Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 18.0, // Adjust text size
                                color: Color.fromARGB(255, 49, 49, 49), // Text color
                                fontWeight: FontWeight.bold, // Make text bold
                              ),
                            ),
                          ),
                        ),
                      ],
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
