import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/centered_message.dart';
import 'SSFGDT12_search.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;

class SSFGDT12_MAIN extends StatefulWidget {
  final String p_attr1;
  final String pErpOuCode;

  const SSFGDT12_MAIN({
    Key? key,
    required this.p_attr1,
    required this.pErpOuCode,
  }) : super(key: key);
  @override
  _SSFGDT12_MAINState createState() => _SSFGDT12_MAINState();
}

class _SSFGDT12_MAINState extends State<SSFGDT12_MAIN> {
  List<dynamic> data = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    print(widget.p_attr1);
    print(widget.pErpOuCode);
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    isLoading = true;
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT12/SSFGDT12_Step_1_SelectWareCode/${globals.P_ERP_OU_CODE}/${globals.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            data = List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            isLoading = false;
          });
        }
        print('dataMenu : $data');
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
      appBar: CustomAppBar(title: 'ผลการตรวจนับ', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              color: Colors.grey[300],
              child: const Center(
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
              child: isLoading
                  ? Center(child: LoadingIndicator())
                  : data.isEmpty
                      ? const Center(child: CenteredMessage())
                      : SingleChildScrollView(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                  imagePath =
                                      'assets/images/warehouse_blue.png';
                                  cardColor = Colors.white;
                                  break;
                                case 'WH000':
                                  imagePath =
                                      'assets/images/warehouse_blue.png';
                                  cardColor = Colors.white;
                                  break;
                                case 'WH001':
                                  imagePath =
                                      'assets/images/warehouse_blue.png';
                                  cardColor = Colors.white;
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Ssfgdt12Search(
                                        pWareCode: item['ware_code'],
                                        pWareName: item['ware_name'],
                                        pErpOuCode: widget.pErpOuCode,
                                        p_attr1: widget.p_attr1,
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
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust border radius
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        15.0), // Add padding
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          imagePath, // ใช้ imagePath ที่กำหนดไว้ใน switch
                                          width: 60, // กำหนดขนาดของภาพ
                                          height: 60,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          item['ware_code'] ?? 'null!!!!!!',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
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
      bottomNavigationBar: BottomBar(
        currentPage: 'not_show',
      ),
    );
  }
}
