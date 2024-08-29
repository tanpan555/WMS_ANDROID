import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';

class Ssfgdt09lCard extends StatefulWidget {
  final String pErpOuCode;
  final String pOuCode;
  final String pAttr1;
  final String pAppUser;
  final int pFlag;
  final String pStatusDESC; // สถานะที่เลือก
  final String pSoNo; // เลขที่ใบตรวจนับ
  final String pDocDate; // date format dd-MM-yyyy

  Ssfgdt09lCard({
    Key? key,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pAttr1,
    required this.pAppUser,
    required this.pFlag,
    required this.pStatusDESC,
    required this.pSoNo,
    required this.pDocDate,
  }) : super(key: key);
  @override
  _Ssfgdt09lCardState createState() => _Ssfgdt09lCardState();
}

class _Ssfgdt09lCardState extends State<Ssfgdt09lCard> {
  List<dynamic> dataCard = [];
  String statusCard = '';
  String messageCard = '';
  String goToStep = '';

  @override
  void initState() {
    print(
        'pErpOuCode : ${widget.pErpOuCode} Type : ${widget.pErpOuCode.runtimeType}');
    print('pAttr1 : ${widget.pAttr1} Type : ${widget.pAttr1.runtimeType}');
    print(
        'pAppUser : ${widget.pAppUser} Type : ${widget.pAppUser.runtimeType}');
    print('pFlag : ${widget.pFlag} Type : ${widget.pFlag.runtimeType}');
    print(
        'pStatusDESC : ${widget.pStatusDESC} Type : ${widget.pStatusDESC.runtimeType}');
    print('pSoNo : ${widget.pSoNo} Type : ${widget.pSoNo.runtimeType}');
    print(
        'pDocDate : ${widget.pDocDate} Type : ${widget.pDocDate.runtimeType}');
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
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/searchCard/${widget.pErpOuCode}/${widget.pAttr1}/${widget.pAppUser}/${widget.pFlag}/${widget.pStatusDESC}/${widget.pSoNo}/${widget.pDocDate}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');

        setState(() {
          dataCard =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataCard : $dataCard');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data : $e');
    }
  }

  Future<void> checkStatusCard(String pReceiveNo) async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/checkStatusCard/${widget.pOuCode}/${widget.pErpOuCode}/$pReceiveNo'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          //

          //
          print('Fetched data: $jsonDecode');

          setState(() {
            statusCard = item['po_status'] ?? '';
            messageCard = item['po_message'] ?? '';
            goToStep = item['po_goto_step'] ?? '';
          });
        } else {
          print('No items found.');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data : $e');
    }
  }

  // void checkGoTostep(String statusCard, String messageCard, String goToStep) {
  //   //
  //   print('statusCard : $statusCard Type : ${statusCard.runtimeType}');
  //   print('messageCard : $messageCard Type : ${messageCard.runtimeType}');
  //   print('goToStep : $goToStep Type : ${goToStep.runtimeType}');
  //   switch (goToStep) {
  //     case '2':
  //     return
  //     break;
  //     default:
  //     return print('Status Card Error!!!');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: dataCard.map((item) {
                  Color cardColor;
                  String statusText;
                  String iconImageYorN;

                  switch (item['card_status_desc']) {
                    case 'ปกติ':
                      cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                      statusText = 'ปกติ';
                      break;
                    case 'ยืนยันการจ่าย' || 'ยืนยันการรับ':
                      cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                      statusText = 'ยืนยันการรับ';
                      break;
                    case 'ยกเลิก':
                      cardColor = Color.fromRGBO(208, 206, 206, 1.0);
                      statusText = 'ยกเลิก';
                      break;
                    case 'ระหว่างบันทึก':
                      cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                      statusText = 'ระหว่างบันทึก';
                      break;
                    case 'อ้างอิงแล้ว':
                      cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                      statusText = 'อ้างอิงแล้ว';
                      break;
                    default:
                      cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                      statusText = 'Unknown';
                  }

                  switch (item['qc_yn']) {
                    case 'Y':
                      iconImageYorN = 'assets/images/rt_machine_on.png';
                      break;
                    case 'N':
                      iconImageYorN = 'assets/images/rt_machine_off.png';
                      break;
                    default:
                      iconImageYorN = 'assets/images/rt_machine_off.png';
                  }

                  return Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: cardColor,
                    child: InkWell(
                      onTap: () {
                        checkStatusCard(item['po_no']);
                      },
                      borderRadius: BorderRadius.circular(15.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: Image.asset(
                                      'assets/images/printer.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  '${item['po_date']} ${item['po_no']} ${item['item_stype_desc']}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          // Positioned สำหรับสถานะ
                          if (statusText != 'Unknown')
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                          color: Colors.black, width: 2.0),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          10.0), // เพิ่มระยะห่างระหว่างสถานะและไอคอน
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: Image.asset(
                                      iconImageYorN,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
