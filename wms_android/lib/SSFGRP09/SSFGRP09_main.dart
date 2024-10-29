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
    setDataFirstLoad();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void setDataFirstLoad() {
    // ----------------------------- Start Ware Code
    displayStartWareCode = '--No Value Set--';
    returnStartWareCode = 'null';
    startWareCodeController.text = '--No Value Set--';
    // ----------------------------- End Ware Code
    displayEndWareCode = '--No Value Set--';
    returnEndWareCode = 'null';
    endWareCodeController.text = '--No Value Set--';
    // ----------------------------- Start Loc
    displayStartLoc = '--No Value Set--';
    returnStartLoc = 'null';
    startLocController.text = '--No Value Set--';
    // ----------------------------- End Loc
    displayEndLoc = '--No Value Set--';
    returnEndLoc = 'null';
    endLocController.text = '--No Value Set--';
    // ----------------------------- Start Group
    displayStartGroup = '--No Value Set--';
    returnStartGroup = 'null';
    startGroupController.text = '--No Value Set--';
    // ----------------------------- End Group
    displayEndGroup = '--No Value Set--';
    returnEndGroup = 'null';
    endGroupController.text = '--No Value Set--';
    // ----------------------------- Start Category
    displayStartCategory = '--No Value Set--';
    returnStartCategory = 'null';
    startCategoryController.text = '--No Value Set--';
    // ----------------------------- End Category
    displayEndCategory = '--No Value Set--';
    returnEndCategory = 'null';
    endCategoryController.text = '--No Value Set--';
    // ----------------------------- Start Sub Category
    displayStartSubCategory = '--No Value Set--';
    returnStartSubCategory = 'null';
    startSubCategoryController.text = '--No Value Set--';
    // ----------------------------- End Sub Category
    displayEndSubCategory = '--No Value Set--';
    returnEndSubCategory = 'null';
    endSubCategoryController.text = '--No Value Set--';
    // ----------------------------- Start Item
    displayStartItem = '--No Value Set--';
    returnStartItem = 'null';
    startItemController.text = '--No Value Set--';
    // ----------------------------- End Item
    displayEndItem = '--No Value Set--';
    returnEndItem = 'null';
    endItemController.text = '--No Value Set--';
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

    // isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(
          title: 'รายงานผลการตรวจนับสินค้า', showExitWarning: checkUpdateData),
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

  void showDialogDropdownSearchDate() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'วันที่เตรียมการตรวจนับ',
          searchController: searchController1,
          data: dataLovDate,
          docString: (item) => '${item['prepare_date'] ?? ''}',
          titleText: (item) => '${item['prepare_date'] ?? ''}',
          subtitleText: (item) => '',
          onTap: (item) {
            Navigator.of(context).pop();
            isLoading = true;
            setState(() {
              returnLovDate = '${item['prepare_date'] ?? ''}';
              displayLovDate = '${item['prepare_date'] ?? ''}';
              dateController.text = displayLovDate.toString();
              if (returnLovDate.isNotEmpty) {
                selectLovDocNo();
                displayLovDocNo = '';
                returnLovDocNo = '';
                docNoController.clear();
                isLoading = false;
              }
              print(
                  'dateController New: $dateController Type : ${dateController.runtimeType}');
              print(
                  'displayLovDate New: $displayLovDate Type : ${displayLovDate.runtimeType}');
              print(
                  'returnLovDate New: $returnLovDate Type : ${returnLovDate.runtimeType}');
            });
            if (returnLovDate != '') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchDocNo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'เลขที่ตรวจนับ',
          searchController: searchController2,
          data: dataLovDocNo,
          docString: (item) =>
              '${item['doc_no'] ?? ''} ${item['prepare_date'] ?? ''}',
          titleText: (item) => '${item['doc_no'] ?? ''}',
          subtitleText: (item) => '${item['prepare_date'] ?? ''}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              returnLovDocNo = '${item['doc_no'] ?? ''}';
              displayLovDocNo = '${item['doc_no'] ?? ''}';
              docNoController.text = displayLovDocNo.toString();
              // -----------------------------------------
              print(
                  'docNoController New: $docNoController Type : ${docNoController.runtimeType}');
              print(
                  'displayLovDocNo New: $displayLovDocNo Type : ${displayLovDocNo.runtimeType}');
              print(
                  'returnLovDocNo New: $returnLovDocNo Type : ${returnLovDocNo.runtimeType}');
            });
            if (returnLovDocNo != 'null') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchStartWareCode() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'จาก คลังสินค้า',
          searchController: searchController3,
          data: dataLovStartWareCode,
          docString: (item) =>
              '${item['ware_code'] ?? ''} ${item['ware_name'] ?? ''}',
          titleText: (item) => '${item['ware_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['ware_code'] ?? ''}',
          subtitleText: (item) => '${item['ware_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartWareCode = '${item['ware_code'] ?? ''}';
              displayStartWareCode = '${item['ware_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['ware_code'] ?? ''}';
              startWareCodeController.text = displayStartWareCode.toString();
              if (returnStartWareCode.isNotEmpty) {
                selectLovEndWareCode();
                displayEndWareCode = '--No Value Set--';
                returnEndWareCode = 'null';
                endWareCodeController.text = '--No Value Set--';
                selectLovStartLoc();
                displayStartLoc = '--No Value Set--';
                returnStartLoc = 'null';
                startLocController.text = '--No Value Set--';
                selectLovEndLoc();
                displayEndLoc = '--No Value Set--';
                returnEndLoc = 'null';
                endLocController.text = '--No Value Set--';
                isLoading = false;
              }
              // -----------------------------------------
              print(
                  'startWareCodeController New: $startWareCodeController Type : ${startWareCodeController.runtimeType}');
              print(
                  'displayStartWareCode New: $displayStartWareCode Type : ${displayStartWareCode.runtimeType}');
              print(
                  'returnStartWareCode New: $returnStartWareCode Type : ${returnStartWareCode.runtimeType}');
            });
            if (returnStartWareCode != 'null') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }

  void showDialogDropdownSearchEndWareCode() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'ถึง คลังสินค้า',
          searchController: searchController4,
          data: dataLovEndLoc,
          docString: (item) =>
              '${item['ware_code'] ?? ''} ${item['ware_name'] ?? ''}',
          titleText: (item) => '${item['ware_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['ware_code'] ?? ''}',
          subtitleText: (item) => '${item['ware_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndWareCode = '${item['ware_code'] ?? ''}';
              displayEndWareCode = '${item['ware_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['ware_code'] ?? ''}';
              print('ware_code : ${item['ware_code'] ?? ''}');
              endWareCodeController.text = displayEndWareCode.toString();
              if (returnStartLoc.isNotEmpty) {
                selectLovStartLoc();
                displayStartLoc = '--No Value Set--';
                returnStartLoc = 'null';
                startLocController.text = '--No Value Set--';
                selectLovEndLoc();
                displayEndLoc = '--No Value Set--';
                returnEndLoc = 'null';
                endLocController.text = '--No Value Set--';
                isLoading = false;
              }
              // -----------------------------------------
              print(
                  'startLocController New: $startLocController Type : ${startLocController.runtimeType}');
              print(
                  'displayEndWareCode New: $displayEndWareCode Type : ${displayEndWareCode.runtimeType}');
              print(
                  'returnEndWareCode New: $returnEndWareCode Type : ${returnEndWareCode.runtimeType}');
            });
            if (returnEndWareCode != 'null') {
              checkUpdateDataALL(true);
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
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'จาก ตำแหน่งจัดเก็บ',
          searchController: searchController5,
          data: dataLovStartLoc,
          docString: (item) =>
              '${item['location_code'] ?? ''} ${item['location_name'] ?? ''}',
          titleText: (item) => '${item['location_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['location_code'] ?? ''}',
          subtitleText: (item) => '${item['location_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartLoc = '${item['location_code'] ?? ''}';
              displayStartLoc = '${item['location_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['location_code'] ?? ''}';
              startLocController.text = displayStartLoc.toString();
              if (returnEndWareCode.isNotEmpty) {
                selectLovEndLoc();
                displayEndLoc = '--No Value Set--';
                returnEndLoc = 'null';
                endLocController.text = '--No Value Set--';
                isLoading = false;
              }
              // -----------------------------------------
              print(
                  'startLocController New: $startLocController Type : ${startLocController.runtimeType}');
              print(
                  'displayStartLoc New: $displayStartLoc Type : ${displayStartLoc.runtimeType}');
              print(
                  'returnStartLoc New: $returnStartLoc Type : ${returnStartLoc.runtimeType}');
            });
            if (returnStartLoc != 'null') {
              checkUpdateDataALL(true);
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
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'ถึง ตำแหน่งจัดเก็บ',
          searchController: searchController6,
          data: dataLovEndLoc,
          docString: (item) =>
              '${item['location_code'] ?? ''} ${item['location_name'] ?? ''}',
          titleText: (item) => '${item['location_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['location_code'] ?? ''}',
          subtitleText: (item) => '${item['location_name'] ?? ''}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              returnEndLoc = '${item['location_code'] ?? ''}';
              displayEndLoc = '${item['location_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['location_code'] ?? ''}';
              endLocController.text = displayEndLoc.toString();
              // -----------------------------------------
              print(
                  'endLocController New: $endLocController Type : ${endLocController.runtimeType}');
              print(
                  'displayEndLoc New: $displayEndLoc Type : ${displayEndLoc.runtimeType}');
              print(
                  'returnEndLoc New: $returnEndLoc Type : ${returnEndLoc.runtimeType}');
            });
            if (returnEndLoc != 'null') {
              checkUpdateDataALL(true);
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
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'จาก กลุ่มสินค้า',
          searchController: searchController7,
          data: dataLovStartGroup,
          docString: (item) =>
              '${item['group_code'] ?? ''} ${item['group_name'] ?? ''}',
          titleText: (item) => '${item['group_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['group_code'] ?? ''}',
          subtitleText: (item) => '${item['group_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartGroup = '${item['group_code'] ?? ''}';
              displayStartGroup = '${item['group_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['group_code'] ?? ''}';
              startGroupController.text = displayStartGroup.toString();
              if (returnStartGroup.isNotEmpty) {
                selectLovEndGroup();
                displayEndGroup = '--No Value Set--';
                returnEndGroup = 'null';
                endGroupController.text = '--No Value Set--';
                selectLovStartCategory();
                displayStartCategory = '--No Value Set--';
                returnStartCategory = 'null';
                startCategoryController.text = '--No Value Set--';
                selectLovEndCategory();
                displayEndCategory = '--No Value Set--';
                returnEndCategory = 'null';
                endCategoryController.text = '--No Value Set--';
                selectLovStartSubCategory();
                displayStartSubCategory = '--No Value Set--';
                returnStartSubCategory = 'null';
                startSubCategoryController.text = '--No Value Set--';
                selectLovEndSubCategory();
                displayEndSubCategory = '--No Value Set--';
                returnEndSubCategory = 'null';
                endSubCategoryController.text = '--No Value Set--';
                selectLovStartItem();
                displayStartItem = '--No Value Set--';
                returnStartItem = 'null';
                startItemController.text = '--No Value Set--';
                selectLovEndItem();
                displayEndItem = '--No Value Set--';
                returnEndItem = 'null';
                endItemController.text = '--No Value Set--';
                isLoading = false;
              }
              // -----------------------------------------
              print(
                  'startGroupController New: $startGroupController Type : ${startGroupController.runtimeType}');
              print(
                  'displayStartGroup New: $displayStartGroup Type : ${displayStartGroup.runtimeType}');
              print(
                  'returnStartGroup New: $returnStartGroup Type : ${returnStartGroup.runtimeType}');
            });
            if (returnStartGroup != 'null') {
              checkUpdateDataALL(true);
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
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'ถึง กลุ่มสินค้า',
          searchController: searchController8,
          data: dataLovEndGroup,
          docString: (item) =>
              '${item['group_code'] ?? ''} ${item['group_name'] ?? ''}',
          titleText: (item) => '${item['group_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['group_code'] ?? ''}',
          subtitleText: (item) => '${item['group_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndGroup = '${item['group_code'] ?? ''}';
              displayEndGroup = '${item['group_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['group_code'] ?? ''}';
              endGroupController.text = displayEndGroup.toString();
              if (returnEndGroup.isNotEmpty) {
                selectLovStartCategory();
                displayStartCategory = '--No Value Set--';
                returnStartCategory = 'null';
                startCategoryController.text = '--No Value Set--';
                selectLovEndCategory();
                displayEndCategory = '--No Value Set--';
                returnEndCategory = 'null';
                endCategoryController.text = '--No Value Set--';
                selectLovStartSubCategory();
                displayStartSubCategory = '--No Value Set--';
                returnStartSubCategory = 'null';
                startSubCategoryController.text = '--No Value Set--';
                selectLovEndSubCategory();
                displayEndSubCategory = '--No Value Set--';
                returnEndSubCategory = 'null';
                endSubCategoryController.text = '--No Value Set--';
                selectLovStartItem();
                displayStartItem = '--No Value Set--';
                returnStartItem = 'null';
                startItemController.text = '--No Value Set--';
                selectLovEndItem();
                displayEndItem = '--No Value Set--';
                returnEndItem = 'null';
                endItemController.text = '--No Value Set--';
                isLoading = false;
              }
              // -----------------------------------------
              print(
                  'endGroupController New: $endGroupController Type : ${endGroupController.runtimeType}');
              print(
                  'displayEndGroup New: $displayEndGroup Type : ${displayEndGroup.runtimeType}');
              print(
                  'returnEndGroup New: $returnEndGroup Type : ${returnEndGroup.runtimeType}');
            });
            if (returnEndGroup != 'null') {
              checkUpdateDataALL(true);
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
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'จาก Category',
          searchController: searchController9,
          data: dataLovStartCategory,
          docString: (item) =>
              '${item['category_code'] ?? ''} ${item['category_desc'] ?? ''}',
          titleText: (item) => '${item['category_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['category_code'] ?? ''}',
          subtitleText: (item) => '${item['category_desc'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartCategory = '${item['category_code'] ?? ''}';
              displayStartCategory = '${item['category_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['category_code'] ?? ''}';
              startCategoryController.text = displayStartCategory.toString();
              if (returnStartCategory.isNotEmpty) {
                selectLovEndCategory();
                displayEndCategory = '--No Value Set--';
                returnEndCategory = 'null';
                endCategoryController.text = '--No Value Set--';
                selectLovStartSubCategory();
                displayStartSubCategory = '--No Value Set--';
                returnStartSubCategory = 'null';
                startSubCategoryController.text = '--No Value Set--';
                selectLovEndSubCategory();
                displayEndSubCategory = '--No Value Set--';
                returnEndSubCategory = 'null';
                endSubCategoryController.text = '--No Value Set--';
                selectLovStartItem();
                displayStartItem = '--No Value Set--';
                returnStartItem = 'null';
                startItemController.text = '--No Value Set--';
                selectLovEndItem();
                displayEndItem = '--No Value Set--';
                returnEndItem = 'null';
                endItemController.text = '--No Value Set--';
                isLoading = false;
              }
              // -----------------------------------------
              print(
                  'endGroupController New: $endGroupController Type : ${endGroupController.runtimeType}');
              print(
                  'displayStartCategory New: $displayStartCategory Type : ${displayStartCategory.runtimeType}');
              print(
                  'returnStartCategory New: $returnStartCategory Type : ${returnStartCategory.runtimeType}');
            });
            if (returnStartCategory != 'null') {
              checkUpdateDataALL(true);
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
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'ถึง Category',
          searchController: searchController10,
          data: dataLovEndCategory,
          docString: (item) =>
              '${item['category_code'] ?? ''} ${item['category_desc'] ?? ''}',
          titleText: (item) => '${item['category_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['category_code'] ?? ''}',
          subtitleText: (item) => '${item['category_desc'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndCategory = '${item['category_code'] ?? ''}';
              displayEndCategory = '${item['category_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['category_code'] ?? ''}';
              endCategoryController.text = displayEndCategory.toString();
              if (returnEndCategory.isNotEmpty) {
                selectLovStartSubCategory();
                displayStartSubCategory = '--No Value Set--';
                returnStartSubCategory = 'null';
                startSubCategoryController.text = '--No Value Set--';
                selectLovEndSubCategory();
                displayEndSubCategory = '--No Value Set--';
                returnEndSubCategory = 'null';
                endSubCategoryController.text = '--No Value Set--';
                selectLovStartItem();
                displayStartItem = 'null';
                returnStartItem = '--No Value Set--';
                startItemController.text = '--No Value Set--';
                selectLovEndItem();
                displayEndItem = '--No Value Set--';
                returnEndItem = 'null';
                endItemController.text = '--No Value Set--';
                isLoading = false;
              }
              // -----------------------------------------
              print(
                  'endCategoryController New: $endCategoryController Type : ${endCategoryController.runtimeType}');
              print(
                  'displayEndCategory New: $displayEndCategory Type : ${displayEndCategory.runtimeType}');
              print(
                  'returnEndCategory New: $returnEndCategory Type : ${returnEndCategory.runtimeType}');
            });
            if (returnEndCategory != 'null') {
              checkUpdateDataALL(true);
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
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'จาก Sub Category',
          searchController: searchController11,
          data: dataLovStartSubCategory,
          docString: (item) =>
              '${item['sub_cat_code'] ?? ''} ${item['sub_cat_desc'] ?? ''}',
          titleText: (item) => '${item['sub_cat_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['sub_cat_code'] ?? ''}',
          subtitleText: (item) => '${item['sub_cat_desc'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartSubCategory = '${item['sub_cat_code'] ?? ''}';
              displayStartSubCategory =
                  '${item['sub_cat_code'] ?? ''}' == 'null'
                      ? '--No Value Set--'
                      : '${item['sub_cat_code'] ?? ''}';
              startSubCategoryController.text =
                  displayStartSubCategory.toString();
              if (returnStartSubCategory.isNotEmpty) {
                selectLovEndSubCategory();
                displayEndSubCategory = '--No Value Set--';
                returnEndSubCategory = 'null';
                endSubCategoryController.text = '--No Value Set--';
                selectLovStartItem();
                displayStartItem = '--No Value Set--';
                returnStartItem = 'null';
                startItemController.text = '--No Value Set--';
                selectLovEndItem();
                displayEndItem = '--No Value Set--';
                returnEndItem = 'null';
                endItemController.text = '--No Value Set--';
                isLoading = false;
              }
              // -----------------------------------------
              print(
                  'startSubCategoryController New: $startSubCategoryController Type : ${startSubCategoryController.runtimeType}');
              print(
                  'displayStartSubCategory New: $displayStartSubCategory Type : ${displayStartSubCategory.runtimeType}');
              print(
                  'returnStartSubCategory New: $returnStartSubCategory Type : ${returnStartSubCategory.runtimeType}');
            });
            if (returnStartSubCategory != 'null') {
              checkUpdateDataALL(true);
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
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'ถึง Sub Category',
          searchController: searchController12,
          data: dataLovEndSubCategory,
          docString: (item) =>
              '${item['sub_cat_code'] ?? ''} ${item['sub_cat_desc'] ?? ''}',
          titleText: (item) => '${item['sub_cat_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['sub_cat_code'] ?? ''}',
          subtitleText: (item) => '${item['sub_cat_desc'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndSubCategory = '${item['sub_cat_code'] ?? ''}';
              displayEndSubCategory = '${item['sub_cat_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['sub_cat_code'] ?? ''}';
              endSubCategoryController.text = displayEndSubCategory.toString();
              if (returnEndSubCategory.isNotEmpty) {
                selectLovStartItem();
                displayStartItem = '--No Value Set--';
                returnStartItem = 'null';
                startItemController.text = '--No Value Set--';
                selectLovEndItem();
                displayEndItem = '--No Value Set--';
                returnEndItem = 'null';
                endItemController.text = '--No Value Set--';
                isLoading = false;
              }
              // -----------------------------------------
              print(
                  'endSubCategoryController New: $endSubCategoryController Type : ${endSubCategoryController.runtimeType}');
              print(
                  'displayEndSubCategory New: $displayEndSubCategory Type : ${displayEndSubCategory.runtimeType}');
              print(
                  'returnEndSubCategory New: $returnEndSubCategory Type : ${returnEndSubCategory.runtimeType}');
            });
            if (returnEndSubCategory != 'null') {
              checkUpdateDataALL(true);
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
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'จาก รหัสสินค้า',
          searchController: searchController13,
          data: dataLovStartItem,
          docString: (item) =>
              '${item['item_code'] ?? ''} ${item['name'] ?? ''}',
          titleText: (item) => '${item['item_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['item_code'] ?? ''}',
          subtitleText: (item) => '${item['name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartItem = '${item['item_code'] ?? ''}';
              displayStartItem = '${item['item_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['item_code'] ?? ''}';
              startItemController.text = displayStartItem.toString();
              if (returnStartItem.isNotEmpty) {
                selectLovEndItem();
                displayEndItem = '--No Value Set--';
                returnEndItem = 'null';
                endItemController.text = '--No Value Set--';
                isLoading = false;
              }
              // -----------------------------------------
              print(
                  'startItemController New: $startItemController Type : ${startItemController.runtimeType}');
              print(
                  'displayEndSubCategory New: $displayEndSubCategory Type : ${displayEndSubCategory.runtimeType}');
              print(
                  'returnStartItem New: $returnStartItem Type : ${returnStartItem.runtimeType}');
            });
            if (returnStartItem != 'null') {
              checkUpdateDataALL(true);
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
        return DialogStyles.customSearchDialog(
          context: context,
          headerText: 'ถึง รหัสสินค้า',
          searchController: searchController14,
          data: dataLovEndItem,
          docString: (item) =>
              '${item['item_code'] ?? ''} ${item['name'] ?? ''}',
          titleText: (item) => '${item['item_code'] ?? ''}' == 'null'
              ? '--No Value Set--'
              : '${item['item_code'] ?? ''}',
          subtitleText: (item) => item['name'] ?? '',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              returnEndItem = item['item_code'] ?? '';
              displayEndItem = '${item['item_code'] ?? ''}' == 'null'
                  ? '--No Value Set--'
                  : '${item['item_code'] ?? ''}';
              endItemController.text = displayEndItem.toString();
              // -----------------------------------------
              print(
                  'endItemController New: $endItemController Type : ${endItemController.runtimeType}');
              print(
                  'displayEndItem New: $displayEndItem Type : ${displayEndItem.runtimeType}');
              print(
                  'returnEndItem New: $returnEndItem Type : ${returnEndItem.runtimeType}');
            });
            if (returnEndItem != 'null') {
              checkUpdateDataALL(true);
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
