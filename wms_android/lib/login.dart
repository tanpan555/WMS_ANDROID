import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
// import 'data_api.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class UpperCaseNoSpaceTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove spaces and convert to uppercase
    final formattedText = newValue.text.replaceAll(' ', '').toUpperCase();

    // Calculate the new cursor position
    int newSelectionIndex = newValue.selection.baseOffset;
    int diff = formattedText.length - newValue.text.length;
    newSelectionIndex = newSelectionIndex + diff;

    // Ensure the cursor position is within bounds
    if (newSelectionIndex < 0) {
      newSelectionIndex = 0;
    } else if (newSelectionIndex > formattedText.length) {
      newSelectionIndex = formattedText.length;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _loginError = '';
  // final ApiService _apiService = ApiService();

  bool _isLoading = false;

  Future<void> _signIn() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    setState(() {
      _loginError = '';
      _isLoading = true;
    });

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _loginError = 'Please enter both username and password.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${globals.IP_API}/apex/wms/login_wms/process'),
        body: {
          'P_USERNAME': username,
          'P_PASSWORD': password,
          'P_OU': 'LIK',
          'P_DIV': 'HQ',
          'APP_ALIAS': 'WMS',
          'P_HTTP_HOST': '172.16.0.82:8888',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['PO_STATUS'] == '0') {
          // Login successful
          globals.P_OU_CODE = data['P_OU_CODE'];
          globals.P_OU_NAME = data['P_OU_NAME'];
          globals.P_DIV_CODE = data['P_DIV_CODE'];
          globals.P_SUBINV = data['P_SUBINV'];
          globals.P_SUBINV_NAME = data['P_SUBINV_NAME'];
          globals.APP_SESSION = data['V_AUDSID'];

          globals.P_ERP_OU_CODE = data['P_ERP_OU_CODE'];
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: globals.APP_SESSION,
          );
        } else if (data['PO_STATUS'] == '1') {
          // Clear password and show error
          _passwordController.clear(); // Clear the password field
          setState(() {
            _loginError = data['PO_MESSAGE'];
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      setState(() {
        print(e);
        _loginError = 'username or password Incorrect.';
        _passwordController.clear(); // Clear the password field on error
        _isLoading = false;
      });
      print('Error during login: $e');
    }
  }

  void _forgotPassword() {
    Navigator.pushNamed(context, '/forgotPassword');
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
          color: Color.fromARGB(255, 17, 0, 56),
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
                            color: Colors.white.withOpacity(0.1),
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
                              Text(
                                'Warehouse Management',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _usernameController,
                                inputFormatters: [
                                  UpperCaseNoSpaceTextFormatter()
                                ], // Updated here
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: Icon(Icons.person,
                                        color: Colors.white, size: 20),
                                  ),
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: FaIcon(FontAwesomeIcons.key,
                                        color: Colors.white, size: 15),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              if (_loginError.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _loginError,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              if (_isLoading)
                                Container(
                                  // color: Color.fromARGB(255, 17, 0, 56),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _signIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
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
                              const TextButton(
                                // onPressed: _forgotPassword,
                                onPressed: null,
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 180, 180, 180),
                                    decoration: TextDecoration.underline,
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
