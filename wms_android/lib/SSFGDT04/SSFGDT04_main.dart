import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT04_SCREEN2.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSFGDT04_MAIN extends StatefulWidget {
  final String p_attr1;
  final String p_ou_code;

  const SSFGDT04_MAIN({
    Key? key,
    required this.p_attr1,
    required this.p_ou_code,
  }) : super(key: key);

  @override
  _SSFGDT04_MAINState createState() => _SSFGDT04_MAINState();
}

class _SSFGDT04_MAINState extends State<SSFGDT04_MAIN> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    print(widget.p_attr1);
    print(widget.p_ou_code);
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/ware_code/${widget.p_ou_code}/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

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
      appBar: CustomAppBar(title: 'รับไม่ตรง (ไม่อ้าง PO)'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              color: Colors.greenAccent,
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
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    Color cardColor;
                    String imagePath;

                    switch (item['ware_code']) {
                      case 'WH000-1':
                        imagePath = 'assets/images/warehouse_blue.png';
                        cardColor = const Color.fromARGB(255, 255, 255, 255);
                        break;
                      case 'WH000':
                        imagePath = 'assets/images/warehouse_blue.png';
                        cardColor = const Color.fromARGB(255, 255, 255, 255);
                        break;
                      case 'WH001':
                        imagePath = 'assets/images/warehouse_blue.png';
                        cardColor = const Color.fromARGB(255, 255, 255, 255);
                        break;
                      default:
                        imagePath = 'assets/images/warehouse2.png';
                        cardColor = const Color.fromARGB(255, 255, 255, 255);
                    }

                    return GestureDetector(
                      onTap: () {
                        // Navigate to SSFGDT04_SCREEN2
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SSFGDT04_SCREEN2(
                              pWareCode: item['ware_code'],
                              pErpOuCode: widget.p_ou_code,
                              // p_attr1: widget.p_attr1,
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
                                item['ware_code'] ?? 'null',
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
