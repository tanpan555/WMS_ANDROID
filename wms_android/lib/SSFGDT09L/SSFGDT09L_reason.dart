import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;

class Ssfgdt09lReason extends StatefulWidget {
  // final String pWareCode;
  final String pOuCode;
  final String pErpOuCode;
  final String pDocNo;
  final String pMoDoNO;
  final String pItemCode;
  final String pQty;
  final String pBarcode;
  final String pLotNo;
  // final String pOuCode;
  // final String pAttr1;
  // final String pAppUser;
  // final String pDocType;
  Ssfgdt09lReason({
    required this.pOuCode,
    required this.pErpOuCode,
    required this.pDocNo,
    required this.pMoDoNO,
    required this.pItemCode,
    required this.pQty,
    required this.pBarcode,
    required this.pLotNo,
    // required this.pWareCode,
    // required this.pOuCode,
    // required this.pDocType,
    // required this.pAttr1,
    // required this.pAppUser,
    Key? key,
  }) : super(key: key);
  @override
  _Ssfgdt09lReasonState createState() => _Ssfgdt09lReasonState();
}

class _Ssfgdt09lReasonState extends State<Ssfgdt09lReason> {
  List<dynamic> dataLovReason = [];
  List<dynamic> dataLovReasonLot = [];
  final List<String> dropdownItemsReasonRpLoc = [
    '--No Value Set--',
    'DF',
    'EM',
    'EL',
    'BM',
    'BL',
    'CM',
  ];

  String reasonLovD = '';
  String reasonLovR = '';
  String reasonRpLocD = '--No Value Set--';
  String reasonRpLocR = 'null';
  String reasonRpLotD = '';
  String reasonRpLotR = '';
  String remark = '';
  String dataNull = 'null';
  String statusSubmit = '';
  String messageSubmit = '';

  Map<String, dynamic>? selectedReasonItem;
  Map<String, dynamic>? selectedLotItem;

  TextEditingController remarkController = TextEditingController();

  // String
  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  void initState() {
    selectLovReason();
    selectLovLot();
    super.initState();
  }

  Future<void> selectLovReason() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLovReason'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovReason =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            selectedReasonItem = dataLovReason[0];
            reasonLovD = selectedReasonItem?['d'] ?? '';
            reasonLovR = selectedReasonItem?['r'] ?? '';
          });
        }
        print('dataLovReason : $dataLovReason');
      } else {
        throw Exception('dataLovReason Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovReason ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovLot() async {
    try {
      final String endpoint = widget.pItemCode != '' &&
              widget.pItemCode.isNotEmpty
          ? 'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLovLot/${widget.pOuCode}/${widget.pMoDoNO}/$reasonRpLocR/${widget.pItemCode}'
          : 'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLovLot/${widget.pOuCode}/${widget.pMoDoNO}/$reasonRpLocR/$dataNull';

      print('Fetching data from: $endpoint');

      final response = await http.get(Uri.parse(endpoint));
      // final response = await http.get(Uri.parse(
      //     'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLovLot/${widget.pOuCode}/${widget.pMoDoNO}/$reasonRpLocR/${widget.pItemCode}')),

      //     :
      //     final response = await http.get(Uri.parse(
      //     'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_SelectLovLot/${widget.pOuCode}/${widget.pMoDoNO}/$reasonRpLocR/${widget.pItemCode}'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovReasonLot =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
            selectedLotItem = dataLovReasonLot[0];
            reasonRpLotD = selectedLotItem?['d'] ?? '';
            reasonRpLotR = selectedLotItem?['r'] ?? '';
          });
        }
        print('dataLovReasonLot : $dataLovReasonLot');
      } else {
        throw Exception(
            'dataLovReasonLot Failed to load fetchData status : ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovReasonLot ERROR IN Fetch Data : $e');
    }
  }

  Future<void> submitAddLine() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_4_AddLine';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pErpOuCode': widget.pErpOuCode.isNotEmpty ? widget.pErpOuCode : 'null',
      'pDocNo': widget.pDocNo.isNotEmpty ? widget.pDocNo : 'null',
      'pBarcode': widget.pBarcode.isNotEmpty ? widget.pBarcode : 'null',
      'pItemCode': widget.pItemCode.isNotEmpty ? widget.pItemCode : 'null',
      'pLotNo': widget.pLotNo.isNotEmpty ? widget.pLotNo : 'null',
      'pQty': widget.pQty.isNotEmpty ? widget.pQty : 'null',
      'pReason': reasonLovR.isNotEmpty ? reasonLovR : 'null',
      'pRemark': remark.isNotEmpty ? remark : 'null',
      'pPdLocation': reasonRpLocR.isNotEmpty ? reasonRpLocR : 'null',
      'pReplaceLot': reasonRpLotR.isNotEmpty ? reasonRpLotR : 'null',
    });
    print('Request body: $body');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataSubmit = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataSubmit : $dataSubmit type : ${dataSubmit.runtimeType}');
        if (mounted) {
          setState(() {
            statusSubmit = dataSubmit['po_status'];
            messageSubmit = dataSubmit['po_message'];

            if (statusSubmit == '1') {
              showDialogAlert(context, messageSubmit);
            }
            if (statusSubmit == '0') {
              Navigator.of(context).pop();
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: const CustomAppBar(title: 'Reason'),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12.0),
                //     ),
                //     minimumSize: const Size(10, 20),
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //   ),
                //   child: const Text(
                //     'Check DATA',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    submitAddLine();
                  },
                  style: AppStyles.ConfirmbuttonStyle(),
                  child: Text(
                    'บันทึก',
                    style: AppStyles.ConfirmbuttonTextStyle(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------------------------------------------------------

            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Reason',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),

              value: selectedReasonItem, // ค่าที่เลือกไว้ก่อนหน้า (ถ้ามี)
              items: dataLovReason.map((item) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: item,
                  child: Container(
                    // width: 300, // กำหนดความกว้างของรายการ
                    child: Text(
                      item['reason_desc'],
                      // maxLines: 3, // กำหนดจำนวนบรรทัดสูงสุด
                      overflow: TextOverflow
                          .ellipsis, // เพิ่มข้อความ '...' ถ้าข้อมูลเกิน
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedReasonItem = value;
                  // เก็บค่า name และ codeName
                  reasonLovD = value?['d'] ?? '';
                  reasonLovR = value?['r'] ?? '';

                  // แสดงค่าที่ถูกเลือก
                  print('d: $reasonLovD, r: $reasonLovR');
                });
              },
              dropdownColor: Colors.white, // กำหนดสีพื้นหลังของ dropdown
              style: const TextStyle(
                  color: Colors
                      .black), // กำหนดสีตัวอักษรเมื่อแสดงรายการที่ถูกเลือก
            ),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            DropdownButtonFormField<String>(
              value: reasonRpLocD,
              items: dropdownItemsReasonRpLoc
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Replace Location',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  reasonRpLocD = value ?? '';
                  switch (reasonRpLocD) {
                    case '--No Value Set--':
                      reasonRpLocR = 'null';
                      break;
                    case 'DF':
                      reasonRpLocR = 'DF';
                      break;
                    case 'EM':
                      reasonRpLocR = 'EM';
                      break;
                    case 'EL':
                      reasonRpLocR = 'EL';
                      break;
                    case 'BM':
                      reasonRpLocR = 'BM';
                      break;
                    case 'BL':
                      reasonRpLocR = 'BL';
                      break;
                    case 'CM':
                      reasonRpLocR = 'CM';
                      break;
                    default:
                      reasonRpLocR = 'Unknown';
                  }
                  selectLovLot();
                });
              },
            ),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Replace LOT',
                labelStyle: TextStyle(
                  color: Colors.black87,
                ),
              ),

              value: selectedLotItem, // ค่าที่เลือกไว้ก่อนหน้า (ถ้ามี)
              items: dataLovReasonLot.map((item) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: item,
                  child: Container(
                    // width: 300, // กำหนดความกว้างของรายการ
                    child: Text(
                      item['d'] ?? '',
                      // maxLines: 3, // กำหนดจำนวนบรรทัดสูงสุด
                      overflow: TextOverflow
                          .ellipsis, // เพิ่มข้อความ '...' ถ้าข้อมูลเกิน
                      // style: TextStyle(
                      //   fontSize: 12,
                      // ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLotItem = value;
                  // เก็บค่า name และ codeName
                  reasonRpLotD = value?['d'] ?? '';
                  reasonRpLotR = value?['r'] ?? '';

                  // แสดงค่าที่ถูกเลือก
                  print('d: $reasonRpLotD, r: $reasonRpLotR');
                });
              },
              dropdownColor: Colors.white, // กำหนดสีพื้นหลังของ dropdown
              style: const TextStyle(
                  color: Colors
                      .black), // กำหนดสีตัวอักษรเมื่อแสดงรายการที่ถูกเลือก
            ),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
            TextFormField(
                controller: remarkController,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Remark',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      remark = value;
                    },
                  );
                }),
            const SizedBox(height: 8),
            // --------------------------------------------------------------------------------------------------
          ]))),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showDialogAlert(
    BuildContext context,
    String messageAlert,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'แจ้งเตือน',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Text(
                    messageAlert,
                    style: const TextStyle(color: Colors.red),
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
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ย้อนกลับ'),
                      ),
                    ],
                  )
                ])),
          ),
        );
      },
    );
  }
}
