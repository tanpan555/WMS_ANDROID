import 'package:flutter/material.dart';
import 'package:wms_android/SSINDT01/SSINDT01_WARE.dart';
import 'package:wms_android/SSINDT01/SSINDT01_search.dart';
import 'custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'test_menu_lv2.dart';
import 'login.dart';
import 'bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/custom_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  String _sessionID = '';

  String get sessionID => _sessionID;

  set sessionID(String value) {
    _sessionID = value;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> dataMenu = [];
  late String sessionID;
  String newSessionID = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null) {
      SessionManager().sessionID = args;
      fetchData();
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    String sessionID = SessionManager().sessionID;
    print('sessionID in Main : $sessionID Type : ${sessionID.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/c/menu_level_1/$sessionID'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');

        setState(() {
          dataMenu =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataMenu : $dataMenu');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'Home'),
      // endDrawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: dataMenu.length,
                  itemBuilder: (context, index) {
                    final item = dataMenu[index];

                    Color? cardColor;
                    String imagePath;
                    String p_attr1;
                    String p_ou_code;

                    switch (item['card_value']) {
                      case 'WMS คลังวัตถุดิบ':
                        imagePath = 'assets/images/open-box2.png';
                        cardColor = Colors.green[200];
                        p_attr1 = globals.Raw_Material;
                        p_ou_code = globals.P_ERP_OU_CODE;
                        break;
                      case 'WMS คลังสำเร็จรูป':
                        imagePath = 'assets/images/box1.png';
                        cardColor = Colors.blue[200];
                        p_attr1 = globals.Finishing;
                        p_ou_code = globals.P_ERP_OU_CODE;
                        break;
                      case 'พิมพ์ Tag':
                        imagePath = 'assets/images/barcode-scanner.png';
                        cardColor = Colors.pink[200];
                        p_attr1 = '';
                        p_ou_code = globals.P_ERP_OU_CODE;
                        break;
                      case 'ตรวจนับประจำงวด':
                        imagePath = 'assets/images/open-box2.png';
                        cardColor = Colors.orange[200];
                        p_attr1 = '';
                        p_ou_code = globals.P_ERP_OU_CODE;
                        break;
                      // Add more cases as needed
                      default:
                        imagePath = 'assets/images/open-box2.png';
                        cardColor = Colors.grey;
                        p_attr1 = '';
                        p_ou_code = globals.P_ERP_OU_CODE;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (p_attr1 == globals.Raw_Material) {
                          globals.ATTR1 = 'Raw Material';
                        } else if (p_attr1 == globals.Finishing) {
                          globals.ATTR1 = 'Finishing';
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestMenuLv2(
                              menu_id: item['menu_id'],
                              sessionID: SessionManager().sessionID,
                              p_attr1: p_attr1,
                              p_ou_code: p_ou_code,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        color: cardColor, // Set card color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Adjust border radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0), // Add padding
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                imagePath, // Use imagePath from switch
                                width: 70, // Set image size
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['card_value'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget images(String imageData, {required double size}) {
    return Image.asset(
      imageData,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}
