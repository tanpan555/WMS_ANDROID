import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:wms_android/styles.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/bottombar.dart';

class SSFGRP09_MAINRRR extends StatefulWidget {
  SSFGRP09_MAINRRR({
    Key? key,
  }) : super(key: key);
  @override
  _SSFGRP09_MAINRRRState createState() => _SSFGRP09_MAINRRRState();
}

class _SSFGRP09_MAINRRRState extends State<SSFGRP09_MAINRRR> {
  List<dynamic> dataLovDate = [];

  bool isLoading = false;
  bool checkUpdateData = false;

  // -----------------------------------  Display
  String displayLovDate = '';
  // -----------------------------------  Return
  String returnLovDate = '';
  // -----------------------------------  Controller
  TextEditingController dateController = TextEditingController();
  // -----------------------------------  Check edit data
  // -----------------------------------  Search
  TextEditingController searchDateController = TextEditingController();

  @override
  void initState() {
    firstLoadData();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  void firstLoadData() async {
    await selectLovDate();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  var maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')}, // อนุญาตเฉพาะตัวเลข
  );

  Future<void> selectLovDate() async {
    // if (isFirstLoad == true) {
    //   if (mounted) {
    //     setState(() {
    //       isLoading = true;
    //     });
    //   }
    // } else if (isFirstLoad == false) {
    //   if (mounted) {
    //     isLoading = true;
    //   }
    // }
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

            // if (isFirstLoad == false) {
            //   if (mounted) {
            //     isLoading = false;
            //   }
            // }
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
                  ],
                ),
              ),
      ),
    );
  }

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
                            searchDateController.clear();
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
                      controller: searchDateController,
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
                                searchDateController.text.trim().toLowerCase();
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
                                  returnLovDate = returnCode;
                                  displayLovDate = doc;
                                  dateController.text =
                                      displayLovDate.toString();
                                  setState(() {
                                    if (returnLovDate != '' ||
                                        returnLovDate.isNotEmpty) {
                                      setState(() {
                                        checkUpdateData = true;
                                      });
                                    }
                                    // if (returnLovDate.isNotEmpty) {
                                    //   selectLovDocNo();
                                    //   displayLovDocNo = '';
                                    //   returnLovDocNo = '';
                                    //   docNoController.clear();
                                    //   isLoading = false;
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
                                    print(
                                        'checkUpdateData New: $checkUpdateData Type : ${checkUpdateData.runtimeType}');
                                  });
                                  if (returnLovDate != '' ||
                                      returnLovDate.isNotEmpty) {
                                    setState(() {
                                      checkUpdateData = true;
                                    });
                                  }
                                  searchDateController.clear();
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
