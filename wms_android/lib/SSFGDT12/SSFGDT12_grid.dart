import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'SSFGDT12_main.dart';
import 'SSFGDT12_barcode.dart';

class Ssfgdt12Grid extends StatefulWidget {
  // final String pOuCode;
  // final String browser_language;
  final String nbCountStaff;
  final String nbCountDate;
  final String docNo;
  final String status;
  // final String browser_language;
  final String wareCode; // ware code ที่มาจาก API แต่เป็น null
  final String pErpOuCode;
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String docDate;
  final String countStaff;
  final String p_attr1;
  Ssfgdt12Grid({
    Key? key,
    required this.nbCountStaff,
    required this.nbCountDate,
    required this.docNo,
    required this.status,
    // required this.browser_language,
    required this.wareCode,
    required this.pErpOuCode,
    required this.pWareCode,
    required this.docDate,
    required this.countStaff,
    required this.p_attr1,
  }) : super(key: key);
  @override
  _Ssfgdt12GridState createState() => _Ssfgdt12GridState();
}

class _Ssfgdt12GridState extends State<Ssfgdt12Grid> {
  List<dynamic> dataCard = []; // data ของ card ทั้งหมด
  List<dynamic> dataCheck = []; // check data ก็กดยื่นยันคลังสินค้า
  // List<dynamic> dataLocatorList = []; // data list locator
  // List<dynamic> dataGradeStatuslist = []; // data list status
  // List<dynamic> dataBarcodeList = []; // dataหลังจากแสกน barcode
  List<dynamic> dataSubmit = []; //
  // final FocusNode _focusNode = FocusNode();
  // int seqNumberBarcode = 0; // เก็บต่า seq ที่ได้หลังจากแสกน barcode
  // String dataLocator = ''; // เก็บค่า locator ตรวจนับ
  // String barcodeTextString = ''; // เก็บ barcode
  // String wareCodeBarcode = ''; // เก็บต่า wareCode ที่ได้หลังจากแสกน barcode
  // String itemCodeBarcode = ''; // เก็บต่า itemCode ที่ได้หลังจากแสกน barcode
  // String lotNumberBarcode = ''; // เก็บค่า lot Number
  // String countQuantityBarcode = ''; // เก็บค่า count Quantity
  // String locatorCodeBarcode =
  //     ''; // เก็บต่า locator ระบบ ที่ได้หลังจากแสกน barcode
  // String dataGridStatus = ''; //  เก็บชื่อ status barcode
  // String statusGridBarcode = ''; // เก็บ status barcode
  int vCouQty = 0; // เก็บค่า v_cou_qty
  String appUser = globals.APP_USER;
  String selectedStatusSubmit = 'ให้จำนวนนับเป็นศูนย์';
  String statusCondition = '1';
  String conditionNull = 'null';
  String statusSubmit = '';
  String messageSubmit = '';
  final List<String> dropdownStatusSubmit = [
    'ให้จำนวนนับเป็นศูนย์',
    'ให้จำนวนนับเท่ากับในระบบ',
  ];
  // final TextEditingController barcodeTextController = TextEditingController();
  // final TextEditingController wareCodeBarcodeController =
  //     TextEditingController();
  // final TextEditingController itemCodeBarcodeController =
  //     TextEditingController();
  // final TextEditingController lotNumberBarcodeController =
  //     TextEditingController();
  // final TextEditingController countQuantityBarcodeController =
  //     TextEditingController();
  // final TextEditingController locatorCodeBarcodeController =
  // TextEditingController();
  // String sysQty = '';
  // String diffQty = '';
  // String rowID = ''

  @override
  void dispose() {
    // _focusNode.dispose();
    // barcodeTextController.dispose();
    // wareCodeBarcodeController.dispose();
    // itemCodeBarcodeController.dispose();
    // lotNumberBarcodeController.dispose();
    // countQuantityBarcodeController.dispose();
    // locatorCodeBarcodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    // fetchDataLocator();
    // fetchDataGradeStatus();
    // _focusNode.addListener(() {
    //   if (!_focusNode.hasFocus) {
    //     if (dataLocator.isNotEmpty) {
    //       print(
    //           'have data !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    //       fetchDataBarcode(barcodeTextString, dataLocator);
    //       print(
    //           'barcodeTextString in check focus: $barcodeTextString Type: ${barcodeTextString.runtimeType}');
    //       print(
    //           'dataLocator in check focus: $dataLocator Type: ${dataLocator.runtimeType}');
    //     } else {
    //       print(
    //           'no data !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    //       print(
    //           'barcodeTextString in check focus: $barcodeTextString Type: ${barcodeTextString.runtimeType}');
    //       print(
    //           'dataLocator in check focus: $dataLocator Type: ${dataLocator.runtimeType}');
    //     }
    //   }
    // }
    // );
    print(
        'nbCountStaff : ${widget.nbCountStaff} Type : ${widget.nbCountStaff.runtimeType}');
    print(
        'nbCountDate : ${widget.nbCountDate} Type : ${widget.nbCountDate.runtimeType}');
    print('docNo : ${widget.docNo} Type : ${widget.docNo.runtimeType}');
    print('status : ${widget.status} Type : ${widget.status.runtimeType}');
    print(
        'wareCode : ${widget.wareCode} Type : ${widget.wareCode.runtimeType}');
    print(
        'pErpOuCode : ${widget.pErpOuCode} Type : ${widget.pErpOuCode.runtimeType}');
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
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/cradGrid/${widget.pErpOuCode}/${widget.docNo}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

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

  Future<void> checkData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/checkDataGrid/${widget.pErpOuCode}/${widget.docNo}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataBarcodeList =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = dataBarcodeList['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          //

          //
          print('Fetched dataBarcodeList: $jsonDecode');

          setState(() {
            vCouQty = item['v_cou_qty'] ?? '';
            vCouQty != null || vCouQty != ''
                ? checkVCouQty(context, vCouQty)
                : print('vCouQty == null ');
            print('vCouQty : $vCouQty type : ${vCouQty.runtimeType}');
          });
        } else {
          print('No items found.');
        }
      } else {
        print(
            'dataBarcodeList  Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataBarcodeList Error: $e');
    }
  }

  void checkVCouQty(
    BuildContext context,
    int vCouQty,
  ) {
    if (vCouQty == 0) {
      showDialogconfirm();
    } else {
      showDialogCONFIRMCOUNT();
    }
  }

  Future<void> submitData(String condition) async {
    print(
        'widget.pErpOuCode : ${widget.pErpOuCode} type : ${widget.pErpOuCode.runtimeType}');
    print('widget.docNo : ${widget.docNo} type : ${widget.docNo.runtimeType}');
    print(
        'widget.docDate : ${widget.docDate} type : ${widget.docDate.runtimeType}');
    print(
        'widget.nbCountDate : ${widget.nbCountDate} type : ${widget.nbCountDate.runtimeType}');
    print(
        'widget.countStaff : ${widget.countStaff} type : ${widget.countStaff.runtimeType}');
    print(
        'widget.nbCountStaff : ${widget.nbCountStaff} type : ${widget.nbCountStaff.runtimeType}');
    print('widget.condition : $condition type : ${condition.runtimeType}');
    print('widget.appUser : $appUser type : ${appUser.runtimeType}');
    final url = 'http://172.16.0.82:8888/apex/wms/SSFGDT12/submitData';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'P_ERP_OU_CODE': widget.pErpOuCode,
      'p_doc_no': widget.docNo,
      'p_doc_date': widget.docDate,
      'p_nb_count_date': widget.nbCountDate,
      'p_count_staff': widget.countStaff,
      'p_nb_count_staff': widget.nbCountStaff,
      'p_condition': condition,
      'p_app_user': appUser,
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
        setState(() {
          statusSubmit = dataSubmit['po_status'];
          messageSubmit = dataSubmit['po_message'];
          checkStatusSubmit(
            context,
            statusSubmit,
            messageSubmit,
          );
        });
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Future<void> fetchDataLocator() async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'http://172.16.0.82:8888/apex/wms/SSFGDT12/selsectLocator/${widget.pWareCode}'));

  //     if (response.statusCode == 200) {
  //       final responseBody = utf8.decode(response.bodyBytes);
  //       final responseData = jsonDecode(responseBody);
  //       print('Fetched data: $responseData');

  //       setState(() {
  //         dataLocatorList =
  //             List<Map<String, dynamic>>.from(responseData['items'] ?? []);
  //       });
  //       print('dataLocatorList : $dataLocatorList');
  //     } else {
  //       throw Exception('fetchDataLocator Failed to load fetchData');
  //     }
  //   } catch (e) {
  //     setState(() {});
  //     print('ERROR IN Fetch Data : $e');
  //   }
  // }

  // Future<void> fetchDataGradeStatus() async {
  //   try {
  //     final response = await http.get(
  //         Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT12/gradeStatus'));

  //     if (response.statusCode == 200) {
  //       final responseBody = utf8.decode(response.bodyBytes);
  //       final responseData = jsonDecode(responseBody);
  //       print('Fetched data: $responseData');

  //       setState(() {
  //         dataGradeStatuslist =
  //             List<Map<String, dynamic>>.from(responseData['items'] ?? []);
  //       });
  //       print('dataGradeStatuslist : $dataGradeStatuslist');
  //     } else {
  //       throw Exception(
  //           'fetchDatadataGradeStatuslist Failed to load fetchData');
  //     }
  //   } catch (e) {
  //     setState(() {});
  //     print('ERROR IN Fetch Data : $e');
  //   }
  // }

  // Future<void> fetchDataBarcode(
  //     String barcodeTextString, String dataLocator) async {
  //   print(
  //       'barcodeTextString in fetchDataBarcode: $barcodeTextString Type : ${barcodeTextString.runtimeType}');
  //   print(
  //       'dataLocator in  fetchDataBarcode: $dataLocator Type : ${dataLocator.runtimeType}');
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'http://172.16.0.82:8888/apex/wms/SSFGDT12/dataBarcode/${widget.pErpOuCode}/${widget.docNo}/${widget.pWareCode}/$appUser/$dataLocator/$barcodeTextString'));

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> dataBarcodeList =
  //           jsonDecode(utf8.decode(response.bodyBytes));
  //       final List<dynamic> items = dataBarcodeList['items'];
  //       print(items);
  //       if (items.isNotEmpty) {
  //         final Map<String, dynamic> item = items[0];
  //         //

  //         //
  //         print('Fetched dataBarcodeList: $jsonDecode');

  //         setState(() {
  //           seqNumberBarcode = item['p_count_seq'] ?? '';
  //           wareCodeBarcode = widget.pWareCode;
  //           itemCodeBarcode = item['p_item_code'] ?? '';
  //           locatorCodeBarcode = item['p_curr_loc'] ?? '';

  //           wareCodeBarcodeController.text = wareCodeBarcode;
  //           itemCodeBarcodeController.text = itemCodeBarcode;
  //           locatorCodeBarcodeController.text = locatorCodeBarcode;
  //         });
  //       } else {
  //         print('No items found.');
  //       }
  //     } else {
  //       print(
  //           'dataBarcodeList  Failed to load data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('dataBarcodeList Error: $e');
  //   }
  // }

  Future<void> updateDataGridDetail(int updatedCountQty, String updatedRemark,
      String ou_code, String doc_no, int seq) async {
    final url = 'http://172.16.0.82:8888/apex/wms/SSFGDT12/updateDataGridCrad';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'COUNT_QTY': updatedCountQty,
      'REMARK': updatedRemark,
      'ou_code': ou_code,
      'doc_no': doc_no,
      'seq': seq,
    });
    print('Request body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          // fetchData();
        });
        print('Success: $responseData');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'ผลการตรวจนับ'),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // showAddItemDialog();
                    _navigateToPage(
                        context,
                        Ssfgdt12Barcode(
                          nbCountStaff: widget.nbCountStaff,
                          nbCountDate: widget.nbCountDate,
                          docNo: widget.docNo,
                          status: widget.status,
                          wareCode: widget.wareCode,
                          pErpOuCode: widget.pErpOuCode,
                          pWareCode: widget.pWareCode,
                          docDate: widget.docDate,
                          countStaff: widget.countStaff,
                          p_attr1: widget.p_attr1,
                        )
                        //
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('บันทึกสินค้าเพิ่มเติม'),
                ),
                ElevatedButton(
                  onPressed: () {
                    checkData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('ยื่นยัน'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                border: Border.all(
                  color: Colors.black, // ขอบสีดำ
                  width: 2.0, // ความกว้างของขอบ 2.0
                ),
                borderRadius:
                    BorderRadius.circular(8.0), // เพิ่มมุมโค้งให้กับ Container
              ),
              child: Center(
                child: Text(
                  '${widget.docNo}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // ปรับขนาดตัวอักษรตามที่ต้องการ
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: dataCard.map((item) {
                  // Check card_value and set icon accordingly
                  // String combinedValue = '${item['card_value']}';
                  // IconData iconData;
                  Color cardColor;
                  String statusText;
                  switch (item['status']) {
                    ////      WMS คลังวัตถุดิบ
                    case 'N':
                      // iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Color.fromRGBO(246, 250, 112, 1.0);
                      statusText = 'รอตรวจนับ';
                      break;
                    case 'T':
                      // iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Color.fromRGBO(208, 206, 206, 1.0);
                      statusText = 'กำลังตรวจนับ';
                      break;
                    case 'X':
                      // iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                      statusText = 'ยื่นยันตรวจนับแล้ว';
                      break;
                    case 'A':
                      // iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Color.fromRGBO(208, 206, 206, 1.0);
                      statusText = 'กำลังปรับปรุงจำนวน/มูลค่า';
                      break;
                    case 'B':
                      // iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                      statusText = 'ยืนยันปรับปรุงจำนวน/มูลค่าแล้ว';
                      break;
                    default:
                      // iconData = Icons.help; // Default icon
                      cardColor = Colors.grey;
                      statusText = 'Unknown';
                  }

                  return Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // กำหนดมุมโค้งของ Card
                    ),
                    color: cardColor,
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Ssfgdt12Form(
                        //       docNo: item['doc_no'],
                        //       pOuCode: widget.p_ou_code,
                        //       browser_language: widget.browser_language,
                        //       wareCode: item['ware_code'] ?? 'ware_code',
                        //       // wareCode: item['ware_code'] == null
                        //       // ? 'ware_code  !!!'
                        //       // : item['ware_code'],
                        //     ),
                        //   ),
                        // );
                      },
                      borderRadius: BorderRadius.circular(
                          15.0), // กำหนดมุมโค้งให้ InkWell เช่นกัน
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(
                                16.0), // เพิ่ม padding เพื่อให้ content ไม่ชิดขอบ
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'รหัสสินค้า : ${item['item_code']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                SizedBox(
                                  child: Text(
                                    '${item['get_item_name']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    'จำนวนคงเหลือในระบบ : ${item['sys_qty']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    'ผลต่างการตรวจนับ : ${item['diff_qty']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    'คลังสินค้า : ${item['ware_code']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    'ตำแหน่งจัดเก็บ : ${item['location_code']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border:
                                    Border.all(color: Colors.black, width: 2.0),
                              ),
                              child: Text(
                                statusText, // แสดง STATUS ที่ได้จาก switch case
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8.0,
                            right: 8.0,
                            child: GestureDetector(
                              onTap: () {
                                showDetailsDialog(
                                  context,
                                  item['sys_qty'],
                                  item['diff_qty'],
                                  item['rowid'],
                                  item['count_qty'],
                                  item['remark'] ?? '',
                                  widget.docNo,
                                  widget.pErpOuCode,
                                  item['seq'],
                                  item['item_code'],
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                      color: Colors.black, width: 2.0),
                                ),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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

  void showDetailsDialog(
    BuildContext context,
    int sys_qty,
    int diff_qty,
    String row_ID,
    int count_qty,
    String remark,
    String doc_no,
    String ou_code,
    int seq,
    String item_code,
  ) {
    // สร้าง TextEditingController สำหรับแต่ละฟิลด์
    TextEditingController sysQtyController =
        TextEditingController(text: sys_qty.toString());
    TextEditingController diffQtyController =
        TextEditingController(text: diff_qty.toString());
    TextEditingController countQtyController =
        TextEditingController(text: count_qty.toString());
    TextEditingController remarkController =
        TextEditingController(text: remark.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('รหัสสินค้า $item_code'), // หัวเรื่องของ Dialog
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // จัดชิดซ้าย
                children: [
                  TextFormField(
                    controller: sysQtyController,
                    readOnly: true,
                    decoration:
                        InputDecoration(labelText: 'จำนวนคงเหลือในระบบ'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: diffQtyController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'ผลต่างการตรวจนับ'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: countQtyController,
                    decoration:
                        InputDecoration(labelText: 'จำนวนที่ตรวจนับได้'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: remarkController,
                    decoration: InputDecoration(labelText: 'หมายเหตุสินค้า'),
                    // keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8.0),
                  // Text(
                  // 'Row ID: $row_ID',
                  // style: TextStyle(color: Colors.black54),
                  // ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                // รับค่าจาก TextFormField
                // int updatedSysQty =
                //     int.tryParse(sysQtyController.text) ?? sys_qty;
                // int updatedDiffQty =
                //     int.tryParse(diffQtyController.text) ?? diff_qty;
                int updatedCountQty =
                    int.tryParse(countQtyController.text) ?? count_qty;
                String updatedRemark = remarkController.text.isNotEmpty
                    ? remarkController.text
                    : remark;

                Navigator.of(context).pop();
                await updateDataGridDetail(
                  updatedCountQty,
                  updatedRemark,
                  ou_code,
                  doc_no,
                  seq,
                );
                await fetchData();
                setState(() {});
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog เมื่อกดปุ่มนี้
              },
            ),
          ],
        );
      },
    );
  }

  // void showAddItemDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //             title: Text('Scan Manual Add'),
  //             content: SingleChildScrollView(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.white,
  //                             side: BorderSide(color: Colors.grey),
  //                           ),
  //                           child: const Text('ย้อนกลับ'),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //                     Container(
  //                       padding: const EdgeInsets.all(12.0),
  //                       decoration: BoxDecoration(
  //                         color: Colors.yellow[200],
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 2.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(8.0),
  //                       ),
  //                       child: Center(
  //                         child: Text(
  //                           '${widget.docNo}',
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 20,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     Container(
  //                       padding: const EdgeInsets.all(12.0),
  //                       decoration: BoxDecoration(
  //                         color: Colors.yellow[200],
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 2.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(8.0),
  //                       ),
  //                       child: Center(
  //                         child: Text(
  //                           '$seqNumberBarcode',
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 20,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     DropdownButtonFormField<String>(
  //                       value: dataLocator.isNotEmpty ? dataLocator : null,
  //                       items: dataLocatorList
  //                           .map((item) => DropdownMenuItem<String>(
  //                                 value: item['location_code'],
  //                                 child: Text(item['location_code']),
  //                               ))
  //                           .toList(),
  //                       decoration: InputDecoration(
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.transparent),
  //                           borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.transparent),
  //                           borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         hintText: 'Locator ตรวจนับ',
  //                         hintStyle: TextStyle(color: Colors.blue),
  //                         filled: true,
  //                         fillColor: Colors.blue[50],
  //                       ),
  //                       onChanged: (value) {
  //                         setState(() {
  //                           dataLocator = value ?? '';
  //                         });
  //                       },
  //                     ),
  //                     const SizedBox(height: 10),
  //                     Row(
  //                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Expanded(
  //                           child: TextFormField(
  //                             controller: barcodeTextController,
  //                             focusNode: _focusNode,
  //                             decoration: InputDecoration(
  //                               enabledBorder: OutlineInputBorder(
  //                                 borderSide: const BorderSide(
  //                                     color: Colors.transparent),
  //                                 borderRadius: BorderRadius.circular(5.5),
  //                               ),
  //                               focusedBorder: OutlineInputBorder(
  //                                 borderSide: const BorderSide(
  //                                     color: Colors.transparent),
  //                                 // borderRadius: BorderRadius.circular(5.5),
  //                               ),
  //                               // hintText: 'เลขที่เอกสาร',
  //                               // hintStyle: const TextStyle(color: Colors.blue),
  //                               labelText: "Barcode",
  //                               labelStyle: TextStyle(color: Colors.black),
  //                               filled: true,
  //                               fillColor: Colors.white,
  //                             ),
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 barcodeTextString = value;
  //                               });
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //                     TextFormField(
  //                       controller: wareCodeBarcodeController,
  //                       readOnly: true,
  //                       decoration: InputDecoration(
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Colors.transparent),
  //                           borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Colors.transparent),
  //                           // borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         // hintText: 'เลขที่เอกสาร',
  //                         // hintStyle: const TextStyle(color: Colors.blue),
  //                         labelText: "Warehouse",
  //                         labelStyle: TextStyle(color: Colors.black),
  //                         filled: true,
  //                         fillColor: Colors.grey[350],
  //                       ),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     TextFormField(
  //                       controller: itemCodeBarcodeController,
  //                       readOnly: true,
  //                       decoration: InputDecoration(
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Colors.transparent),
  //                           borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Colors.transparent),
  //                           // borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         // hintText: 'เลขที่เอกสาร',
  //                         // hintStyle: const TextStyle(color: Colors.blue),
  //                         labelText: "item code",
  //                         labelStyle: TextStyle(color: Colors.black),
  //                         filled: true,
  //                         fillColor: Colors.grey[350],
  //                       ),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     TextFormField(
  //                       controller: lotNumberBarcodeController,
  //                       decoration: InputDecoration(
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Colors.transparent),
  //                           borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Colors.transparent),
  //                           // borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         // hintText: 'เลขที่เอกสาร',
  //                         // hintStyle: const TextStyle(color: Colors.blue),
  //                         labelText: "Lot Number",
  //                         labelStyle: TextStyle(color: Colors.black),
  //                         filled: true,
  //                         fillColor: Colors.white,
  //                       ),
  //                       onChanged: (value) {
  //                         setState(() {
  //                           lotNumberBarcode = value;
  //                         });
  //                       },
  //                     ),
  //                     const SizedBox(height: 10),
  //                     TextFormField(
  //                       controller: countQuantityBarcodeController,
  //                       decoration: InputDecoration(
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Colors.transparent),
  //                           borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Colors.transparent),
  //                           // borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         // hintText: 'เลขที่เอกสาร',
  //                         // hintStyle: const TextStyle(color: Colors.blue),
  //                         labelText: "Count Quantity",
  //                         labelStyle: TextStyle(color: Colors.black),
  //                         filled: true,
  //                         fillColor: Colors.white,
  //                       ),
  //                       onChanged: (value) {
  //                         setState(() {
  //                           countQuantityBarcode = value;
  //                         });
  //                       },
  //                     ),
  //                     const SizedBox(height: 10),
  //                     TextFormField(
  //                       controller: locatorCodeBarcodeController,
  //                       readOnly: true,
  //                       decoration: InputDecoration(
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Colors.transparent),
  //                           borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Colors.transparent),
  //                           // borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         // hintText: 'เลขที่เอกสาร',
  //                         // hintStyle: const TextStyle(color: Colors.blue),
  //                         labelText: "Locator ระบบ",
  //                         labelStyle: TextStyle(color: Colors.black),
  //                         filled: true,
  //                         fillColor: Colors.white,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     DropdownButtonFormField<String>(
  //                       value:
  //                           dataGridStatus.isNotEmpty ? dataGridStatus : null,
  //                       items: dataGradeStatuslist
  //                           .map((item) => DropdownMenuItem<String>(
  //                                 value: item['d'],
  //                                 child: Text(item['d']),
  //                               ))
  //                           .toList(),
  //                       decoration: InputDecoration(
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.transparent),
  //                           borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.transparent),
  //                           borderRadius: BorderRadius.circular(5.5),
  //                         ),
  //                         hintText: 'Locator ตรวจนับ',
  //                         hintStyle: TextStyle(color: Colors.blue),
  //                         filled: true,
  //                         fillColor: Colors.blue[50],
  //                       ),
  //                       onChanged: (value) {
  //                         setState(() {
  //                           dataGridStatus = value ?? '';
  //                           switch (dataGridStatus) {
  //                             case 'สภาพปกติ/ของดี':
  //                               statusGridBarcode = '01';
  //                               break;
  //                             case 'สภาพรอคัด/แยกซ่อม':
  //                               statusGridBarcode = '02';
  //                               break;
  //                             case 'ชำรุด/เสียหาย':
  //                               statusGridBarcode = '03';
  //                               break;
  //                             default:
  //                               statusGridBarcode = 'Unknown';
  //                           }
  //                         });
  //                       },
  //                     ),
  //                     Row(
  //                       children: [
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             // Navigator.of(context).pop();
  //                             setState(() {
  //                               dataLocator = '';
  //                               barcodeTextString = '';
  //                               wareCodeBarcode = '';
  //                               itemCodeBarcode = '';
  //                               lotNumberBarcode = '';
  //                               countQuantityBarcode = '';
  //                               locatorCodeBarcode = '';
  //                               dataGridStatus = '';
  //                               statusGridBarcode = '';
  //                               dataLocatorList.clear();
  //                               barcodeTextController.clear();
  //                               wareCodeBarcodeController.clear();
  //                               itemCodeBarcodeController.clear();
  //                               lotNumberBarcodeController.clear();
  //                               countQuantityBarcodeController.clear();
  //                               locatorCodeBarcodeController.clear();
  //                               dataGradeStatuslist.clear();
  //                             });
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.white,
  //                           ),
  //                           child: const Text('Clear'),
  //                         ),
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             // Navigator.of(context).pop();
  //                             setState(() {
  //                               print(
  //                                   'dataLocator : $dataLocator Type : ${dataLocator.runtimeType}');
  //                               print(
  //                                   'barcodeTextString : $barcodeTextString Type : ${barcodeTextString.runtimeType}');
  //                               print(
  //                                   'wareCodeBarcode : $wareCodeBarcode Type : ${wareCodeBarcode.runtimeType}');
  //                               print(
  //                                   'itemCodeBarcode : $itemCodeBarcode Type : ${itemCodeBarcode.runtimeType}');
  //                               print(
  //                                   'lotNumberBarcode : $lotNumberBarcode Type : ${lotNumberBarcode.runtimeType}');
  //                               print(
  //                                   'countQuantityBarcode : $countQuantityBarcode Type : ${countQuantityBarcode.runtimeType}');
  //                               print(
  //                                   'locatorCodeBarcode : $locatorCodeBarcode Type : ${locatorCodeBarcode.runtimeType}');
  //                               print(
  //                                   'dataGridStatus : $dataGridStatus Type : ${dataGridStatus.runtimeType}');
  //                               print(
  //                                   'statusGridBarcode : $statusGridBarcode Type : ${statusGridBarcode.runtimeType}');
  //                             });
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.white,
  //                           ),
  //                           child: const Text('Save'),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ));
  //       });
  // }

  void showDialogconfirm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.notification_important, // ใช้ไอคอนแจ้งเตือน
                    color: Colors.red, // สีของไอคอน
                  ),
                  SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                  Text('แจ้งเตือน'), // ข้อความแจ้งเตือน
                ],
              ),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('ต้องการยืนยันตรวจนับ หรือไม่ !!!'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ElevatedButton(
                            onPressed: () {
                              submitData(conditionNull);
                              // Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey),
                            ),
                            child: const Text('ยื่นยัน'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  void showDialogCONFIRMCOUNT() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.notification_important, // ใช้ไอคอนแจ้งเตือน
                    color: Colors.red, // สีของไอคอน
                  ),
                  SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
                  Text('แจ้งเตือน'), // ข้อความแจ้งเตือน
                ],
              ),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('ตรวจพบสินค้าที่ไม่ระบุจำนวนนับ'),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedStatusSubmit,
                        items: dropdownStatusSubmit
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          labelText: "สถานะ",
                          labelStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedStatusSubmit = value ?? '';
                            switch (selectedStatusSubmit) {
                              case 'ให้จำนวนนับเป็นศูนย์':
                                statusCondition = '1';
                                break;
                              case 'ให้จำนวนนับเท่ากับในระบบ':
                                statusCondition = '2';
                                break;
                              default:
                                statusCondition = 'Unknown';
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ElevatedButton(
                            onPressed: () {
                              submitData(statusCondition);
                              // Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey),
                            ),
                            child: const Text('ยื่นยัน'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  void checkStatusSubmit(
    BuildContext context,
    String statusSubmit,
    String messageSubmit,
  ) {
    IconData iconData;
    Color textColor;
    String statusText;

    switch (statusSubmit) {
      case '0':
        iconData = Icons.check_circle;
        textColor = Colors.black; // กำหนดสีข้อความเป็นสีเหลือง
        statusText = 'Success';
        break;
      case '1':
        iconData = Icons.notification_important;
        textColor = Colors.red; // กำหนดสีข้อความเป็นสีเทาอ่อน
        statusText = 'Error';
        break;
      default:
        iconData = Icons.help; // Default icon
        textColor = Colors.grey; // กำหนดสีข้อความเป็นสีเทา
        statusText = 'Unknown';
    }

    // สร้าง Dialog ที่แสดงข้อมูลตามสถานะที่กำหนด
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                iconData,
                color: textColor,
              ),
              SizedBox(width: 10),
              Text(
                statusText,
                style: TextStyle(color: textColor),
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
                    messageSubmit,
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (statusSubmit == '1')
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
                      if (statusSubmit == '0')
                        ElevatedButton(
                          onPressed: () {
                            _navigateToPage(
                                context,
                                SSFGDT12_MAIN(
                                  p_attr1: widget.p_attr1,
                                  pErpOuCode: widget.pErpOuCode,
                                )
                                //
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey),
                          ),
                          child: const Text('ตกลง'),
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
