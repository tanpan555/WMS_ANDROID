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
  List<dynamic> dataLovStartGroup = [];
  List<dynamic> dataLovEndGroup = [];
  List<dynamic> dataLovStartCategory = [];
  List<dynamic> dataLovEndCategory = [];
  List<dynamic> dataLovStartSubCategory = [];
  List<dynamic> dataLovEndSubCategory = [];
  List<dynamic> dataLovStartItem = [];
  List<dynamic> dataLovEndItem = [];

  // ----------------------------- Date
  String? displayLovDate;
  String returnLovDate = '';
  String updatedStringLovDate = '';
  TextEditingController dateController = TextEditingController();
  // ----------------------------- Doc No
  String? displayLovDocNo;
  String returnLovDocNo = '';
  TextEditingController docNoController = TextEditingController();
  // ----------------------------- Start Ware Code
  String? displayStartWareCode;
  String returnStartWareCode = '';
  TextEditingController startWareCodeController = TextEditingController();
  // ----------------------------- End Ware Code
  String? displayEndWareCode;
  String returnEndWareCode = '';
  TextEditingController endWareCodeController = TextEditingController();
  // ----------------------------- Start Loc
  String? displayStartLoc;
  String returnStartLoc = '';
  TextEditingController startLocController = TextEditingController();
  // ----------------------------- End Loc
  String? displayEndLoc;
  String returnEndLoc = '';
  TextEditingController endLocController = TextEditingController();
  // ----------------------------- Start Group
  String? displayStartGroup;
  String returnStartGroup = '';
  TextEditingController startGroupController = TextEditingController();
  // ----------------------------- End Group
  String? displayEndGroup;
  String returnEndGroup = '';
  TextEditingController endGroupController = TextEditingController();
  // ----------------------------- Start Category
  String? displayStartCategory;
  String returnStartCategory = '';
  TextEditingController startCategoryController = TextEditingController();
  // ----------------------------- End Category
  String? displayEndCategory;
  String returnEndCategory = '';
  TextEditingController endCategoryController = TextEditingController();
  // ----------------------------- Start Sub Category
  String? displayStartSubCategory;
  String returnStartSubCategory = '';
  TextEditingController startSubCategoryController = TextEditingController();
  // ----------------------------- End Sub Category
  String? displayEndSubCategory;
  String returnEndSubCategory = '';
  TextEditingController endSubCategoryController = TextEditingController();
  // ----------------------------- Start Item
  String? displayStartItem;
  String returnStartItem = '';
  TextEditingController startItemController = TextEditingController();
  // ----------------------------- End Item
  String? displayEndItem;
  String returnEndItem = '';
  TextEditingController endItemController = TextEditingController();
  // -----------------------------

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    selectLovDate();
    selectLovDocNo();
    selectLovStartWareCode();
    selectLovEndWareCode();
    selectLovStartLoc();
    selectLovEndLoc();
    selectLovStartGroup();
    selectLovEndGroup();
    selectLovStartCategory();
    selectLovEndCategory();
    selectLovStartSubCategory();
    selectLovEndSubCategory();
    selectLovStartItem();
    selectLovEndItem();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    dateController.dispose();
    docNoController.dispose();
    startWareCodeController.dispose();
    endWareCodeController.dispose();
    startLocController.dispose();
    endLocController.dispose();
    startGroupController.dispose();
    endGroupController.dispose();
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
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovStartWareCode/${globals.APP_USER}'));

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
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovEndWareCode/${globals.APP_USER}/${returnStartWareCode.isNotEmpty ? returnStartWareCode : 'null'}'));

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
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovStartLoc/${globals.P_ERP_OU_CODE}'
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
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SeletLovEndLoc'
          '/${globals.P_ERP_OU_CODE}'
          '/${returnStartLoc.isNotEmpty ? returnStartLoc : 'null'}'
          '/${returnStartWareCode.isNotEmpty ? returnStartWareCode : 'null'}'
          '/${returnEndWareCode.isNotEmpty ? returnEndWareCode : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndLoc =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovEndLoc : $dataLovEndLoc');
      } else {
        throw Exception(
            'dataLovEndLoc Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndLoc ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartGroup() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovStartGroup'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartGroup =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovEndLoc : $dataLovEndLoc');
      } else {
        throw Exception(
            'dataLovEndLoc Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndLoc ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndGroup() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovEndGroup/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndGroup =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovEndLoc : $dataLovEndLoc');
      } else {
        throw Exception(
            'dataLovEndLoc Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndLoc ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartCategory() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovStartCategory'
          '/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'
          '/${returnEndGroup.isNotEmpty ? returnEndGroup : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartCategory =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovStartCategory : $dataLovStartCategory');
      } else {
        throw Exception(
            'dataLovStartCategory Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovStartCategory ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndCategory() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovEndCategory'
          '/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'
          '/${returnEndGroup.isNotEmpty ? returnEndGroup : 'null'}'
          '/${returnStartCategory.isNotEmpty ? returnStartCategory : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndCategory =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovEndCategory : $dataLovEndCategory');
      } else {
        throw Exception(
            'dataLovEndCategory Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndCategory ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartSubCategory() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovStartSubCategory'
          '/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'
          '/${returnEndGroup.isNotEmpty ? returnEndGroup : 'null'}'
          '/${returnStartCategory.isNotEmpty ? returnStartCategory : 'null'}'
          '/${returnEndCategory.isNotEmpty ? returnEndCategory : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartSubCategory =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovEndCategory : $dataLovEndCategory');
      } else {
        throw Exception(
            'dataLovEndCategory Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndCategory ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndSubCategory() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovEndSubCategory'
          '/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'
          '/${returnEndGroup.isNotEmpty ? returnEndGroup : 'null'}'
          '/${returnStartCategory.isNotEmpty ? returnStartCategory : 'null'}'
          '/${returnEndCategory.isNotEmpty ? returnEndCategory : 'null'}'
          '/${returnStartSubCategory.isNotEmpty ? returnStartSubCategory : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndSubCategory =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovEndCategory : $dataLovEndCategory');
      } else {
        throw Exception(
            'dataLovEndCategory Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndCategory ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartItem() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovStartItem'
          '/${globals.BROWSER_LANGUAGE}'
          '/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'
          '/${returnEndGroup.isNotEmpty ? returnEndGroup : 'null'}'
          '/${returnStartCategory.isNotEmpty ? returnStartCategory : 'null'}'
          '/${returnEndCategory.isNotEmpty ? returnEndCategory : 'null'}'
          '/${returnStartSubCategory.isNotEmpty ? returnStartSubCategory : 'null'}'
          '/${returnEndSubCategory.isNotEmpty ? returnEndSubCategory : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartItem =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovStartItem : $dataLovStartItem');
      } else {
        throw Exception(
            'dataLovStartItem Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovStartItem ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndItem() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovEndItem'
          '/${globals.BROWSER_LANGUAGE}'
          '/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'
          '/${returnEndGroup.isNotEmpty ? returnEndGroup : 'null'}'
          '/${returnStartCategory.isNotEmpty ? returnStartCategory : 'null'}'
          '/${returnEndCategory.isNotEmpty ? returnEndCategory : 'null'}'
          '/${returnStartSubCategory.isNotEmpty ? returnStartSubCategory : 'null'}'
          '/${returnEndSubCategory.isNotEmpty ? returnEndSubCategory : 'null'}'
          '/${returnStartItem.isNotEmpty ? returnStartItem : 'null'}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndItem =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovStartItem : $dataLovStartItem');
      } else {
        throw Exception(
            'dataLovStartItem Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovStartItem ERROR IN Fetch Data : $e');
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchDate(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'วันที่เตรียมการตรวจนับ',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: docNoController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchDocNo(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'เลขที่ตรวจนับ',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),

              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: startWareCodeController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchStartWareCode(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'จาก คลังสินค้า',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),

              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: endWareCodeController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchEndWareCode(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ถึง คลังสินค้า',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),

              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: startLocController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchStartLoc(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'จาก ตำแหน่งจัดเก็บ',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),

              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: endLocController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchEndLoc(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ถึง ตำแหน่งจัดเก็บ',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),

              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: startGroupController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchStartGroup(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'จาก กลุ่มสินค้า',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: endGroupController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchEndGroup(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ถึง กลุ่มสินค้า',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: startCategoryController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchStartCategory(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'จาก Category',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: endCategoryController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchEndCategory(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ถึง Category',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: startSubCategoryController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchStartSubCategory(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'จาก Sub Category',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: endSubCategoryController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchEndSubCategory(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ถึง Sub Category',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: startItemController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchStartItem(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'จาก รหัสสินค้า',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              // -------------------------------------------------------------------------------------------------------------//
              const SizedBox(height: 8),
              TextFormField(
                controller: endItemController,
                readOnly: true,
                onTap: () => showDialogDropdownSearchEndItem(),
                minLines: 1,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ถึง รหัสสินค้า',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showDialogDropdownSearchDate() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'วันที่เตรียมการตรวจนับ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems = dataLovDate.where((item) {
                            final docString =
                                '${item['prepare_date']}'.toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['prepare_date']}';
                              final returnCode = '${item['prepare_date']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  doc,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnLovDate = returnCode;
                                    displayLovDate = doc;
                                    dateController.text =
                                        displayLovDate.toString();
                                    if (returnLovDate.isNotEmpty) {
                                      selectLovDocNo();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'dateController New: $dateController Type : ${dateController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayLovDate New: $displayLovDate Type : ${displayLovDate.runtimeType}');
                                    print(
                                        'returnLovDate New: $returnLovDate Type : ${returnLovDate.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchDocNo() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'เลขที่ตรวจนับ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems = dataLovDocNo.where((item) {
                            final docString =
                                '${item['doc_no']} ${item['prepare_date']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['doc_no']}';
                              final returnCode = '${item['prepare_date']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['doc_no']} ${item['prepare_date']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnLovDocNo = returnCode;
                                    displayLovDocNo = doc;
                                    docNoController.text =
                                        displayLovDocNo.toString();
                                    // -----------------------------------------
                                    print(
                                        'docNoController New: $docNoController Type : ${docNoController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayLovDocNo New: $displayLovDocNo Type : ${displayLovDocNo.runtimeType}');
                                    print(
                                        'returnLovDocNo New: $returnLovDocNo Type : ${returnLovDocNo.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchStartWareCode() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'จาก คลังสินค้า',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems =
                              dataLovStartWareCode.where((item) {
                            final docString =
                                '${item['ware_code']} ${item['ware_name']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['ware_code']}';
                              final returnCode = '${item['ware_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['ware_code']} ${item['ware_name']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnStartWareCode = returnCode;
                                    displayStartWareCode = doc;
                                    startWareCodeController.text =
                                        displayStartWareCode.toString();
                                    if (returnStartWareCode.isNotEmpty) {
                                      selectLovEndWareCode();
                                      selectLovStartLoc();
                                      selectLovEndLoc();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'startWareCodeController New: $startWareCodeController Type : ${startWareCodeController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayStartWareCode New: $displayStartWareCode Type : ${displayStartWareCode.runtimeType}');
                                    print(
                                        'returnStartWareCode New: $returnStartWareCode Type : ${returnStartWareCode.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchEndWareCode() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ถึง คลังสินค้า',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems =
                              dataLovEndWareCode.where((item) {
                            final docString =
                                '${item['ware_code']} ${item['ware_name']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['ware_code']}';
                              final returnCode = '${item['ware_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['ware_code']} ${item['ware_name']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnEndWareCode = returnCode;
                                    displayEndWareCode = doc;
                                    endWareCodeController.text =
                                        displayEndWareCode.toString();
                                    if (returnEndWareCode.isNotEmpty) {
                                      selectLovStartLoc();
                                      selectLovEndLoc();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'endWareCodeController New: $endWareCodeController Type : ${endWareCodeController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndWareCode New: $displayEndWareCode Type : ${displayEndWareCode.runtimeType}');
                                    print(
                                        'returnEndWareCode New: $returnEndWareCode Type : ${returnEndWareCode.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchStartLoc() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'จาก ตำแหน่งจัดเก็บ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems = dataLovStartLoc.where((item) {
                            final docString =
                                '${item['location_code']} ${item['location_name']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['location_code']}';
                              final returnCode = '${item['location_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['location_code']} ${item['location_name']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnStartLoc = returnCode;
                                    displayStartLoc = doc;
                                    startLocController.text =
                                        displayStartLoc.toString();
                                    if (returnStartLoc.isNotEmpty) {
                                      selectLovEndLoc();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'startLocController New: $startLocController Type : ${startLocController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayStartLoc New: $displayStartLoc Type : ${displayStartLoc.runtimeType}');
                                    print(
                                        'returnStartLoc New: $returnStartLoc Type : ${returnStartLoc.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchEndLoc() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ถึง ตำแหน่งจัดเก็บ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems = dataLovEndLoc.where((item) {
                            final docString =
                                '${item['location_code']} ${item['location_name']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['location_code']}';
                              final returnCode = '${item['location_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['location_code']} ${item['location_name']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnEndLoc = returnCode;
                                    displayEndLoc = doc;
                                    endLocController.text =
                                        displayEndLoc.toString();
                                    // -----------------------------------------
                                    print(
                                        'endLocController New: $endLocController Type : ${endLocController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndLoc New: $displayEndLoc Type : ${displayEndLoc.runtimeType}');
                                    print(
                                        'returnEndLoc New: $returnEndLoc Type : ${returnEndLoc.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchStartGroup() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'จาก กลุ่มสินค้า',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems = dataLovStartGroup.where((item) {
                            final docString =
                                '${item['group_code']} ${item['group_name']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['group_code']}';
                              final returnCode = '${item['group_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['group_code']} ${item['group_name']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnStartGroup = returnCode;
                                    displayStartGroup = doc;
                                    startGroupController.text =
                                        displayStartGroup.toString();
                                    if (returnStartGroup.isNotEmpty) {
                                      selectLovEndGroup();
                                      selectLovStartCategory();
                                      selectLovEndCategory();
                                      selectLovStartSubCategory();
                                      selectLovEndSubCategory();
                                      selectLovStartItem();
                                      selectLovEndItem();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'startGroupController New: $startGroupController Type : ${startGroupController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayStartGroup New: $displayStartGroup Type : ${displayStartGroup.runtimeType}');
                                    print(
                                        'returnStartGroup New: $returnStartGroup Type : ${returnStartGroup.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchEndGroup() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ถึง กลุ่มสินค้า',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems = dataLovEndGroup.where((item) {
                            final docString =
                                '${item['group_code']} ${item['group_name']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['group_code']}';
                              final returnCode = '${item['group_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['group_code']} ${item['group_name']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnEndGroup = returnCode;
                                    displayEndGroup = doc;
                                    endGroupController.text =
                                        displayEndGroup.toString();
                                    if (returnEndGroup.isNotEmpty) {
                                      selectLovStartCategory();
                                      selectLovEndCategory();
                                      selectLovStartSubCategory();
                                      selectLovEndSubCategory();
                                      selectLovStartItem();
                                      selectLovEndItem();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'endGroupController New: $endGroupController Type : ${endGroupController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndGroup New: $displayEndGroup Type : ${displayEndGroup.runtimeType}');
                                    print(
                                        'returnEndGroup New: $returnEndGroup Type : ${returnEndGroup.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchStartCategory() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'จาก Category',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems =
                              dataLovStartCategory.where((item) {
                            final docString =
                                '${item['category_code']} ${item['category_desc']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['category_code']}';
                              final returnCode = '${item['category_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['category_code']} ${item['category_desc']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnStartCategory = returnCode;
                                    displayStartCategory = doc;
                                    startCategoryController.text =
                                        displayStartCategory.toString();
                                    if (returnStartCategory.isNotEmpty) {
                                      selectLovEndCategory();
                                      selectLovStartSubCategory();
                                      selectLovEndSubCategory();
                                      selectLovStartItem();
                                      selectLovEndItem();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'endGroupController New: $endGroupController Type : ${endGroupController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayStartCategory New: $displayStartCategory Type : ${displayStartCategory.runtimeType}');
                                    print(
                                        'returnStartCategory New: $returnStartCategory Type : ${returnStartCategory.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchEndCategory() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ถึง Category',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems =
                              dataLovEndCategory.where((item) {
                            final docString =
                                '${item['category_code']} ${item['category_desc']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['category_code']}';
                              final returnCode = '${item['category_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['category_code']} ${item['category_desc']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnEndCategory = returnCode;
                                    displayEndCategory = doc;
                                    endCategoryController.text =
                                        displayEndCategory.toString();
                                    if (returnEndCategory.isNotEmpty) {
                                      selectLovStartSubCategory();
                                      selectLovEndSubCategory();
                                      selectLovStartItem();
                                      selectLovEndItem();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'endCategoryController New: $endCategoryController Type : ${endCategoryController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndCategory New: $displayEndCategory Type : ${displayEndCategory.runtimeType}');
                                    print(
                                        'returnEndCategory New: $returnEndCategory Type : ${returnEndCategory.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchStartSubCategory() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'จาก Sub Category',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems =
                              dataLovStartSubCategory.where((item) {
                            final docString =
                                '${item['sub_cat_code']} ${item['sub_cat_desc']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['sub_cat_code']}';
                              final returnCode = '${item['sub_cat_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['sub_cat_code']} ${item['sub_cat_desc']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnStartSubCategory = returnCode;
                                    displayStartSubCategory = doc;
                                    startSubCategoryController.text =
                                        displayStartSubCategory.toString();
                                    if (returnStartSubCategory.isNotEmpty) {
                                      selectLovEndSubCategory();
                                      selectLovStartItem();
                                      selectLovEndItem();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'startSubCategoryController New: $startSubCategoryController Type : ${startSubCategoryController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayStartSubCategory New: $displayStartSubCategory Type : ${displayStartSubCategory.runtimeType}');
                                    print(
                                        'returnStartSubCategory New: $returnStartSubCategory Type : ${returnStartSubCategory.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchEndSubCategory() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ถึง Sub Category',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems =
                              dataLovEndSubCategory.where((item) {
                            final docString =
                                '${item['sub_cat_code']} ${item['sub_cat_desc']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['sub_cat_code']}';
                              final returnCode = '${item['sub_cat_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['sub_cat_code']} ${item['sub_cat_desc']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnEndSubCategory = returnCode;
                                    displayEndSubCategory = doc;
                                    endSubCategoryController.text =
                                        displayEndSubCategory.toString();
                                    if (returnEndSubCategory.isNotEmpty) {
                                      selectLovStartItem();
                                      selectLovEndItem();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'endSubCategoryController New: $endSubCategoryController Type : ${endSubCategoryController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndSubCategory New: $displayEndSubCategory Type : ${displayEndSubCategory.runtimeType}');
                                    print(
                                        'returnEndSubCategory New: $returnEndSubCategory Type : ${returnEndSubCategory.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchStartItem() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'จาก รหัสสินค้า',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems = dataLovStartItem.where((item) {
                            final docString =
                                '${item['item_code']} ${item['name']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['item_code']}';
                              final returnCode = '${item['item_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['item_code']} ${item['name']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnStartItem = returnCode;
                                    displayStartItem = doc;
                                    startItemController.text =
                                        displayEndSubCategory.toString();
                                    if (returnStartItem.isNotEmpty) {
                                      selectLovEndItem();
                                    }
                                    // -----------------------------------------
                                    print(
                                        'startItemController New: $startItemController Type : ${startItemController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndSubCategory New: $displayEndSubCategory Type : ${displayEndSubCategory.runtimeType}');
                                    print(
                                        'returnStartItem New: $returnStartItem Type : ${returnStartItem.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showDialogDropdownSearchEndItem() {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ถึง รหัสสินค้า',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems = dataLovEndItem.where((item) {
                            final docString =
                                '${item['item_code']} ${item['name']}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ NO DATA FOUND หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('NO DATA FOUND'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['item_code']}';
                              final returnCode = '${item['item_code']}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['item_code']} ${item['name']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    returnEndItem = returnCode;
                                    displayEndItem = doc;
                                    endItemController.text =
                                        displayEndItem.toString();
                                    // -----------------------------------------
                                    print(
                                        'endItemController New: $endItemController Type : ${endItemController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndItem New: $displayEndItem Type : ${displayEndItem.runtimeType}');
                                    print(
                                        'returnEndItem New: $returnEndItem Type : ${returnEndItem.runtimeType}');
                                  });
                                  searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
