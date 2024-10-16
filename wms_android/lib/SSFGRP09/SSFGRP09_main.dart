import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wms_android/styles.dart';
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
  // ----------------------------- Radio
  String selectedRadio = '1';

  bool isLoading = false;
  bool isFirstLoad = true;

  // --------------------------------------\\
  bool checkUpdateData = false;
  // --------------------------------------\\

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

  String? P_USER_ID;
  String? PROGRAM_ID;
  String? PROGRAM_NAME;
  String? P_LIN_ID;
  String? P_OU_NAME;
  String? P_OU_CODE;
  String? P_E_CAT;
  String? P_E_GRP;
  String? P_E_ITEM;
  String? P_E_LOC;
  String? P_E_SUB_CAT;
  String? P_E_WARE;
  String? P_F_DOC_NO;
  String? P_F_P_DATE;
  String? P_I_E_WARE;
  String? P_I_S_WARE;
  String? P_SHOW_MODE = '1';
  String? P_S_CAT;
  String? P_S_GRP;
  String? P_S_ITEM;
  String? P_S_LOC;
  String? P_S_SUB_CAT;
  String? P_S_WARE;
  //------------------------------
  String? LH_PROGRAM_ID;
  String? LH_WARE;
  String? LH_GRP;
  String? LH_SUB_CAT;
  String? LH_DOC_NO;
  String? LH_LOC;
  String? LH_CAT;
  String? LH_ITEM;
  String? LH_PREPARE;
  String? LH_PAGE;
  String? LH_DATE;
  // --------------------------------
  String? LB_SEQ;
  String? LB_ITEM;
  String? LB_ITEM_DESC;
  String? LB_UMS;
  String? LB_LOC;
  String? LB_LOC1;
  String? LB_WARE;
  String? LB_SYS_BAL;
  String? LB_PHY_BAL;
  String? LB_DIFF_BAL;
  String? LB_IN;
  String? LB_RE;
  String? LB_UNIT;
  String? LB_UNIT1;
  String? LB_RIGHT;
  String? LB_TOTAL;
  // -----------------------------
  String? H_WARE;
  String? H_LOC;
  String? H_GRP;
  String? H_CAT;
  String? H_SEB;
  String? H_ITEM;
  // --------------------------------
  String? V_SYSDATE;

  @override
  void initState() {
    firstLoadData();
    super.initState();
  }

  @override
  void dispose() {
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

  void firstLoadData() async {
    await selectLovDate();
    await selectLovDocNo();
    await selectLovStartWareCode();
    await selectLovEndWareCode();
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
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> selectLovDate() async {
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
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovDate/${globals.P_ERP_OU_CODE}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovDate =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
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

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
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

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
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

            if (isFirstLoad == false) {
              if (mounted) {
                isLoading = false;
              }
            }
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
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
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_SelectLovStartGroup'));

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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
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

  Future<void> selectLovStartCategory() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
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

  Future<void> selectLovEndSubCategory() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
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

  Future<void> selectLovStartItem() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
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

  Future<void> getPDF() async {
    isLoading = true;
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGRP09/SSFGRP09_Step_1_GET_PDF'
          '/${globals.BROWSER_LANGUAGE}'
          '/${returnStartWareCode.isNotEmpty ? returnStartWareCode : 'null'}'
          '/${returnEndWareCode.isNotEmpty ? returnEndWareCode : 'null'}'
          '/${returnStartLoc.isNotEmpty ? returnStartLoc : 'null'}'
          '/${returnEndLoc.isNotEmpty ? returnEndLoc : 'null'}'
          '/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'
          '/${returnEndGroup.isNotEmpty ? returnEndGroup : 'null'}'
          '/${returnStartCategory.isNotEmpty ? returnStartCategory : 'null'}'
          '/${returnEndCategory.isNotEmpty ? returnEndCategory : 'null'}'
          '/${returnStartSubCategory.isNotEmpty ? returnStartSubCategory : 'null'}'
          '/${returnEndSubCategory.isNotEmpty ? returnEndSubCategory : 'null'}'
          '/${returnStartItem.isNotEmpty ? returnStartItem : 'null'}'
          '/${returnEndItem.isNotEmpty ? returnEndItem : 'null'}'
          '/${globals.P_ERP_OU_CODE}'
          '/${globals.APP_USER}'
          '/${globals.P_DS_PDF}'));

      print('Response body: ${response.body}'); // แสดงข้อมูลที่ได้รับจาก API

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataPDF = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
        if (mounted) {
          setState(() {
            // P_USER_ID = dataPDF['V_DS_PDF'] ?? '';
            P_USER_ID = dataPDF['P_USER_ID'] ?? '';
            PROGRAM_ID = dataPDF['PROGRAM_ID'] ?? '';
            PROGRAM_NAME = dataPDF['PROGRAM_NAME'] ?? '';
            P_LIN_ID = dataPDF['P_LIN_ID'] ?? '';
            P_OU_NAME = dataPDF['P_OU_NAME'] ?? '';
            P_OU_CODE = dataPDF['P_OU_CODE'] ?? '';
            P_E_CAT = dataPDF['P_E_CAT'] ?? '';
            P_E_GRP = dataPDF['P_E_GRP'] ?? '';
            P_E_ITEM = dataPDF['P_E_ITEM'] ?? '';
            P_E_LOC = dataPDF['P_E_LOC'] ?? '';
            P_E_SUB_CAT = dataPDF['P_E_SUB_CAT'] ?? '';
            P_E_WARE = dataPDF['P_E_WARE'] ?? '';
            P_F_DOC_NO = dataPDF['P_F_DOC_NO'] ?? '';
            P_F_P_DATE = dataPDF['P_F_P_DATE'] ?? '';
            P_I_E_WARE = dataPDF['P_I_E_WARE'] ?? '';
            P_I_S_WARE = dataPDF['P_I_S_WARE'] ?? '';
            // P_SHOW_MODE = dataPDF['P_SHOW_MODE'] ?? '';
            P_S_CAT = dataPDF['P_S_CAT'] ?? '';
            P_S_GRP = dataPDF['P_S_GRP'] ?? '';
            P_S_ITEM = dataPDF['P_S_ITEM'] ?? '';
            P_S_LOC = dataPDF['P_S_LOC'] ?? '';
            P_S_SUB_CAT = dataPDF['P_S_SUB_CAT'] ?? '';
            P_S_WARE = dataPDF['P_S_WARE'] ?? '';
            //------------------------------
            LH_PROGRAM_ID = dataPDF['LH_PROGRAM_ID'] ?? '';
            LH_WARE = dataPDF['LH_WARE'] ?? '';
            LH_GRP = dataPDF['LH_GRP'] ?? '';
            LH_SUB_CAT = dataPDF['LH_SUB_CAT'] ?? '';
            LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
            LH_LOC = dataPDF['LH_LOC'] ?? '';
            LH_CAT = dataPDF['LH_CAT'] ?? '';
            LH_ITEM = dataPDF['LH_ITEM'] ?? '';
            LH_PREPARE = dataPDF['LH_PREPARE'] ?? '';
            LH_PAGE = dataPDF['LH_PAGE'] ?? '';
            LH_DATE = dataPDF['LH_DATE'] ?? '';
            // --------------------------------
            LB_SEQ = dataPDF['LB_SEQ'] ?? '';
            LB_ITEM = dataPDF['LB_ITEM'] ?? '';
            LB_ITEM_DESC = dataPDF['LB_ITEM_DESC'] ?? '';
            LB_UMS = dataPDF['LB_UMS'] ?? '';
            LB_LOC = dataPDF['LB_LOC'] ?? '';
            LB_LOC1 = dataPDF['LB_LOC1'] ?? '';
            LB_WARE = dataPDF['LB_WARE'] ?? '';
            LB_SYS_BAL = dataPDF['LB_SYS_BAL'] ?? '';
            LB_PHY_BAL = dataPDF['LB_PHY_BAL'] ?? '';
            LB_DIFF_BAL = dataPDF['LB_DIFF_BAL'] ?? '';
            LB_IN = dataPDF['LB_IN'] ?? '';
            LB_RE = dataPDF['LB_RE'] ?? '';
            LB_UNIT = dataPDF['LB_UNIT'] ?? '';
            LB_UNIT1 = dataPDF['LB_UNIT1'] ?? '';
            LB_RIGHT = dataPDF['LB_RIGHT'] ?? '';
            LB_TOTAL = dataPDF['LB_TOTAL'] ?? '';
            // -----------------------------
            H_WARE = dataPDF['H_WARE'] ?? '';
            H_LOC = dataPDF['H_LOC'] ?? '';
            H_GRP = dataPDF['H_GRP'] ?? '';
            H_CAT = dataPDF['H_CAT'] ?? '';
            H_SEB = dataPDF['H_SEB'] ?? '';
            H_ITEM = dataPDF['H_ITEM'] ?? '';
            // ==============================
            V_SYSDATE = dataPDF['V_SYSDATE'] ?? '';

            isLoading = false;
            _launchUrl();
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in submit Data: $e');
    }
  }

  Future<void> _launchUrl() async {
    final uri = Uri.parse('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/WMS_SSFGRP09'
        '&_repFormat=pdf'
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=SSFGRP09_$V_SYSDATE.pdf'
        '&_repLocale=en_US'
        '&V_DS_PDF=${globals.P_DS_PDF}'
        '&P_USER_ID=$P_USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&PROGRAM_NAME=$PROGRAM_NAME'
        '&P_LIN_ID=$P_LIN_ID'
        '&P_OU_NAME=$P_OU_NAME'
        '&P_OU_CODE=$P_OU_CODE'
        //
        '&P_E_CAT=$returnEndCategory'
        '&P_E_GRP=$returnEndGroup'
        '&P_E_ITEM=$returnEndItem'
        '&P_E_LOC=$returnEndLoc'
        '&P_E_SUB_CAT=$returnEndSubCategory'
        '&P_E_WARE=$returnEndWareCode'
        '&P_F_DOC_NO=$returnLovDocNo'
        '&P_F_P_DATE=$returnLovDate'
        '&P_I_E_WARE=$P_I_E_WARE'
        '&P_I_S_WARE=$P_I_S_WARE'
        '&P_SHOW_MODE=$P_SHOW_MODE'
        '&P_S_CAT=$returnStartCategory'
        '&P_S_GRP=$returnStartGroup'
        '&P_S_ITEM=$returnStartItem'
        '&P_S_LOC=$returnStartLoc'
        '&P_S_SUB_CAT=$returnStartSubCategory'
        '&P_S_WARE=$returnStartWareCode'
        //
        '&P_E_CAT=${returnEndCategory}'
        '&P_E_GRP=${returnEndGroup}'
        '&P_E_ITEM=${returnEndItem}'
        '&P_E_LOC=${returnEndLoc}'
        '&P_E_SUB_CAT=${returnEndSubCategory}'
        '&P_E_WARE=${returnEndWareCode}'
        '&P_F_DOC_NO=$returnLovDocNo'
        '&P_F_P_DATE=$returnLovDate'
        '&P_I_E_WARE=$P_I_E_WARE'
        '&P_I_S_WARE=$P_I_S_WARE'
        '&P_SHOW_MODE=$P_SHOW_MODE'
        '&P_S_CAT=${returnStartCategory}'
        '&P_S_GRP=${returnStartGroup}'
        '&P_S_ITEM=${returnStartItem}'
        '&P_S_LOC=${returnStartLoc}'
        '&P_S_SUB_CAT=$returnStartSubCategory'
        '&P_S_WARE=${returnStartWareCode}'
        //
        '&LH_PROGRAM_ID=$LH_PROGRAM_ID'
        '&LH_WARE=$LH_WARE'
        '&LH_GRP=$LH_GRP'
        '&LH_SUB_CAT=$LH_SUB_CAT'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_LOC=$LH_LOC'
        '&LH_CAT=$LH_CAT'
        '&LH_ITEM=$LH_ITEM'
        '&LH_PREPARE=$LH_PREPARE'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        //
        '&LB_SEQ=$LB_SEQ'
        '&LB_ITEM=$LB_ITEM'
        '&LB_ITEM_DESC=$LB_ITEM_DESC'
        '&LB_UMS=$LB_UMS'
        '&LB_LOC=$LB_LOC'
        '&LB_LOC1=$LB_LOC1'
        '&LB_WARE=$LB_WARE'
        '&LB_SYS_BAL=$LB_SYS_BAL'
        '&LB_PHY_BAL=$LB_PHY_BAL'
        '&LB_DIFF_BAL=$LB_DIFF_BAL'
        '&LB_IN=$LB_IN'
        '&LB_RE=$LB_RE'
        '&LB_UNIT=$LB_UNIT'
        '&LB_UNIT1=$LB_UNIT1'
        '&LB_RIGHT=$LB_RIGHT'
        '&LB_TOTAL=$LB_TOTAL'
        //
        '&H_WARE=$H_WARE'
        '&H_LOC=$H_LOC'
        '&H_GRP=$H_GRP'
        '&H_CAT=$H_CAT'
        '&H_SEB=$H_SEB'
        '&H_ITEM=$H_ITEM');

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    print('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/WMS_SSFGRP09'
        '&_repFormat=pdf'
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=SSFGRP09_$V_SYSDATE.pdf'
        '&_repLocale=en_US'
        '&V_DS_PDF=${globals.P_DS_PDF}'
        '&P_USER_ID=$P_USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&PROGRAM_NAME=$PROGRAM_NAME'
        '&P_LIN_ID=$P_LIN_ID'
        '&P_OU_NAME=$P_OU_NAME'
        '&P_OU_CODE=$P_OU_CODE'
        //
        '&P_E_CAT=${returnEndCategory.isNotEmpty ? returnEndCategory : 'สิ้นสุด'}'
        '&P_E_GRP=${returnEndGroup.isNotEmpty ? returnEndGroup : 'สิ้นสุด'}'
        '&P_E_ITEM=${returnEndItem.isNotEmpty ? returnEndItem : 'สิ้นสุด'}'
        '&P_E_LOC=${returnEndLoc.isNotEmpty ? returnEndLoc : 'สิ้นสุด'}'
        '&P_E_SUB_CAT=${returnEndSubCategory.isNotEmpty ? returnEndSubCategory : 'สิ้นสุด'}'
        '&P_E_WARE=${returnEndWareCode.isNotEmpty ? returnEndWareCode : 'สิ้นสุด'}'
        '&P_F_DOC_NO=$returnLovDocNo'
        '&P_F_P_DATE=$returnLovDate'
        '&P_I_E_WARE=$P_I_E_WARE'
        '&P_I_S_WARE=$P_I_S_WARE'
        '&P_SHOW_MODE=$P_SHOW_MODE'
        '&P_S_CAT=${returnStartCategory.isNotEmpty ? returnStartCategory : 'เริ่มต้น'}'
        '&P_S_GRP=${returnStartGroup.isNotEmpty ? returnStartGroup : 'เริ่มต้น'}'
        '&P_S_ITEM=${returnStartItem.isNotEmpty ? returnStartItem : 'เริ่มต้น'}'
        '&P_S_LOC=${returnStartLoc.isNotEmpty ? returnStartLoc : 'เริ่มต้น'}'
        '&P_S_SUB_CAT=${returnStartSubCategory.isNotEmpty ? returnStartSubCategory : 'เริ่มต้น'}'
        '&P_S_WARE=${returnStartWareCode.isNotEmpty ? returnStartWareCode : 'เริ่มต้น'}'
        //
        '&LH_PROGRAM_ID=$LH_PROGRAM_ID'
        '&LH_WARE=$LH_WARE'
        '&LH_GRP=$LH_GRP'
        '&LH_SUB_CAT=$LH_SUB_CAT'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_LOC=$LH_LOC'
        '&LH_CAT=$LH_CAT'
        '&LH_ITEM=$LH_ITEM'
        '&LH_PREPARE=$LH_PREPARE'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        //
        '&LB_SEQ=$LB_SEQ'
        '&LB_ITEM=$LB_ITEM'
        '&LB_ITEM_DESC=$LB_ITEM_DESC'
        '&LB_UMS=$LB_UMS'
        '&LB_LOC=$LB_LOC'
        '&LB_LOC1=$LB_LOC1'
        '&LB_WARE=$LB_WARE'
        '&LB_SYS_BAL=$LB_SYS_BAL'
        '&LB_PHY_BAL=$LB_PHY_BAL'
        '&LB_DIFF_BAL=$LB_DIFF_BAL'
        '&LB_IN=$LB_IN'
        '&LB_RE=$LB_RE'
        '&LB_UNIT=$LB_UNIT'
        '&LB_UNIT1=$LB_UNIT1'
        '&LB_RIGHT=$LB_RIGHT'
        '&LB_TOTAL=$LB_TOTAL'
        //
        '&H_WARE=$H_WARE'
        '&H_LOC=$H_LOC'
        '&H_GRP=$H_GRP'
        '&H_CAT=$H_CAT'
        '&H_SEB=$H_SEB'
        '&H_ITEM=$H_ITEM');

    // isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(
          title: 'รายงานผลการตรวจนับสินค้า',
          showExitWarning:
              // checkUpdateData

              returnLovDate.isEmpty &&
                      returnLovDocNo.isEmpty &&
                      returnStartWareCode.isEmpty &&
                      returnEndWareCode.isEmpty &&
                      returnStartLoc.isEmpty &&
                      returnEndLoc.isEmpty &&
                      returnStartGroup.isEmpty &&
                      returnEndGroup.isEmpty &&
                      returnStartCategory.isEmpty &&
                      returnEndCategory.isEmpty &&
                      returnStartSubCategory.isEmpty &&
                      returnEndSubCategory.isEmpty &&
                      returnStartItem.isEmpty &&
                      returnEndItem.isEmpty
                  ? false
                  : true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Column(
                children: [
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
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
                          fontSize: 12,
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
                          fontSize: 12,
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ),
                    ),

                    // -------------------------------------------------------------------------------------------------------------//
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startWareCodeController,
                            readOnly: true,
                            onTap: () =>
                                showDialogDropdownSearchStartWareCode(),
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

                    // -------------------------------------------------------------------------------------------------------------//
                    const SizedBox(height: 8),
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

                    // -------------------------------------------------------------------------------------------------------------//
                    const SizedBox(height: 8),
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
                    // -------------------------------------------------------------------------------------------------------------//
                    const SizedBox(height: 8),
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

                    // -------------------------------------------------------------------------------------------------------------//
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    // -------------------------------------------------------------------------------------------------------------//
                    const SizedBox(height: 8),
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
                              labelText: 'จาก รหัสสินค้า',
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
                              labelText: 'ถึง รหัสสินค้า',
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
                    // -------------------------------------------------------------------------------------------------------------//
                    const SizedBox(height: 8),

                    Container(
                      color: Colors.white, // กำหนดสีพื้นหลังของ Container
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: const Text(
                              'แสดงข้อมูลทั้งหมด',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            leading: Radio<String>(
                              value: '1',
                              groupValue: selectedRadio, // ค่าที่เลือก
                              onChanged: (String? value) {
                                setState(() {
                                  selectedRadio = value.toString();
                                  P_SHOW_MODE = value;
                                  print('selectedRadio : $selectedRadio');
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'แสดงข้อมูลเฉพาะข้อมูลที่มีผลต่าง',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            leading: Radio<String>(
                              value: '0',
                              groupValue: selectedRadio, // ค่าที่เลือก
                              onChanged: (String? value) {
                                setState(() {
                                  selectedRadio = value.toString();
                                  P_SHOW_MODE = value;
                                  print('selectedRadio : $selectedRadio');
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (selectedRadio.isNotEmpty && P_SHOW_MODE != '') {
                              if (returnLovDate.isEmpty &&
                                  returnLovDocNo.isEmpty) {
                                String message =
                                    'กรุณาระบุ วันที่เตรียมการตรวจนับ และ เลขที่ตรวจนับ';
                                showDialogAlert(context, message);
                              } else if (returnLovDate.isEmpty) {
                                String message =
                                    'กรุณาระบุ วันที่เตรียมการตรวจนับ';
                                showDialogAlert(context, message);
                              } else if (returnLovDocNo.isEmpty) {
                                String message = 'กรุณาระบุ เลขที่ตรวจนับ';
                                showDialogAlert(context, message);
                              } else {
                                getPDF();
                              }
                            }
                          },
                          style: AppStyles.ConfirmbuttonStyle(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.print,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Print',
                                style: AppStyles.ConfirmbuttonTextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: 'show',
      ),
    );
  }

  // --------------------------------- ||
  var maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')}, // อนุญาตเฉพาะตัวเลข
  );
  // --------------------------------- ||

  void showDialogDropdownSearchDate() {
    showDialog(
      context: context,
      barrierDismissible: true,
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
                            searchController1.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    // TextField(
                    //   controller: searchController1,
                    //   decoration: const InputDecoration(
                    //     hintText: 'ค้นหา',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   onChanged: (query) {
                    //     if (mounted) {
                    //       setState(() {});
                    //     }
                    //   },
                    // ),
                    // ========================================================================= ||
                    TextField(
                      controller: searchController1,
                      keyboardType: TextInputType.number,
                      inputFormatters: [maskFormatter],
                      decoration: const InputDecoration(
                        hintText: 'DD/MM/YYYY',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final filteredItems = dataLovDate.where((item) {
                            final docString =
                                '${item['prepare_date'] ?? ''}'.toLowerCase();
                            final searchQuery =
                                searchController1.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['prepare_date'] ?? ''}';
                              final returnCode =
                                  '${item['prepare_date'] ?? ''}';

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
                                  isLoading = true;
                                  setState(() {
                                    String dataCheck = returnCode;
                                    returnLovDate = returnCode;
                                    displayLovDate = doc;
                                    dateController.text =
                                        displayLovDate.toString();
                                    if (returnLovDate.isNotEmpty) {
                                      selectLovDocNo();
                                      displayLovDocNo = '';
                                      returnLovDocNo = '';
                                      docNoController.clear();
                                      isLoading = false;
                                    }

                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController1.clear();
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
      barrierDismissible: true,
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
                            searchController2.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController2,
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
                                '${item['doc_no'] ?? ''} ${item['prepare_date'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController2.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['doc_no'] ?? ''}';
                              final returnCode =
                                  '${item['doc_no'] ?? 'ไมมีค่า'}';
                              // print('item $item');
                              // print('doc $doc');
                              // print('returnCode $returnCode');

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['doc_no'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['prepare_date'] ?? ''}'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnLovDocNo = returnCode;
                                    displayLovDocNo = doc;
                                    docNoController.text =
                                        displayLovDocNo.toString();
                                    // -----------------------------------------
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
                                    print(
                                        'docNoController New: $docNoController Type : ${docNoController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayLovDocNo New: $displayLovDocNo Type : ${displayLovDocNo.runtimeType}');
                                    print(
                                        'returnLovDocNo New: $returnLovDocNo Type : ${returnLovDocNo.runtimeType}');
                                  });
                                  searchController2.clear();
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
      barrierDismissible: true,
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
                            searchController3.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController3,
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
                                '${item['ware_code'] ?? ''} ${item['ware_name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController3.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['ware_code'] ?? ''}';
                              final returnCode = '${item['ware_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['ware_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['ware_name'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnStartWareCode = returnCode;
                                    displayStartWareCode = doc;
                                    startWareCodeController.text =
                                        displayStartWareCode.toString();
                                    if (returnStartWareCode.isNotEmpty) {
                                      selectLovEndWareCode();
                                      displayEndWareCode = '';
                                      returnEndWareCode = '';
                                      endWareCodeController.clear();
                                      selectLovStartLoc();
                                      displayStartLoc = '';
                                      returnStartLoc = '';
                                      startLocController.clear();
                                      selectLovEndLoc();
                                      displayEndLoc = '';
                                      returnEndLoc = '';
                                      endLocController.clear();
                                      isLoading = false;
                                    }

                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController3.clear();
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
      barrierDismissible: true,
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
                            searchController4.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController4,
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
                                '${item['ware_code'] ?? ''} ${item['ware_name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController4.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['ware_code'] ?? ''}';
                              final returnCode = '${item['ware_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['ware_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['ware_name'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnEndWareCode = returnCode;
                                    displayEndWareCode = doc;
                                    endWareCodeController.text =
                                        displayEndWareCode.toString();
                                    if (returnEndWareCode.isNotEmpty) {
                                      selectLovStartLoc();
                                      displayStartLoc = '';
                                      returnStartLoc = '';
                                      startLocController.clear();
                                      selectLovEndLoc();
                                      displayEndLoc = '';
                                      returnEndLoc = '';
                                      endLocController.clear();
                                      isLoading = false;
                                    }
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController4.clear();
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
      barrierDismissible: true,
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
                            searchController5.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController5,
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
                                '${item['location_code'] ?? ''} ${item['location_name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController5.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['location_code'] ?? ''}';
                              final returnCode =
                                  '${item['location_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['location_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle:
                                    Text('${item['location_name'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnStartLoc = returnCode;
                                    displayStartLoc = doc;
                                    startLocController.text =
                                        displayStartLoc.toString();
                                    if (returnStartLoc.isNotEmpty) {
                                      selectLovEndLoc();
                                      displayEndLoc = '';
                                      returnEndLoc = '';
                                      endLocController.clear();
                                      isLoading = false;
                                    }
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController5.clear();
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
      barrierDismissible: true,
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
                            searchController6.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController6,
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
                                '${item['location_code'] ?? ''} ${item['location_name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController6.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['location_code'] ?? ''}';
                              final returnCode =
                                  '${item['location_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['location_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle:
                                    Text('${item['location_name'] ?? ''}'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnEndLoc = returnCode;
                                    displayEndLoc = doc;
                                    endLocController.text =
                                        displayEndLoc.toString();
                                    // -----------------------------------------
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
                                    print(
                                        'endLocController New: $endLocController Type : ${endLocController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndLoc New: $displayEndLoc Type : ${displayEndLoc.runtimeType}');
                                    print(
                                        'returnEndLoc New: $returnEndLoc Type : ${returnEndLoc.runtimeType}');
                                  });
                                  searchController6.clear();
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
      barrierDismissible: true,
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
                            searchController7.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController7,
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
                                '${item['group_code'] ?? ''} ${item['group_name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController7.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['group_code'] ?? ''}';
                              final returnCode = '${item['group_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['group_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['group_name'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    String dataCheck = returnCode;
                                    returnStartGroup = returnCode;
                                    displayStartGroup = doc;
                                    startGroupController.text =
                                        displayStartGroup.toString();
                                    if (returnStartGroup.isNotEmpty) {
                                      selectLovEndGroup();
                                      displayEndGroup = '';
                                      returnEndGroup = '';
                                      endGroupController.clear();
                                      selectLovStartCategory();
                                      displayStartCategory = '';
                                      returnStartCategory = '';
                                      startCategoryController.clear();
                                      selectLovEndCategory();
                                      displayEndCategory = '';
                                      returnEndCategory = '';
                                      endCategoryController.clear();
                                      selectLovStartSubCategory();
                                      displayStartSubCategory = '';
                                      returnStartSubCategory = '';
                                      startSubCategoryController.clear();
                                      selectLovEndSubCategory();
                                      displayEndSubCategory = '';
                                      returnEndSubCategory = '';
                                      endSubCategoryController.clear();
                                      selectLovStartItem();
                                      displayStartItem = '';
                                      returnStartItem = '';
                                      startItemController.clear();
                                      selectLovEndItem();
                                      displayEndItem = '';
                                      returnEndItem = '';
                                      endItemController.clear();
                                      isLoading = false;
                                    }
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController7.clear();
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
      barrierDismissible: true,
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
                            searchController8.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController8,
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
                                '${item['group_code'] ?? ''} ${item['group_name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController8.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['group_code'] ?? ''}';
                              final returnCode = '${item['group_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['group_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['group_name'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    String dataCheck = returnCode;
                                    returnEndGroup = returnCode;
                                    displayEndGroup = doc;
                                    endGroupController.text =
                                        displayEndGroup.toString();
                                    if (returnEndGroup.isNotEmpty) {
                                      selectLovStartCategory();
                                      displayStartCategory = '';
                                      returnStartCategory = '';
                                      startCategoryController.clear();
                                      selectLovEndCategory();
                                      displayEndCategory = '';
                                      returnEndCategory = '';
                                      endCategoryController.clear();
                                      selectLovStartSubCategory();
                                      displayStartSubCategory = '';
                                      returnStartSubCategory = '';
                                      startSubCategoryController.clear();
                                      selectLovEndSubCategory();
                                      displayEndSubCategory = '';
                                      returnEndSubCategory = '';
                                      endSubCategoryController.clear();
                                      selectLovStartItem();
                                      displayStartItem = '';
                                      returnStartItem = '';
                                      startItemController.clear();
                                      selectLovEndItem();
                                      displayEndItem = '';
                                      returnEndItem = '';
                                      endItemController.clear();
                                      isLoading = false;
                                    }
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController8.clear();
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
      barrierDismissible: true,
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
                            searchController9.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController9,
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
                                '${item['category_code'] ?? ''} ${item['category_desc'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController9.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['category_code'] ?? ''}';
                              final returnCode =
                                  '${item['category_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['category_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle:
                                    Text('${item['category_desc'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    String dataCheck = returnCode;
                                    returnStartCategory = returnCode;
                                    displayStartCategory = doc;
                                    startCategoryController.text =
                                        displayStartCategory.toString();
                                    if (returnStartCategory.isNotEmpty) {
                                      selectLovEndCategory();
                                      displayEndCategory = '';
                                      returnEndCategory = '';
                                      endCategoryController.clear();
                                      selectLovStartSubCategory();
                                      displayStartSubCategory = '';
                                      returnStartSubCategory = '';
                                      startSubCategoryController.clear();
                                      selectLovEndSubCategory();
                                      displayEndSubCategory = '';
                                      returnEndSubCategory = '';
                                      endSubCategoryController.clear();
                                      selectLovStartItem();
                                      displayStartItem = '';
                                      returnStartItem = '';
                                      startItemController.clear();
                                      selectLovEndItem();
                                      displayEndItem = '';
                                      returnEndItem = '';
                                      endItemController.clear();
                                      isLoading = false;
                                    }
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController9.clear();
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
      barrierDismissible: true,
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
                            searchController10.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController10,
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
                                '${item['category_code'] ?? ''} ${item['category_desc'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController10.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['category_code'] ?? ''}';
                              final returnCode =
                                  '${item['category_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['category_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle:
                                    Text('${item['category_desc'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    String dataCheck = returnCode;
                                    returnEndCategory = returnCode;
                                    displayEndCategory = doc;
                                    endCategoryController.text =
                                        displayEndCategory.toString();
                                    if (returnEndCategory.isNotEmpty) {
                                      selectLovStartSubCategory();
                                      displayStartSubCategory = '';
                                      returnStartSubCategory = '';
                                      startSubCategoryController.clear();
                                      selectLovEndSubCategory();
                                      displayEndSubCategory = '';
                                      returnEndSubCategory = '';
                                      endSubCategoryController.clear();
                                      selectLovStartItem();
                                      displayStartItem = '';
                                      returnStartItem = '';
                                      startItemController.clear();
                                      selectLovEndItem();
                                      displayEndItem = '';
                                      returnEndItem = '';
                                      endItemController.clear();
                                      isLoading = false;
                                    }
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController10.clear();
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
      barrierDismissible: true,
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
                            searchController11.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController11,
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
                                '${item['sub_cat_code'] ?? ''} ${item['sub_cat_desc'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController11.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['sub_cat_code'] ?? ''}';
                              final returnCode =
                                  '${item['sub_cat_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['sub_cat_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['sub_cat_desc'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnStartSubCategory = returnCode;
                                    displayStartSubCategory = doc;
                                    startSubCategoryController.text =
                                        displayStartSubCategory.toString();
                                    if (returnStartSubCategory.isNotEmpty) {
                                      selectLovEndSubCategory();
                                      displayEndSubCategory = '';
                                      returnEndSubCategory = '';
                                      endSubCategoryController.clear();
                                      selectLovStartItem();
                                      displayStartItem = '';
                                      returnStartItem = '';
                                      startItemController.clear();
                                      selectLovEndItem();
                                      displayEndItem = '';
                                      returnEndItem = '';
                                      endItemController.clear();
                                      isLoading = false;
                                    }
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController11.clear();
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
      barrierDismissible: true,
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
                            searchController12.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController12,
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
                                '${item['sub_cat_code'] ?? ''} ${item['sub_cat_desc'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController12.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['sub_cat_code'] ?? ''}';
                              final returnCode =
                                  '${item['sub_cat_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['sub_cat_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['sub_cat_desc'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnEndSubCategory = returnCode;
                                    displayEndSubCategory = doc;
                                    endSubCategoryController.text =
                                        displayEndSubCategory.toString();
                                    if (returnEndSubCategory.isNotEmpty) {
                                      selectLovStartItem();
                                      displayStartItem = '';
                                      returnStartItem = '';
                                      startItemController.clear();
                                      selectLovEndItem();
                                      displayEndItem = '';
                                      returnEndItem = '';
                                      endItemController.clear();
                                      isLoading = false;
                                    }
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController12.clear();
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
      barrierDismissible: true,
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
                            searchController13.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController13,
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
                                '${item['item_code'] ?? ''} ${item['name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController13.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['item_code'] ?? ''}';
                              final returnCode = '${item['item_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['item_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['name'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnStartItem = returnCode;
                                    displayStartItem = doc;
                                    startItemController.text =
                                        displayStartItem.toString();
                                    if (returnStartItem.isNotEmpty) {
                                      selectLovEndItem();
                                      displayEndItem = '';
                                      returnEndItem = '';
                                      endItemController.clear();
                                      isLoading = false;
                                    }
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController13.clear();
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
      barrierDismissible: true,
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
                            searchController14.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchController14,
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
                                '${item['item_code'] ?? ''} ${item['name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery =
                                searchController14.text.trim().toLowerCase();
                            return docString.contains(searchQuery);
                          }).toList();

                          // แสดงข้อความ No data found หากไม่มีข้อมูลที่ค้นหา
                          if (filteredItems.isEmpty) {
                            return const Center(
                              child: Text('No data found'),
                            );
                          }

                          // แสดง ListView เมื่อมีข้อมูลที่กรองได้
                          return ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final doc = '${item['item_code'] ?? ''}';
                              final returnCode = '${item['item_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['item_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['name'] ?? ''}'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnEndItem = returnCode;
                                    displayEndItem = doc;
                                    endItemController.text =
                                        displayEndItem.toString();
                                    // if (dataCheck != '') {
                                    //   checkUpdateData = true;
                                    // }
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
                                  searchController14.clear();
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

  void showDialogAlert(
    BuildContext context,
    String messageAlert,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
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
