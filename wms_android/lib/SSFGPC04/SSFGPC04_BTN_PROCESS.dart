import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:wms_android/styles.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'SSFGPC04_MAIN.dart';

class SSFGPC04_BTN_PROCESS extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final String date;
  final String note;
  final String docNo;
  SSFGPC04_BTN_PROCESS({
    Key? key,
    required this.selectedItems,
    required this.date,
    required this.note,
    required this.docNo,
  }) : super(key: key);
  @override
  _SSFGPC04_BTN_PROCESSState createState() => _SSFGPC04_BTN_PROCESSState();
}

class _SSFGPC04_BTN_PROCESSState extends State<SSFGPC04_BTN_PROCESS> {
  // ----------------------------- Start Group
  List<dynamic> dataLovStartGroup = [];
  String? displayStartGroup;
  String returnStartGroup = '';
  TextEditingController startGroupController = TextEditingController();
  TextEditingController searchStartGroupController = TextEditingController();
  // ----------------------------- End Group
  List<dynamic> dataLovEndGroup = [];
  String? displayEndGroup;
  String returnEndGroup = '';
  TextEditingController endGroupController = TextEditingController();
  TextEditingController searchEndGroupController = TextEditingController();
  // ----------------------------- Start Category
  List<dynamic> dataLovStartCategory = [];
  String? displayStartCategory;
  String returnStartCategory = '';
  TextEditingController startCategoryController = TextEditingController();
  TextEditingController searchStartCatController = TextEditingController();
  // ----------------------------- End Category
  List<dynamic> dataLovEndCategory = [];
  String? displayEndCategory;
  String returnEndCategory = '';
  TextEditingController endCategoryController = TextEditingController();
  TextEditingController searchEndCatController = TextEditingController();
  // ----------------------------- Start Sub Category
  List<dynamic> dataLovStartSubCategory = [];
  String? displayStartSubCategory;
  String returnStartSubCategory = '';
  TextEditingController startSubCategoryController = TextEditingController();
  TextEditingController searchStartSubCatController = TextEditingController();
  // ----------------------------- End Sub Category
  List<dynamic> dataLovEndSubCategory = [];
  String? displayEndSubCategory;
  String returnEndSubCategory = '';
  TextEditingController endSubCategoryController = TextEditingController();
  TextEditingController searchEndSubCatController = TextEditingController();
  // ----------------------------- Start Brand
  List<dynamic> dataLovStartBrand = [];
  String? displayStartBrand;
  String returnStartBrand = '';
  TextEditingController startBrandController = TextEditingController();
  TextEditingController searchStartBrandController = TextEditingController();
  // ----------------------------- End Brand
  List<dynamic> dataLovEndBrand = [];
  String? displayEndBrand;
  String returnEndBrand = '';
  TextEditingController endBrandController = TextEditingController();
  TextEditingController searchEndBrandController = TextEditingController();
  // ----------------------------- Start Item
  List<dynamic> dataLovStartItem = [];
  String? displayStartItem;
  String returnStartItem = '';
  TextEditingController startItemController = TextEditingController();
  TextEditingController searchStartItemController = TextEditingController();
  // ----------------------------- End Item
  List<dynamic> dataLovEndItem = [];
  String? displayEndItem;
  String returnEndItem = '';
  TextEditingController endItemController = TextEditingController();
  TextEditingController searchEndItemController = TextEditingController();
//----------------------------------------------------------------------------//
  bool isLoading = false;
  bool isFirstLoad = true;
  bool checkUpdateData = false;

  @override
  void initState() {
    firstLoadData();
    super.initState();
  }

  @override
  void dispose() {
    searchStartGroupController.dispose();
    searchEndGroupController.dispose();

    searchStartCatController.dispose();
    searchEndCatController.dispose();

    searchStartSubCatController.dispose();
    searchEndSubCatController.dispose();

    searchStartBrandController.dispose();
    searchEndBrandController.dispose();

    searchStartItemController.dispose();
    searchEndItemController.dispose();
    super.dispose();
  }

  void firstLoadData() async {
    await selectLovStartGroup();
    await selectLovEndGroup();

    await selectLovStartCategory();
    await selectLovEndCategory();

    await selectLovStartSubCategory();
    await selectLovEndSubCategory();

    // await selectLovStartBrand();
    // await selectLovEndBrand();

    await selectLovStartItem();
    await selectLovEndItem();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notification_important, // ไอคอนแจ้งเตือน
                color: Colors.red, // สีแดง
                size: 30,
              ),
              SizedBox(width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
              Text('แจ้งเตือน'),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black), // ไอคอนปิด
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด popup
                },
              ),
            ],
          ),
          content:
              const Text('กรุณาระบุข้อมูล รหัสคลังสินค้า'),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notification_important, // ไอคอนแจ้งเตือน
                color: Colors.red, // สีแดง
                size: 30,
              ),
              SizedBox(width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
              Text('แจ้งเตือน'),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black), // ไอคอนปิด
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด popup
                },
              ),
            ],
          ),
          content: const Text('Please Confirm to process !!!'),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              onPressed: () {
                // process();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                process(); // Proceed with processing
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

//----------------------------------------------------------------------------//
// กลุ่มสินค้า
  Future<void> selectLovStartGroup() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(
          Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_GROUP'));

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
          '${gb.IP_API}/apex/wms/SSFGPC04/Step_3_GROUP_E/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'));

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

//----------------------------------------------------------------------------//
// Category
  Future<void> selectLovStartCategory() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http
          .get(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_CAT'
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
          '${gb.IP_API}/apex/wms/SSFGPC04/Step_3_CAT_E'
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

//----------------------------------------------------------------------------//
// Sub Category
  Future<void> selectLovStartSubCategory() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGPC04/Step_3_SUB_CAT'
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
          '${gb.IP_API}/apex/wms/SSFGPC04/Step_3_SUB_CAT_E'
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
        print('dataLovEndSubCategory : $dataLovEndSubCategory');
      } else {
        throw Exception(
            'dataLovEndSubCategory Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndSubCategory ERROR IN Fetch Data : $e');
    }
  }

//----------------------------------------------------------------------------//
// Brand
  Future<void> selectLovStartBrand() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(
          Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_BRAND'));

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

  Future<void> selectLovEndBrand() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGPC04/Step_3_BRAND_E/${returnStartBrand.isNotEmpty ? returnStartBrand : 'null'}'));

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

//----------------------------------------------------------------------------//
// Item
  Future<void> selectLovStartItem() async {
    if (isFirstLoad == false) {
      if (mounted) {
        isLoading = true;
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGPC04/Step_3_ITM'
          '/${gb.BROWSER_LANGUAGE}'
          '/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'
          '/${returnEndGroup.isNotEmpty ? returnEndGroup : 'null'}'
          '/${returnStartCategory.isNotEmpty ? returnStartCategory : 'null'}'
          '/${returnEndCategory.isNotEmpty ? returnEndCategory : 'null'}'
          '/${returnStartSubCategory.isNotEmpty ? returnStartSubCategory : 'null'}'
          '/${returnEndSubCategory.isNotEmpty ? returnEndSubCategory : 'null'}'
          '/${returnStartBrand.isNotEmpty ? returnStartBrand : 'null'}'
          '/${returnEndBrand.isNotEmpty ? returnEndBrand : 'null'}'));

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
          '${gb.IP_API}/apex/wms/SSFGPC04/Step_3_ITM_E'
          '/${gb.BROWSER_LANGUAGE}'
          '/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'
          '/${returnEndGroup.isNotEmpty ? returnEndGroup : 'null'}'
          '/${returnStartCategory.isNotEmpty ? returnStartCategory : 'null'}'
          '/${returnEndCategory.isNotEmpty ? returnEndCategory : 'null'}'
          '/${returnStartSubCategory.isNotEmpty ? returnStartSubCategory : 'null'}'
          '/${returnEndSubCategory.isNotEmpty ? returnEndSubCategory : 'null'}'
          '/${returnStartBrand.isNotEmpty ? returnStartBrand : 'null'}'
          '/${returnEndBrand.isNotEmpty ? returnEndBrand : 'null'}'
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
        print('dataLovEndItem : $dataLovEndItem');
      } else {
        throw Exception(
            'dataLovEndItem Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndItem ERROR IN Fetch Data : $e');
    }
  }

//----------------------------------------------------------------------------//
//button
  String? v_nb_doc_no;
  String? v_alt;
  String? v_alt2;
  Future<void> process() async {
    final url = '${gb.IP_API}/apex/wms/SSFGPC04/Step_3_process_new';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'P_s_group_code': startGroupController.text,
      'P_e_group_code': endGroupController.text,
      'P_s_cat_code': startCategoryController.text,
      'P_e_cat_code': endCategoryController.text,
      'P_s_sub_cat_code': startSubCategoryController.text,
      'P_e_sub_cat_code': endSubCategoryController.text,
      'P_s_brand_code': startBrandController.text,
      'P_e_brand_code': endBrandController.text,
      'P_s_item_code': startItemController.text,
      'P_e_item_code': endItemController.text,
      'P_NB_DATE': widget.date,
      'P_NOTE': widget.note,
      'P_EMP_ID': gb.P_EMP_ID,
      'APP_SESSION': gb.APP_SESSION,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      'browser_language': gb.BROWSER_LANGUAGE,
      'APP_USER': gb.APP_USER,
      'P_ATTR1': '',
    });

    print('Request body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            if (mounted) {
              setState(() {
                v_nb_doc_no = responseData['V_NB_DOC_NO'];
                v_alt = responseData['V_ALT'];
                v_alt2 = responseData['V_ALT2'];
              });
            }

            // Check for v_nb_doc_no and show appropriate popup
            if (v_nb_doc_no == 'AUTO') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        v_alt ?? 'ไม่พบข้อมูลสำหรับการสร้างเอกสารใบตรวจนับ'),
                    actions: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('ตกลง'),
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(v_alt ?? 'ประมวลผลเสร็จสิ้น เลขที่ใบตรวจนับ'),
                    actions: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(
                            MaterialPageRoute(
                              builder: (context) => SSFGPC04_MAIN(
                                  ),
                            ),
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }

            print('Success: $responseData');
          } catch (e) {
            print('Error decoding JSON: $e');
          }
        } else {
          print('Response body is empty');
        }
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('การประมวลผล Error นะฮ๊าฟฟู๊วววว: $e');
    }
  }

//----------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(
          title: 'ประมวลผลก่อนการตรวจนับ',
          showExitWarning: returnStartGroup.isEmpty &&
                  returnEndGroup.isEmpty &&
                  returnStartCategory.isEmpty &&
                  returnEndCategory.isEmpty &&
                  returnStartSubCategory.isEmpty &&
                  returnEndSubCategory.isEmpty &&
                  returnStartBrand.isEmpty &&
                  returnEndBrand.isEmpty &&
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
//----------------------------------------------------------------------------//
// กลุ่มสินค้า
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
//----------------------------------------------------------------------------//
// Category
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
//----------------------------------------------------------------------------//
// Sub Category
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
//----------------------------------------------------------------------------//
// Brand
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchStartBrandController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchStartBrand(),
                            minLines: 1,
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'จาก ยี่ห้อ',
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
                            controller: searchEndBrandController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchEndBrand(),
                            minLines: 1,
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'ถึง ยี่ห้อ',
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
//----------------------------------------------------------------------------//
// Item
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
//----------------------------------------------------------------------------//
// ประมวลผล
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (widget.selectedItems.isEmpty) {
                              // Show alert if no items are selected
                              showAlertDialog();
                            } else {
                              showConfirmationDialog();
                              // Call process() if items are selected
                              
                            }
                          },
                          style: AppStyles.ConfirmbuttonStyle(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                'ประมวลผล',
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

//----------------------------------------------------------------------------//
// จากกลุ่มสินค้า
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
                            searchStartGroupController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchStartGroupController,
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
                            final searchQuery = searchStartGroupController.text
                                .trim()
                                .toLowerCase();
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
                                  searchStartGroupController.clear();
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

//----------------------------------------------------------------------------//
// ถึงกลุ่มสินค้า
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
                            searchEndGroupController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchEndGroupController,
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
                            final searchQuery = searchEndGroupController.text
                                .trim()
                                .toLowerCase();
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
                                  searchEndGroupController.clear();
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

//----------------------------------------------------------------------------//
// จาก Category
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
                            searchStartCatController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchStartCatController,
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
                            final searchQuery = searchStartCatController.text
                                .trim()
                                .toLowerCase();
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
                                  searchStartCatController.clear();
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

//----------------------------------------------------------------------------//
// ถึง Category
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
                            searchEndCatController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchEndCatController,
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
                            final searchQuery = searchEndCatController.text
                                .trim()
                                .toLowerCase();
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
                                  searchEndCatController.clear();
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

//----------------------------------------------------------------------------//
// จาก Sub Category
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
                            searchStartSubCatController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchStartSubCatController,
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
                            final searchQuery = searchStartSubCatController.text
                                .trim()
                                .toLowerCase();
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
                                      // selectLovStartBrand();
                                      // displayStartBrand = '';
                                      // returnStartBrand = '';
                                      // startBrandController.clear();
                                      // selectLovEndBrand();
                                      // displayEndBrand = '';
                                      // returnEndBrand = '';
                                      // endBrandController.clear();
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
                                  searchStartSubCatController.clear();
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

//----------------------------------------------------------------------------//
// ถึง Sub Category
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
                            searchEndSubCatController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchEndSubCatController,
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
                            final searchQuery = searchEndSubCatController.text
                                .trim()
                                .toLowerCase();
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
                                      // selectLovStartBrand();
                                      // displayStartBrand = '';
                                      // returnStartBrand = '';
                                      // startBrandController.clear();
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
                                    print(
                                        'endSubCategoryController New: $endSubCategoryController Type : ${endSubCategoryController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndSubCategory New: $displayEndSubCategory Type : ${displayEndSubCategory.runtimeType}');
                                    print(
                                        'returnEndSubCategory New: $returnEndSubCategory Type : ${returnEndSubCategory.runtimeType}');
                                  });
                                  searchEndSubCatController.clear();
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

//----------------------------------------------------------------------------//
// จาก Brand
  void showDialogDropdownSearchStartBrand() {
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
                          'จาก Brand',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchStartBrandController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchStartBrandController,
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
                          final filteredItems = dataLovStartBrand.where((item) {
                            final docString =
                                '${item['brand_code'] ?? ''} ${item['brand_name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery = searchStartBrandController.text
                                .trim()
                                .toLowerCase();
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
                              final doc = '${item['brand_code'] ?? ''}';
                              final returnCode = '${item['brand_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['brand_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['brand_name'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnStartBrand = returnCode;
                                    displayStartBrand = doc;
                                    startBrandController.text =
                                        displayStartBrand.toString();
                                    if (returnStartBrand.isNotEmpty) {
                                      selectLovEndBrand();
                                      displayEndBrand = '';
                                      returnEndBrand = '';
                                      endBrandController.clear();
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
                                        'startBrandController New: $startBrandController Type : ${startBrandController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayStartBrand New: $displayStartSubCategory Type : ${displayStartSubCategory.runtimeType}');
                                    print(
                                        'returnStartBrand New: $returnStartBrand Type : ${returnStartBrand.runtimeType}');
                                  });
                                  searchStartBrandController.clear();
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

//----------------------------------------------------------------------------//
// ถึง Brand
  void showDialogDropdownSearchEndBrand() {
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
                          'ถึง Brand',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            searchEndBrandController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchEndBrandController,
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
                          final filteredItems = dataLovEndBrand.where((item) {
                            final docString =
                                '${item['brand_code'] ?? ''} ${item['brand_name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery = searchEndBrandController.text
                                .trim()
                                .toLowerCase();
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
                              final doc = '${item['brand_code'] ?? ''}';
                              final returnCode = '${item['brand_code'] ?? ''}';

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${item['brand_code'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('${item['brand_name'] ?? ''}'),
                                onTap: () {
                                  isLoading = true;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnEndBrand = returnCode;
                                    displayEndBrand = doc;
                                    endBrandController.text =
                                        displayEndBrand.toString();
                                    if (returnEndBrand.isNotEmpty) {
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
                                    print(
                                        'endBrandController New: $endBrandController Type : ${endBrandController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndBrand New: $displayEndBrand Type : ${displayEndBrand.runtimeType}');
                                    print(
                                        'returnEndBrand New: $returnEndBrand Type : ${returnEndBrand.runtimeType}');
                                  });
                                  searchEndBrandController.clear();
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

//----------------------------------------------------------------------------//
// จาก item
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
                            searchStartItemController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchStartItemController,
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
                                '${item['item_code'] ?? ''} ${item['itm_name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery = searchStartItemController.text
                                .trim()
                                .toLowerCase();
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
                                subtitle: Text('${item['itm_name'] ?? ''}'),
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
                                  searchStartItemController.clear();
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

//----------------------------------------------------------------------------//
// ถึง Item
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
                            searchEndItemController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ช่องค้นหา
                    TextField(
                      controller: searchEndItemController,
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
                                '${item['item_code'] ?? ''} ${item['itm_name'] ?? ''}'
                                    .toLowerCase();
                            final searchQuery = searchEndItemController.text
                                .trim()
                                .toLowerCase();
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
                                subtitle: Text('${item['itm_name'] ?? ''}'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // String dataCheck = returnCode;
                                    returnEndItem = returnCode;
                                    displayEndItem = doc;
                                    endItemController.text =
                                        displayEndItem.toString();
                                    print(
                                        'endItemController New: $endItemController Type : ${endItemController.runtimeType}');
                                    print(
                                        'doc New: $doc Type : ${doc.runtimeType}');
                                    print(
                                        'displayEndItem New: $displayEndItem Type : ${displayEndItem.runtimeType}');
                                    print(
                                        'returnEndItem New: $returnEndItem Type : ${returnEndItem.runtimeType}');
                                  });
                                  searchEndItemController.clear();
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
