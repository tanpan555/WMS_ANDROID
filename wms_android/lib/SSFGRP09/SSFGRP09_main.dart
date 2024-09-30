import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wms_android/styles.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';

class SSFGRP09_MAIN extends StatefulWidget {
//////
  SSFGRP09_MAIN({
    Key? key,

    ///
  }) : super(key: key);
  @override
  _SSFGRP09_MAINState createState() => _SSFGRP09_MAINState();
}

class _SSFGRP09_MAINState extends State<SSFGRP09_MAIN> {
  List<dynamic> dataLovDate = [];
  List<dynamic> dataLovDocNo = [];
  List<dynamic> dataLovStartWareCode = [];
  List<dynamic> dataLovEndWareCode = [];
  List<dynamic> dataLovStartLoc = [];
  List<dynamic> dataLovEndLoc = [];

  // -----------------------------
  String? displayLovDate;
  String returnLovDate = '';
  String updatedStringLovDate = '';
  // -----------------------------
  String? displayLovDocNo;
  String returnLovDocNo = '';
  // -----------------------------
  String? displayStartWareCode;
  String returnStartWareCode = '';
  // -----------------------------
  String? displayEndWareCode;
  String returnEndWareCode = '';
  // -----------------------------
  String? displayStartLoc;
  String returnStartLoc = '';
  // -----------------------------
  String? displayEndLoc;
  String returnEndLoc = '';
  // -----------------------------

  @override
  void initState() {
    selectLovDate();
    selectLovDocNo();
    selectLovStartWareCode();
    selectLovEndWareCode();
    selectLovStartLoc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> selectLovDate() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovDate/${globals.P_ERP_OU_CODE}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovDate =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovDate : $dataLovDate');
      } else {
        throw Exception('dataLovDate Failed to load fetchData');
      }
    } catch (e) {
      print('dataLovDate ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovDocNo() async {
    if (returnLovDate.isNotEmpty) {
      updatedStringLovDate = replaceSlashWithDash(returnLovDate);
    }
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovDocNo/${globals.P_ERP_OU_CODE}/${returnLovDate.isNotEmpty ? updatedStringLovDate : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovDocNo =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovDocNo : $dataLovDocNo');
      } else {
        throw Exception(
            'dataLovDocNo Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovDocNo ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartWareCode() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_S_ware/${globals.APP_USER}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartWareCode =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovStartWareCode : $dataLovStartWareCode');
      } else {
        throw Exception(
            'dataLovStartWareCode Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovStartWareCode ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndWareCode() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_E_ware/${globals.APP_USER}/${returnStartWareCode.isNotEmpty ? returnStartWareCode : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndWareCode =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovEndWareCode : $dataLovEndWareCode');
      } else {
        throw Exception(
            'dataLovEndWareCode Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndWareCode ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartLoc() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_S_loc/${globals.P_ERP_OU_CODE}'
          '/${returnStartWareCode.isNotEmpty ? returnStartWareCode : 'null'}'
          '/${returnEndWareCode.isNotEmpty ? returnEndWareCode : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartLoc =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovStartLoc : $dataLovStartLoc');
      } else {
        throw Exception(
            'dataLovStartLoc Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovStartLoc ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndLoc() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_E_ware/${globals.APP_USER}/${returnStartWareCode.isNotEmpty ? returnStartWareCode : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndWareCode =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovEndWareCode : $dataLovEndWareCode');
      } else {
        throw Exception(
            'dataLovEndWareCode Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndWareCode ERROR IN Fetch Data : $e');
    }
  }

  String replaceSlashWithDash(String input) {
    if (input.contains('/')) {
      return input.replaceAll('/', '-');
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'รายงานผลการตรวจนับสินค้า'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Text(item),
                    selected: isSelected,
                  );
                },
                constraints: BoxConstraints(
                  maxHeight: 250,
                ),
              ),
              items: dataLovDate
                  .map<String>((item) => '${item['prepare_date']}')
                  .toList(),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'วันที่เตรียมการตรวจนับ',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  displayLovDate = value;

                  // Find the selected item
                  var selectedItem = dataLovDate.firstWhere(
                    (item) => '${item['prepare_date']}' == value,
                    orElse: () => <String, dynamic>{}, // แก้ไข orElse
                  );
                  // Update variables based on selected item
                  if (selectedItem.isNotEmpty) {
                    returnLovDate = selectedItem['prepare_date'] ?? '';
                    if (returnLovDate.isNotEmpty) {
                      selectLovDocNo();
                    }
                  }
                });
                print(
                    'dataLovDate in body: $dataLovDate type: ${dataLovDate.runtimeType}');
                // print(selectedItem);
                print(
                    'returnLovDate in body: $returnLovDate type: ${returnLovDate.runtimeType}');
              },
              selectedItem: displayLovDate,
            ),
            // -------------------------------------------------------------------------------------------------------------//
            const SizedBox(height: 8),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Text(item),
                    selected: isSelected,
                  );
                },
                constraints: BoxConstraints(
                  maxHeight: 250,
                ),
              ),
              items: dataLovDocNo
                  .map<String>((item) => '${item['doc_no']}')
                  .toList(),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'เลขที่ตรวจนับ',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  displayLovDocNo = value;

                  // Find the selected item
                  var selectedItem = dataLovDocNo.firstWhere(
                    (item) => '${item['doc_no']}' == value,
                    orElse: () => <String, dynamic>{}, // แก้ไข orElse
                  );
                  // Update variables based on selected item
                  if (selectedItem.isNotEmpty) {
                    returnLovDocNo = selectedItem['doc_no'] ?? '';
                  }
                });
                print(
                    'dataLovDocNo in body: $dataLovDocNo type: ${dataLovDocNo.runtimeType}');
                // print(selectedItem);
                print(
                    'returnLovDocNo in body: $returnLovDocNo type: ${returnLovDocNo.runtimeType}');
              },
              selectedItem: displayLovDocNo,
            ),
            // -------------------------------------------------------------------------------------------------------------//
            const SizedBox(height: 8),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Text(item),
                    selected: isSelected,
                  );
                },
                constraints: BoxConstraints(
                  maxHeight: 250,
                ),
              ),
              items: dataLovStartWareCode
                  .map<String>((item) => '${item['ware_code']}')
                  .toList(),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'จาก คลังสินค้า',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  displayStartWareCode = value;

                  // Find the selected item
                  var selectedItem = dataLovStartWareCode.firstWhere(
                    (item) => '${item['ware_code']}' == value,
                    orElse: () => <String, dynamic>{}, // แก้ไข orElse
                  );
                  // Update variables based on selected item
                  if (selectedItem.isNotEmpty) {
                    returnStartWareCode = selectedItem['ware_code'] ?? '';
                    if (returnStartWareCode.isNotEmpty) {
                      selectLovEndWareCode();
                      selectLovStartLoc();
                    }
                  }
                });
                print(
                    'dataLovStartWareCode in body: $dataLovStartWareCode type: ${dataLovStartWareCode.runtimeType}');
                // print(selectedItem);
                print(
                    'returnStartWareCode in body: $returnStartWareCode type: ${returnStartWareCode.runtimeType}');
              },
              selectedItem: displayStartWareCode,
            ),
            // -------------------------------------------------------------------------------------------------------------//
            const SizedBox(height: 8),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Text(item),
                    selected: isSelected,
                  );
                },
                constraints: BoxConstraints(
                  maxHeight: 250,
                ),
              ),
              items: dataLovEndWareCode
                  .map<String>((item) => '${item['ware_code']}')
                  .toList(),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ถึง คลังสินค้า',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  displayEndWareCode = value;

                  // Find the selected item
                  var selectedItem = dataLovEndWareCode.firstWhere(
                    (item) => '${item['ware_code']}' == value,
                    orElse: () => <String, dynamic>{}, // แก้ไข orElse
                  );
                  // Update variables based on selected item
                  if (selectedItem.isNotEmpty) {
                    returnEndWareCode = selectedItem['ware_code'] ?? '';
                    if (returnEndWareCode.isNotEmpty) {
                      selectLovStartLoc();
                    }
                  }
                });
                print(
                    'dataLovEndWareCode in body: $dataLovEndWareCode type: ${dataLovEndWareCode.runtimeType}');
                // print(selectedItem);
                print(
                    'returnLovDocNo in body: $returnLovDocNo type: ${returnLovDocNo.runtimeType}');
              },
              selectedItem: displayEndWareCode,
            ),
            // -------------------------------------------------------------------------------------------------------------//
            const SizedBox(height: 8),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Text(item),
                    selected: isSelected,
                  );
                },
                constraints: BoxConstraints(
                  maxHeight: 250,
                ),
              ),
              items: dataLovStartLoc
                  .map<String>((item) => '${item['location_code']}')
                  .toList(),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'จาก ตำแหน่งจัดเก็บ',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  displayStartLoc = value;

                  // Find the selected item
                  var selectedItem = dataLovStartLoc.firstWhere(
                    (item) => '${item['location_code']}' == value,
                    orElse: () => <String, dynamic>{}, // แก้ไข orElse
                  );
                  // Update variables based on selected item
                  if (selectedItem.isNotEmpty) {
                    returnStartLoc = selectedItem['location_code'] ?? '';
                  }
                });
                print(
                    'dataLovStartLoc in body: $dataLovStartLoc type: ${dataLovStartLoc.runtimeType}');
                // print(selectedItem);
                print(
                    'returnLovDocNo in body: $returnLovDocNo type: ${returnLovDocNo.runtimeType}');
              },
              selectedItem: displayStartLoc,
            ),
            // -------------------------------------------------------------------------------------------------------------//
            const SizedBox(height: 8),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Text(item),
                    selected: isSelected,
                  );
                },
                constraints: BoxConstraints(
                  maxHeight: 250,
                ),
              ),
              items: dataLovEndWareCode
                  .map<String>((item) => '${item['ware_code']}')
                  .toList(),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ถึง ตำแหน่งจัดเก็บ',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  displayEndWareCode = value;

                  // Find the selected item
                  var selectedItem = dataLovEndWareCode.firstWhere(
                    (item) => '${item['ware_code']}' == value,
                    orElse: () => <String, dynamic>{}, // แก้ไข orElse
                  );
                  // Update variables based on selected item
                  if (selectedItem.isNotEmpty) {
                    returnEndWareCode = selectedItem['ware_code'] ?? '';
                  }
                });
                print(
                    'dataLovEndWareCode in body: $dataLovEndWareCode type: ${dataLovEndWareCode.runtimeType}');
                // print(selectedItem);
                print(
                    'returnLovDocNo in body: $returnLovDocNo type: ${returnLovDocNo.runtimeType}');
              },
              selectedItem: displayEndWareCode,
            ),
            // -------------------------------------------------------------------------------------------------------------//
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
