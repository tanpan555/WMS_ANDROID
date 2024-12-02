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
  String returnEndDocNo = '';
  TextEditingController endDocNoController = TextEditingController();
  // --------------------------------- Start Ware
  String? displayStartWare;
  String returnStartWare = '';
  TextEditingController startWareController = TextEditingController();
  // --------------------------------- End Ware
  String? displayEndWare;
  String returnEndWare = '';
  TextEditingController endWareController = TextEditingController();
  // --------------------------------- Start Loc
  String? displayStartLoc;
  String returnStartLoc = '';
  TextEditingController startLocController = TextEditingController();
  // --------------------------------- End Loc
  String? displayEndLoc;
  String returnEndLoc = '';
  TextEditingController endLocController = TextEditingController();
  // --------------------------------- Start Group
  String? displayStartGroup;
  String returnStartGroup = '';
  TextEditingController startGroupController = TextEditingController();
  // --------------------------------- End Group
  String? displayEndGroup;
  String returnEndGroup = '';
  TextEditingController endGroupController = TextEditingController();
  // ---------------------------------
  String selectedRadio = '1';
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
    // searchController1.dispose();
    // searchController2.dispose();
    // searchController3.dispose();
    // searchController4.dispose();
    // searchController5.dispose();
    // searchController6.dispose();
    // searchController7.dispose();
    // searchController8.dispose();
    // searchController9.dispose();
    // searchController10.dispose();
    // searchController11.dispose();
    // searchController12.dispose();
    // searchController13.dispose();
    // searchController14.dispose();
    // searchController15.dispose();
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
      //   if (mounted) {
      //     setState(() {
      //       isLoading = true;
      //     });
      //   }
      // } else if (isFirstLoad == false) {
      //   if (mounted) {
      //     isLoading = true;
      //   }
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
    print(
        '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartDocNo'
        '/${globals.P_ERP_OU_CODE}/${returnDocDate.isNotEmpty ? returnDocDate : 'null'}');
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartDocNo/${globals.P_ERP_OU_CODE}/${returnDocDate.isNotEmpty ? returnDocDate : 'null'}'));
      print(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartDocNo/${globals.P_ERP_OU_CODE}/${returnDocDate.isNotEmpty ? returnDocDate : 'null'}'));
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndDocNo/${globals.P_ERP_OU_CODE}'
          '/${returnDocDate.isEmpty ? 'null' : returnDocDate}'
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
          'http://172.16.0.82:8888/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartLoc'
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
          'http://172.16.0.82:8888/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndLoc'
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
          'http://172.16.0.82:8888/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartGroup'));

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
          'http://172.16.0.82:8888/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovEndGroup'
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'วันที่เตียมการตรวตนับ', showExitWarning: checkUpdateData),
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
                              labelText: 'จาก จากกลุ่มสินค้า',
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
                              labelText: 'ถึง จากกลุ่มสินค้า',
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
              '${item['doc_no'] ?? ''} ${item['doc_date'] ?? ''}',
          titleText: (item) => '${item['doc_no'] ?? '--No Value Set--'}',
          subtitleText: (item) {
            final docNo = item['doc_no'] ?? '';
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
                selectLovEndDocNO();
                displayEndDocNo = 'ทั้งหมด';
                returnEndDocNo = 'null';
                endDocNoController.text = 'ทั้งหมด';
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
              '${item['doc_no'] ?? ''} ${item['doc_date'] ?? ''}',
          titleText: (item) => '${item['doc_date'] ?? '--No Value Set--'}',
          subtitleText: (item) {
            final docNo = item['doc_no'] ?? '';
            return docNo.isNotEmpty ? docNo : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndDocNo = '${item['doc_no'] ?? 'null'}';
              displayEndDocNo = '${item['doc_date'] ?? 'ทั้งหมด'}';
              print('doc_date : ${item['doc_date'] ?? ''}');
              endDocNoController.text = displayEndDocNo.toString();
              if (returnEndDocNo.isNotEmpty) {
                //
              }
              isLoading = false;
              // -----------------------------------------
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
              '${item['ware_code'] ?? ''} ${item['ware_name'] ?? '--No Value Set--'}',
          titleText: (item) => '${item['ware_code'] ?? '--No Value Set--'}',
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
                selectLovEndWare();
                displayEndWare = 'ทั้งหมด';
                returnEndWare = 'null';
                endWareController.text = 'ทั้งหมด';
                searchController5.clear;
                selectLovStartLoc();
                displayStartDocNo = 'ทั้งหมด';
                returnStartLoc = 'null';
                startLocController.text = 'ทั้งหมด';
                searchController6.clear;
                selectLovEndLoc();
                displayEndLoc = 'ทั้งหมด';
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
              '${item['ware_code'] ?? ''} ${item['ware_name'] ?? '--No Value Set--'}',
          titleText: (item) => '${item['ware_code'] ?? '--No Value Set--'}',
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
              '${item['location_code'] ?? '--No Value Set--'} ${item['location_name'] ?? ''} ${item['ware_code'] ?? ''}',
          titleText: (item) => '${item['location_code'] ?? '--No Value Set--'}',
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
                selectLovEndLoc();
                displayEndLoc = 'ทั้งหมด';
                returnEndLoc = 'null';
                endLocController.text = 'ทั้งหมด';
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
              '${item['location_code'] ?? '--No Value Set--'} ${item['location_name'] ?? ''} ${item['ware_code'] ?? ''}',
          titleText: (item) => '${item['location_code'] ?? '--No Value Set--'}',
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
              print('location_code : ${item['location_code'] ?? ''}');
              endLocController.text = displayEndLoc.toString();
              if (returnEndLoc.isNotEmpty) {
                //
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

  void showDialogDropdownSearchStartGroup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก ตำแหน่งจัดเก็บ',
          searchController: searchController8,
          data: dataLovStartGroup,
          docString: (item) => '${item['group_code'] ?? '--No Value Set--'}',
          titleText: (item) => '${item['group_code'] ?? '--No Value Set--'}',
          subtitleText: (item) {
            final groupName = item['group_name'] ?? '';
            return groupName.isNotEmpty ? groupName : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndLoc = '${item['group_code'] ?? 'null'}';
              displayEndLoc = '${item['group_code'] ?? 'ทั้งหมด'}';
              print('group_code : ${item['group_code'] ?? ''}');
              endLocController.text = displayEndLoc.toString();
              if (returnEndLoc.isNotEmpty) {
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

  void showDialogDropdownSearchEndGroup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก ตำแหน่งจัดเก็บ',
          searchController: searchController9,
          data: dataLovEndGroup,
          docString: (item) => '${item['group_code'] ?? '--No Value Set--'}',
          titleText: (item) => '${item['group_code'] ?? '--No Value Set--'}',
          subtitleText: (item) {
            final groupName = item['group_name'] ?? '';
            return groupName.isNotEmpty ? groupName : null;
          },
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndLoc = '${item['group_code'] ?? 'null'}';
              displayEndLoc = '${item['group_code'] ?? 'ทั้งหมด'}';
              print('group_code : ${item['group_code'] ?? ''}');
              endLocController.text = displayEndLoc.toString();
              if (returnEndLoc.isNotEmpty) {
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
}
