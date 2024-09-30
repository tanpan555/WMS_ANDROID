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

  // -----------------------------
  String? displayLovDate;
  String returnLovDate = '';
  // -----------------------------

  FocusNode _selectDateFocusNode = FocusNode();

  @override
  void initState() {
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
                  .map<String>((item) => '${item['so_no']}')
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
          ],
        ),
      ),
    );
  }
}
