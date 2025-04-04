import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wms_android/Global_API.dart';
import 'package:wms_android/Global_ConfirmDialog.dart';
import 'dart:ui';
// import 'data_api.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    final formattedText = newValue.text.replaceAll(' ', '').toUpperCase();

    int newSelectionIndex = newValue.selection.baseOffset;
    int diff = formattedText.length - newValue.text.length;
    newSelectionIndex = newSelectionIndex + diff;

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
  String appVersion = 'Unknown';
  bool Loading_Update = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _loginError = '';
  // final ApiService _apiService = ApiService();

  bool _isLoading = false;

  @override
  initState() {
    initializeApp();
    super.initState();
    
  }

  Future<void> initializeApp() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version.isNotEmpty ? packageInfo.version : 'Unknown';
      print("App Version: $appVersion");
      
      setState(() {    
        // Loading_Update = true;   
        });
    } catch (e) {
      print("Initialization Error: $e");
    } finally {
      setState(() {
        // Loading_Update = true;
      });
    }
  }

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
      // print(Uri.parse('${globals.IP_API}/apex/wms/login_wms/process'));
      // print({
      //     'P_USERNAME': username,
      //     'P_PASSWORD': password,
      //     'P_OU': 'LIK',
      //     'P_DIV': 'HQ',
      //     'APP_ALIAS': 'WMS',
      //     'P_HTTP_HOST': '172.16.0.125:8080',
      //   });
      final response = await http.post(
        Uri.parse('${globals.IP_API}/apex/wms/login_wms/process'),
        body: {
          'P_USERNAME': username,
          'P_PASSWORD': password,
          'P_OU': 'LIK',
          'P_DIV': 'HQ',
          'APP_ALIAS': 'WMS',
          'P_HTTP_HOST': '172.16.0.125:8080',
        },
      );
      print('response.statusCode : ${response.statusCode}');
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

  Future<void> checkForUpdate(BuildContext context) async {
    if(appVersion == 'Unknown') {
      print("App version is unknown, skipping update check.");
      return;
    }else{
      Loading_Update = true;
      try {
      final response = await apiget2('mb_ver/APK_PROCESS', {'p_version': appVersion});
      print('response : $response');
      // print('response :${response[0]['po_status'] == '1'}');
      if (response[0]['po_status'] == '1') {
        String downloadUrl = response[0]['po_message'];
        // print("Version mismatch detected, showing dialog...");
        final bool? confirm = await showConfirmationDialog(
            context: context,
            title: 'อัปเดตแอปใหม่!',
            content: 'มีเวอร์ชันใหม่\nกรุณาอัปเดต');
        if (confirm == true) {
          await downloadAndOpenFile(downloadUrl, context);
        }
        // showDialog(context: context,
        //   builder: (context) => AlertDialog(
        //     title: const Text("อัปเดตแอปใหม่!"),
        //     content: const Text("มีเวอร์ชันใหม่  กรุณาอัปเดต"
        //         ),
        //     actions: [
        //       TextButton(
        //         onPressed: () async {},
        //         child: const Text("อัปเดต"),
        //       ),
        //       TextButton(
        //         onPressed: () => Navigator.pop(context),
        //         child: const Text("ภายหลัง"),
        //       ),
        //     ],
        //   ),
        // );
      } else {
        print("แอปของคุณเป็นเวอร์ชันล่าสุดแล้ว ($appVersion)");
      }
    } catch (e) {
      print("Check Update Error: $e");
    }
    }
    
  }

  Future<void> downloadAndOpenFile(String url, BuildContext context) async {
    Dio dio = Dio(); // สร้าง instance ของ Dio
    ValueNotifier<double> progressNotifier = ValueNotifier(0.0);

    try {
      // แสดง loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: ValueListenableBuilder<double>(
              valueListenable: progressNotifier,
              builder: (context, progress, child) {
                return Row(
                  children: [
                    CircularProgressIndicator(
                        value: progress > 0 ? progress : null),
                    const SizedBox(width: 20),
                    Text(
                        "กำลังดาวน์โหลด ${(progress * 100).toStringAsFixed(0)}%"),
                  ],
                );
              },
            ),
          );
        },
      );

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/app_update.apk';
      // print("Downloading file to: $filePath");
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progressNotifier.value = received / total;
          }
        },
      );

      // ปิด loading dialog
      Navigator.pop(context);

      // เปิดไฟล์ที่ดาวน์โหลด
      print("Downloaded file to: $filePath");
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done) {
        print("Error opening file: ${result.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ไม่สามารถเปิดไฟล์ได้: ${result.message}")),
        );
      }
    } catch (e) {
      print("Download Error: $e");
      Navigator.pop(context); // ปิด loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาดในการดาวน์โหลด: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    print('Loading_Update : $Loading_Update');
    if (!Loading_Update ) {
      
            WidgetsBinding.instance.addPostFrameCallback((_) {checkForUpdate(context);});
            
          }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: screenHeight - 20,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 17, 0, 56),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
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
                                  const Text(
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
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.all(13),
                                        child: Icon(Icons.person,
                                            color: Colors.white, size: 20),
                                      ),
                                      hintText: 'Username',
                                      hintStyle: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: FaIcon(FontAwesomeIcons.key,
                                            color: Colors.white, size: 15),
                                      ),
                                      hintText: 'Password',
                                      hintStyle: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  if (_loginError.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _loginError,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  if (_isLoading)
                                    const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
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
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                        color:
                                            Color.fromARGB(255, 180, 180, 180),
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
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 17, 0, 56),
            ),
            width: screenWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Version : $appVersion',
                style: const TextStyle(color: Colors.white,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
