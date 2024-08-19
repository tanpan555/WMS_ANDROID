import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bottombar.dart';
import 'test_menu_lv2.dart';
// import 'data_api.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSINDT01/SSINDT01_barcode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drawer Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
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

  // final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchData(); // เรียกใช้ฟังก์ชันเพื่อโหลดข้อมูล
    // _apiService.fetchSessionid().then((_) {
    //   setState(() {}); // อัปเดต UI หลังจากโหลดข้อมูล
    // });
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/menuLv1'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');

        setState(() {
          dataMenu =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          print(globals.APP_USER);
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
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(globals.APP_USER),
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
                    IconData iconData;
                    Color cardColor;

                    switch (item['card_value']) {
                      case 'WMS คลังวัตถุดิบ':
                        iconData = Icons.inventory_2_outlined;
                        cardColor = Colors.blueAccent;
                        break;
                      case 'WMS คลังสำเร็จรูป':
                        iconData = Icons.shopping_bag_outlined;
                        cardColor = Colors.orangeAccent;
                        break;
                      case 'พิมพ์ Tag':
                        iconData = Icons.discount_outlined;
                        cardColor = Colors.greenAccent;
                        break;
                      case 'ตรวจนับประจำงวด':
                        iconData = Icons.folder_outlined;
                        cardColor = Colors.greenAccent;
                        break;
                      // Add more cases as needed
                      default:
                        iconData = Icons.help; // Default icon and color
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
                            builder: (context) =>
                                TestMenuLv2(menu_id: item['menu_id']),
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
                              Icon(
                                iconData,
                                size: 50, // Icon size
                                color: Colors.black,
                              ),
                              const SizedBox(
                                  height: 20), // Spacing between icon and text
                              Text(
                                item['card_value'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8), // Spacing between text
                              Text(
                                item['menu_id'] ?? '',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
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
}
