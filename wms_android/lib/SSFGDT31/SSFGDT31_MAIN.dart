import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/centered_message.dart';
import 'SSFGDT31_menu.dart';

class SSFGDT31_MAIN extends StatefulWidget {
  const SSFGDT31_MAIN({
    Key? key,
  }) : super(key: key);
  @override
  _SSFGDT31_MAINState createState() => _SSFGDT31_MAINState();
}

class _SSFGDT31_MAINState extends State<SSFGDT31_MAIN> {
  List<dynamic> dataWareCode = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
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
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_1_WareCode/${globals.ATTR1}/${globals.P_ERP_OU_CODE}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataWareCode =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            isLoading = false;
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
      appBar: CustomAppBar(
          title: 'รับคืนจากการเบิกเพื่อผลผลิต', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  : dataWareCode.isEmpty
                      ? const Center(child: CenteredMessage())
                      : SingleChildScrollView(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: dataWareCode.length,
                            itemBuilder: (context, index) {
                              final item = dataWareCode[index];
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
                                default:
                                  imagePath =
                                      'assets/images/warehouse_blue.png';
                                  cardColor = Colors.white;
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Ssfgdt31Menu(
                                        pWareCode: item['ware_code'],
                                        pWareName: item['ware_name'],
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  color: cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          imagePath,
                                          width: 60,
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
      bottomNavigationBar: const BottomBar(
        currentPage: 'not_show',
      ),
    );
  }
}
