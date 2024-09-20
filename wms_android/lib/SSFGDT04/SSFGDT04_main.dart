import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'SSFGDT04_MENU.dart';
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
    print(gb.P_ERP_OU_CODE);
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_1_ware_code/${gb.P_ERP_OU_CODE}/${gb.ATTR1}'));

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
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
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
                        gb.P_WARE_CODE = item['ware_code'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SSFGDT04_MENU(
                              pWareCode: gb.P_WARE_CODE,
                              pErpOuCode: gb.P_ERP_OU_CODE,
                              // p_attr1: widget.p_attr1,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4.0,
                        // margin: const EdgeInsets.symmetric(vertical: 4),
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                imagePath,
                                width: 70,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item['ware_code'] ?? 'null',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
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
