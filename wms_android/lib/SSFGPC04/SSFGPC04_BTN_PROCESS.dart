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
  String endGroup = '';
  String returnEndGroup = '';
  TextEditingController endGroupController = TextEditingController();
  TextEditingController searchEndGroupController = TextEditingController();
  // ----------------------------- Start Category
  List<dynamic> dataLovStartCategory = [];
  String? displayStartCategory;
  String endCategory = '';
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
  String endSubCategory = '';
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
  String endBrand = '';
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
  String endItem = '';
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

    await selectLovStartBrand();
    await selectLovEndBrand();

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
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text('กรุณาระบุข้อมูล รหัสคลังสินค้า'),
          onClose: () {
            Navigator.of(context).pop();
          },
          onConfirm: () async {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageCheckDialog(
          context: context,
          content:
              const Text('Please Confirm to process !!!'), // เนื้อหาใน popup
          onClose: () {
            Navigator.of(context).pop(); // ปิด dialog
          },
          onConfirm: () {
            Navigator.of(context).pop(); // ปิด dialog
            process(); // ดำเนินการ process
          },
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
      final response = await http
          .get(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_GROUP'));
      print(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_GROUP'));

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
      print(Uri.parse(
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
      final response =
          await http.get(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_CAT'
              '/${returnStartGroup.isNotEmpty ? returnStartGroup : 'null'}'
              '/${returnEndGroup.isNotEmpty ? returnEndGroup : 'null'}'));
      print(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_CAT'
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
      print(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_CAT_E'
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
      print(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_SUB_CAT'
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
      print(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_SUB_CAT_E'
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
      final response = await http
          .get(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_BRAND'));

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
      print(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_ITM'
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
      print(Uri.parse('${gb.IP_API}/apex/wms/SSFGPC04/Step_3_ITM_E'
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
    print('process : $url');
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'P_s_group_code': displayStartGroup,
      'P_e_group_code': displayEndGroup,
      'P_s_cat_code': displayStartCategory,
      'P_e_cat_code': displayEndCategory,
      'P_s_sub_cat_code': displayStartSubCategory,
      'P_e_sub_cat_code': displayEndSubCategory,
      'P_s_brand_code': displayStartBrand,
      'P_e_brand_code': displayEndBrand,
      'P_s_item_code': displayStartItem,
      'P_e_item_code': displayEndItem,
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
                  return DialogStyles.messageDialog(
                    context: context,
                    content: Text(
                        v_alt ?? 'ไม่พบข้อมูลสำหรับการสร้างเอกสารใบตรวจนับ'),
                    onClose: () {
                      Navigator.of(context).pop(); // ปิด dialog
                    },
                    onConfirm: () async {
                      Navigator.of(context).pop(); // ปิด dialog
                      // คุณสามารถใส่คำสั่งเพิ่มเติมได้ที่นี่
                    },
                    showCloseIcon: false,
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogStyles.messageDialog(
                    context: context,
                    content: Text(v_alt ?? 'ประมวลผลเสร็จสิ้น เลขที่ใบตรวจนับ'),
                    onClose: () {
                      Navigator.of(context).pop(); // ปิด dialog
                    },
                    onConfirm: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SSFGPC04_MAIN(
                              v_nb_doc_no: v_nb_doc_no, note: widget.note),
                        ),
                      );
                      // ปิด dialog
                    },
                    showCloseIcon: false,
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
      appBar: CustomAppBar(
          title: 'ประมวลผลก่อนการตรวจนับ', showExitWarning: checkUpdateData),
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
                            // controller: startGroupController,
                            controller: startGroupController.text.isNotEmpty
                                ? startGroupController
                                : TextEditingController(
                                    text: displayStartGroup ?? 'ทั้งหมด'),
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
                            // controller: endGroupController,
                            controller: endGroupController.text.isNotEmpty
                                ? endGroupController
                                : TextEditingController(
                                    text: displayEndGroup ?? 'ทั้งหมด'),
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
                            // controller: startCategoryController,
                            controller: startCategoryController.text.isNotEmpty
                                ? startCategoryController
                                : TextEditingController(
                                    text: displayStartCategory ?? 'ทั้งหมด'),
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
                            // controller: endCategoryController,
                            controller: endCategoryController.text.isNotEmpty
                                ? endCategoryController
                                : TextEditingController(
                                    text: displayEndCategory ?? 'ทั้งหมด'),
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
                            // controller: startSubCategoryController,
                            controller: startSubCategoryController
                                    .text.isNotEmpty
                                ? startSubCategoryController
                                : TextEditingController(
                                    text: displayStartSubCategory ?? 'ทั้งหมด'),
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
                            // controller: endSubCategoryController,
                            controller: endSubCategoryController.text.isNotEmpty
                                ? endSubCategoryController
                                : TextEditingController(
                                    text: displayEndSubCategory ?? 'ทั้งหมด'),
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
                            // controller: startBrandController,
                            controller: startBrandController.text.isNotEmpty
                                ? startBrandController
                                : TextEditingController(
                                    text: displayStartBrand ?? 'ทั้งหมด'),
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
                            // controller: endBrandController,
                            controller: endBrandController.text.isNotEmpty
                                ? endBrandController
                                : TextEditingController(
                                    text: displayEndBrand ?? 'ทั้งหมด'),
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
                            // controller: startItemController,
                            controller: startItemController.text.isNotEmpty
                                ? startItemController
                                : TextEditingController(
                                    text: displayStartItem ?? 'ทั้งหมด'),
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
                            // controller: endItemController,
                            controller: endItemController.text.isNotEmpty
                                ? endItemController
                                : TextEditingController(
                                    text: displayEndItem ?? 'ทั้งหมด'),

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
                    const SizedBox(height: 20),
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
    final List<Map<String, dynamic>> dataStartGroup = [
      {'group_code': 'ทั้งหมด', 'group_name': ''},
      ...dataLovStartGroup, // เพิ่มข้อมูลเดิมทั้งหมด
    ];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก กลุ่มสินค้า',
          searchController: searchStartGroupController,
          data: dataStartGroup,
          docString: (item) =>
              '${item['group_code'] ?? ''} ${item['group_name'] ?? ''}',
          titleText: (item) => '${item['group_code'] ?? ''}',
          subtitleText: (item) => '${item['group_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartGroup = '${item['group_code'] ?? ''}';
              displayStartGroup = returnStartGroup == 'ทั้งหมด'
                  ? null
                  : '${item['group_code'] ?? ''}';
              startGroupController.text = displayStartGroup ?? 'ทั้งหมด';

              // Additional logic when "ทั้งหมด" is selected
              if (returnStartGroup == 'ทั้งหมด') {
                // If "ทั้งหมด" is selected, set null for API call
                displayStartGroup = null;
                returnStartGroup = '';
              } else {
                // Logic for when a specific group is selected
                if (returnEndGroup.isNotEmpty &&
                    returnEndGroup != '' &&
                    returnStartGroup != '') {
                  if (displayStartGroup
                          .toString()
                          .compareTo(displayEndGroup.toString()) >
                      0) {
                    displayEndGroup = displayStartGroup;
                    endGroup = displayStartGroup ?? '';
                    returnEndGroup = returnStartGroup;
                    endGroupController.text = displayStartGroup.toString();
                  }
                } else if (returnEndGroup == '' &&
                    endGroup.toString().isNotEmpty) {
                  if (displayStartGroup
                          .toString()
                          .compareTo(displayEndGroup.toString()) >
                      0) {
                    displayEndGroup = displayStartGroup;
                    endGroup = displayStartGroup ?? '';
                    returnEndGroup = returnStartGroup;
                    endGroupController.text = displayStartGroup.toString();
                  } else {
                    displayEndGroup = endGroup;
                    returnEndGroup = returnStartGroup;
                    endGroupController.text = endGroup.toString();
                  }
                }
              }

              // Reset other fields when group is selected
              selectLovEndGroup();
              searchEndGroupController.clear();
              selectLovStartCategory();
              displayStartCategory = null;
              returnStartCategory = '';
              startCategoryController.text = '';
              searchStartCatController.clear();
              selectLovEndCategory();
              displayEndCategory = null;
              returnEndCategory = '';
              endCategoryController.text = '';
              searchEndCatController.clear();
              selectLovStartSubCategory();
              displayStartSubCategory = null;
              returnStartSubCategory = '';
              startSubCategoryController.text = '';
              searchStartSubCatController.clear();
              selectLovEndSubCategory();
              displayEndSubCategory = null;
              returnEndSubCategory = '';
              endSubCategoryController.text = '';
              searchEndSubCatController.clear();
              selectLovStartBrand();
              displayStartBrand = null;
              returnStartBrand = '';
              startBrandController.text = '';
              searchStartBrandController.clear();
              selectLovEndBrand();
              displayEndBrand = null;
              returnEndBrand = '';
              endBrandController.text = '';
              searchEndBrandController.clear();
              selectLovStartItem();
              displayStartItem = null;
              returnStartItem = '';
              startItemController.text = '';
              searchStartItemController.clear();
              selectLovEndItem();
              displayEndItem = null;
              returnEndItem = '';
              endItemController.text = '';
              searchEndItemController.clear();

              isLoading = false;
            });

            if (returnStartGroup != 'ทั้งหมด') {
              checkUpdateDataALL(true);
            }

            // Debug log
            print(
                'startGroupController New: $startGroupController Type : ${startGroupController.runtimeType}');
            print(
                'displayStartGroup New: $displayStartGroup Type : ${displayStartGroup.runtimeType}');
            print(
                'returnStartGroup New: $returnStartGroup Type : ${returnStartGroup.runtimeType}');
          },
        );
      },
    );
  }

//----------------------------------------------------------------------------//
// ถึงกลุ่มสินค้า
  void showDialogDropdownSearchEndGroup() {
    final List<Map<String, dynamic>> dataEndGroup = [
      {'group_code': 'ทั้งหมด', 'group_name': ''},
      ...dataLovEndGroup, // เพิ่มข้อมูลเดิมทั้งหมด
    ];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง กลุ่มสินค้า',
          searchController: searchEndGroupController,
          data: dataEndGroup,
          docString: (item) =>
              '${item['group_code'] ?? ''} ${item['group_name'] ?? ''}',
          titleText: (item) => '${item['group_code'] ?? ''}',
          subtitleText: (item) => '${item['group_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndGroup = '${item['group_code'] ?? ''}';
              displayEndGroup = returnEndGroup == 'ทั้งหมด'
                  ? null
                  : '${item['group_code'] ?? ''}';
              endGroup = displayEndGroup.toString().isNotEmpty &&
                      returnEndGroup != 'ทั้งหมด'
                  ? '${item['group_code']}'
                  : '';

              endGroupController.text = displayEndGroup ?? 'ทั้งหมด';

              // Reset related values when "ทั้งหมด" is selected
              if (returnEndGroup == 'ทั้งหมด') {
                selectLovStartCategory();
                displayStartCategory = null;
                returnStartCategory = '';
                startCategoryController.text = '';
                searchStartCatController.clear();
                selectLovEndCategory();
                displayEndCategory = null;
                returnEndCategory = '';
                endCategoryController.text = '';
                searchEndCatController.clear();
                selectLovStartSubCategory();
                displayStartSubCategory = null;
                returnStartSubCategory = '';
                startSubCategoryController.text = '';
                searchStartSubCatController.clear();
                selectLovEndSubCategory();
                displayEndSubCategory = null;
                returnEndSubCategory = '';
                endSubCategoryController.text = '';
                searchEndSubCatController.clear();
                selectLovStartBrand();
                displayStartBrand = null;
                returnStartBrand = '';
                startBrandController.text = '';
                searchStartBrandController.clear();
                selectLovEndBrand();
                displayEndBrand = null;
                returnEndBrand = '';
                endBrandController.text = '';
                searchEndBrandController.clear();
                selectLovStartItem();
                displayStartItem = null;
                returnStartItem = '';
                startItemController.text = '';
                searchStartItemController.clear();
                selectLovEndItem();
                displayEndItem = null;
                returnEndItem = '';
                endItemController.text = '';
                searchEndItemController.clear();
                isLoading = false;
              }

              isLoading = false;

              // Debug log
              print(
                  'endGroupController New: $endGroupController Type : ${endGroupController.runtimeType}');
              print(
                  'displayEndGroup New: $displayEndGroup Type : ${displayEndGroup.runtimeType}');
              print(
                  'returnEndGroup New: $returnEndGroup Type : ${returnEndGroup.runtimeType}');
            });

            if (returnStartGroup != 'ทั้งหมด') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }


//----------------------------------------------------------------------------//
// จาก Category
  void showDialogDropdownSearchStartCategory() {
    final List<Map<String, dynamic>> dataStartCategory = [
      {'category_code': 'ทั้งหมด', 'category_desc': ''},
      ...dataLovStartCategory, // เพิ่มข้อมูลเดิมทั้งหมด
    ];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก Category',
          searchController: searchStartCatController,
          data: dataStartCategory,
          docString: (item) =>
              '${item['category_code'] ?? ''} ${item['category_desc'] ?? ''}',
          titleText: (item) => '${item['category_code'] ?? ''}',
          subtitleText: (item) => '${item['category_desc'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartCategory = '${item['category_code'] ?? ''}';
              // If "ทั้งหมด" is selected, set the values to null for API usage
              displayStartCategory = returnStartCategory == 'ทั้งหมด'
                  ? null
                  : '${item['category_code'] ?? ''}';
              startCategoryController.text = displayStartCategory ?? 'ทั้งหมด';

              // Reset other related fields if "ทั้งหมด" is selected
              if (returnStartCategory == 'ทั้งหมด') {
                displayStartCategory = null;
                returnStartCategory = '';
              } else {
                if (returnEndCategory.isNotEmpty &&
                    returnEndCategory != '' &&
                    returnStartCategory != '') {
                  if (displayStartCategory
                          .toString()
                          .compareTo(displayEndCategory.toString()) >
                      0) {
                    displayEndCategory = displayStartCategory;
                    endCategory = displayStartCategory ?? '';
                    returnEndCategory = returnStartCategory;
                    endCategoryController.text =
                        displayStartCategory.toString();
                  }
                } else if (returnEndCategory == '' &&
                    endCategory.toString().isNotEmpty) {
                  if (displayStartCategory
                          .toString()
                          .compareTo(displayEndCategory.toString()) >
                      0) {
                    displayEndCategory = displayStartCategory;
                    endCategory = displayStartCategory ?? '';
                    returnEndCategory = returnStartCategory;
                    endCategoryController.text =
                        displayStartCategory.toString();
                  } else {
                    displayEndCategory = endCategory;
                    returnEndCategory = returnStartCategory;
                    endCategoryController.text = endCategory.toString();
                  }
                }
              }
              // Reset other dependent fields
              selectLovEndCategory();
              searchEndCatController.clear();
              selectLovStartSubCategory();
              displayStartSubCategory = null;
              returnStartSubCategory = '';
              startSubCategoryController.text = '';
              searchStartSubCatController.clear();
              selectLovEndSubCategory();
              displayEndSubCategory = null;
              returnEndSubCategory = '';
              endSubCategoryController.text = '';
              searchEndSubCatController.clear();
              selectLovStartBrand();
              displayStartBrand = null;
              returnStartBrand = '';
              startBrandController.text = '';
              searchStartBrandController.clear();
              selectLovEndBrand();
              displayEndBrand = null;
              returnEndBrand = '';
              endBrandController.text = '';
              searchEndBrandController.clear();
              selectLovStartItem();
              displayStartItem = null;
              returnStartItem = '';
              startItemController.text = '';
              searchStartItemController.clear();
              selectLovEndItem();
              displayEndItem = null;
              returnEndItem = '';
              endItemController.text = '';
              searchEndItemController.clear();
              isLoading = false;
            });
            searchStartCatController.clear();

            if (returnStartCategory != 'ทั้งหมด') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }
//----------------------------------------------------------------------------//
// ถึง Category
  void showDialogDropdownSearchEndCategory() {
    final List<Map<String, dynamic>> dataEndCategory = [
      {'category_code': 'ทั้งหมด', 'category_desc': ''},
      ...dataLovEndCategory,
    ];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง Category',
          searchController: searchEndCatController,
          data: dataEndCategory,
          docString: (item) =>
              '${item['category_code'] ?? ''} ${item['category_desc'] ?? ''}',
          titleText: (item) => '${item['category_code'] ?? ''}',
          subtitleText: (item) => '${item['category_desc'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndCategory = '${item['category_code'] ?? ''}';

              // If "ทั้งหมด" is selected, set values to null for API usage
              if (returnEndCategory == 'ทั้งหมด') {
                displayEndCategory = null;
                returnEndCategory = '';
              } else {
                displayEndCategory = '${item['category_code'] ?? ''}';
              }

              endCategoryController.text = displayEndCategory ?? 'ทั้งหมด';

              // Reset related fields when "ทั้งหมด" is selected
              if (returnEndCategory == 'ทั้งหมด') {
                endCategory = '';
                endCategoryController.text = '';
              } else {
                endCategory = displayEndCategory ?? '';
              }

              // Reset dependent fields
              selectLovStartSubCategory();
              displayStartSubCategory = null;
              returnStartSubCategory = '';
              startSubCategoryController.text = '';
              searchStartSubCatController.clear();
              selectLovEndSubCategory();
              displayEndSubCategory = null;
              returnEndSubCategory = '';
              endSubCategoryController.text = '';
              searchEndSubCatController.clear();
              selectLovStartBrand();
              displayStartBrand = null;
              returnStartBrand = '';
              startBrandController.text = '';
              searchStartBrandController.clear();
              selectLovEndBrand();
              displayEndBrand = null;
              returnEndBrand = '';
              endBrandController.text = '';
              searchEndBrandController.clear();
              selectLovStartItem();
              displayStartItem = null;
              returnStartItem = '';
              startItemController.text = '';
              searchStartItemController.clear();
              selectLovEndItem();
              displayEndItem = null;
              returnEndItem = '';
              endItemController.text = '';
              searchEndItemController.clear();

              isLoading = false;
            });

            searchEndCatController.clear();
            if (returnEndCategory != 'ทั้งหมด') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }


//----------------------------------------------------------------------------//
// จาก Sub Category
  void showDialogDropdownSearchStartSubCategory() {
    final List<Map<String, dynamic>> dataStartSubCategory = [
      {'sub_cat_code': 'ทั้งหมด', 'sub_cat_desc': ''},
      ...dataLovStartSubCategory, // เพิ่มข้อมูลเดิมทั้งหมด
    ];
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก Sub Category',
          searchController: searchStartSubCatController,
          data: dataStartSubCategory,
          docString: (item) =>
              '${item['sub_cat_code'] ?? ''} ${item['sub_cat_desc'] ?? ''}',
          titleText: (item) => '${item['sub_cat_code'] ?? ''}',
          subtitleText: (item) => '${item['sub_cat_desc'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartSubCategory = '${item['sub_cat_code'] ?? ''}';
              // If "ทั้งหมด" is selected, set the values to null for API usage
              displayStartSubCategory = returnStartSubCategory == 'ทั้งหมด'
                  ? null
                  : '${item['sub_cat_code'] ?? ''}';
              startSubCategoryController.text = displayStartSubCategory ?? 'ทั้งหมด';

              // Reset other related fields if "ทั้งหมด" is selected
              if (returnStartSubCategory == 'ทั้งหมด') {
                displayStartSubCategory = null;
                returnStartSubCategory = '';
              } else {
                if (returnEndSubCategory.isNotEmpty &&
                    returnEndSubCategory != '' &&
                    returnStartSubCategory != '') {
                  if (displayStartSubCategory
                          .toString()
                          .compareTo(displayEndSubCategory.toString()) >
                      0) {
                    displayEndSubCategory = displayStartSubCategory;
                    endSubCategory = displayStartSubCategory ?? '';
                    returnEndSubCategory = returnStartSubCategory;
                    endSubCategoryController.text =
                        displayStartSubCategory.toString();
                  }
                } else if (returnEndSubCategory == '' &&
                    endSubCategory.toString().isNotEmpty) {
                  if (displayStartSubCategory
                          .toString()
                          .compareTo(displayEndSubCategory.toString()) >
                      0) {
                    displayEndSubCategory = displayStartSubCategory;
                    endSubCategory = displayStartSubCategory ?? '';
                    returnEndSubCategory = returnStartSubCategory;
                    endSubCategoryController.text =
                        displayStartSubCategory.toString();
                  } else {
                    displayEndSubCategory = endSubCategory;
                    returnEndSubCategory = returnStartSubCategory;
                    endSubCategoryController.text = endSubCategory.toString();
                  }
                }
              }
              selectLovEndSubCategory();
              searchEndSubCatController.clear();
              selectLovStartBrand();
              displayStartBrand = null;
              returnStartBrand = '';
              startBrandController.text = '';
              searchStartBrandController.clear();
              selectLovEndBrand();
              displayEndBrand = null;
              returnEndBrand = '';
              endBrandController.text = '';
              searchEndBrandController.clear();
              selectLovStartItem();
              displayStartItem = null;
              returnStartItem = '';
              startItemController.text = '';
              searchStartItemController.clear();
              selectLovEndItem();
              displayEndItem = null;
              returnEndItem = '';
              endItemController.text = '';
              searchEndItemController.clear();
              isLoading = false;
            });
            searchStartSubCatController.clear();

            if (returnStartSubCategory != 'ทั้งหมด') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }

//----------------------------------------------------------------------------//
// ถึง Sub Category
  void showDialogDropdownSearchEndSubCategory() {
    final List<Map<String, dynamic>> dataEndSubCategory = [
      {'sub_cat_code': 'ทั้งหมด', 'sub_cat_desc': ''},
      ...dataLovEndSubCategory, // เพิ่มข้อมูลเดิมทั้งหมด
    ];
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง Sub Category',
          searchController: searchEndSubCatController,
          data: dataEndSubCategory,
          docString: (item) =>
              '${item['sub_cat_code'] ?? ''} ${item['sub_cat_desc'] ?? ''}',
          titleText: (item) => '${item['sub_cat_code'] ?? ''}',
          subtitleText: (item) => '${item['sub_cat_desc'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndSubCategory = '${item['sub_cat_code'] ?? ''}';

              // If "ทั้งหมด" is selected, set values to null for API usage
              if (returnEndSubCategory == 'ทั้งหมด') {
                displayEndSubCategory = null;
                returnEndSubCategory = '';
              } else {
                displayEndSubCategory = '${item['sub_cat_code'] ?? ''}';
              }

              endSubCategoryController.text = displayEndSubCategory ?? 'ทั้งหมด';

              // Reset related fields when "ทั้งหมด" is selected
              if (returnEndSubCategory == 'ทั้งหมด') {
                endSubCategory = '';
                endSubCategoryController.text = '';
              } else {
                endSubCategory = displayEndSubCategory ?? '';
              }

              // Reset dependent fields
              selectLovStartBrand();
              displayStartBrand = null;
              returnStartBrand = '';
              startBrandController.text = '';
              searchStartBrandController.clear();
              selectLovEndBrand();
              displayEndBrand = null;
              returnEndBrand = '';
              endBrandController.text = '';
              searchEndBrandController.clear();
              selectLovStartItem();
              displayStartItem = null;
              returnStartItem = '';
              startItemController.text = '';
              searchStartItemController.clear();
              selectLovEndItem();
              displayEndItem = null;
              returnEndItem = '';
              endItemController.text = '';
              searchEndItemController.clear();

              isLoading = false;
            });

            searchEndSubCatController.clear();
            if (returnEndSubCategory != 'ทั้งหมด') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }

//----------------------------------------------------------------------------//
// จาก Brand
  void showDialogDropdownSearchStartBrand() {
    final List<Map<String, dynamic>> dataStartBrand = [
      {'brand_code': 'ทั้งหมด', 'brand_name': ''},
      ...dataLovStartBrand, // เพิ่มข้อมูลเดิมทั้งหมด
    ];
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก Brand',
          searchController: searchStartBrandController,
          data: dataStartBrand,
          docString: (item) =>
              '${item['brand_code'] ?? ''} ${item['brand_name'] ?? ''}',
          titleText: (item) => '${item['brand_code'] ?? ''}',
          subtitleText: (item) => '${item['brand_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartBrand = '${item['brand_code'] ?? ''}';
              displayStartBrand = '${item['brand_code'] ?? ''}' == 'ทั้งหมด'
                  ? null
                  : '${item['brand_code'] ?? ''}';
              startBrandController.text = displayStartBrand ?? 'ทั้งหมด';
              if (returnStartBrand != 'ทั้งหมด') {
                if (returnEndBrand.isNotEmpty &&
                    returnEndBrand != '' &&
                    returnStartBrand != '') {
                  if (displayStartBrand
                          .toString()
                          .compareTo(displayEndBrand.toString()) >
                      0) {
                    displayEndBrand = displayStartBrand;
                    endBrand = displayStartBrand ?? '';
                    returnEndBrand = returnStartBrand;
                    endBrandController.text = displayStartBrand.toString();
                  }
                } else if (returnEndBrand == '' &&
                    endBrand.toString().isNotEmpty) {
                  if (displayStartBrand
                          .toString()
                          .compareTo(displayEndBrand.toString()) >
                      0) {
                    displayEndBrand = displayStartBrand;
                    endBrand = displayStartBrand ?? '';
                    returnEndBrand = returnStartBrand;
                    endBrandController.text = displayStartBrand.toString();
                  } else {
                    displayEndBrand = endBrand;
                    returnEndBrand = returnStartBrand;
                    endBrandController.text = endBrand.toString();
                  }
                }
                selectLovEndBrand();
                // displayEndBrand = null;
                // returnEndBrand = '';
                // endBrandController.text = '';
                searchEndBrandController.clear();
                selectLovStartItem();
                displayStartItem = null;
                returnStartItem = '';
                startItemController.text = '';
                searchStartItemController.clear();
                selectLovEndItem();
                displayEndItem = null;
                returnEndItem = '';
                endItemController.text = '';
                searchEndItemController.clear();
                isLoading = false;
              }
              isLoading = false;
            });
            searchStartBrandController.clear();
          },
        );
      },
    );
  }

//----------------------------------------------------------------------------//
// ถึง Brand
  void showDialogDropdownSearchEndBrand() {
    final List<Map<String, dynamic>> dataEndBrand = [
      {'brand_code': 'ทั้งหมด', 'brand_name': ''},
      ...dataLovEndBrand, // เพิ่มข้อมูลเดิมทั้งหมด
    ];
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง Brand',
          searchController: searchEndBrandController,
          data: dataEndBrand,
          docString: (item) =>
              '${item['brand_code'] ?? ''} ${item['brand_name'] ?? ''}',
          titleText: (item) => '${item['brand_code'] ?? ''}',
          subtitleText: (item) => '${item['brand_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndBrand = '${item['brand_code'] ?? ''}';
              displayEndBrand = '${item['brand_code'] ?? ''}' == 'ทั้งหมด'
                  ? null
                  : '${item['brand_code'] ?? ''}';
              endBrandController.text = displayEndBrand ?? 'ทั้งหมด';
              if (displayEndBrand.toString().isNotEmpty &&
                  displayEndBrand != 'ทั้งหมด' &&
                  returnEndBrand != '') {
                endBrand = '${item['brand_code']}';
              } else {
                endBrand = '';
              }
              if (returnEndBrand != 'ทั้งหมด') {
                selectLovStartItem();
                displayStartItem = null;
                returnStartItem = '';
                startItemController.text = '';
                searchStartItemController.clear;
                selectLovEndItem();
                displayEndItem = null;
                returnEndItem = '';
                endItemController.text = '';
                searchEndItemController.clear;
                isLoading = false;
              }
              isLoading = false;
            });
            searchEndBrandController.clear();
          },
        );
      },
    );
  }

//----------------------------------------------------------------------------//
// จาก item
  void showDialogDropdownSearchStartItem() {
    final List<Map<String, dynamic>> dataStartItem = [
      {'item_code': 'ทั้งหมด', 'itm_name': ''},
      ...dataLovStartItem, // เพิ่มข้อมูลเดิมทั้งหมด
    ];
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'จาก รหัสสินค้า',
          searchController: searchStartItemController,
          data: dataStartItem,
          docString: (item) =>
              '${item['item_code'] ?? ''} ${item['itm_name'] ?? ''}',
          titleText: (item) => '${item['item_code'] ?? ''}',
          subtitleText: (item) => '${item['itm_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnStartItem = '${item['item_code'] ?? ''}';
              // If "ทั้งหมด" is selected, set the values to null for API usage
              displayStartItem = returnStartItem == 'ทั้งหมด'
                  ? null
                  : '${item['item_code'] ?? ''}';
              startItemController.text =
                  displayStartItem ?? 'ทั้งหมด';

              // Reset other related fields if "ทั้งหมด" is selected
              if (returnStartItem == 'ทั้งหมด') {
                displayStartItem = null;
                returnStartItem = '';
              } else {
                if (returnEndItem.isNotEmpty &&
                    returnEndItem != '' &&
                    returnStartItem != '') {
                  if (displayStartItem
                          .toString()
                          .compareTo(displayEndItem.toString()) >
                      0) {
                    displayEndItem = displayStartItem;
                    endItem = displayStartItem ?? '';
                    returnEndItem = returnStartItem;
                    endItemController.text =
                        displayStartItem.toString();
                  }
                } else if (returnEndItem == '' &&
                    endItem.toString().isNotEmpty) {
                  if (displayStartItem
                          .toString()
                          .compareTo(displayEndItem.toString()) >
                      0) {
                    displayEndItem = displayStartItem;
                    endItem = displayStartItem ?? '';
                    returnEndItem = returnStartItem;
                    endItemController.text =
                        displayStartItem.toString();
                  } else {
                    displayEndItem = endItem;
                    returnEndItem = returnStartItem;
                    endItemController.text = endItem.toString();
                  }
                }
              }
              selectLovEndItem();
              searchEndItemController.clear();
              isLoading = false;
            });
            searchStartItemController.clear();

            if (returnStartItem != 'ทั้งหมด') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }

//----------------------------------------------------------------------------//
// ถึง Item
  void showDialogDropdownSearchEndItem() {
    // เพิ่มตัวเลือก "ทั้งหมด" เข้าไปใน `dataLovEndItem`
    final List<Map<String, dynamic>> dataEndItem = [
      {'item_code': 'ทั้งหมด', 'itm_name': ''},
      ...dataLovEndItem, // เพิ่มข้อมูลเดิมทั้งหมด
    ];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'ถึง รหัสสินค้า',
          searchController: searchEndItemController,
          data: dataEndItem,
          docString: (item) =>
              '${item['item_code'] ?? ''} ${item['itm_name'] ?? ''}',
          titleText: (item) => '${item['item_code'] ?? ''}',
          subtitleText: (item) => '${item['itm_name'] ?? ''}',
          onTap: (item) {
            isLoading = true;
            Navigator.of(context).pop();
            setState(() {
              returnEndItem = '${item['item_code'] ?? ''}';

              // If "ทั้งหมด" is selected, set values to null for API usage
              if (returnEndItem == 'ทั้งหมด') {
                displayEndItem = null;
                returnEndItem = '';
              } else {
                displayEndItem = '${item['item_code'] ?? ''}';
              }

              endItemController.text =
                  displayEndItem ?? 'ทั้งหมด';

              // Reset related fields when "ทั้งหมด" is selected
              if (returnEndItem == 'ทั้งหมด') {
                endItem = '';
                endItemController.text = '';
              } else {
                endItem = displayEndItem ?? '';
              }
              isLoading = false;
            });

            searchEndItemController.clear();
            if (returnEndItem != 'ทั้งหมด') {
              checkUpdateDataALL(true);
            }
          },
        );
      },
    );
  }
}
