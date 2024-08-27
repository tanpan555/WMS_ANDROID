import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSINDT01_main.dart';

class SSFGDT01_WARE extends StatefulWidget {
  final String p_attr1;
  final String p_ou_code;

  const SSFGDT01_WARE({
    Key? key,
    required this.p_attr1,
    required this.p_ou_code,
  }) : super(key: key);
  @override
  _SSFGDT01_WAREState createState() => _SSFGDT01_WAREState();
}

class _SSFGDT01_WAREState extends State<SSFGDT01_WARE> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    print(widget.p_attr1);
    print(widget.p_ou_code);
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/ware_code/${widget.p_ou_code}/${widget.p_attr1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');

        setState(() {
          data = List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataMenu : $data');
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
      appBar: CustomAppBar(title: 'ผลการตรวจนับ'),
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
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    // Check card_value and set icon and color accordingly
                    // IconData iconData;
                    Color cardColor;
                    String imagePath;

                    switch (item['ware_code']) {
                      case 'WH000-1':
                        imagePath = 'assets/images/warehouse_blue.png';
                        cardColor = Colors.amber;
                        break;
                      case 'WH000':
                        imagePath = 'assets/images/warehouse_blue.png';
                        cardColor = Colors.amber;
                        break;
                      case 'WH001':
                        imagePath = 'assets/images/warehouse_blue.png';
                        cardColor = Colors.amber;
                        break;
                      // case 'ตรวจนับประจำงวด':
                      //   imagePath = 'assets/images/warehouse_blue.png';
                      //   cardColor = Colors.orangeAccent;
                      //   break;
                      // Add more cases as needed
                      default:
                        imagePath = 'assets/images/warehouse2.png';
                        cardColor = Colors.red;
                    }

                    return GestureDetector(
                      onTap: () {
                        // Action when the card is tapped
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Clicked on ${item['ware_code']}'),
                          ),
                        );
                        // Or navigate to another page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SSINDT01_MAIN(
                              pWareCode: item['ware_code'],
                              pWareName: item['ware_name'],
                              p_ou_code: widget.p_ou_code,
                            ),
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
                              const SizedBox(height: 10),
                              Text(
                                item['ware_code'] ?? 'null!!!!!!',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // const SizedBox(height: 10),
                              // Text(
                              //   item['ware_name'] ?? 'null!!!!!!',
                              //   style: const TextStyle(
                              //     fontSize: 12,
                              //     color: Colors.black,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
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
