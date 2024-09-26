import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:ui';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'SSFGDT09L_menu.dart';

class SSFGDT09L_MAIN extends StatefulWidget {
  final String pAttr1;
  final String pErpOuCode;
  final String pOuCode;

  const SSFGDT09L_MAIN({
    Key? key,
    required this.pAttr1,
    required this.pErpOuCode,
    required this.pOuCode,
  }) : super(key: key);
  @override
  _SSFGDT09L_MAINState createState() => _SSFGDT09L_MAINState();
}

class _SSFGDT09L_MAINState extends State<SSFGDT09L_MAIN> {
  List<dynamic> dataWareCode = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    print(
        'widget.pAttr1 : ${widget.pAttr1} Type : ${widget.pAttr1.runtimeType}');
    print(
        'widget.pErpOuCode : ${widget.pErpOuCode} Type : ${widget.pErpOuCode.runtimeType}');
    print(
        'widget.pOuCode : ${widget.pOuCode} Type : ${widget.pOuCode.runtimeType}');
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
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_SelectWareCode/${widget.pAttr1}/${widget.pErpOuCode}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataWareCode =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataWareCode : $dataWareCode');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('ERROR IN Fetch Data : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(
                  bottom: 8.0), // Add some space below the container
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'เลือกคลังปฏิบัติงาน',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ),
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
                  itemCount: dataWareCode.length,
                  itemBuilder: (context, index) {
                    final item = dataWareCode[index];
                    Color cardColor;
                    String imagePath;

                    switch (item['ware_code']) {
                      case 'WH000-1':
                        imagePath = 'assets/images/warehouse_blue.png';
                        cardColor = Colors.white;
                        break;
                      case 'WH000':
                        imagePath = 'assets/images/warehouse_blue.png';
                        cardColor = Colors.white;
                        break;
                      case 'WH001':
                        imagePath = 'assets/images/warehouse_blue.png';
                        cardColor = Colors.white;
                        break;
                      default:
                        imagePath = 'assets/images/warehouse2.png';
                        cardColor = Colors.red;
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Ssfgdt09lMenu(
                              pWareCode: item['ware_code'],
                              pWareName: item['ware_name'],
                              pErpOuCode: widget.pErpOuCode,
                              pOuCode: widget.pOuCode,
                              pAttr1: widget.pAttr1,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                imagePath,
                                width: 70,
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
