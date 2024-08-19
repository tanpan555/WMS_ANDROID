import 'package:flutter/material.dart';
import 'custom_appbar.dart';
// import 'custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'test_menu_lv2.dart';
import 'login.dart';
import 'bottombar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', // Set LoginPage as the initial route
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

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> dataMenu = [];
  late String sessionID;
  String newSessionID = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null) {
      sessionID = args;
      fetchData();
      newSessionID = args;
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
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
        print(
            'newSessionID in Main : $newSessionID Type : ${newSessionID.runtimeType}');
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
      // drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20), // Spacing above the grid
            Expanded(
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 5, // Horizontal spacing between cards
                    mainAxisSpacing: 5, // Vertical spacing between cards
                    childAspectRatio: 1.0, // Aspect ratio for each card
                  ),
                  itemCount: dataMenu.length,
                  itemBuilder: (context, index) {
                    final item = dataMenu[index];

                    // Check card_value and set icon and color accordingly
                    // IconData iconData;
                    Color cardColor;
                    String imagePath;

                    switch (item['card_value']) {
                      case 'WMS คลังวัตถุดิบ':
                        imagePath = 'assets/images/open-box2.png';
                        cardColor = Colors.greenAccent;
                        break;
                      case 'WMS คลังสำเร็จรูป':
                        imagePath = 'assets/images/box1.png';
                        cardColor = Colors.blueAccent;
                        break;
                      case 'พิมพ์ Tag':
                        imagePath = 'assets/images/barcode-scanner.png';
                        cardColor = Colors.pinkAccent;
                        break;
                      case 'ตรวจนับประจำงวด':
                        imagePath = 'assets/images/open-box2.png';
                        cardColor = Colors.orangeAccent;
                        break;
                      // Add more cases as needed
                      default:
                        imagePath = 'assets/images/open-box2.png';
                        cardColor = Colors.grey;
                    }

                    return GestureDetector(
                      onTap: () {
                        // Action when the card is tapped
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Clicked on ${item['card_value']}'),
                          ),
                        );

                        // Or navigate to another page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestMenuLv2(
                                menu_id: item['menu_id'],
                                sessionID: newSessionID),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: cardColor, // Set card color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Adjust border radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0), // Add padding
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                imagePath, // ใช้ imagePath ที่กำหนดไว้ใน switch
                                width: 70, // กำหนดขนาดของภาพ
                              ),
                              const SizedBox(height: 20),
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
