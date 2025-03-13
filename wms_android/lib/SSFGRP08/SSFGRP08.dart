import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/loading.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';

class SSFGRP08_MAIN extends StatefulWidget {
//////
  SSFGRP08_MAIN({
    Key? key,

    ///
  }) : super(key: key);
  @override
  _SSFGRP08_MAINState createState() => _SSFGRP08_MAINState();
}

class _SSFGRP08_MAINState extends State<SSFGRP08_MAIN> {
  // --------------------------------- data list
  List<dynamic> dataLovDocDate = [];
  List<dynamic> dataLovStartDocNo = [];
  List<dynamic> dataLovEndDocNo = [];
  List<dynamic> dataLovStartWare = [];
  List<dynamic> dataLovEndWare = [];
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
  // --------------------------------- Doc Date
  String? displayDocDate;
  String returnDocDate = '';
  TextEditingController docDateController = TextEditingController();
  // --------------------------------- Start Doc No
  String? displayStartDocNo;
  String returnStartDocNo = '';
  TextEditingController startDocNoController = TextEditingController();
  // --------------------------------- End Doc No
  String? displayEndDocNo;
  String displayEndDocNoBackup = '';
  String returnEndDocNo = '';
  TextEditingController endDocNoController = TextEditingController();
  // --------------------------------- Start Ware
  String? displayStartWare;
  String returnStartWare = '';
  TextEditingController startWareController = TextEditingController();
  // --------------------------------- End Ware
  String? displayEndWare;
  String displayEndWareBackup = '';
  String returnEndWare = '';
  TextEditingController endWareController = TextEditingController();
  // --------------------------------- Start Loc
  String? displayStartLoc;
  String returnStartLoc = '';
  TextEditingController startLocController = TextEditingController();
  // --------------------------------- End Loc
  String? displayEndLoc;
  String displayEndLocBackup = '';
  String returnEndLoc = '';
  TextEditingController endLocController = TextEditingController();
  // --------------------------------- Start Group
  String? displayStartGroup;
  String returnStartGroup = '';
  TextEditingController startGroupController = TextEditingController();
  // --------------------------------- End Group
  String? displayEndGroup;
  String displayEndGroupBackup = '';
  String returnEndGroup = '';
  TextEditingController endGroupController = TextEditingController();
  // --------------------------------- Start Category
  String? displayStartCategory;
  String returnStartCategory = '';
  TextEditingController startCategoryController = TextEditingController();
  // --------------------------------- End Category
  String? displayEndCategory;
  String displayEndCategoryBackup = '';
  String returnEndCategory = '';
  TextEditingController endCategoryController = TextEditingController();
  // --------------------------------- Start Sub Category
  String? displayStartSubCategory;
  String returnStartSubCategory = '';
  TextEditingController startSubCategoryController = TextEditingController();
  // --------------------------------- End Sub Category
  String? displayEndSubCategory;
  String displayEndSubCategoryBackup = '';
  String returnEndSubCategory = '';
  TextEditingController endSubCategoryController = TextEditingController();
  // --------------------------------- Start Item
  String? displayStartItem;
  String returnStartItem = '';
  TextEditingController startItemController = TextEditingController();
  // --------------------------------- End Item
  String? displayEndItem;
  String displayEndItemBackup = '';
  String returnEndItem = '';
  TextEditingController endItemController = TextEditingController();
  // --------------------------------- Radio Group
  String selectedRadio1 = 'S';
  String selectedRadio2 = '1';
  // ---------------------------------
  bool isLoading = false;
  bool isFirstLoad = true;
  bool checkUpdateData = false;
  // --------------------------------- Search Controller
  TextEditingController searchController1 = TextEditingController();
  TextEditingController searchController2 = TextEditingController();
  TextEditingController searchController3 = TextEditingController();
  TextEditingController searchController4 = TextEditingController();
  TextEditingController searchController5 = TextEditingController();
  TextEditingController searchController6 = TextEditingController();
  TextEditingController searchController7 = TextEditingController();
  TextEditingController searchController8 = TextEditingController();
  TextEditingController searchController9 = TextEditingController();
  TextEditingController searchController10 = TextEditingController();
  TextEditingController searchController11 = TextEditingController();
  TextEditingController searchController12 = TextEditingController();
  TextEditingController searchController13 = TextEditingController();
  TextEditingController searchController14 = TextEditingController();
  TextEditingController searchController15 = TextEditingController();
  // ---------------------------------

  @override
  void initState() {
    super.initState();
    firstLoadData();
    setDataFirstLoad();
  }

  @override
  void dispose() {
    docDateController.dispose();
    startDocNoController.dispose();
    endDocNoController.dispose();
    startWareController.dispose();
    endWareController.dispose();
    startLocController.dispose();
    endLocController.dispose();
    startGroupController.dispose();
    endGroupController.dispose();
    startCategoryController.dispose();
    endCategoryController.dispose();
    startSubCategoryController.dispose();
    endSubCategoryController.dispose();
    startItemController.dispose();
    endItemController.dispose();

    searchController1.dispose();
    searchController2.dispose();
    searchController3.dispose();
    searchController4.dispose();
    searchController5.dispose();
    searchController6.dispose();
    searchController7.dispose();
    searchController8.dispose();
    searchController9.dispose();
    searchController10.dispose();
    searchController11.dispose();
    searchController12.dispose();
    searchController13.dispose();
    searchController14.dispose();
    searchController15.dispose();
    super.dispose();
  }

  Future<void> firstLoadData() async {
    await selectLovDocDate();
    await selectLovStartDocNo();
    await selectLovEndDocNO();
    await selectLovStartWare();
    await selectLovEndWare();
    await selectLovStartLoc();
    await selectLovEndLoc();
    await selectLovStartGroup();
    await selectLovEndGroup();
    await selectLovStartCategory();
    await selectLovEndCategory();
    await selectLovStartSubCategory();
    await selectLovEndSubCategory();
    await selectLovStartItem();
    await selectLovEndItem();
    setDataFirstLoad();
  }

  Future<void> setDataFirstLoad() async {
    // ----------------------------
    displayDocDate = '';
    returnDocDate = '';
    docDateController.text = '';
    // ----------------------------
    displayStartDocNo = 'ทั้งหมด';
    returnStartDocNo = 'null';
    startDocNoController.text = 'ทั้งหมด';
    // ----------------------------
    displayEndDocNo = 'ทั้งหมด';
    returnEndDocNo = 'null';
    endDocNoController.text = 'ทั้งหมด';
    // ----------------------------
    displayStartWare = 'ทั้งหมด';
    returnStartWare = 'null';
    startWareController.text = 'ทั้งหมด';
    // ----------------------------
    displayEndWare = 'ทั้งหมด';
    returnEndWare = 'null';
    endWareController.text = 'ทั้งหมด';
    // ----------------------------
    displayStartLoc = 'ทั้งหมด';
    returnStartLoc = 'null';
    startLocController.text = 'ทั้งหมด';
    // ----------------------------
    displayEndLoc = 'ทั้งหมด';
    returnEndLoc = 'null';
    endLocController.text = 'ทั้งหมด';
    // ----------------------------
    displayStartGroup = 'ทั้งหมด';
    returnStartGroup = 'null';
    startGroupController.text = 'ทั้งหมด';
    // ----------------------------
    displayEndGroup = 'ทั้งหมด';
    returnEndGroup = 'null';
    endGroupController.text = 'ทั้งหมด';
    // ----------------------------
    displayStartCategory = 'ทั้งหมด';
    returnStartCategory = 'null';
    startCategoryController.text = 'ทั้งหมด';
    // ----------------------------
    displayEndCategory = 'ทั้งหมด';
    returnEndCategory = 'null';
    endCategoryController.text = 'ทั้งหมด';
    // ----------------------------
    displayStartSubCategory = 'ทั้งหมด';
    returnStartSubCategory = 'null';
    startSubCategoryController.text = 'ทั้งหมด';
    // ----------------------------
    displayEndSubCategory = 'ทั้งหมด';
    returnEndSubCategory = 'null';
    endSubCategoryController.text = 'ทั้งหมด';
    // ----------------------------
    displayStartItem = 'ทั้งหมด';
    returnStartItem = 'null';
    startItemController.text = 'ทั้งหมด';
    // ----------------------------
    displayEndItem = 'ทั้งหมด';
    returnEndItem = 'null';
    endItemController.text = 'ทั้งหมด';
    // ----------------------------
  }

  void checkUpdateDataALL(bool check) {
    if (mounted) {
      setState(() {
        checkUpdateData = check;
        print('check in checkUpdateDataALL : $check');
        print('checkUpdateData in checkUpdateDataALL : $checkUpdateData');
      });
    }
  }

  Future<void> selectLovDocDate() async {
    if (isFirstLoad == true) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
    } else if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectDocDate/${globals.P_ERP_OU_CODE}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovDocDate =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
          });
        }
        print('dataLovDocDate : $dataLovDocDate');
      } else {
        throw Exception('dataLovDocDate Failed to load fetchData');
      }
    } catch (e) {
      print('dataLovDocDate ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartDocNo() async {
    String dateCheck = returnDocDate.replaceAll('/', '-');
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartDocNo/${globals.P_ERP_OU_CODE}/${dateCheck.isNotEmpty ? dateCheck : 'null'}'));
      print(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartDocNo/${globals.P_ERP_OU_CODE}/${dateCheck.isNotEmpty ? dateCheck : 'null'}'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartDocNo =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
          });
        }
        print('dataLovStartDocNo : $dataLovStartDocNo');
      } else {
        throw Exception(
            'dataLovStartDocNo Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovStartDocNo ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndDocNO() async {
    String dateCheck = returnDocDate.replaceAll('/', '-');
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    print(
        '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndDocNo/${globals.P_ERP_OU_CODE}'
        '/${dateCheck.isEmpty ? 'null' : dateCheck}'
        '/${returnStartDocNo.isEmpty ? 'null' : returnStartDocNo}');
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndDocNo/${globals.P_ERP_OU_CODE}'
          '/${dateCheck.isEmpty ? 'null' : dateCheck}'
          '/${returnStartDocNo.isEmpty ? 'null' : returnStartDocNo}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndDocNo =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
          });
        }
        print('dataLovEndDocNo : $dataLovEndDocNo');
      } else {
        throw Exception(
            'dataLovEndDocNo Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndDocNo ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartWare() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartWare/${globals.P_ERP_OU_CODE}/${globals.APP_USER}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartWare =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
          });
        }
        print('dataLovStartWare : $dataLovStartWare');
      } else {
        throw Exception(
            'dataLovStartWare Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovStartWare ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndWare() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndWare/'
          '${globals.P_ERP_OU_CODE}/${globals.APP_USER}/${returnStartWare.isEmpty ? 'null' : returnStartWare}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndWare =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
          });
        }
        print('dataLovEndWare : $dataLovEndWare');
      } else {
        throw Exception(
            'dataLovEndWare Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndWare ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartLoc() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartLoc'
          '/${globals.P_ERP_OU_CODE}/${globals.APP_USER}/${returnStartWare.isEmpty ? 'null' : returnStartWare}'
          '/${returnEndWare.isEmpty ? 'null' : returnEndWare}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartLoc =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndLoc'
          '/${globals.P_ERP_OU_CODE}/${globals.APP_USER}/${returnStartWare.isEmpty ? 'null' : returnStartWare}'
          '/${returnEndWare.isEmpty ? 'null' : returnEndWare}/${returnStartLoc.isEmpty ? 'null' : returnStartLoc}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndLoc =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartGroup'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartGroup =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
          });
        }
        print('dataLovStartGroup : $dataLovStartGroup');
      } else {
        throw Exception(
            'dataLovStartGroup Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovStartGroup ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndGroup() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndGroup'
          '/${returnStartGroup.isEmpty ? 'null' : returnStartGroup}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndGroup =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
          });
        }
        print('dataLovEndGroup : $dataLovEndGroup');
      } else {
        throw Exception(
            'dataLovEndGroup Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndGroup ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartCategory() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartCategory'
          '/${returnStartGroup.isEmpty ? 'null' : returnStartGroup}/${returnEndGroup.isEmpty ? 'null' : returnEndGroup}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartCategory =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndCategory'
          '/${returnStartGroup.isEmpty ? 'null' : returnStartGroup}'
          '/${returnEndGroup.isEmpty ? 'null' : returnEndGroup}'
          '/${returnStartCategory.isEmpty ? 'null' : returnEndCategory}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndCategory =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartSubCategory'
          '/${returnStartGroup.isEmpty ? 'null' : returnStartGroup}'
          '/${returnEndGroup.isEmpty ? 'null' : returnEndGroup}'
          '/${returnStartCategory.isEmpty ? 'null' : returnStartCategory}'
          '/${returnEndCategory.isEmpty ? 'null' : returnEndCategory}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartSubCategory =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
          });
        }
        print('dataLovStartSubCategory : $dataLovStartSubCategory');
      } else {
        throw Exception(
            'dataLovStartSubCategory Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovStartSubCategory ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndSubCategory() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndSubCategory'
          '/${returnStartGroup.isEmpty ? 'null' : returnStartGroup}'
          '/${returnEndGroup.isEmpty ? 'null' : returnEndGroup}'
          '/${returnStartCategory.isEmpty ? 'null' : returnStartCategory}'
          '/${returnEndCategory.isEmpty ? 'null' : returnEndCategory}'
          '/${returnStartSubCategory.isEmpty ? 'null' : returnStartSubCategory}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndSubCategory =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
          });
        }
        print('dataLovEndSubCategory : $dataLovEndSubCategory');
      } else {
        throw Exception(
            'dataLovEndSubCategory Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndSubCategory ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartItem() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartItem'
          '/${globals.BROWSER_LANGUAGE}'
          '/${returnStartGroup.isEmpty ? 'null' : returnStartGroup}'
          '/${returnEndGroup.isEmpty ? 'null' : returnEndGroup}'
          '/${returnStartCategory.isEmpty ? 'null' : returnStartCategory}'
          '/${returnEndCategory.isEmpty ? 'null' : returnEndCategory}'
          '/${returnStartSubCategory.isEmpty ? 'null' : returnStartSubCategory}'
          '/${returnEndSubCategory.isEmpty ? 'null' : returnEndSubCategory}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovStartItem =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndItem'
          '/${globals.BROWSER_LANGUAGE}'
          '/${returnStartGroup.isEmpty ? 'null' : returnStartGroup}'
          '/${returnEndGroup.isEmpty ? 'null' : returnEndGroup}'
          '/${returnStartCategory.isEmpty ? 'null' : returnStartCategory}'
          '/${returnEndCategory.isEmpty ? 'null' : returnEndCategory}'
          '/${returnStartSubCategory.isEmpty ? 'null' : returnStartSubCategory}'
          '/${returnEndSubCategory.isEmpty ? 'null' : returnEndSubCategory}'
          '/${returnStartItem.isEmpty ? 'null' : returnStartItem}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovEndItem =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == true) {
              isFirstLoad = false;
              isLoading = false;
            }
            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
          });
        }
        print('dataLovEndItem : $dataLovEndItem');
      } else {
        throw Exception(
            'dataLovEndItem Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndItem ERROR IN Fetch Data : $e');
    }
  }

  Future<void> getPDFCard() async {
    print('${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_GETPDFCard'
        '/${globals.P_OU_NAME}/${globals.P_ERP_OU_CODE}'
        '/${globals.BROWSER_LANGUAGE}/${globals.APP_USER}/${globals.P_DS_PDF}');
    isLoading = true;
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_GETPDFCard'
          '/${globals.P_OU_NAME}/${globals.P_ERP_OU_CODE}'
          '/${globals.BROWSER_LANGUAGE}/${globals.APP_USER}/${globals.P_DS_PDF}'));

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataPDF =
            jsonDecode(utf8.decode(response.bodyBytes));
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
        if (mounted) {
          setState(() {
            String? LIN_ID = dataPDF['LIN_ID'] ?? '';
            String? P_OU_NAME = dataPDF['P_OU_NAME'] ?? '';
            String? P_PROGRAM_ID = dataPDF['P_PROGRAM_ID'] ?? '';
            String? P_USER_ID = dataPDF['P_USER_ID'] ?? '';
            String? P_OU_CODE = dataPDF['P_OU_CODE'] ?? '';
            String? V_SYSDATE = dataPDF['V_SYSDATE'] ?? '';
            String? LB_COUNT_QTY = dataPDF['LB_COUNT_QTY'] ?? '';
            String? LB_DIFF_QTY = dataPDF['LB_DIFF_QTY'] ?? '';
            String? LB_ITEM_CODE_EN = dataPDF['LB_ITEM_CODE_EN'] ?? '';
            String? LB_ITEM_CODE_TH = dataPDF['LB_ITEM_CODE_TH'] ?? '';
            String? LB_ITEM_NAME_EN = dataPDF['LB_ITEM_NAME_EN'] ?? '';
            String? LB_ITEM_NAME_TH = dataPDF['LB_ITEM_NAME_TH'] ?? '';
            String? LB_REMARK = dataPDF['LB_REMARK'] ?? '';
            String? LB_SYS_QTY = dataPDF['LB_SYS_QTY'] ?? '';
            String? LH_DATE_EN = dataPDF['LH_DATE_EN'] ?? '';
            String? LH_DATE_TH = dataPDF['LH_DATE_TH'] ?? '';
            String? LH_LOCATION = dataPDF['LH_LOCATION'] ?? '';
            String? LH_NO = dataPDF['LH_NO'] ?? '';
            String? LH_TAG_NAME_EN = dataPDF['LH_TAG_NAME_EN'] ?? '';
            String? LH_TAG_NAME_TH = dataPDF['LH_TAG_NAME_TH'] ?? '';
            String? LT_SIGN1 = dataPDF['LT_SIGN1'] ?? '';
            String? LT_SIGN2 = dataPDF['LT_SIGN2'] ?? '';
            String? LT_SIGN3 = dataPDF['LT_SIGN3'] ?? '';

            isLoading = false;
            _launchUrlCard(
                LIN_ID,
                P_OU_NAME,
                P_PROGRAM_ID,
                P_USER_ID,
                P_OU_CODE,
                V_SYSDATE,
                LB_COUNT_QTY,
                LB_DIFF_QTY,
                LB_ITEM_CODE_EN,
                LB_ITEM_CODE_TH,
                LB_ITEM_NAME_EN,
                LB_ITEM_NAME_TH,
                LB_REMARK,
                LB_SYS_QTY,
                LH_DATE_EN,
                LH_DATE_TH,
                LH_LOCATION,
                LH_NO,
                LH_TAG_NAME_EN,
                LH_TAG_NAME_TH,
                LT_SIGN1,
                LT_SIGN2,
                LT_SIGN3);
          });
        }
      } else {
        print(' getPDFCard รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getPDFCard : $e');
    }
  }

  Future<void> _launchUrlCard(
    String? LIN_ID,
    String? P_OU_NAME,
    String? P_PROGRAM_ID,
    String? P_USER_ID,
    String? P_OU_CODE,
    String? V_SYSDATE,
    String? LB_COUNT_QTY,
    String? LB_DIFF_QTY,
    String? LB_ITEM_CODE_EN,
    String? LB_ITEM_CODE_TH,
    String? LB_ITEM_NAME_EN,
    String? LB_ITEM_NAME_TH,
    String? LB_REMARK,
    String? LB_SYS_QTY,
    String? LH_DATE_EN,
    String? LH_DATE_TH,
    String? LH_LOCATION,
    String? LH_NO,
    String? LH_TAG_NAME_EN,
    String? LH_TAG_NAME_TH,
    String? LT_SIGN1,
    String? LT_SIGN2,
    String? LT_SIGN3,
  ) async {
    final uri = Uri.parse('${globals.IP_API}/jri/report?'
        '&_repName=WMS/WMS_SSFGRP08_2'
        '&_repFormat=pdf'
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=SSFGRP08_2_$V_SYSDATE.pdf'
        '&_repLocale=en_US'
        '&P_USER_ID=$P_USER_ID'
        '&P_OU_CODE=$P_OU_CODE'
        '&P_OU_NAME=$P_OU_NAME'
        '&P_PROGRAM_ID=SSFGRP08'
        '&P_PROGRAM_NAME=undefined'
        // '&P_PROGRAM_NAME=$P_PROGRAM_ID'
        '&P_OU_NAME=$P_OU_NAME'
        '&LIN_ID=$LIN_ID'
        '&P_DATE=$returnDocDate'
        '&P_E_CAT=${returnEndCategory == 'null' ? '' : returnEndCategory}'
        '&P_E_GRP=${returnEndGroup == 'null' ? '' : returnEndGroup}'
        '&P_E_ITEM=${returnEndItem == 'null' ? '' : returnEndItem}'
        '&P_E_LOC=${returnEndLoc == 'null' ? '' : returnEndLoc}'
        '&P_E_LOT=${returnEndDocNo == 'null' ? '' : returnEndDocNo}'
        '&P_E_SUB_CAT=${returnEndSubCategory == 'null' ? '' : returnEndSubCategory}'
        '&P_E_WARE=${returnEndWare == 'null' ? '' : returnEndWare}'
        '&P_S_CAT=${returnStartCategory == 'null' ? '' : returnStartCategory}'
        '&P_S_GRP=${returnStartGroup == 'null' ? '' : returnStartGroup}'
        '&P_S_ITEM=${returnStartItem == 'null' ? '' : returnStartItem}'
        '&P_S_LOC=${returnStartLoc == 'null' ? '' : returnStartLoc}'
        '&P_S_LOT=${returnStartDocNo == 'null' ? '' : returnStartDocNo}'
        '&P_S_SUB_CAT=${returnStartSubCategory == 'null' ? '' : returnStartSubCategory}'
        '&P_S_WARE=${returnStartWare == 'null' ? '' : returnStartWare}'
        '&LB_COUNT_QTY=$LB_COUNT_QTY'
        '&LB_DIFF_QTY=$LB_DIFF_QTY'
        '&LB_ITEM_CODE_EN=$LB_ITEM_CODE_EN'
        '&LB_ITEM_CODE_TH=$LB_ITEM_CODE_TH'
        '&LB_ITEM_NAME_EN=$LB_ITEM_NAME_EN'
        '&LB_ITEM_NAME_TH=$LB_ITEM_NAME_TH'
        '&LB_REMARK=$LB_REMARK'
        '&LB_SYS_QTY=$LB_SYS_QTY'
        '&LH_DATE_EN=$LH_DATE_EN'
        '&LH_DATE_TH=$LH_DATE_TH'
        '&LH_LOCATION=$LH_LOCATION'
        '&LH_NO=$LH_NO'
        '&LH_TAG_NAME_EN=$LH_TAG_NAME_EN'
        '&LH_TAG_NAME_TH=$LH_TAG_NAME_TH'
        '&LT_SIGN1=$LT_SIGN1'
        '&LT_SIGN2=$LT_SIGN2'
        '&LT_SIGN3=$LT_SIGN3');

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  Future<void> getPDFSheet() async {
    isLoading = true;
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_GETPDFSheet'
          '/${globals.P_DS_PDF}/${globals.P_OU_NAME}'
          '/${globals.APP_USER}/${globals.BROWSER_LANGUAGE}'
          '/${globals.P_ERP_OU_CODE}'));

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataPDF =
            jsonDecode(utf8.decode(response.bodyBytes));
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
        if (mounted) {
          setState(() {
            String? LIN_ID = dataPDF['LIN_ID'] ?? '';
            String? V_DS_PDF = dataPDF['V_DS_PDF'] ?? '';
            String? V_SYSDATE = dataPDF['V_SYSDATE'] ?? '';
            String? P_OU_NAME = dataPDF['P_OU_NAME'] ?? '';
            String? P_PROGRAM_ID = dataPDF['P_PROGRAM_ID'] ?? '';
            String? P_USER_ID = dataPDF['P_USER_ID'] ?? '';
            String? P_OU_CODE = dataPDF['P_OU_CODE'] ?? '';
            String? P_PROGRAM_NAME = dataPDF['P_PROGRAM_NAME'] ?? '';

            String? LH_DESC = dataPDF['LH_DESC'] ?? '';
            String? LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
            String? LH_DOC_DATE = dataPDF['LH_DOC_DATE'] ?? '';
            String? LB_WARE = dataPDF['LB_WARE'] ?? '';
            String? LB_SEQ = dataPDF['LB_SEQ'] ?? '';
            String? LB_ITEM_CODE = dataPDF['LB_ITEM_CODE'] ?? '';
            String? LB_DETAIL = dataPDF['LB_DETAIL'] ?? '';
            String? LB_LOC = dataPDF['LB_LOC'] ?? '';
            String? LB_BAL = dataPDF['LB_BAL'] ?? '';
            String? LB_UMS = dataPDF['LB_UMS'] ?? '';
            String? LB_COUNT = dataPDF['LB_COUNT'] ?? '';
            String? LB_REMARK = dataPDF['LB_REMARK'] ?? '';
            String? LT_SIGN1 = dataPDF['LT_SIGN1'] ?? '';
            String? LT_SIGN2 = dataPDF['LT_SIGN2'] ?? '';
            String? LT_SIGN3 = dataPDF['LT_SIGN3'] ?? '';
            String? LT_SIGN4 = dataPDF['LT_SIGN4'] ?? '';
            String? LT_DATE = dataPDF['LT_DATE'] ?? '';
            String? LT_PAGE = dataPDF['LT_PAGE'] ?? '';
            String? LT_PAGE1 = dataPDF['LT_PAGE1'] ?? '';

            isLoading = false;
            _launchUrlSheet(
                LIN_ID,
                V_DS_PDF,
                V_SYSDATE,
                P_OU_NAME,
                P_PROGRAM_ID,
                P_USER_ID,
                P_OU_CODE,
                P_PROGRAM_NAME,
                LH_DESC,
                LH_DOC_NO,
                LH_DOC_DATE,
                LB_WARE,
                LB_SEQ,
                LB_ITEM_CODE,
                LB_DETAIL,
                LB_LOC,
                LB_BAL,
                LB_UMS,
                LB_COUNT,
                LB_REMARK,
                LT_SIGN1,
                LT_SIGN2,
                LT_SIGN3,
                LT_SIGN4,
                LT_DATE,
                LT_PAGE,
                LT_PAGE1
                //
                );
          });
        }
      } else {
        print(' getPDFCard รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getPDFCard : $e');
    }
  }

  Future<void> _launchUrlSheet(
      String? LIN_ID,
      String? V_DS_PDF,
      String? V_SYSDATE,
      String? P_OU_NAME,
      String? P_PROGRAM_ID,
      String? P_USER_ID,
      String? P_OU_CODE,
      String? P_PROGRAM_NAME,
      String? LH_DESC,
      String? LH_DOC_NO,
      String? LH_DOC_DATE,
      String? LB_WARE,
      String? LB_SEQ,
      String? LB_ITEM_CODE,
      String? LB_DETAIL,
      String? LB_LOC,
      String? LB_BAL,
      String? LB_UMS,
      String? LB_COUNT,
      String? LB_REMARK,
      String? LT_SIGN1,
      String? LT_SIGN2,
      String? LT_SIGN3,
      String? LT_SIGN4,
      String? LT_DATE,
      String? LT_PAGE,
      String? LT_PAGE1) async {
    final uri = Uri.parse('${globals.IP_API}/jri/report?'
        '&_repName=WMS/WMS_SSFGRP08_1'
        '&_repFormat=pdf'
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=SSFGRP08_1_$V_SYSDATE.pdf'
        '&_repLocale=en_US'
        //
        '&P_USER_ID=$P_USER_ID'
        '&P_OU_CODE=$P_OU_CODE'
        '&LIN_ID=$LIN_ID'
        '&P_OU_NAME=$P_OU_NAME'
        '&P_PROGRAM_NAME=$P_PROGRAM_ID'
        //
        '&P_DATE=$returnDocDate'
        '&P_E_CAT=${returnEndCategory == 'null' ? '' : returnEndCategory}'
        '&P_E_GRP=${returnEndGroup == 'null' ? '' : returnEndGroup}'
        '&P_E_ITEM=${returnEndItem == 'null' ? '' : returnEndItem}'
        '&P_E_LOC=${returnEndLoc == 'null' ? '' : returnEndLoc}'
        '&P_E_LOT=${returnEndDocNo == 'null' ? '' : returnEndDocNo}'
        '&P_E_SUB_CAT=${returnEndSubCategory == 'null' ? '' : returnEndSubCategory}'
        '&P_E_WARE=${returnEndWare == 'null' ? '' : returnEndWare}'
        '&P_S_CAT=${returnStartCategory == 'null' ? '' : returnStartCategory}'
        '&P_S_GRP=${returnStartGroup == 'null' ? '' : returnStartGroup}'
        '&P_S_ITEM=${returnStartItem == 'null' ? '' : returnStartItem}'
        '&P_S_LOC=${returnStartLoc == 'null' ? '' : returnStartLoc}'
        '&P_S_LOT=${returnStartDocNo == 'null' ? '' : returnStartDocNo}'
        '&P_S_SUB_CAT=${returnStartSubCategory == 'null' ? '' : returnStartSubCategory}'
        '&P_S_WARE=${returnStartWare == 'null' ? '' : returnStartWare}'
        '&P_COND=$selectedRadio1'
        '&P_GROUP=$selectedRadio2'
        //
        '&LH_DESC=$LH_DESC'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_DOC_DATE=$LH_DOC_DATE'
        '&LB_WARE=$LB_WARE'
        '&LB_SEQ=$LB_SEQ'
        '&LB_ITEM_CODE=$LB_ITEM_CODE'
        '&LB_DETAIL=$LB_DETAIL'
        '&LB_LOC=$LB_LOC'
        '&LB_BAL=$LB_BAL'
        '&LB_UMS=$LB_UMS'
        '&LB_COUNT=$LB_COUNT'
        '&LB_REMARK=$LB_REMARK'
        '&LT_SIGN1=$LT_SIGN1'
        '&LT_SIGN2=$LT_SIGN2'
        '&LT_SIGN3=$LT_SIGN3'
        '&LT_SIGN4=$LT_SIGN4'
        '&LT_DATE=$LT_DATE'
        '&LT_PAGE=$LT_PAGE'
        '&LT_PAGE1=$LT_PAGE1'
        //
        );

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'รายงานเตรียมการตรวจนับสินค้า',
          showExitWarning: checkUpdateData),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Column(
                children: [
                  Expanded(
                    child: Center(
                      child: LoadingIndicator(),
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: docDateController,
                      readOnly: true,
                      onTap: () => showDialogDropdownSearchDocDate(),
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
                          fontSize: 12,
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startDocNoController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchStartDocNo(),
                            minLines: 1,
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'จาก เลขที่เอกสาร',
                              labelStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            // style: const TextStyle(
                            //   fontSize: 14,
                            //   color: Colors.black,
                            // ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: endDocNoController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchEndDocNo(),
                            minLines: 1,
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'ถึง เลขที่เอกสาร',
                              labelStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startWareController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchStartWare(),
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
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: endWareController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchEndWare(),
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
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
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
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
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
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
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
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
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
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startCategoryController,
                            readOnly: true,
                            onTap: () =>
                                showDialogDropdownSearchStartCategory(),
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
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
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
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startSubCategoryController,
                            readOnly: true,
                            onTap: () =>
                                showDialogDropdownSearchStartSubCategory(),
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
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: endSubCategoryController,
                            readOnly: true,
                            onTap: () =>
                                showDialogDropdownSearchEndSubCategory(),
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
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
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
                              labelText: 'จาก รหัสวัตถุดิบ',
                              labelStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
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
                              labelText: 'ถึง รหัสวัตถุดิบ',
                              labelStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text(
                                  'เงื่อนไขการพิมพ์',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RadioListTile<String>(
                            title: Text(
                              'แสดงจำนวน',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: selectedRadio1 == 'S'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            value: 'S',
                            groupValue: selectedRadio1,
                            onChanged: (String? value) {
                              setState(() {
                                selectedRadio1 = value.toString();
                                print('selectedRadio1 : $selectedRadio1');
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: Text(
                              'Blank Forms (Blind Count)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: selectedRadio1 == 'B'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            value: 'B',
                            groupValue: selectedRadio1,
                            onChanged: (String? value) {
                              setState(() {
                                selectedRadio1 = value.toString();
                                print('selectedRadio1 : $selectedRadio1');
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text(
                                  'รูปแบบรายงาน',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RadioListTile<String>(
                            title: Text(
                              'คลังสินค้า',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: selectedRadio2 == '1'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            value: '1',
                            groupValue: selectedRadio2,
                            onChanged: (String? value) {
                              setState(() {
                                selectedRadio2 = value.toString();
                                print('selectedRadio2 : $selectedRadio2');
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: Text(
                              'กลุ่มสินค้า',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: selectedRadio2 == '2'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            value: '2',
                            groupValue: selectedRadio2,
                            onChanged: (String? value) {
                              setState(() {
                                selectedRadio2 = value.toString();
                                print('selectedRadio2 : $selectedRadio2');
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (returnDocDate.isNotEmpty) {
                              getPDFCard();
                            } else {
                              String message =
                                  'กรุณาระบุข้อมูล วันที่เตรียมการตรวจนับ';
                              showDialogAlert(context, message);
                            }
                          },
                          style: AppStyles.ConfirmbuttonStyle(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'พิมพ์บัตร',
                                style: AppStyles.ConfirmbuttonTextStyle(),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (returnDocDate.isNotEmpty) {
                              getPDFSheet();
                            } else {
                              String message =
                                  'กรุณาระบุข้อมูล วันที่เตรียมการตรวจนับ';
                              showDialogAlert(context, message);
                            }
                          },
                          style: AppStyles.ConfirmbuttonStyle(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'พิมพ์ใบตรวจนับ',
                                style: AppStyles.ConfirmbuttonTextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // -----------------------------------------------
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: checkUpdateData == true ? 'show' : 'not_show',
      ),
    );
  }

  // --------------------------------- ||
  var maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')}, // อนุญาตเฉพาะตัวเลข
  );
  // --------------------------------- ||

  void showDialogDropdownSearchDocDate() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'วันที่เตรียมการตรวจนับ',
          searchController: searchController1,
          data: dataLovDocDate,
          docString: (item) => '${item['prepare_date'] ?? ''}',
          titleText: (item) => '${item['prepare_date'] ?? ''}',
          subtitleText: (item) => null,
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnDocDate = '${item['prepare_date'] ?? ''}';
              displayDocDate = '${item['prepare_date'] ?? ''}';
              print('prepare_date : ${item['prepare_date'] ?? ''}');
              docDateController.text = displayDocDate.toString();
              if (returnDocDate.isNotEmpty) {
                selectLovStartDocNo();
                displayStartDocNo = 'ทั้งหมด';
                returnStartDocNo = 'null';
                startDocNoController.text = 'ทั้งหมด';
                searchController2.clear;
                selectLovEndDocNO();
                displayEndDocNo = 'ทั้งหมด';
                displayEndDocNoBackup = '';
                returnEndDocNo = 'null';
                endDocNoController.text = 'ทั้งหมด';
                searchController3.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnDocDate != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchStartDocNo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก เลขที่เอกสาร',
          searchController: searchController2,
          data: dataLovStartDocNo,
          docString: (item) =>
              '${item['doc_no'] ?? 'ทั้งหมด'} ${item['doc_date'] ?? ''}',
          titleText: (item) => '${item['doc_no'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final docNo = item['doc_date'] ?? '';
            return docNo.isNotEmpty ? docNo : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartDocNo = '${item['doc_no'] ?? 'null'}';
              displayStartDocNo = '${item['doc_no'] ?? 'ทั้งหมด'}';
              print('doc_no : ${item['doc_no'] ?? ''}');
              startDocNoController.text = displayStartDocNo.toString();
              if (returnStartDocNo.isNotEmpty) {
                if (returnEndDocNo.isNotEmpty &&
                    returnEndDocNo != 'null' &&
                    returnStartDocNo != 'null') {
                  if (displayStartDocNo
                          .toString()
                          .compareTo(displayEndDocNo.toString()) >
                      0) {
                    displayEndDocNo = displayStartDocNo;
                    displayEndDocNoBackup = displayStartDocNo ?? '';
                    returnEndDocNo = returnStartDocNo;
                    endDocNoController.text = displayStartDocNo.toString();
                  }
                } else if (returnEndDocNo == 'null' &&
                    displayEndDocNoBackup.toString().isNotEmpty) {
                  if (displayStartDocNo
                          .toString()
                          .compareTo(displayEndDocNo.toString()) >
                      0) {
                    displayEndDocNo = displayStartDocNo;
                    displayEndDocNoBackup = displayStartDocNo ?? '';
                    returnEndDocNo = returnStartDocNo;
                    endDocNoController.text = displayStartDocNo.toString();
                  } else {
                    displayEndDocNo = displayEndDocNoBackup;
                    // displayEndDocNoBackup = displayStartDocNo;
                    returnEndDocNo = returnStartDocNo;
                    endDocNoController.text = displayEndDocNoBackup.toString();
                  }
                }
                selectLovEndDocNO();
                searchController3.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (displayStartDocNo != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchEndDocNo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง เลขที่เอกสาร',
          searchController: searchController3,
          data: dataLovEndDocNo,
          docString: (item) =>
              '${item['doc_no'] ?? 'ทั้งหมด'} ${item['doc_date'] ?? ''}',
          titleText: (item) => '${item['doc_no'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final docNo = item['doc_date'] ?? '';
            return docNo.isNotEmpty ? docNo : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndDocNo = '${item['doc_no'] ?? 'null'}';
              displayEndDocNo = '${item['doc_date'] ?? 'ทั้งหมด'}';
              print('doc_date : ${item['doc_date'] ?? ''}');
              if (displayEndDocNo.toString().isNotEmpty &&
                  displayEndDocNo != 'ทั้งหมด' &&
                  returnEndDocNo != 'null') {
                displayEndDocNoBackup = '${item['doc_date']}';
              } else {
                displayEndDocNoBackup = '';
              }
              endDocNoController.text = displayEndDocNo.toString();
              if (returnEndDocNo.isNotEmpty) {
                //
              }
              isLoading = false;
              // -----------------------------------------
              print('displayEndDocNoBackup : $displayEndDocNoBackup');
            });
            if (returnEndDocNo != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchStartWare() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก คลังสินค้า',
          searchController: searchController4,
          data: dataLovStartWare,
          docString: (item) =>
              '${item['ware_code'] ?? 'ทั้งหมด'} ${item['ware_name'] ?? ''}',
          titleText: (item) => '${item['ware_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final wareName = item['ware_name'] ?? '';
            return wareName.isNotEmpty ? wareName : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartWare = '${item['ware_code'] ?? 'null'}';
              displayStartWare = '${item['ware_code'] ?? 'ทั้งหมด'}';
              print('ware_code : ${item['ware_code'] ?? ''}');
              startWareController.text = displayStartWare.toString();
              if (returnStartWare.isNotEmpty) {
                if (returnEndWare.isNotEmpty &&
                    returnEndWare != 'null' &&
                    returnStartWare != 'null') {
                  if (displayStartWare
                          .toString()
                          .compareTo(displayEndWare.toString()) >
                      0) {
                    displayEndWare = displayStartWare;
                    displayEndWareBackup = displayStartWare ?? '';
                    returnEndWare = returnStartWare;
                    endWareController.text = displayStartWare.toString();
                  }
                } else if (returnEndWare == 'null' &&
                    displayEndWareBackup.toString().isNotEmpty) {
                  if (displayStartWare
                          .toString()
                          .compareTo(displayEndWare.toString()) >
                      0) {
                    displayEndWare = displayStartWare;
                    displayEndWareBackup = displayStartWare ?? '';
                    returnEndWare = returnStartWare;
                    endWareController.text = displayStartWare.toString();
                  } else {
                    displayEndWare = displayEndWareBackup;
                    returnEndWare = returnStartWare;
                    endWareController.text = displayEndWareBackup.toString();
                  }
                }
                selectLovEndWare();
                searchController5.clear;
                selectLovStartLoc();
                displayStartLoc = 'ทั้งหมด';
                returnStartLoc = 'null';
                startLocController.text = 'ทั้งหมด';
                searchController6.clear;
                selectLovEndLoc();
                displayEndLoc = 'ทั้งหมด';
                displayEndLocBackup = '';
                returnEndLoc = 'null';
                endLocController.text = 'ทั้งหมด';
                searchController7.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnStartWare != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchEndWare() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง คลังสินค้า',
          searchController: searchController5,
          data: dataLovEndWare,
          docString: (item) =>
              '${item['ware_code'] ?? ''} ${item['ware_name'] ?? 'ทั้งหมด'}',
          titleText: (item) => '${item['ware_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final wareName = item['ware_name'] ?? '';
            return wareName.isNotEmpty ? wareName : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndWare = '${item['ware_code'] ?? 'null'}';
              displayEndWare = '${item['ware_code'] ?? 'ทั้งหมด'}';
              if (displayEndWare.toString().isNotEmpty &&
                  displayEndWare != 'ทั้งหมด' &&
                  returnEndWare != 'null') {
                displayEndWareBackup = '${item['ware_code']}';
              } else {
                displayEndWareBackup = '';
              }
              print('ware_code : ${item['ware_code'] ?? ''}');
              endWareController.text = displayEndWare.toString();
              if (returnEndWare.isNotEmpty) {
                selectLovStartLoc();
                displayStartDocNo = 'ทั้งหมด';
                returnStartLoc = 'null';
                startLocController.text = 'ทั้งหมด';
                searchController6.clear;
                selectLovEndLoc();
                displayEndLoc = 'ทั้งหมด';
                displayEndLocBackup = '';
                returnEndLoc = 'null';
                endLocController.text = 'ทั้งหมด';
                searchController7.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnEndWare != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchStartLoc() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก ตำแหน่งจัดเก็บ',
          searchController: searchController6,
          data: dataLovStartLoc,
          docString: (item) =>
              '${item['location_code'] ?? 'ทั้งหมด'} ${item['location_name'] ?? ''} ${item['ware_code'] ?? ''}',
          titleText: (item) => '${item['location_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final locName = item['location_name'] ?? '';
            return locName.isNotEmpty ? locName : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartLoc = '${item['location_code'] ?? 'null'}';
              displayStartLoc = '${item['location_code'] ?? 'ทั้งหมด'}';
              print('location_code : ${item['location_code'] ?? ''}');
              startLocController.text = displayStartLoc.toString();
              if (returnStartLoc.isNotEmpty) {
                if (returnEndLoc.isNotEmpty &&
                    returnEndLoc != 'null' &&
                    returnStartLoc != 'null') {
                  if (displayStartLoc
                          .toString()
                          .compareTo(displayEndLoc.toString()) >
                      0) {
                    displayEndLoc = displayStartLoc;
                    displayEndLocBackup = displayStartLoc ?? '';
                    returnEndLoc = returnStartLoc;
                    endLocController.text = displayStartLoc.toString();
                  }
                } else if (returnEndLoc == 'null' &&
                    displayEndLocBackup.toString().isNotEmpty) {
                  if (displayStartLoc
                          .toString()
                          .compareTo(displayEndLoc.toString()) >
                      0) {
                    displayEndLoc = displayStartLoc;
                    displayEndLocBackup = displayStartLoc ?? '';
                    returnEndLoc = returnStartLoc;
                    endLocController.text = displayStartLoc.toString();
                  } else {
                    displayEndLoc = displayEndLocBackup;
                    returnEndLoc = returnStartLoc;
                    endLocController.text = displayEndLocBackup.toString();
                  }
                }
                selectLovEndLoc();
                searchController7.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnStartLoc != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchEndLoc() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง ตำแหน่งจัดเก็บ',
          searchController: searchController7,
          data: dataLovEndLoc,
          docString: (item) =>
              '${item['location_code'] ?? 'ทั้งหมด'} ${item['location_name'] ?? ''} ${item['ware_code'] ?? ''}',
          titleText: (item) => '${item['location_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final locName = item['location_name'] ?? '';
            return locName.isNotEmpty ? locName : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndLoc = '${item['location_code'] ?? 'null'}';
              displayEndLoc = '${item['location_code'] ?? 'ทั้งหมด'}';
              if (displayEndLoc.toString().isNotEmpty &&
                  displayEndLoc != 'ทั้งหมด' &&
                  returnEndLoc != 'null') {
                displayEndLocBackup = '${item['location_code']}';
              } else {
                displayEndLocBackup = '';
              }
              print('location_code : ${item['location_code'] ?? ''}');
              endLocController.text = displayEndLoc.toString();
              if (returnEndLoc.isNotEmpty) {
                //
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnEndLoc != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchStartGroup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก กลุ่มสินค้า',
          searchController: searchController8,
          data: dataLovStartGroup,
          docString: (item) =>
              '${item['group_code'] ?? 'ทั้งหมด'} ${item['group_name'] ?? ''}',
          titleText: (item) => '${item['group_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final groupName = item['group_name'] ?? '';
            return groupName.isNotEmpty ? groupName : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartGroup = '${item['group_code'] ?? 'null'}';
              displayStartGroup = '${item['group_code'] ?? 'ทั้งหมด'}';
              print('group_code : ${item['group_code'] ?? ''}');
              startGroupController.text = displayStartGroup.toString();
              if (returnStartGroup.isNotEmpty) {
                if (returnEndGroup.isNotEmpty &&
                    returnEndGroup != 'null' &&
                    returnStartGroup != 'null') {
                  if (displayStartGroup
                          .toString()
                          .compareTo(displayEndGroup.toString()) >
                      0) {
                    displayEndGroup = displayStartGroup;
                    displayEndGroupBackup = displayStartGroup ?? '';
                    returnEndGroup = returnStartGroup;
                    endGroupController.text = displayStartGroup.toString();
                  }
                } else if (returnEndGroup == 'null' &&
                    displayEndGroupBackup.toString().isNotEmpty) {
                  if (displayStartGroup
                          .toString()
                          .compareTo(displayEndGroup.toString()) >
                      0) {
                    displayEndGroup = displayStartGroup;
                    displayEndGroupBackup = displayStartGroup ?? '';
                    returnEndGroup = returnStartGroup;
                    endGroupController.text = displayStartGroup.toString();
                  } else {
                    displayEndGroup = displayEndGroupBackup;
                    returnEndGroup = returnStartGroup;
                    endGroupController.text = displayEndGroupBackup.toString();
                  }
                }
                selectLovEndGroup();
                searchController9.clear;
                selectLovStartCategory();
                displayStartCategory = 'ทั้งหมด';
                returnStartCategory = 'null';
                startCategoryController.text = 'ทั้งหมด';
                searchController10.clear;
                selectLovEndCategory();
                displayEndCategory = 'ทั้งหมด';
                displayEndCategoryBackup = '';
                returnEndCategory = 'null';
                endCategoryController.text = 'ทั้งหมด';
                searchController11.clear;
                selectLovStartSubCategory();
                displayStartSubCategory = 'ทั้งหมด';
                returnStartSubCategory = 'null';
                startSubCategoryController.text = 'ทั้งหมด';
                searchController12.clear;
                selectLovEndSubCategory();
                displayEndSubCategory = 'ทั้งหมด';
                displayEndSubCategoryBackup = '';
                returnEndSubCategory = 'null';
                endSubCategoryController.text = 'ทั้งหมด';
                searchController13.clear;
                selectLovStartItem();
                displayStartItem = 'ทั้งหมด';
                returnStartItem = 'null';
                startItemController.text = 'ทั้งหมด';
                searchController14.clear;
                selectLovEndItem();
                displayEndItem = 'ทั้งหมด';
                displayEndItemBackup = 'ทั้งหมด';
                returnEndItem = 'null';
                endItemController.text = 'ทั้งหมด';
                searchController15.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnStartGroup != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchEndGroup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง กลุ่มสินค้า',
          searchController: searchController9,
          data: dataLovEndGroup,
          docString: (item) =>
              '${item['group_code'] ?? 'ทั้งหมด'} ${item['group_name'] ?? ''}',
          titleText: (item) => '${item['group_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final groupName = item['group_name'] ?? '';
            return groupName.isNotEmpty ? groupName : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndGroup = '${item['group_code'] ?? 'null'}';
              displayEndGroup = '${item['group_code'] ?? 'ทั้งหมด'}';
              if (displayEndGroup.toString().isNotEmpty &&
                  displayEndGroup != 'ทั้งหมด' &&
                  returnEndGroup != 'null') {
                displayEndGroupBackup = '${item['group_code']}';
              } else {
                displayEndGroupBackup = '';
              }
              print('group_code : ${item['group_code'] ?? ''}');
              endGroupController.text = displayEndGroup.toString();
              if (returnEndGroup.isNotEmpty) {
                selectLovStartCategory();
                displayStartCategory = 'ทั้งหมด';
                returnStartCategory = 'null';
                startCategoryController.text = 'ทั้งหมด';
                searchController10.clear;
                selectLovEndCategory();
                displayEndCategory = 'ทั้งหมด';
                displayEndCategoryBackup = '';
                returnEndCategory = 'null';
                endCategoryController.text = 'ทั้งหมด';
                searchController11.clear;
                selectLovStartSubCategory();
                displayStartSubCategory = 'ทั้งหมด';
                returnStartSubCategory = 'null';
                startSubCategoryController.text = 'ทั้งหมด';
                searchController12.clear;
                selectLovEndSubCategory();
                displayEndSubCategory = 'ทั้งหมด';
                displayEndSubCategoryBackup = '';
                returnEndSubCategory = 'null';
                endSubCategoryController.text = 'ทั้งหมด';
                searchController13.clear;
                selectLovStartItem();
                displayStartItem = 'ทั้งหมด';
                returnStartItem = 'null';
                startItemController.text = 'ทั้งหมด';
                searchController14.clear;
                selectLovEndItem();
                displayEndItem = 'ทั้งหมด';
                displayEndItemBackup = 'ทั้งหมด';
                returnEndItem = 'null';
                endItemController.text = 'ทั้งหมด';
                searchController15.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnStartGroup != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchStartCategory() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก Category',
          searchController: searchController10,
          data: dataLovStartCategory,
          docString: (item) =>
              '${item['category_code'] ?? 'ทั้งหมด'} ${item['category_desc'] ?? ''}',
          titleText: (item) => '${item['category_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final catDesc = item['category_desc'] ?? '';
            return catDesc.isNotEmpty ? catDesc : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartCategory = '${item['category_code'] ?? 'null'}';
              displayStartCategory = '${item['category_code'] ?? 'ทั้งหมด'}';
              print('category_code : ${item['category_code'] ?? ''}');
              startCategoryController.text = displayStartCategory.toString();
              if (returnStartCategory.isNotEmpty) {
                if (returnEndCategory.isNotEmpty &&
                    returnEndCategory != 'null' &&
                    returnStartCategory != 'null') {
                  if (displayStartCategory
                          .toString()
                          .compareTo(displayEndCategory.toString()) >
                      0) {
                    displayEndCategory = displayStartCategory;
                    displayEndCategoryBackup = displayStartCategory ?? '';
                    returnEndCategory = returnStartCategory;
                    endCategoryController.text =
                        displayStartCategory.toString();
                  }
                } else if (returnEndCategory == 'null' &&
                    displayEndCategoryBackup.toString().isNotEmpty) {
                  if (displayStartCategory
                          .toString()
                          .compareTo(displayEndCategory.toString()) >
                      0) {
                    displayEndCategory = displayStartCategory;
                    displayEndCategoryBackup = displayStartCategory ?? '';
                    returnEndCategory = returnStartCategory;
                    endCategoryController.text =
                        displayStartCategory.toString();
                  } else {
                    displayEndCategory = displayEndCategoryBackup;
                    returnEndCategory = returnStartCategory;
                    endCategoryController.text =
                        displayEndCategoryBackup.toString();
                  }
                }

                selectLovEndCategory();
                searchController11.clear;
                selectLovStartSubCategory();
                displayStartSubCategory = 'ทั้งหมด';
                returnStartSubCategory = 'null';
                startSubCategoryController.text = 'ทั้งหมด';
                searchController12.clear;
                selectLovEndSubCategory();
                displayEndSubCategory = 'ทั้งหมด';
                displayEndSubCategoryBackup = '';
                returnEndSubCategory = 'null';
                endSubCategoryController.text = 'ทั้งหมด';
                searchController13.clear;
                selectLovStartItem();
                displayStartItem = 'ทั้งหมด';
                returnStartItem = 'null';
                startItemController.text = 'ทั้งหมด';
                searchController14.clear;
                selectLovEndItem();
                displayEndItem = 'ทั้งหมด';
                displayEndItemBackup = 'ทั้งหมด';
                returnEndItem = 'null';
                endItemController.text = 'ทั้งหมด';
                searchController15.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnStartCategory != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchEndCategory() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง Category',
          searchController: searchController11,
          data: dataLovEndCategory,
          docString: (item) =>
              '${item['category_code'] ?? 'ทั้งหมด'} ${item['category_desc'] ?? ''}',
          titleText: (item) => '${item['category_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final catDesc = item['category_desc'] ?? '';
            return catDesc.isNotEmpty ? catDesc : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndCategory = '${item['category_code'] ?? 'null'}';
              displayEndCategory = '${item['category_code'] ?? 'ทั้งหมด'}';
              if (displayEndCategory.toString().isNotEmpty &&
                  displayEndCategory != 'ทั้งหมด' &&
                  returnEndCategory != 'null') {
                displayEndCategoryBackup = '${item['category_code']}';
              } else {
                displayEndCategoryBackup = '';
              }
              print('category_code : ${item['category_code'] ?? ''}');
              endCategoryController.text = displayEndCategory.toString();
              if (returnEndCategory.isNotEmpty) {
                selectLovStartSubCategory();
                displayStartSubCategory = 'ทั้งหมด';
                returnStartSubCategory = 'null';
                startSubCategoryController.text = 'ทั้งหมด';
                searchController12.clear;
                selectLovEndSubCategory();
                displayEndSubCategory = 'ทั้งหมด';
                displayEndSubCategoryBackup = '';
                returnEndSubCategory = 'null';
                endSubCategoryController.text = 'ทั้งหมด';
                searchController13.clear;
                selectLovStartItem();
                displayStartItem = 'ทั้งหมด';
                returnStartItem = 'null';
                startItemController.text = 'ทั้งหมด';
                searchController14.clear;
                selectLovEndItem();
                displayEndItem = 'ทั้งหมด';
                displayEndItemBackup = 'ทั้งหมด';
                returnEndItem = 'null';
                endItemController.text = 'ทั้งหมด';
                searchController15.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnEndCategory != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchStartSubCategory() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก Sub Category',
          searchController: searchController12,
          data: dataLovStartSubCategory,
          docString: (item) =>
              '${item['sub_cat_code'] ?? 'ทั้งหมด'} ${item['sub_cat_desc'] ?? ''}',
          titleText: (item) => '${item['sub_cat_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final subCatDesc = item['sub_cat_desc'] ?? '';
            return subCatDesc.isNotEmpty ? subCatDesc : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartSubCategory = '${item['sub_cat_code'] ?? 'null'}';
              displayStartSubCategory = '${item['sub_cat_code'] ?? 'ทั้งหมด'}';
              print('sub_cat_code : ${item['sub_cat_code'] ?? ''}');
              startSubCategoryController.text =
                  displayStartSubCategory.toString();
              if (returnStartSubCategory.isNotEmpty) {
                if (returnEndSubCategory.isNotEmpty &&
                    returnEndSubCategory != 'null' &&
                    returnStartSubCategory != 'null') {
                  if (displayStartSubCategory
                          .toString()
                          .compareTo(displayEndSubCategory.toString()) >
                      0) {
                    displayEndSubCategory = displayStartSubCategory;
                    displayEndSubCategoryBackup = displayStartSubCategory ?? '';
                    returnEndSubCategory = returnStartSubCategory;
                    endSubCategoryController.text =
                        displayStartSubCategory.toString();
                  }
                } else if (returnEndSubCategory == 'null' &&
                    displayEndSubCategoryBackup.toString().isNotEmpty) {
                  if (displayStartSubCategory
                          .toString()
                          .compareTo(displayEndSubCategory.toString()) >
                      0) {
                    displayEndSubCategory = displayStartSubCategory;
                    displayEndSubCategoryBackup = displayStartSubCategory ?? '';
                    returnEndSubCategory = returnStartSubCategory;
                    endSubCategoryController.text =
                        displayStartSubCategory.toString();
                  } else {
                    displayEndSubCategory = displayEndSubCategoryBackup;
                    returnEndSubCategory = returnStartSubCategory;
                    endSubCategoryController.text =
                        displayEndSubCategoryBackup.toString();
                  }
                }

                selectLovEndSubCategory();
                searchController13.clear;
                selectLovStartItem();
                displayStartItem = 'ทั้งหมด';
                returnStartItem = 'null';
                startItemController.text = 'ทั้งหมด';
                searchController14.clear;
                selectLovEndItem();
                displayEndItem = 'ทั้งหมด';
                displayEndItemBackup = 'ทั้งหมด';
                returnEndItem = 'null';
                endItemController.text = 'ทั้งหมด';
                searchController15.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnStartSubCategory != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchEndSubCategory() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง Sub Category',
          searchController: searchController13,
          data: dataLovEndSubCategory,
          docString: (item) =>
              '${item['sub_cat_code'] ?? 'ทั้งหมด'} ${item['sub_cat_desc'] ?? ''}',
          titleText: (item) => '${item['sub_cat_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final subCatDesc = item['sub_cat_desc'] ?? '';
            return subCatDesc.isNotEmpty ? subCatDesc : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndSubCategory = '${item['sub_cat_code'] ?? 'null'}';
              displayEndSubCategory = '${item['sub_cat_code'] ?? 'ทั้งหมด'}';
              if (displayEndSubCategory.toString().isNotEmpty &&
                  displayEndSubCategory != 'ทั้งหมด' &&
                  returnEndSubCategory != 'null') {
                displayEndSubCategoryBackup = '${item['sub_cat_code']}';
              } else {
                displayEndSubCategoryBackup = '';
              }
              print('sub_cat_code : ${item['sub_cat_code'] ?? ''}');
              endSubCategoryController.text = displayEndSubCategory.toString();
              if (returnEndSubCategory.isNotEmpty) {
                selectLovStartItem();
                displayStartItem = 'ทั้งหมด';
                returnStartItem = 'null';
                startItemController.text = 'ทั้งหมด';
                searchController14.clear;
                selectLovEndItem();
                displayEndItem = 'ทั้งหมด';
                displayEndItemBackup = 'ทั้งหมด';
                returnEndItem = 'null';
                endItemController.text = 'ทั้งหมด';
                searchController15.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnEndSubCategory != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchStartItem() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก รหัสวัตถุดิบ',
          searchController: searchController14,
          data: dataLovStartItem,
          docString: (item) =>
              '${item['item_code'] ?? 'ทั้งหมด'} ${item['item_name'] ?? ''}',
          titleText: (item) => '${item['item_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final itemName = item['item_name'] ?? '';
            return itemName.isNotEmpty ? itemName : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartItem = '${item['item_code'] ?? 'null'}';
              displayStartItem = '${item['item_code'] ?? 'ทั้งหมด'}';
              print('item_code : ${item['item_code'] ?? ''}');
              startItemController.text = displayStartItem.toString();
              if (returnStartItem.isNotEmpty) {
                if (returnEndItem.isNotEmpty &&
                    returnEndItem != 'null' &&
                    returnStartItem != 'null') {
                  if (displayStartItem
                          .toString()
                          .compareTo(displayEndItem.toString()) >
                      0) {
                    displayEndItem = displayStartItem;
                    displayEndItemBackup = displayStartItem ?? '';
                    returnEndItem = returnStartItem;
                    endSubCategoryController.text = displayStartItem.toString();
                  }
                } else if (returnEndItem == 'null' &&
                    displayEndItemBackup.toString().isNotEmpty) {
                  if (displayStartItem
                          .toString()
                          .compareTo(displayEndItem.toString()) >
                      0) {
                    displayEndItem = displayStartItem;
                    displayEndItemBackup = displayStartItem ?? '';
                    returnEndItem = returnStartItem;
                    endSubCategoryController.text = displayStartItem.toString();
                  } else {
                    displayEndItem = displayEndItemBackup;
                    returnEndItem = returnStartItem;
                    endSubCategoryController.text =
                        displayEndItemBackup.toString();
                  }
                }

                selectLovEndItem();
                searchController15.clear;
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnStartItem != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchEndItem() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง รหัสวัตถุดิบ',
          searchController: searchController15,
          data: dataLovEndItem,
          docString: (item) =>
              '${item['item_code'] ?? 'ทั้งหมด'} ${item['item_name'] ?? ''}',
          titleText: (item) => '${item['item_code'] ?? 'ทั้งหมด'}',
          subtitleText: (item) {
            final itemName = item['item_name'] ?? '';
            return itemName.isNotEmpty ? itemName : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndItem = '${item['item_code'] ?? 'null'}';
              displayEndItem = '${item['item_code'] ?? 'ทั้งหมด'}';
              if (displayEndItem.toString().isNotEmpty &&
                  displayEndItem != 'ทั้งหมด' &&
                  returnEndItem != 'null') {
                displayEndItemBackup = '${item['item_code']}';
              } else {
                displayEndItemBackup = '';
              }
              print('item_code : ${item['item_code'] ?? ''}');
              endItemController.text = displayEndItem.toString();
              if (returnEndItem.isNotEmpty) {
                //
              }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnEndItem != 'null') {
              checkUpdateDataALL(true);
            } else {
              checkUpdateDataALL(false);
            }
          },
        );
      },
    );
  }

  void showDialogAlert(
    BuildContext context,
    String messageAlert,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(messageAlert),
          onClose: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
