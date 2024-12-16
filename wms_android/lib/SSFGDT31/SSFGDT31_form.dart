import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'package:wms_android/loading.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/TextFormFieldCheckDate.dart';
import 'SSFGDT31_grid.dart';

class Ssfgdt31Form extends StatefulWidget {
  final String pWareCode;
  final String pDocNo;
  final String pDocType;
  Ssfgdt31Form({
    Key? key,
    required this.pWareCode,
    required this.pDocNo,
    required this.pDocType,
  }) : super(key: key);
  @override
  _Ssfgdt31FormState createState() => _Ssfgdt31FormState();
}

class _Ssfgdt31FormState extends State<Ssfgdt31Form> {
  List<dynamic> dataForm = [];
  List<dynamic> dataLovDocType = [];
  List<dynamic> dataLovMoDoNo = [];
  List<dynamic> dataLovRefNo = [];
  List<dynamic> dataLovCancel = [];
  String? selectLovDocType;
  String returnStatusLovDocType = '';
  // -----------------------------
  String? selectLovMoDoNo;
  String returnStatusLovMoDoNo = '';
  // -----------------------------
  String? selectLovRefNo;
  String returnStatusLovRefNo = '';
  // -----------------------------
  String? selectLovCancel;
  String returnStatusLovCancel = '';
  // -----------------------------
  String custName = ''; // cust_code + cust_name
  String ouCode = '';
  String docNo = '';
  String docType = '';
  String crDate = '';
  String refNo = '';
  String moDoNo = '';
  String staffCode = '';
  String note = '';
  String erpDocNo = '';
  String updBy = '';
  String updDate = '';
  String updProgID = '';
  String docDate = '';
  int testChk = 0; //

  //---------------------------------------\\
  String custNameForCheck = ''; // cust_code + cust_name
  String ouCodeForCheck = '';
  String docNoForCheck = '';
  String docTypeForCheck = '';
  String crDateForCheck = '';
  String refNoForCheck = '';
  String moDoNoForCheck = '';
  String staffCodeForCheck = '';
  String noteForCheck = '';
  String erpDocNoForCheck = '';
  String updByForCheck = '';
  String updDateForCheck = '';
  String updProgIDForCheck = '';
  String docDateForCheck = '';

  String returnStatusLovDocTypeForCheck = '';
  String returnStatusLovMoDoNoForCheck = '';
  String returnStatusLovRefNoForCheck = '';
  String returnStatusLovCancelForCheck = '';
  //---------------------------------------\\

  String soNoForChk = ''; // ref_no สำหรับ check
  String shidForChk = ''; // mo_do_no สำหรับ check
  String pMessageErr = ''; // message หลังจาก check    so_no == shid

  String statusSubmit = '';
  String messageSubmit = '';

  String deleteStatus = '';
  String deleteMessage = '';

  String updateStatus = '';
  String updateMessage = '';
  String refDocType = '';
  String refDocNo = '';

  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);
  bool isDateInvalid = false;

  bool isLoading = false;
  bool isFirstLoad = true;
  bool isNextDisabled = false;

  bool checkUpdateData = false;

  TextEditingController custNameController = TextEditingController();
  TextEditingController ouCodeController = TextEditingController();
  TextEditingController docNoController = TextEditingController();
  TextEditingController docTypeController = TextEditingController();
  TextEditingController crDateController = TextEditingController();
  TextEditingController refNoController = TextEditingController();
  TextEditingController moDoNoController = TextEditingController();
  TextEditingController staffCodeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController erpDocNoController = TextEditingController();
  TextEditingController updByController = TextEditingController();
  TextEditingController updDateController = TextEditingController();
  TextEditingController updProgIDController = TextEditingController();
  TextEditingController docDateController = TextEditingController();

  TextEditingController _searchController1 = TextEditingController();
  TextEditingController _searchController2 = TextEditingController();
  TextEditingController _searchController3 = TextEditingController();
  TextEditingController _searchController4 = TextEditingController();
  TextEditingController cancelController = TextEditingController();

  @override
  void initState() {
    print('doc no : ${widget.pDocNo}');
    print('doc type : ${widget.pDocType}');
    firstLoadData();
    super.initState();
  }

  @override
  void dispose() {
    _searchController1.dispose();
    _searchController2.dispose();
    _searchController3.dispose();
    _searchController4.dispose();
    custNameController.dispose();
    ouCodeController.dispose();
    docNoController.dispose();
    docTypeController.dispose();
    crDateController.dispose();
    refNoController.dispose();
    moDoNoController.dispose();
    staffCodeController.dispose();
    noteController.dispose();
    erpDocNoController.dispose();
    updByController.dispose();
    updDateController.dispose();
    updProgIDController.dispose();
    docDateController.dispose();
    super.dispose();
  }

  void firstLoadData() async {
    await fetchData();
    await lovDocType();
    await lovMoDoNo();
    await lovRefNo();
    await lovCancel();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    if (isFirstLoad == true) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
    }
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_DataForm/${globals.P_ERP_OU_CODE}/${widget.pDocNo}/${widget.pDocType}/${globals.ATTR1}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          print('Fetched data: $jsonDecode');
          print('data $data');
          if (mounted) {
            setState(() {
              // -----------------------------
              ouCode = item['ou_code'] ?? '';
              ouCodeForCheck = item['ou_code'] ?? '';
              // -----------------------------
              docNo = item['doc_no'] ?? '';
              docNoForCheck = item['doc_no'] ?? '';
              // -----------------------------
              // docType = item['doc_type'] ?? '';
              // -----------------------------
              crDate = item['cr_date'] ?? '';
              crDateForCheck = item['cr_date'] ?? '';
              // -----------------------------
              staffCode = item['staff_code"'] ?? '';
              staffCodeForCheck = item['staff_code"'] ?? '';
              // -----------------------------
              note = item['note'] ?? '';
              noteForCheck = item['note'] ?? '';
              // -----------------------------
              erpDocNo = item['erp_doc_no'] ?? '';
              erpDocNoForCheck = item['erp_doc_no'] ?? '';
              // -----------------------------
              updBy = item['upd_by'] ?? '';
              updByForCheck = item['upd_by'] ?? '';
              // -----------------------------
              updDate = item['upd_date'] ?? '';
              updDateForCheck = item['upd_date'] ?? '';
              // -----------------------------
              updProgID = item['upd_prog_id'] ?? '';
              updProgIDForCheck = item['upd_prog_id'] ?? '';
              // -----------------------------
              docDate = item['doc_date'] ?? '';
              docDateForCheck = item['doc_date'] ?? '';
              // -----------------------------
              selectLovDocType = item['doc_type_d'] ?? '';
              returnStatusLovDocType = item['doc_type_r'] ?? '';
              returnStatusLovDocTypeForCheck = item['doc_type_r'] ?? '';
              // -----------------------------
              selectLovRefNo = item['ref_no'] ?? '';
              returnStatusLovRefNo = item['ref_no'] ?? '';
              returnStatusLovRefNoForCheck = item['ref_no'] ?? '';
              // -----------------------------
              selectLovMoDoNo = item['mo_do_no'] ?? '';
              returnStatusLovMoDoNo = item['mo_do_no'] ?? '';
              returnStatusLovMoDoNoForCheck = item['mo_do_no'] ?? '';
              // -----------------------------
              ouCodeController.text = ouCode;
              docNoController.text = docNo;
              crDateController.text = crDate;
              // refNoController.text = refNo;
              // moDoNoController.text = refNo;
              staffCodeController.text = staffCode;
              noteController.text = note;
              erpDocNoController.text = erpDocNo;
              updByController.text = updBy;
              updDateController.text = updDate;
              updProgIDController.text = updProgID;
              docDateController.text = docDate;

              docTypeController.text = selectLovDocType.toString();
              moDoNoController.text = selectLovMoDoNo.toString();
              refNoController.text = selectLovRefNo.toString();

              print('selectLovDocType : $selectLovDocType');
              print('returnStatusLovDocType : $returnStatusLovDocType');
              print(
                  'returnStatusLovDocTypeForCheck : $returnStatusLovDocTypeForCheck');
              print('docTypeController : $docTypeController');
            });
          }
        } else {
          print('No items found.');
        }
      } else {
        print(
            'fetchData     Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('1');
      print('Error: $e');
    }
  }

  Future<void> lovDocType() async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_SelectLovDocType/${globals.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovDocType =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovDocType : $dataLovDocType');
      } else {
        throw Exception('dataLovDocType Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovDocType ERROR IN Fetch Data : $e');
    }
  }

  Future<void> lovMoDoNo() async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_SelectLovMoDoNo'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovMoDoNo =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovMoDoNo : $dataLovMoDoNo');
      } else {
        throw Exception('dataLovMoDoNo Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovMoDoNo ERROR IN Fetch Data : $e');
    }
  }

  Future<void> lovRefNo() async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_SelectLovRefNo/${globals.P_ERP_OU_CODE}/${globals.ATTR1}/${widget.pWareCode}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovRefNo =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovRefNo : $dataLovRefNo');
      } else {
        throw Exception('dataLovRefNo Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovRefNo ERROR IN Fetch Data : $e');
    }
  }

  Future<void> lovCancel() async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_SelectLovCancel'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataLovCancel =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);

            if (isFirstLoad == true) {
              isFirstLoad = false;
              isLoading = false;
            }
          });
        }
        print('dataLovCancel : $dataLovCancel');
      } else {
        throw Exception('dataLovCancel Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('dataLovCancel ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectCust(String pMoDoNo, String checkWhere) async {
    print('pMoDoNo in selectCust   : $pMoDoNo type : ${pMoDoNo.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_Cust/$pMoDoNo'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          if (custName.isEmpty) {
            if (mounted) {
              setState(() {
                custName = item['cust'] ?? '';
                custNameController.text = custName;
              });
            }
          } else if (custName.isNotEmpty) {
            if (checkWhere == 'MODONO') {
              String custNameTest = item['cust'] ?? '';
              if (custNameTest == custName) {
                if (mounted) {
                  setState(() {
                    custName = item['cust'] ?? '';
                    custNameController.text = custName;
                  });
                }
              } else if (returnStatusLovMoDoNo.isNotEmpty &&
                  returnStatusLovMoDoNo != 'null' &&
                  (returnStatusLovRefNo.isEmpty ||
                      returnStatusLovRefNo == 'null')) {
                if (mounted) {
                  setState(() {
                    custName = item['cust'] ?? '';
                    custNameController.text = custName;
                  });
                }
              } else {
                selectLovMoDoNo = '';
                returnStatusLovMoDoNo = '';
                moDoNoController.clear();
              }
            }
          }
          print('custName : $custName');
        } else {
          print('No items found.');
        }
      } else {
        print(
            'pMoDoNo in selectCust   else: $pMoDoNo type : ${pMoDoNo.runtimeType}');
        print(
            'selectCust   Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('2');
      print('Error: $e');
    }
  }

  Future<void> chkCust(
      String custCode, String arCode, int testChk, String checkWhere) async {
    print(
        '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_CheckCust/$custCode/$arCode');
    print('custCode  in chkCust  : $custCode type : ${custCode.runtimeType}');
    print('arCode  in chkCust  : $arCode type : ${arCode.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_CheckCust/$custCode/$arCode'));
      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataMessage = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataMessage : $dataMessage type : ${dataMessage.runtimeType}');
        if (mounted) {
          setState(() {
            pMessageErr = dataMessage['p_message_err'];
            print(
                'pMessageErr :: $pMessageErr  type :: ${pMessageErr.runtimeType}');
            if (pMessageErr.isNotEmpty) {
              if (checkWhere == 'MONODO') {
                if (mounted) {
                  setState(() {
                    selectLovMoDoNo = '';
                    returnStatusLovMoDoNo = '';
                    moDoNoController.clear();
                    isNextDisabled = false;
                  });
                  showDialogErrorCHK(context, pMessageErr);
                }
              } else if (checkWhere == 'REFNO') {
                if (mounted) {
                  setState(() {
                    selectLovRefNo = '';
                    returnStatusLovRefNo = '';
                    refNoController.clear();
                    isNextDisabled = false;
                  });
                  showDialogErrorCHK(context, pMessageErr);
                }
              }
            } else if (testChk == 1 && checkWhere == 'NEXT') {
              updateForm();
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('chkCust รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> changeRefNo(String soNoForChk, String checkWhere) async {
    try {
      final response = await http.get(Uri.parse(
          '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_ChangeRefNo/$soNoForChk'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          print('Fetched data: $jsonDecode');
          if (custName.isEmpty) {
            if (mounted) {
              setState(() {
                custName = item['ar_code_name'] ?? '';
                custNameController.text = custName;
              });
            }
          } else if (custName.isNotEmpty) {
            if (checkWhere == 'REFNO') {
              String custNameTest = item['ar_code_name'] ?? '';
              if (custNameTest == custName) {
                if (mounted) {
                  setState(() {
                    custName = item['ar_code_name'] ?? '';
                    custNameController.text = custName;
                  });
                }
              } else if (returnStatusLovRefNo.isNotEmpty &&
                  returnStatusLovRefNo != 'null' &&
                  (returnStatusLovMoDoNo.isEmpty ||
                      returnStatusLovMoDoNo == 'null')) {
                if (mounted) {
                  setState(() {
                    custName = item['ar_code_name'] ?? '';
                    custNameController.text = custName;
                  });
                }
              } else {
                selectLovRefNo = '';
                returnStatusLovRefNo = '';
                refNoController.clear();
              }
            }
          }
        } else {
          print('No items found.');
        }
      } else {
        print(
            'selectCust   Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('2');
      print('Error: $e');
    }
  }

  Future<void> updateForm() async {
    final url =
        '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_UpdateForm';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_erp_ou_code': globals.P_ERP_OU_CODE, // 000
      'p_doc_no': widget.pDocNo,
      'p_doc_type': widget.pDocType,
      'p_ref_no': returnStatusLovRefNo,
      'p_mo_do_no': returnStatusLovMoDoNo,
      'p_note': note.isEmpty ? 'null' : note,
      'p_app_user': globals.APP_USER,
      'p_doc_date': docDate,
    });
    print('Request body updateForm : $body');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataUpdateForm =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'dataUpdateForm : $dataUpdateForm type : ${dataUpdateForm.runtimeType}');
        updateStatus = dataUpdateForm['po_status'];
        updateMessage = dataUpdateForm['po_message'];
        refDocType = dataUpdateForm['v_ref_type'];
        refDocNo = dataUpdateForm['v_ref_doc_no'];
        if (updateStatus == '1') {
          print('updateStatus : $updateStatus');
          showDialogErrorCHK(context, updateMessage);
        } else if (updateStatus == '0') {
          if (mounted) {
            setState(() {
              submitData();
            });
          }
        }
      } else {
        print(
            'โพสต์ข้อมูลล้มเหลว(save data form). รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SaveDataForm: $e');
    }
  }

  Future<void> submitData() async {
    final url =
        '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_SubmitForm';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_erp_ou_code': globals.P_ERP_OU_CODE,
      'p_app_user': globals.APP_USER,
      'p_doc_no': widget.pDocNo,
      'p_doc_type': widget.pDocType,
      'p_ref_doc_type': refDocType.isEmpty ? 'null' : refDocType,
      'p_ref_doc_no': refDocNo.isEmpty ? 'null' : refDocNo,
      'p_ref_no': returnStatusLovRefNo,
      'p_mo_do_no': returnStatusLovMoDoNo
    });
    print('Request body submitData : $body');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataSubmit = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataSubmit : $dataSubmit type : ${dataSubmit.runtimeType}');
        if (mounted) {
          setState(() {
            statusSubmit = dataSubmit['po_status'];
            messageSubmit = dataSubmit['po_message'];

            if (statusSubmit == '1') {
              showDialogErrorCHK(context, messageSubmit);
              if (mounted) {
                setState(() {
                  isNextDisabled = false;
                });
              }
            }
            if (statusSubmit == '0') {
              checkUpdateData = false;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Ssfgdt31Grid(
                          pWareCode: widget.pWareCode,
                          docNo: widget.pDocNo,
                          docType: widget.pDocType,
                          docDate: docDate,
                          moDoNo: returnStatusLovMoDoNo,
                          refNo: returnStatusLovRefNo,
                          refDocNo: refDocNo,
                          refDocType: refDocType,
                        )),
              ).then((value) async {
                // Navigator.of(context).pop();
                await fetchData();
                await lovDocType();
                await lovMoDoNo();
                await lovRefNo();
                await lovCancel();
                checkUpdateData = false;
                isNextDisabled = false;
              });
            }

            print(
                'statusSubmit in Function submitData : $statusSubmit type : ${statusSubmit.runtimeType}');
            print(
                'messageSubmit in Function submitData : $messageSubmit type : ${messageSubmit.runtimeType}');
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print(
            'โพสต์ข้อมูลล้มเหลว submitData . รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in submit Data: $e');
    }
  }

  Future<void> deleteForm(String cancelCode) async {
    print('cancelCode : $cancelCode');
    final url =
        '${globals.IP_API}/apex/wms/SSFGDT31/SSFGDT31_Step_2_CancelForm';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'ou_code': globals.P_OU_CODE,
      'erp_ou_code': globals.P_ERP_OU_CODE,
      'doc_type': widget.pDocType,
      'doc_no': widget.pDocNo,
      'cancel_code': cancelCode,
      'app_code': globals.APP_USER,
    });
    print('Request body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataDelete =
            jsonDecode(utf8.decode(response.bodyBytes));
        print('dataDelete : $dataDelete type : ${dataDelete.runtimeType}');
        if (mounted) {
          setState(() {
            deleteStatus = dataDelete['po_status'];
            deleteMessage = dataDelete['po_message'];

            if (deleteStatus == '1') {
              showDialogErrorCHK(context, deleteMessage);
            }
            if (deleteStatus == '0') {
              if (mounted) {
                setState(() async {
                  showDialogErrorForDEL(context, deleteMessage);
                });
              }
            }
          });
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('ลบข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'รับคืนจากการเบิกเพื่อผลผลิต',
        showExitWarning: checkUpdateData,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isLoading
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialogLovCancel();
                        },
                        style: AppStyles.NextButtonStyle(),
                        child: Text('ยกเลิก',
                            style: AppStyles.CancelbuttonTextStyle()),
                      ),
                      ElevatedButtonStyle.nextpage(
                        onPressed: isNextDisabled
                            ? null
                            : () {
                                if (isDateInvalidNotifier.value == false &&
                                    docDate.isNotEmpty) {
                                  setState(() {
                                    isNextDisabled = true;
                                  });
                                  String checkWhere = 'NEXT';
                                  if (docNo.isNotEmpty &&
                                      docNo != '' &&
                                      docNo != 'null' &&
                                      returnStatusLovDocType.isNotEmpty &&
                                      returnStatusLovDocType != '' &&
                                      returnStatusLovDocType != 'null') {
                                    print(
                                        '*******************************************************************************');
                                    chkCust(
                                      returnStatusLovMoDoNo.isEmpty
                                          ? 'null'
                                          : returnStatusLovMoDoNo,
                                      returnStatusLovRefNo.isEmpty
                                          ? 'null'
                                          : returnStatusLovRefNo,
                                      testChk = 1,
                                      checkWhere,
                                    );
                                  }
                                } else {
                                  setState(() {
                                    isDateInvalidNotifier.value = true;
                                  });
                                }
                              },
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
            // -----------------------------
            Expanded(
              child: isLoading
                  ? Center(child: LoadingIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                                controller: docNoController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  label: RichText(
                                    text: const TextSpan(
                                      text: 'เลขที่ใบเบิก WMS',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          // -----------------------------

                          TextFormField(
                            controller: docTypeController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchDocType(),
                            minLines: 1,
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              label: RichText(
                                text: const TextSpan(
                                  text: 'ประเภทการจ่าย',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          // -----------------------------
                          CustomTextFormField(
                            controller: docDateController,
                            labelText: 'วันที่บันทึก',
                            keyboardType: TextInputType.number,
                            showAsterisk: true,
                            onChanged: (value) {
                              docDate = value;
                              print('วันที่ที่กรอก: $docDate');
                              if (docDate != docDateForCheck) {
                                checkUpdateData = true;
                              }
                            },
                            isDateInvalidNotifier: isDateInvalidNotifier,
                          ),
                          // TextFormField(
                          //   controller: docDateController,
                          //   keyboardType: TextInputType.number,
                          //   inputFormatters: [
                          //     FilteringTextInputFormatter.digitsOnly,
                          //     LengthLimitingTextInputFormatter(8),
                          //     dateInputFormatter,
                          //   ],
                          //   decoration: InputDecoration(
                          //     border: InputBorder.none,
                          //     filled: true,
                          //     fillColor: Colors.white,
                          //     labelText: 'วันที่ตรวจนับ',
                          //     hintText: 'DD/MM/YYYY',
                          //     hintStyle: TextStyle(color: Colors.grey),
                          //     labelStyle: isDateInvalid == true
                          //         ? const TextStyle(color: Colors.red)
                          //         : const TextStyle(color: Colors.black87),
                          //     suffixIcon: IconButton(
                          //       icon: const Icon(Icons.calendar_today),
                          //       onPressed: () async {
                          //         _selectDate(context);
                          //       },
                          //     ),
                          //   ),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       docDate = value;
                          //       isDateInvalid =
                          //           dateInputFormatter.noDateNotifier.value;
                          //       print('docDate : $docDate');
                          //       if (docDate != docDateForCheck) {
                          //         checkUpdateData = true;
                          //       }
                          //     });
                          //   },
                          // ),
                          // isDateInvalidNotifier == true
                          //     ? const Padding(
                          //         padding: EdgeInsets.only(top: 4.0),
                          //         child: Text(
                          //           'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                          //           style: TextStyle(
                          //             color: Colors.red,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 12,
                          //           ),
                          //         ))
                          //     : const SizedBox.shrink(),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: refNoController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchRefNo(),
                            minLines: 1,
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'เลขที่เอกสารอ้างอิง',
                              labelStyle: TextStyle(
                                color: Colors.black87,
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: moDoNoController,
                            readOnly: true,
                            onTap: () => showDialogDropdownSearchMoDoNo(),
                            minLines: 1,
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              label: Text(
                                'เลขที่คำสั่งผลผลิต',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // -----------------------------
                          GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: custNameController,
                                readOnly: true,
                                minLines: 1,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelText: 'ลูกค้า',
                                  labelStyle: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (custName != custNameForCheck) {
                                    checkUpdateData = true;
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // -----------------------------
                          TextFormField(
                            controller: noteController,
                            minLines: 1,
                            maxLines: 5,
                            // readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'หมายเหตุ',
                              labelStyle: const TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            onChanged: (value) => {
                              setState(() {
                                note = value;
                                if (note != noteForCheck) {
                                  checkUpdateData = true;
                                }
                              }),
                            },
                          ),
                          const SizedBox(height: 8),
                          // -----------------------------
                          GestureDetector(
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: erpDocNoController,
                                readOnly: true,
                                minLines: 1,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelText: 'เลขที่เอกสาร ERP',
                                  labelStyle: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (erpDocNo != erpDocNoForCheck) {
                                    checkUpdateData = true;
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: checkUpdateData == true ? 'show' : 'not_show',
      ),
    );
  }

  void showDialogLovCancel() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.cancelDialog(
          context: context,
          onCloseDialog: () {
            Navigator.of(context).pop();
            setState(() {
              selectLovCancel = '';
              returnStatusLovCancel = '';
              cancelController.text = '';
            });
          },
          onConfirmDialog: () {
            setState(() {
              deleteForm(returnStatusLovCancel);
            });
          },
          onTap: () => showDialogDropdownSearchCancel(),
          controller: cancelController,
        );
      },
    );
  }

  void showDialogErrorCHK(
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

  Future<void> showDialogErrorForDEL(
    BuildContext context,
    String messageAlert,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(messageAlert),
          onClose: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          onConfirm: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showDialogDropdownSearchMoDoNo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลขที่คำสั่งผลผลิต',
          searchController: _searchController1,
          data: dataLovMoDoNo,
          docString: (item) =>
              '${item['schid'] ?? '--No Value Set--'} ${item['fg_code'] ?? ''} ${item['cust_name'] ?? ''}',
          titleText: (item) => '${item['schid'] ?? '--No Value Set--'}',
          subtitleText: (item) =>
              '${item['cust_name'] ?? ''}' == '--No Value Set--'
                  ? ''
                  : '${item['cust_name'] ?? ''}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              String checkWhere = 'MODONO';
              String dataCHK = '${item['schid'] ?? ''}';
              selectLovMoDoNo = '${item['schid'] ?? '--No Value Set--'}';
              returnStatusLovMoDoNo = '${item['schid'] ?? 'null'}';
              moDoNoController.text = selectLovMoDoNo.toString();
              shidForChk =
                  '${item['schid']}' == '' ? 'null' : '${item['schid']}';
              if (returnStatusLovMoDoNo.isNotEmpty &&
                  returnStatusLovMoDoNo != 'null') {
                // Select ชื่อลูกค้า
                print(
                    'IIIYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY');
                selectCust(returnStatusLovMoDoNo, checkWhere);
              }

              if (dataCHK != returnStatusLovMoDoNoForCheck) {
                checkUpdateData = true;
              } else {
                print('returnStatusLovMoDoNo : '
                    '$returnStatusLovMoDoNo'
                    'returnStatusLovMoDoNoForCheck : '
                    '$returnStatusLovMoDoNoForCheck');
              }
              if (selectLovMoDoNo == '--No Value Set--' &&
                  selectLovRefNo == '--No Value Set--') {
                custName = '';
                custNameController.clear();
              }
              print(
                  'returnStatusLovMoDoNo New: $returnStatusLovMoDoNo Type : ${returnStatusLovMoDoNo.runtimeType}');
              print(
                  'selectLovMoDoNo New: $selectLovMoDoNo Type : ${selectLovMoDoNo.runtimeType}');
              print(
                  'moDoNoController New: $moDoNoController Type : ${moDoNoController.runtimeType}');

              print('shidForChk : $shidForChk');
              print(
                  'returnStatusLovMoDoNoForCheck : $returnStatusLovMoDoNoForCheck');
              print(' checkUpdateData : $checkUpdateData');
              if ((returnStatusLovMoDoNo.isNotEmpty &&
                      returnStatusLovMoDoNo != 'null') &&
                  (returnStatusLovRefNo.isNotEmpty &&
                      returnStatusLovRefNo != 'null')) {
                chkCust(
                  returnStatusLovMoDoNo,
                  returnStatusLovRefNo,
                  testChk = 0,
                  checkWhere,
                );
              }
            });
          },
        );
      },
    );
  }

  void showDialogDropdownSearchRefNo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลขที่เอกสารอ้างอิง',
          searchController: _searchController2,
          data: dataLovRefNo,
          docString: (item) =>
              '${item['doc_no'] ?? '--No Value Set--'} ${item['document_remark'] ?? ''}',
          titleText: (item) => '${item['doc_no'] ?? '--No Value Set--'}',
          subtitleText: (item) => '${item['document_remark'] ?? ''}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              String checkWhere = 'REFNO';
              String dataCHK = '${item['doc_no'] ?? ''}';
              selectLovRefNo = '${item['doc_no'] ?? '--No Value Set--'}';
              returnStatusLovRefNo = '${item['doc_no'] ?? 'null'}';
              refNoController.text = selectLovRefNo.toString();

              if (dataCHK != returnStatusLovRefNoForCheck) {
                checkUpdateData = true;
              }

              if (selectLovMoDoNo == '--No Value Set--' &&
                  selectLovRefNo == '--No Value Set--') {
                custName = '';
                custNameController.clear();
              }
              print(
                  'returnStatusLovRefNo New: $returnStatusLovRefNo Type : ${returnStatusLovRefNo.runtimeType}');
              print(
                  'selectLovRefNo New: $selectLovRefNo Type : ${selectLovRefNo.runtimeType}');
              print(
                  'refNoController New: $refNoController Type : ${refNoController.runtimeType}');
              if (returnStatusLovRefNo.isNotEmpty &&
                  returnStatusLovRefNo != 'null') {
                changeRefNo(returnStatusLovRefNo, checkWhere);
              }
              if ((returnStatusLovMoDoNo.isNotEmpty &&
                      returnStatusLovMoDoNo != 'null') &&
                  (returnStatusLovRefNo.isNotEmpty &&
                      returnStatusLovRefNo != 'null')) {
                chkCust(
                  returnStatusLovMoDoNo,
                  returnStatusLovRefNo,
                  testChk = 0,
                  checkWhere,
                );
              }
            });
          },
        );
      },
    );
  }

  void showDialogDropdownSearchDocType() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customRequiredLovSearchDialog(
          context: context,
          headerText: 'ประเภทการจ่าย',
          searchController: _searchController3,
          data: dataLovDocType,
          docString: (item) => '${item['r']} ${item['d']}',
          titleText: (item) => '${item['r']}',
          subtitleText: (item) => '${item['d'] ?? ''}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              String dataCHK = '${item['d']}';
              selectLovDocType = '${item['d']}';
              docTypeController.text = '${item['d']}';
              returnStatusLovDocType = '${item['r']}';

              if (dataCHK != returnStatusLovDocTypeForCheck) {
                checkUpdateData = true;
              }
            });
            print(
                'dataLovDocType in body: $dataLovDocType type: ${dataLovDocType.runtimeType}');
            // print(selectedItem);
            print(
                'returnStatusLovDocType in body: $returnStatusLovDocType type: ${returnStatusLovDocType.runtimeType}');
          },
        );
      },
    );
  }

  void showDialogDropdownSearchCancel() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'สาเหตุการยกเลิก',
          searchController: _searchController4,
          data: dataLovCancel,
          docString: (item) => '${item['d']}',
          titleText: (item) => '${item['r']}',
          subtitleText: (item) => '${item['cancel_desc']}',
          onTap: (item) {
            Navigator.of(context).pop();
            setState(() {
              selectLovCancel = '${item['d']}';
              cancelController.text = selectLovCancel.toString();
              returnStatusLovCancel = '${item['r']}';

              //  if(returnStatusLovCancel != returnStatusLovCancelForCheck) {
              // checkUpdateData = true;
              // }
            });
            print(
                'dataLovCancel in body: $dataLovCancel type: ${dataLovCancel.runtimeType}');
            // print(selectedItem);
            print(
                'returnStatusLovCancel in body: $returnStatusLovCancel type: ${returnStatusLovCancel.runtimeType}');
          },
        );
      },
    );
  }
}
