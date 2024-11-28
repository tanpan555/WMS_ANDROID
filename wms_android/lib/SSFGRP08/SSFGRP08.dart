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
  }

  Future<void> setDataFirstLoad() async {
    // ----------------------------
    displayDocDate = '';
    returnDocDate = '';
    docDateController.text = '';
    // ----------------------------
    displayStartDocNo = '';
    returnStartDocNo = '';
    startDocNoController.text = '';
    // ----------------------------
    displayEndDocNo = '';
    returnEndDocNo = '';
    endDocNoController.text = '';
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
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGRP08/SSFGRP08_Step_1_SelectLovStartDocNo/'
          '${globals.P_ERP_OU_CODE}/${returnStartDocNo.isEmpty ? 'null' : returnStartDocNo}'));

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
          '/${returnDocDate.isEmpty ? 'null' : returnDocDate}/${returnStartDocNo.isEmpty ? 'null' : returnStartDocNo}'));

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
                            controller: docDateController,
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
                            controller: docDateController,
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
                            controller: docDateController,
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
                            controller: docDateController,
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
          searchController: searchController4,
          data: dataLovDocDate,
          docString: (item) => '${item['prepare_date'] ?? ''}',
          titleText: (item) => '${item['prepare_date'] ?? ''}',
          subtitleText: (item) => null,
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnDocDate = '${item['prepare_date'] ?? ''}';
              displayDocDate = '${item['prepare_date'] ?? ''}' == 'null'
                  ? 'ทั้งหมด'
                  : '${item['prepare_date'] ?? ''}';
              print('prepare_date : ${item['prepare_date'] ?? ''}');
              docDateController.text = displayDocDate.toString();
              // if (returnStartLoc.isNotEmpty) {
              //   selectLovStartLoc('1');
              //   searchController5.clear;
              //   // displayStartLoc = '--';
              //   // returnStartLoc = 'null';
              //   // startLocController.text = '--';
              //   selectLovEndLoc('1');
              //   searchController6.clear;
              //   // displayEndLoc = '--';
              //   // returnEndLoc = 'null';
              //   // endLocController.text = '--';
              // }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnDocDate != 'null') {
              checkUpdateDataALL(true);
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
          searchController: searchController4,
          data: dataLovDocDate,
          docString: (item) => '${item['doc_no'] ?? ''}',
          titleText: (item) => '${item['doc_no'] ?? ''}',
          subtitleText: (item) => null,
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartDocNo = '${item['doc_no'] ?? ''}';
              displayStartDocNo = '${item['doc_no'] ?? ''}' == 'null'
                  ? 'ทั้งหมด'
                  : '${item['doc_no'] ?? ''}';
              print('doc_no : ${item['doc_no'] ?? ''}');
              startDocNoController.text = displayStartDocNo.toString();
              // if (returnStartLoc.isNotEmpty) {
              //   selectLovStartLoc('1');
              //   searchController5.clear;
              //   // displayStartLoc = '--';
              //   // returnStartLoc = 'null';
              //   // startLocController.text = '--';
              //   selectLovEndLoc('1');
              //   searchController6.clear;
              //   // displayEndLoc = '--';
              //   // returnEndLoc = 'null';
              //   // endLocController.text = '--';
              // }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnDocDate != 'null') {
              checkUpdateDataALL(true);
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
          searchController: searchController4,
          data: dataLovDocDate,
          docString: (item) => '${item['doc_no'] ?? ''}',
          titleText: (item) => '${item['doc_no'] ?? ''}',
          subtitleText: (item) => null,
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartDocNo = '${item['doc_no'] ?? ''}';
              displayStartDocNo = '${item['doc_no'] ?? ''}' == 'null'
                  ? 'ทั้งหมด'
                  : '${item['doc_no'] ?? ''}';
              print('doc_no : ${item['doc_no'] ?? ''}');
              startDocNoController.text = displayStartDocNo.toString();
              // if (returnStartLoc.isNotEmpty) {
              //   selectLovStartLoc('1');
              //   searchController5.clear;
              //   // displayStartLoc = '--';
              //   // returnStartLoc = 'null';
              //   // startLocController.text = '--';
              //   selectLovEndLoc('1');
              //   searchController6.clear;
              //   // displayEndLoc = '--';
              //   // returnEndLoc = 'null';
              //   // endLocController.text = '--';
              // }
              isLoading = false;
              // -----------------------------------------
            });
            if (returnDocDate != 'null') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }
}
