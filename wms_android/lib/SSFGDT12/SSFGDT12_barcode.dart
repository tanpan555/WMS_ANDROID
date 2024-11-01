import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/styles.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;

class Ssfgdt12Barcode extends StatefulWidget {
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
  Ssfgdt12Barcode({
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
  _Ssfgdt12BarcodeState createState() => _Ssfgdt12BarcodeState();
}

class _Ssfgdt12BarcodeState extends State<Ssfgdt12Barcode> {
  List<dynamic> dataLocatorList = []; // data list locator
  List<dynamic> dataGradeStatuslist = []; // data list status
  List<dynamic> dataBarcodeList = []; // dataหลังจากแสกน barcode
  int seqNumberBarcodeInt = 0; // เก็บต่า seq ที่ได้หลังจากแสกน barcode type int
  String seqNumberBarcodeString =
      ''; // เก็บต่า seq ที่ได้หลังจากแสกน barcode type String
  String dataLocator = ''; // เก็บค่า locator ตรวจนับ
  String barcodeTextString = ''; // เก็บ barcode
  String wareCodeBarcode = ''; // เก็บต่า wareCode ที่ได้หลังจากแสกน barcode
  String itemCodeBarcode = ''; // เก็บต่า itemCode ที่ได้หลังจากแสกน barcode
  String lotNumberBarcode = ''; // เก็บค่า lot Number
  String countQuantityBarcode = ''; // เก็บค่า count Quantity
  String locatorCodeBarcode = '';
  String dataGridStatus = 'สภาพปกติ/ของดี'; //  เก็บชื่อ status barcode
  String statusGridBarcode = '01'; // เก็บ status barcode
  String appUser = globals.APP_USER;

  String poMessageBarcode = '';
  String poStatusBarcode = '';

  String statusSubmit = '';
  String messageSubmit = '';

  final FocusNode _focusNode = FocusNode();
  final TextEditingController barcodeTextController = TextEditingController();
  final TextEditingController wareCodeBarcodeController =
      TextEditingController();
  final TextEditingController itemCodeBarcodeController =
      TextEditingController();
  final TextEditingController lotNumberBarcodeController =
      TextEditingController();
  final TextEditingController countQuantityBarcodeController =
      TextEditingController();
  final TextEditingController locatorCodeBarcodeController =
      TextEditingController();
  final TextEditingController dataGridStatusBarcodeController =
      TextEditingController();
  final TextEditingController dataLocatorListBarcodeController =
      TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    barcodeTextController.dispose();
    wareCodeBarcodeController.dispose();
    itemCodeBarcodeController.dispose();
    lotNumberBarcodeController.dispose();
    countQuantityBarcodeController.dispose();
    locatorCodeBarcodeController.dispose();
    dataGridStatusBarcodeController.dispose();
    dataLocatorListBarcodeController.dispose();
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
    super.initState();
    fetchDataLocator();
    fetchDataGradeStatus();
    setDataIsFirst();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (barcodeTextString.isNotEmpty) {
          fetchDataBarcode();
        }
      }
    });
  }

  void setDataIsFirst() {
    if (mounted) {
      setState(() {
        dataGridStatus = 'สภาพปกติ/ของดี'; //  เก็บชื่อ status barcode
        statusGridBarcode = '01'; // เก็บ status barcode
        dataGridStatusBarcodeController.text = 'สภาพปกติ/ของดี';
      });
    }
  }

  Future<void> fetchDataLocator() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_4_BarcodeSelsectLocator/${widget.pWareCode}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');
        if (mounted) {
          setState(() {
            dataLocatorList =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
            dataGridStatusBarcodeController.text = 'สภาพปกติ/ของดี';
          });
        }
        print('dataLocatorList : $dataLocatorList');
      } else {
        throw Exception('fetchDataLocator Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('ERROR IN Fetch Data : $e');
    }
  }

  Future<void> fetchDataGradeStatus() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_4_BarcodeSelectGradeStatus'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');
        if (mounted) {
          setState(() {
            dataGradeStatuslist =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
      } else {
        throw Exception(
            'fetchDatadataGradeStatuslist Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('ERROR IN Fetch Data : $e');
    }
  }

  Future<void> fetchDataBarcode() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_4_BarcodeSelectDataBarcode/${widget.pErpOuCode}/${widget.docNo}/${widget.pWareCode}/$appUser/${dataLocator.isNotEmpty ? dataLocator : 'null'}/$barcodeTextString')); // ตรวจสอบให้แน่ใจว่า URL ถูกต้อง
      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataBarcode =
            jsonDecode(utf8.decode(response.bodyBytes));
        if (mounted) {
          setState(() {
            poMessageBarcode = dataBarcode['po_message'] ?? '';
            poStatusBarcode = dataBarcode['po_status'] ?? '';

            if (poStatusBarcode == '1') {
              showExitAlertDialog(poMessageBarcode);
            }
            if (poStatusBarcode == '0') {
              seqNumberBarcodeInt = dataBarcode['po_count_seq'] ?? '';
              seqNumberBarcodeString = dataBarcode['po_count_seq'].toString();
              wareCodeBarcode = widget.pWareCode;
              itemCodeBarcode = dataBarcode['po_item_code'] ?? '';
              locatorCodeBarcode = dataBarcode['po_curr_loc'] ?? '';

              wareCodeBarcodeController.text = wareCodeBarcode;
              itemCodeBarcodeController.text = itemCodeBarcode;
              locatorCodeBarcodeController.text = locatorCodeBarcode;
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('ดึงข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print(
          'Error: $e'); // จัดการข้อผิดพลาด เช่น การเชื่อมต่อหรือการ decode JSON
    }
  }

  Future<void> submitBarcode() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_4_SubmitBarcode';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_erp_ou_code': widget.pErpOuCode,
      'p_doc_no': widget.docNo,
      'p_ware_code': widget.pWareCode,
      'p_location_to':
          locatorCodeBarcode.isNotEmpty ? locatorCodeBarcode : 'null',
      'p_seq':
          seqNumberBarcodeString.isNotEmpty ? seqNumberBarcodeString : 'null',
      'p_barcode': barcodeTextString.isNotEmpty ? barcodeTextString : 'null',
      'p_item_code': itemCodeBarcode.isNotEmpty ? itemCodeBarcode : 'null',
      'p_lot_number': lotNumberBarcode.isNotEmpty ? lotNumberBarcode : 'null',
      'p_count_qty':
          countQuantityBarcode.isNotEmpty ? countQuantityBarcode : 'null',
      'p_grad_status': statusGridBarcode,
      'p_app_user': globals.APP_USER,
    });
    // print('Request body: $body');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataSubmit =
            jsonDecode(utf8.decode(response.bodyBytes));
        if (mounted) {
          setState(() {
            statusSubmit = dataSubmit['po_status'];
            messageSubmit = dataSubmit['po_message'];
            if (statusSubmit == '1') {
              showExitAlertDialog(messageSubmit);
            }
            if (statusSubmit == '0') {
              dataLocator = '';
              dataLocatorListBarcodeController.clear();

              barcodeTextString = '';
              barcodeTextController.clear();

              wareCodeBarcode = '';
              wareCodeBarcodeController.clear();

              itemCodeBarcode = '';
              itemCodeBarcodeController.clear();

              lotNumberBarcode = '';
              lotNumberBarcodeController.clear();

              countQuantityBarcode = '';
              countQuantityBarcodeController.clear();

              locatorCodeBarcode = '';
              locatorCodeBarcodeController.clear();

              dataGridStatus = 'สภาพปกติ/ของดี'; //  เก็บชื่อ status barcode
              statusGridBarcode = '01'; // เก็บ status barcode
              dataGridStatusBarcodeController.text = 'สภาพปกติ/ของดี';
              seqNumberBarcodeInt = 0;
              seqNumberBarcodeString = '';
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
      appBar: CustomAppBar(title: 'Scan Manual Add', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    widget.docNo,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              //////////////////////////////////////////////////////////////////////////////
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    seqNumberBarcodeString,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              //////////////////////////////////////////////////////////////////////////////
              TextFormField(
                controller: dataLocatorListBarcodeController,
                readOnly: true,
                onTap: () => showDialogSelectDataLocator(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Locator ตรวจนับ',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // DropdownButtonFormField2<String>(
              //   value: dataLocator.isNotEmpty ? dataLocator : null,
              //   items: dataLocatorList
              //       .map((item) => DropdownMenuItem<String>(
              //             value: item['location_code'],
              //             child: Text(item['location_code']),
              //           ))
              //       .toList(),
              //   decoration: InputDecoration(
              //     border: InputBorder.none,
              //     filled: true,
              //     fillColor: Colors.white,
              //     labelText: 'Locator ตรวจนับ',
              //     labelStyle: const TextStyle(
              //       color: Colors.black87,
              //     ),
              //   ),
              //   onChanged: (value) {
              //     setState(() {
              //       dataLocator = value ?? '';
              //     });
              //   },
              // ),
              // const SizedBox(height: 8),

              //////////////////////////////////////////////////////////////////////////////
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: barcodeTextController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Barcode',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          barcodeTextString = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              //////////////////////////////////////////////////////////////////////////////
              GestureDetector(
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: wareCodeBarcodeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Warehouse',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              //////////////////////////////////////////////////////////////////////////////
              GestureDetector(
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: itemCodeBarcodeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Item Code',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              //////////////////////////////////////////////////////////////////////////////
              TextFormField(
                controller: lotNumberBarcodeController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Lot Number',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    lotNumberBarcode = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              //////////////////////////////////////////////////////////////////////////////
              TextFormField(
                controller: countQuantityBarcodeController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Count Quantity',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    countQuantityBarcode = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              //////////////////////////////////////////////////////////////////////////////
              GestureDetector(
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: locatorCodeBarcodeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Locator ระบบ',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              //////////////////////////////////////////////////////////////////////////////
              TextFormField(
                controller: dataGridStatusBarcodeController,
                readOnly: true,
                onTap: () => showDialogSelectStatus(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'สภาพ',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // DropdownButtonFormField2<String>(
              //   value: dataGridStatus.isNotEmpty ? dataGridStatus : null,
              //   items: dataGradeStatuslist
              //       .map((item) => DropdownMenuItem<String>(
              //             value: item['d'],
              //             child: Text(item['d']),
              //           ))
              //       .toList(),
              //   decoration: InputDecoration(
              //     border: InputBorder.none,
              //     filled: true,
              //     fillColor: Colors.white,
              //     labelText: 'สภาพ',
              //     labelStyle: const TextStyle(
              //       color: Colors.black87,
              //     ),
              //   ),
              //   onChanged: (value) {
              //     setState(() {
              //       dataGridStatus = value ?? '';
              //       switch (dataGridStatus) {
              //         case 'สภาพปกติ/ของดี':
              //           statusGridBarcode = '01';
              //           break;
              //         case 'สภาพรอคัด/แยกซ่อม':
              //           statusGridBarcode = '02';
              //           break;
              //         case 'ชำรุด/เสียหาย':
              //           statusGridBarcode = '03';
              //           break;
              //         default:
              //           statusGridBarcode = 'Unknown';
              //       }
              //     });
              //   },
              // ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      fetchDataLocator();
                      fetchDataGradeStatus();
                      setState(() {
                        dataLocator = '';
                        barcodeTextString = '';
                        wareCodeBarcode = '';
                        itemCodeBarcode = '';
                        lotNumberBarcode = '';
                        countQuantityBarcode = '';
                        locatorCodeBarcode = '';
                        dataGridStatus = 'สภาพปกติ/ของดี';
                        statusGridBarcode = '01';
                        dataGridStatusBarcodeController.text = 'สภาพปกติ/ของดี';
                        dataLocatorListBarcodeController.clear();
                        dataLocatorList.clear();
                        barcodeTextController.clear();
                        wareCodeBarcodeController.clear();
                        itemCodeBarcodeController.clear();
                        lotNumberBarcodeController.clear();
                        countQuantityBarcodeController.clear();
                        locatorCodeBarcodeController.clear();
                        // dataGradeStatuslist.clear();
                      });
                    },
                    style: AppStyles.cancelButtonStyle(),
                    child: Text(
                      'ยกเลิก',
                      style: AppStyles.CancelbuttonTextStyle(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submitBarcode();
                      // setState(() {});
                    },
                    style: AppStyles.ConfirmbuttonStyle(),
                    child: Text(
                      'บันทึก',
                      style: AppStyles.ConfirmbuttonTextStyle(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: 'show',
      ),
    );
  }

  void showExitAlertDialog(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
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
                      message,
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop(false);
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.white,
                  //     side: const BorderSide(color: Colors.grey),
                  //   ),
                  //   child: const Text('Cancel'),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('OK'),
                  ),
                ],
              )
            ]);
      },
    );
    FocusScope.of(context).requestFocus(_focusNode);
    if (mounted) {
      setState(() {
        dataLocator = '';
        dataLocatorListBarcodeController.clear();

        barcodeTextString = '';
        barcodeTextController.clear();

        wareCodeBarcode = '';
        wareCodeBarcodeController.clear();

        itemCodeBarcode = '';
        itemCodeBarcodeController.clear();

        lotNumberBarcode = '';
        lotNumberBarcodeController.clear();

        countQuantityBarcode = '';
        countQuantityBarcodeController.clear();

        locatorCodeBarcode = '';
        locatorCodeBarcodeController.clear();

        dataGridStatus = 'สภาพปกติ/ของดี'; //  เก็บชื่อ status barcode
        statusGridBarcode = '01'; // เก็บ status barcode
        dataGridStatusBarcodeController.text = 'สภาพปกติ/ของดี';
        seqNumberBarcodeInt = 0;
        seqNumberBarcodeString = '';
      });
    }
  }

  void showDialogSelectDataLocator() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                height: 300, // ปรับความสูงของ Popup ตามต้องการ
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // สีของเส้น
                            width: 1.0, // ความหนาของเส้น
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Locator ตรวจนับ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // เพื่อให้ทำงานร่วมกับ ListView ด้านนอกได้
                            itemCount: dataLocatorList.length,
                            itemBuilder: (context, index) {
                              // ดึงข้อมูลรายการจาก dataCard
                              var item = dataLocatorList[index];

                              // return GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       dataLocator = item['location_code'];
                              //     });
                              //   },
                              //   child: SizedBox(
                              //     child: Text('${item['location_code']}'),
                              //   ),
                              // );
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey, // สีของขอบทั้ง 4 ด้าน
                                      width: 2.0, // ความหนาของขอบ
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        10.0), // ทำให้ขอบมีความโค้ง
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical:
                                          8.0), // เพิ่ม padding ด้านซ้าย-ขวา และ ด้านบน-ล่าง
                                  child: Text(
                                    item['location_code'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    dataLocator = item['location_code'];
                                    dataLocatorListBarcodeController.text =
                                        dataLocator;
                                    // -----------------------------------------
                                    print(
                                        'dataLocatorListBarcodeController New: $dataLocatorListBarcodeController Type : ${dataLocatorListBarcodeController.runtimeType}');
                                    print(
                                        'dataLocator New: $dataLocator Type : ${dataLocator.runtimeType}');
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )

                    // ช่องค้นหา
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogSelectStatus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                height: 300, // ปรับความสูงของ Popup ตามต้องการ
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // สีของเส้น
                            width: 1.0, // ความหนาของเส้น
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'สภาพ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // เพื่อให้ทำงานร่วมกับ ListView ด้านนอกได้
                            itemCount: dataGradeStatuslist.length,
                            itemBuilder: (context, index) {
                              // ดึงข้อมูลรายการจาก dataCard
                              var item = dataGradeStatuslist[index];

                              // return GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       dataLocator = item['location_code'];
                              //     });
                              //   },
                              //   child: SizedBox(
                              //     child: Text('${item['location_code']}'),
                              //   ),
                              // );
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey, // สีของขอบทั้ง 4 ด้าน
                                      width: 2.0, // ความหนาของขอบ
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        10.0), // ทำให้ขอบมีความโค้ง
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical:
                                          8.0), // เพิ่ม padding ด้านซ้าย-ขวา และ ด้านบน-ล่าง
                                  child: Text(
                                    item['d'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    dataGridStatus = item['d'];
                                    statusGridBarcode = item['r'];
                                    dataGridStatusBarcodeController.text =
                                        dataGridStatus;
                                    Navigator.of(context).pop();
                                    print('dataGridStatus : $dataGridStatus');
                                    print(
                                        'statusGridBarcode : $statusGridBarcode');
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )

                    // ช่องค้นหา
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // void showDialogSelectStatus() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: StatefulBuilder(
  //           builder: (context, setState) {
  //             return Container(
  //               padding: const EdgeInsets.all(16),
  //               height: 300, // ปรับความสูงของ Popup ตามต้องการ
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       const Text(
  //                         'สภาพ',
  //                         style: TextStyle(
  //                             fontSize: 18, fontWeight: FontWeight.bold),
  //                       ),
  //                       IconButton(
  //                         icon: const Icon(Icons.close),
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Expanded(
  //                     child: ListView(
  //                       children: [
  //                         ListView.builder(
  //                           shrinkWrap: true,
  //                           physics:
  //                               const NeverScrollableScrollPhysics(), // เพื่อให้ทำงานร่วมกับ ListView ด้านนอกได้
  //                           itemCount: dataGradeStatuslist.length,
  //                           itemBuilder: (context, index) {
  //                             // ดึงข้อมูลรายการจาก dataCard
  //                             var item = dataGradeStatuslist[index];
  //                             Color cardColor;
  //                             String statusText;
  //                             String iconImageYorN;
  //                             print(item['d']);
  //                             switch (item['d']) {
  //                               case 'สภาพปกติ/ของดี':
  //                                 cardColor =
  //                                     Color.fromRGBO(246, 250, 112, 1.0);
  //                                 statusText = '01';
  //                                 break;
  //                               case 'สภาพรอคัด/แยกซ่อม':
  //                                 cardColor = Color.fromRGBO(146, 208, 80, 1.0);
  //                                 statusText = '02';
  //                                 break;
  //                               case 'ชำรุด/เสียหาย':
  //                                 cardColor =
  //                                     Color.fromRGBO(208, 206, 206, 1.0);
  //                                 statusText = '03';
  //                                 break;
  //                               default:
  //                                 cardColor =
  //                                     Color.fromRGBO(255, 255, 255, 1.0);
  //                                 statusText = 'Unknown';
  //                             }

  //                             switch (item['qc_yn']) {
  //                               case 'Y':
  //                                 iconImageYorN =
  //                                     'assets/images/rt_machine_on.png';
  //                                 break;
  //                               case 'N':
  //                                 iconImageYorN =
  //                                     'assets/images/rt_machine_off.png';
  //                                 break;
  //                               default:
  //                                 iconImageYorN =
  //                                     'assets/images/rt_machine_off.png';
  //                             }
  //                             return InkWell(
  //                               onTap: () {
  //                                 setState(() {
  //                                   dataGridStatus = item['d'];
  //                                   statusGridBarcode = statusText;
  //                                   dataGridStatusBarcodeController.text =
  //                                       dataGridStatus;
  //                                   Navigator.of(context).pop();
  //                                   print('dataGridStatus : $dataGridStatus');
  //                                   print(
  //                                       'statusGridBarcode : $statusGridBarcode');
  //                                 });
  //                               },
  //                               child: Card(
  //                                 elevation: 8.0,
  //                                 margin: EdgeInsets.symmetric(vertical: 8.0),
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(15.0),
  //                                 ),
  //                                 color: Color.fromRGBO(204, 235, 252, 1.0),
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(16.0),
  //                                   child: Text('${item['d']}'),
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   )

  //                   // ช่องค้นหา
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}
