import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  @override
  void dispose() {
    _focusNode.dispose();
    barcodeTextController.dispose();
    wareCodeBarcodeController.dispose();
    itemCodeBarcodeController.dispose();
    lotNumberBarcodeController.dispose();
    countQuantityBarcodeController.dispose();
    locatorCodeBarcodeController.dispose();
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
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (dataLocator.isNotEmpty) {
          print(
              'have data !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
          fetchDataBarcode(barcodeTextString, dataLocator);
          print(
              'barcodeTextString in check focus: $barcodeTextString Type: ${barcodeTextString.runtimeType}');
          print(
              'dataLocator in check focus: $dataLocator Type: ${dataLocator.runtimeType}');
        } else {
          print(
              'no data !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
          print(
              'barcodeTextString in check focus: $barcodeTextString Type: ${barcodeTextString.runtimeType}');
          print(
              'dataLocator in check focus: $dataLocator Type: ${dataLocator.runtimeType}');
        }
      }
    });
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

  Future<void> fetchDataLocator() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_3_BarcodeSelsectLocator/${widget.pWareCode}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        setState(() {
          dataLocatorList =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataLocatorList : $dataLocatorList');
      } else {
        throw Exception('fetchDataLocator Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data : $e');
    }
  }

  Future<void> fetchDataGradeStatus() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_3_BarcodeSelectGradeStatus'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        setState(() {
          dataGradeStatuslist =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataGradeStatuslist : $dataGradeStatuslist');
      } else {
        throw Exception(
            'fetchDatadataGradeStatuslist Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data : $e');
    }
  }

  Future<void> fetchDataBarcode(
      String barcodeTextString, String dataLocator) async {
    print(
        'barcodeTextString in fetchDataBarcode: $barcodeTextString Type : ${barcodeTextString.runtimeType}');
    print(
        'dataLocator in  fetchDataBarcode: $dataLocator Type : ${dataLocator.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT12/SSFGDT12_Step_3_BarcodeSelectDataBarcode/${widget.pErpOuCode}/${widget.docNo}/${widget.pWareCode}/$appUser/$dataLocator/$barcodeTextString'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataBarcodeList =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = dataBarcodeList['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          print('Fetched dataBarcodeList: $jsonDecode');

          setState(() {
            seqNumberBarcodeInt = item['p_count_seq'] ?? '';
            seqNumberBarcodeString = item['p_count_seq'].toString();
            wareCodeBarcode = widget.pWareCode;
            itemCodeBarcode = item['p_item_code'] ?? '';
            locatorCodeBarcode = item['p_curr_loc'] ?? '';

            wareCodeBarcodeController.text = wareCodeBarcode;
            itemCodeBarcodeController.text = itemCodeBarcode;
            locatorCodeBarcodeController.text = locatorCodeBarcode;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'Scan Manual Add'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
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
                    '${widget.docNo}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                    '$seqNumberBarcodeString',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //////////////////////////////////////////////////////////////////////////////
              DropdownButtonFormField<String>(
                value: dataLocator.isNotEmpty ? dataLocator : null,
                items: dataLocatorList
                    .map((item) => DropdownMenuItem<String>(
                          value: item['location_code'],
                          child: Text(item['location_code']),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Locator ตรวจนับ',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    dataLocator = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 10),
              //////////////////////////////////////////////////////////////////////////////
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: barcodeTextController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Barcode',
                        labelStyle: const TextStyle(
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
              const SizedBox(height: 10),
              //////////////////////////////////////////////////////////////////////////////
              TextFormField(
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
              const SizedBox(height: 10),
              //////////////////////////////////////////////////////////////////////////////
              TextFormField(
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
              const SizedBox(height: 10),
              //////////////////////////////////////////////////////////////////////////////
              TextFormField(
                controller: lotNumberBarcodeController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Lot Number',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    lotNumberBarcode = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              //////////////////////////////////////////////////////////////////////////////
              TextFormField(
                controller: countQuantityBarcodeController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Count Quantity',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    countQuantityBarcode = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              //////////////////////////////////////////////////////////////////////////////
              TextFormField(
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
              const SizedBox(height: 10),
              //////////////////////////////////////////////////////////////////////////////
              DropdownButtonFormField<String>(
                value: dataGridStatus.isNotEmpty ? dataGridStatus : null,
                items: dataGradeStatuslist
                    .map((item) => DropdownMenuItem<String>(
                          value: item['d'],
                          child: Text(item['d']),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'สภาพ',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    dataGridStatus = value ?? '';
                    switch (dataGridStatus) {
                      case 'สภาพปกติ/ของดี':
                        statusGridBarcode = '01';
                        break;
                      case 'สภาพรอคัด/แยกซ่อม':
                        statusGridBarcode = '02';
                        break;
                      case 'ชำรุด/เสียหาย':
                        statusGridBarcode = '03';
                        break;
                      default:
                        statusGridBarcode = 'Unknown';
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
                      // Navigator.of(context).pop();
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
                        dataLocatorList.clear();
                        barcodeTextController.clear();
                        wareCodeBarcodeController.clear();
                        itemCodeBarcodeController.clear();
                        lotNumberBarcodeController.clear();
                        countQuantityBarcodeController.clear();
                        locatorCodeBarcodeController.clear();
                        dataGradeStatuslist.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(10, 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      setState(() {
                        print(
                            'dataLocator : $dataLocator Type : ${dataLocator.runtimeType}');
                        print(
                            'barcodeTextString : $barcodeTextString Type : ${barcodeTextString.runtimeType}');
                        print(
                            'wareCodeBarcode : $wareCodeBarcode Type : ${wareCodeBarcode.runtimeType}');
                        print(
                            'itemCodeBarcode : $itemCodeBarcode Type : ${itemCodeBarcode.runtimeType}');
                        print(
                            'lotNumberBarcode : $lotNumberBarcode Type : ${lotNumberBarcode.runtimeType}');
                        print(
                            'countQuantityBarcode : $countQuantityBarcode Type : ${countQuantityBarcode.runtimeType}');
                        print(
                            'locatorCodeBarcode : $locatorCodeBarcode Type : ${locatorCodeBarcode.runtimeType}');
                        print(
                            'dataGridStatus : $dataGridStatus Type : ${dataGridStatus.runtimeType}');
                        print(
                            'statusGridBarcode : $statusGridBarcode Type : ${statusGridBarcode.runtimeType}');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(10, 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
