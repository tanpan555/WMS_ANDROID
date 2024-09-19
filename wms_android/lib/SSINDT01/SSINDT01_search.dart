import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wms_android/SSINDT01/SSINDT01_main.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSINDT01_SEARCH extends StatefulWidget {
  final String pWareCode;
  final String pWareName;
  final String p_ou_code;

  const SSINDT01_SEARCH(
      {Key? key,
      required this.pWareCode,
      required this.pWareName,
      required this.p_ou_code})
      : super(key: key);

  @override
  _SSINDT01_SEARCHState createState() => _SSINDT01_SEARCHState();
}

class _SSINDT01_SEARCHState extends State<SSINDT01_SEARCH> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> statusItems = [
    'ทั้งหมด',
    'รายการใบสั่งซื้อ',
    'รายการรอรับดำเนินการ'
  ];

  String currentSessionID = '';
  List<dynamic> apCodes = [];
  String? selectedApCode;
  String errorMessage = '';
  String? _selectedValue = 'ทั้งหมด';
  

  final TextEditingController _documentNumberController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    _selectedValue = 'ทั้งหมด';
    fetchApCodes();
    selectedApCode = ''; 
    // print('$selectedApCode' ?? 'test');

    print('Search Global Ware Code: ${gb.P_WARE_CODE}');
    log('Search Global Ware Code: ${gb.P_WARE_CODE}');
  }

  Future<void> fetchApCodes() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/AP_CODE'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          apCodes = jsonData['items'] ?? [];
          apCodes.insert(0, {'ap_code': 'ทั้งหมด', 'ap_name': 'ทั้งหมด'});
          selectedApCode = '';
        });
      } else {
        throw Exception('Failed to load AP codes');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        print(
            'errorMessage : $errorMessage Type : ${errorMessage.runtimeType}');
      });
    }
  }

  void _resetForm() {
    setState(() {
      _selectedValue = 'ทั้งหมด';
      selectedApCode = '';

      _documentNumberController.clear();
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'รับจากการสั่งซื้อ'),
      backgroundColor: const Color(0xFF17153B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSearchBox: false,
                    showSelectedItems: true,
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Text(item),
                        selected: isSelected,
                      );
                    },
                    constraints: BoxConstraints(
                      maxHeight: 175,
                    ),
                  ),
                  items: <String>[
                    'ทั้งหมด',
                    'รายการรอรับดำเนินการ',
                    'รายการใบสั่งซื้อ',

                  ],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "ประเภทสินค้า",
                      hintText: "เลือกประเภทสินค้า",
                      hintStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                  selectedItem: _selectedValue,
                ),
                SizedBox(height: 15),
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    showSelectedItems: true,
                    itemBuilder: (context, item, isSelected) {
                      // Find the corresponding item details from apCodes
                      final apCodeItem = apCodes.firstWhere(
                        (element) => element['ap_code'] == item,
                        orElse: () => {'ap_name': 'No name'},
                      );
                      return ListTile(
                        title: Text(
                          item,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          apCodeItem['ap_name'] ?? 'No name',
                          style: TextStyle(color: Colors.grey, fontSize: 8),
                        ),
                        selected: isSelected,
                      );
                    },
                    constraints: BoxConstraints(
                      maxHeight: 300,
                    ),
                  ),
                  items:
                      apCodes.map((item) => item['ap_code'] as String).toList(),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "ผู้ขาย",
                      hintText: "เลือกผู้ขาย",
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedApCode = value ?? 'ทั้งหมด';
                    });
                  },
                  selectedItem: selectedApCode,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _documentNumberController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'เลขที่เอกสาร',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _resetForm,
                      child: Image.asset('assets/images/eraser_red.png',
                          width: 50, height: 25),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
    final documentNumber = _documentNumberController.text.isNotEmpty
        ? _documentNumberController.text
        : 'null';

    // final apCode = 
    selectedApCode ?? 'ทั้งหมด';
    print('selectedApCode $selectedApCode');
    print(_selectedValue);
    // print('apCode $apCode');
    print(documentNumber);
    // log(apCode);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SSINDT01_MAIN(
          pWareCode: widget.pWareCode,
          pWareName: widget.pWareName,
          p_ou_code: widget.p_ou_code,
          selectedValue: _selectedValue ?? 'ทั้งหมด',
          apCode: selectedApCode ?? 'ทั้งหมด',
          documentNumber: documentNumber,
        ),
      ),
    );
  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Image.asset('assets/images/search_color.png',
                          width: 50, height: 25),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
