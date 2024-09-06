import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT09L_form.dart';
import 'SSFGDT09L_grid.dart';

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
  String sessionID = globals.APP_SESSION;
  String pDocNoGetInHead = '';
  String pDocTypeGetInHead = '';

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
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_SearchCard/${widget.pErpOuCode}/${widget.pAttr1}/${widget.pAppUser}/${widget.pStatusDESC}/${widget.pSoNo}/${widget.pDocDate}'));

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

  Future<void> checkStatusCard(
      String pReceiveNo, String pDocNo, String pDocType) async {
    print('po_status $pReceiveNo Type: ${pReceiveNo.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_check_ISSDirect_validate/${widget.pOuCode}/${widget.pErpOuCode}/$pReceiveNo'));

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataStatusCard = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print(
            'dataStatusCard : $dataStatusCard type : ${dataStatusCard.runtimeType}');

        //
        print('Fetched data: $jsonDecode');

        setState(() {
          // statusCard = dataStatusCard['po_status'] ?? '';
          // messageCard = dataStatusCard['po_message'] ?? '';
          // goToStep = dataStatusCard['po_goto_step'] ?? '';
          checkGoTostep(
            dataStatusCard['po_status'] ?? '',
            dataStatusCard['po_message'] ?? '',
            dataStatusCard['po_goto_step'] ?? '',
            pDocNo,
            pDocType,
          );

          print(
              'po_status : ${dataStatusCard['po_status']} Type: ${dataStatusCard['po_status'.runtimeType]}');
          print(
              'po_message : ${dataStatusCard['po_message']} Type: ${dataStatusCard['po_message'.runtimeType]}');
          print(
              'po_goto_step : ${dataStatusCard['po_goto_step']} Type: ${dataStatusCard['po_goto_step'.runtimeType]}');
        });
        // } else {
        //   print('No items found.');
        // }
      } else {
        print(
            'checkStatusCard Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {});
      print('checkStatusCard ERROR IN Fetch Data : $e');
    }
  }

  void checkGoTostep(String statusCard, String messageCard, String goToStep,
      String pDocNo, String pDocType) {
    //
    print('statusCard : $statusCard Type : ${statusCard.runtimeType}');
    print('messageCard : $messageCard Type : ${messageCard.runtimeType}');
    print('goToStep : $goToStep Type : ${goToStep.runtimeType}');
    if (statusCard == '1') {
      showMessageStatusCard(context, messageCard);
    }
    if (statusCard == '0') {
      getInhead(
        goToStep,
        pDocNo,
        pDocType,
      );
    }
  }

  Future<void> getInhead(
      String goToStep, String pDocNo, String pDocType) async {
    print('pDocNo $pDocNo Type: ${pDocNo.runtimeType}');
    print('pDocType $pDocType Type: ${pDocType.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_1_GET_INHEAD/${widget.pOuCode}/${widget.pErpOuCode}/$sessionID/$pDocNo/$pDocType/${widget.pAppUser}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataGetInHead =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'dataGetInHead : $dataGetInHead type : ${dataGetInHead.runtimeType}');

        //
        print('Fetched data: $jsonDecode');

        setState(() {
          pDocNoGetInHead = dataGetInHead['po_doc_no'] ?? '';
          pDocTypeGetInHead = dataGetInHead['po_doc_type'] ?? '';
          getInheadStpe(
            dataGetInHead['po_doc_no'] ?? '',
            dataGetInHead['po_doc_type'] ?? '',
            dataGetInHead['po_status'],
            dataGetInHead['po_message'],
            goToStep,
          );

          print(
              'po_doc_type : ${dataGetInHead['po_doc_type']} Type: ${dataGetInHead['po_doc_type'.runtimeType]}');
          print(
              'po_doc_no : ${dataGetInHead['po_doc_no']} Type: ${dataGetInHead['po_doc_no'.runtimeType]}');
          print(
              'po_status : ${dataGetInHead['po_status']} Type: ${dataGetInHead['po_status'.runtimeType]}');
          print(
              'po_message : ${dataGetInHead['po_message']} Type: ${dataGetInHead['po_message'.runtimeType]}');
        });
        // } else {
        //   print('No items found.');
        // }
      } else {
        print(
            'getInhead Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {});
      print('getInhead ERROR IN Fetch Data : $e');
    }
  }

  void getInheadStpe(String pDocNoGetInHead, String pDocTypeGetInHead,
      String poStatus, String poMessage, String goToStep) {
    if (poStatus == '1') {
      showMessageStatusCard(context, poMessage);
    }
    if (poStatus == '0') {
      switch (goToStep) {
        case '2':
          return _navigateToPage(
              context,
              Ssfgdt09lForm(
                  pWareCode: widget.pErpOuCode,
                  pAttr1: widget.pAttr1,
                  pDocNo: 'RMO1-WMS-24090028',
                  pDocType: 'RMO1',
                  // pDocNo: pDocNoGetInHead,
                  // pDocType: pDocTypeGetInHead,
                  pOuCode: widget.pOuCode,
                  pErpOuCode: widget.pErpOuCode));
        case '3':
          return _navigateToPage(
              context,
              Ssfgdt09lGrid(
                pWareCode: widget.pErpOuCode,
                pAttr1: widget.pAttr1,
                docNo: 'RMO1-WMS-24090028',
                docType: 'RMO1',
                // docNo: pDocNoGetInHead,
                // docType: pDocTypeGetInHead,
                // test
                statusCase: 'test3',
              ));
        case '4':
          return _navigateToPage(
              context,
              Ssfgdt09lGrid(
                pWareCode: widget.pErpOuCode,
                pAttr1: widget.pAttr1,
                docNo: 'RMO1-WMS-24090028',
                docType: 'RMO1',
                // docNo: pDocNoGetInHead,
                // docType: pDocTypeGetInHead,
                // test
                statusCase: 'test4',
              ));
        default:
          return null;
      }
    }
  }

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
                    color: Color.fromRGBO(204, 235, 252, 1.0),
                    child: InkWell(
                      onTap: () {
                        checkStatusCard(item['po_no'] ?? '',
                            item['p_doc_no'] ?? '', item['p_doc_type'] ?? '');

                        print(
                            'po_no in Card : ${item['po_no']} Type : ${item['po_no'].runtimeType}');
                        print(
                            'p_doc_no in Card : ${item['p_doc_no']} Type : ${item['p_doc_no'].runtimeType}');
                        print(
                            'p_doc_type in Card : ${item['p_doc_type']} Type : ${item['p_doc_type'].runtimeType}');
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
                                  child: Container(
                                    width: 100,
                                    height: 40,
                                    // color: cardColor, // เปลี่ยนสีพื้นหลังที่นี่
                                    child: Image.asset(
                                      'assets/images/printer.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
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
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                          color: cardColor, width: 2.0),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 5.0),
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

  void showMessageStatusCard(
    BuildContext context,
    String messageCard,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'Error',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    messageCard,
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ย้อนกลับ'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
