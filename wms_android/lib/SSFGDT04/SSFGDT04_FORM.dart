import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGDT04_GRID.dart';
import 'SSFGDT04_MENU.dart';
import '../styles.dart';
import '../loading.dart';
import '../TextFormFieldCheckDate.dart';
import '../Global_API.dart' as api;

class SSFGDT04_FORM extends StatefulWidget {
  // final String pReceiveNo; // ware code ที่มาจากเลือ lov
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String? po_doc_no;
  final String? po_doc_type;

  SSFGDT04_FORM({
    Key? key,
    // required this.pReceiveNo,
    required this.pWareCode,
    required this.po_doc_no,
    required this.po_doc_type,
  }) : super(key: key);

  @override
  _SSFGDT04_FORMState createState() => _SSFGDT04_FORMState();
}

class _SSFGDT04_FORMState extends State<SSFGDT04_FORM> {
  List<Map<String, dynamic>> fromItems = [];
  List<Map<String, dynamic>> docTypeItems = [];
  List<Map<String, dynamic>> saffCodeItems = [];
  List<Map<String, dynamic>> refReceiveItems = [];
  List<Map<String, dynamic>> refNoItems = [];
  List<Map<String, dynamic>> cancelItems = [];
  List<Map<String, dynamic>> changeRefReceive = [];
  String? selectedDocType;
  String? selectedSaffCode;
  String? selectedRefReceive;
  String? selectedRefNo;
  String? selectedCancelCode;
  String? selectedValue;
  String? p_ref_no;
  String? mo_do_no;
  String? poStatus;
  String? poMessage;
  String? po_doc_no;
  String selectedDate = '';
  String selectedCancelDescription = '';

  TextEditingController _docNoController = TextEditingController();
  String docNo = '';

  TextEditingController _docTypeController = TextEditingController();
  String docType = '';

  TextEditingController _docDateController = TextEditingController();
  String docDate = '';

  TextEditingController _refReceiveController =
      TextEditingController(); // REF_RECEIVE
  String refReceive = '';

  TextEditingController _refNoController = TextEditingController();
  String refNo = '';

  TextEditingController _oderNoController = TextEditingController(); // order_no
  String oder = '';

  TextEditingController _moDoNoController = TextEditingController(); // mo_do_no
  String moDoNo = '';

  TextEditingController _staffCodeController =
      TextEditingController(); // staff_code
  String staffCode = '';

  TextEditingController _noteController = TextEditingController();
  String note = '';

  TextEditingController _erpDocNoController = TextEditingController();
  String erpDocNo = '';

  TextEditingController _custController = TextEditingController();
  String cust = '';

  TextEditingController _searchController =
      TextEditingController(); // เพิ่ม Controller สำหรับการค้นหา
  TextEditingController _canCelController = TextEditingController();

  // เพิ่ม DateFormat สำหรับฟอร์แมทวันที่
  final DateFormat _dateTimeFormatter = DateFormat('dd/MM/yyyy');
  // Regular expression to validate dd/MM/yyyy format
  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);

  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false;
  bool chkDate = false;
  bool checkUpdateData = false;
  bool isDialogShowing = false;
  bool isDateInvalid = false;
  bool isNextDisabled = false;
  bool isNavigating = false;
  final dateInputFormatter = DateInputFormatter();

  bool check = false;
  void checkIfHasData() {
    setState(() {
      if (_docNoController.text.isNotEmpty ||
          _docDateController.text.isNotEmpty ||
          _refReceiveController.text.isNotEmpty ||
          _refNoController.text.isNotEmpty ||
          _oderNoController.text.isNotEmpty ||
          _moDoNoController.text.isNotEmpty ||
          _staffCodeController.text.isNotEmpty ||
          _noteController.text.isNotEmpty ||
          _erpDocNoController.text.isNotEmpty ||
          _custController.text.isNotEmpty ||
          _searchController.text.isNotEmpty ||
          _canCelController.text.isNotEmpty) {
        check = true;
        print(check);
      } else {
        check = false;
        print(check);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFromItems();
    fetchDocTypeItems();
    fetchSaffCodeItems();
    fetchRefReceiveItems();
    fetchRefNoItems();
    fetchCancelItems();
  }

  Future<void> fetchFromItems() async {
    print('Fetching form data...');
    print(
        'po_doc_type จ้าาา : ${widget.po_doc_type} Type : ${widget.po_doc_type.runtimeType}');
    print(
        'po_doc_no จ้าาา: ${widget.po_doc_no} : ${widget.po_doc_no.runtimeType}');

    try {
      final response = await http.get(Uri.parse(
        '${gb.IP_API}/apex/wms/SSFGDT04/Step_2_form/${gb.P_ERP_OU_CODE}/${widget.po_doc_type}/${widget.po_doc_no}',
      ));
      print(Uri.parse(
        '${gb.IP_API}/apex/wms/SSFGDT04/Step_2_form/${gb.P_ERP_OU_CODE}/${widget.po_doc_type}/${widget.po_doc_no}',
      ));
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);

        if (mounted) {
          setState(() {
            fromItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
            if (fromItems.isNotEmpty) {
              _docNoController.text = fromItems[0]['doc_no'] ?? '';
              docNo = fromItems[0]['doc_no'] ?? '';

              // ตรวจสอบและกำหนดค่าให้ _docDateController
              if (fromItems[0]['cr_date'] != null &&
                  fromItems[0]['cr_date'].isNotEmpty) {
                DateTime parsedDate = DateTime.parse(fromItems[0]['cr_date']);
                _docDateController.text = _dateTimeFormatter.format(parsedDate);
                docDate = fromItems[0]['cr_date'] ?? '';
              }

              _refReceiveController.text =
                  fromItems[0]['ref_receive'] ?? ''; // REF_RECEIVE
              refReceive = fromItems[0]['ref_receive'] ?? '';

              _refNoController.text = fromItems[0]['ref_no'] ?? ''; // REF_NO
              refNo = fromItems[0]['ref_no'] ?? '';

              _oderNoController.text =
                  fromItems[0]['order_no'] ?? ''; // order_no
              oder = fromItems[0]['order_no'] ?? '';

              _moDoNoController.text =
                  fromItems[0]['mo_do_no'] ?? ''; // mo_do_no
              moDoNo = fromItems[0]['mo_do_no'] ?? '';

              _staffCodeController.text =
                  fromItems[0]['staff_code'] ?? ''; // staff_code
              staffCode = fromItems[0]['staff_code'] ?? '';

              _noteController.text = fromItems[0]['note'] ?? '';
              note = fromItems[0]['note'] ?? '';

              _erpDocNoController.text = fromItems[0]['erp_doc_no'] ?? '';
              erpDocNo = fromItems[0]['erp_doc_no'] ?? '';
            }
          });
        }
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to load form data.');
      }
    } catch (e) {
      print('Error occurred while fetching form data: $e');
      throw Exception('Failed to load form data.');
    }
  }

  Future<void> fetchDocTypeItems() async {
    final response = await http.get(
        Uri.parse('${gb.IP_API}/apex/wms/SSFGDT04/Step_2_TYPE/${gb.ATTR1}'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      if (mounted) {
        setState(() {
          docTypeItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
          if (docTypeItems.isNotEmpty) {
            selectedDocType = docTypeItems[0]['doc_desc'];
            _docTypeController.text =
                docTypeItems[0]['doc_desc']; // Default selection
          }
        });
      }
    } else {
      throw Exception('Failed to load DOC_TYPE items');
    }
  }

  Future<void> fetchSaffCodeItems() async {
    final response = await http.get(Uri.parse(
        '${gb.IP_API}/apex/wms/SSFGDT04/Step_2_STAFF_CODE/${gb.P_ERP_OU_CODE}/${gb.BROWSER_LANGUAGE}'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      if (mounted) {
        setState(() {
          saffCodeItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        });
      }
    } else {
      throw Exception('Failed to load STAFF_CODE items');
    }
  }

  Future<void> fetchRefReceiveItems() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT04/Step_2_REFRECEIVE/${gb.ATTR1}/${widget.pWareCode}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);

        if (mounted) {
          // ตรวจสอบว่า widget ยังคงอยู่ใน tree
          setState(() {
            refReceiveItems =
                List<Map<String, dynamic>>.from(data['items'] ?? []);
          });
        }
      } else {
        throw Exception('Failed to load REFRECEIVE items');
      }
    } catch (e) {
      // จัดการกับข้อผิดพลาด
      print('Error fetching REFRECEIVE items: $e');
    }
  }

  Future<void> fetchRefNoItems() async {
    final response = await http
        .get(Uri.parse('${gb.IP_API}/apex/wms/SSFGDT04/Step_2_REF_NO'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      if (mounted) {
        setState(() {
          refNoItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        });
      }
    } else {
      throw Exception('Failed to load REFNO items');
    }
  }

  Future<void> fetchCancelItems() async {
    final response = await http
        .get(Uri.parse('${gb.IP_API}/apex/wms/SSFGDT04/Step_2_CANCEL'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      if (mounted) {
        setState(() {
          cancelItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        });
      }
    } else {
      throw Exception('Failed to load CANCEL items');
    }
  }

  Future<void> save_INHeadNonePO_WMS(String? po_doc_no) async {
    final url =
        '${gb.IP_API}/apex/wms/SSFGDT04/Step_2_validateSave_INHeadNonePO_WMS';

    final headers = {
      'Content-Type': 'application/json',
    };
    print(po_doc_no);
    print(gb.P_OU_CODE);
    print(gb.P_ERP_OU_CODE);
    print(gb.APP_USER);

    final body = jsonEncode({
      'V_DOC_NO': po_doc_no,
      'APP_USER': gb.APP_USER,
      'P_OU_CODE': gb.P_OU_CODE,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
    });

    print('headers : $headers Type : ${headers.runtimeType}');
    print('body : $body Type : ${body.runtimeType}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            po_doc_no = responseData['po_doc_no'];
            poStatus = responseData['po_status'];
            poMessage = responseData['po_message'];

            print('po_doc_no : $po_doc_no Type : ${po_doc_no.runtimeType}');
            print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
            print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
          });
        }
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> update(
    String? po_doc_type,
    String? po_doc_no,
  ) async {
    print(
        'update called with po_doc_type: $po_doc_type, po_doc_no: $po_doc_no');
    final url = Uri.parse('${gb.IP_API}/apex/wms/SSFGDT04/Step_2_wms_ith');
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'P_WARE_CODE': gb.P_WARE_CODE,
          'P_OU_CODE': gb.P_ERP_OU_CODE,
          'P_REF_RECEIVE': selectedRefReceive,
          'P_ORDER_NO': _oderNoController.text,
          'P_MO_DO_NO': _moDoNoController.text,
          'P_STAFF_CODE': _staffCodeController.text,
          'P_NOTE': _noteController.text,
          'APP_USER': gb.APP_USER,
          'P_DOC_NO': po_doc_no,
          'P_ATTR1': gb.ATTR1,
          'P_DOC_TYPE': po_doc_type,
        }));

    print('Navigating to SSFGDT04_GRID with:');
    print('REF_RECEIVE: ${selectedRefReceive}');
    print('ORDER_NO: ${_oderNoController.text}');
    print('MO_DO_NO: ${_moDoNoController.text}');
    print('STAFF_CODE: ${_staffCodeController.text}');
    print('P_DOC_NO: ${widget.po_doc_no}');
    print('P_DOC_TYPE: ${widget.po_doc_type}');
    print('pWareCode: ${widget.pWareCode}');
    print('ref_no: ${selectedRefReceive}');

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  String? po_status;
  String? po_message;
  Future<void> cancel_INHeadNonePO_WMS(
    String selectedCancelCode,
  ) async {
    final url = Uri.parse(
        '${gb.IP_API}/apex/wms/SSFGDT04/Step_2_cancel_INHeadNonePO_WMS');
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'P_OU_CODE': gb.P_OU_CODE,
          'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
          'p_doc_type': widget.po_doc_type,
          'p_doc_no': widget.po_doc_no,
          'p_cancel_code': selectedCancelCode,
          'APP_USER': gb.APP_USER,
        }));

    print('Navigating to SSFGDT04_GRID with:');
    print('po_doc_no: ${widget.po_doc_no}');
    print('po_doc_type: ${widget.po_doc_type}');
    print('pWareCode: $selectedCancelCode');
    print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
    print('poMessage : $poMessage Type : ${poMessage.runtimeType}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        po_status = responseData['po_status'] ?? '';
        po_message = responseData['po_message'] ?? '';
        print('po_status: $po_status');
        print('po_message: $po_message');
      } catch (e) {
        print('Error parsing response: $e');
      }
    } else {
      print('Failed to cancel: ${response.statusCode}');
    }
  }

  Future<void> changeRefReceiveItems(
      String? oder, String? moDoNo, String? note, String? refReceive) async {
    List<dynamic> get_ref_rec =
        await api.apiget2('SSFGDT04/Step_2_CHANGE_REF_RECEIVE', {
      'P_ATTR1': gb.ATTR1,
      'P_WARE_CODE': widget.pWareCode,
      'P_REF_RECEIVE': refReceive
    });
    setState(() {
      _moDoNoController.text = get_ref_rec[0]['P_MO_DO_NO'] ?? '';
      _oderNoController.text = get_ref_rec[0]['P_ORDER_NO'] ?? '';
      _noteController.text = get_ref_rec[0]['P_NOTE'] ?? '';
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      String formattedDate = new DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          isDateInvalid = false;
          _docDateController.text = formattedDate;
          docDate = _docDateController.text;
        });
      }
    }
  }

  @override
  void dispose() {
    // เรียกใช้ dispose() บน TextEditingController โดยตรง
    _docNoController.dispose();
    _docDateController.dispose();
    _refReceiveController.dispose();
    _refNoController.dispose();
    _oderNoController.dispose();
    _moDoNoController.dispose();
    _staffCodeController.dispose();
    _noteController.dispose();
    _erpDocNoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'รับตรง (ไม่อ้าง PO)',
        showExitWarning: checkUpdateData,
      ),
      body: fromItems.isEmpty
          ? Center(child: LoadingIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ปุ่ม ถัดไป และ ยกเลิก (ส่วนด้านบน)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ปุ่ม ยกเลิก //
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogStyles.cancelDialog(
                                  context: context,
                                  controller: _canCelController,
                                  onCloseDialog: () {
                                    Navigator.of(context).pop();
                                  },
                                  // onTap: searchDialog, // Open search dialog
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogStyles
                                            .customLovSearchDialog(
                                          context: context,
                                          headerText:
                                              'เลือกสาเหตุการยกเลิก', // Set header text
                                          searchController:
                                              _searchController, // Pass search controller
                                          data:
                                              cancelItems, // Pass the list of items
                                          docString: (item) {
                                            // Define how to extract search text from each item
                                            final code = item['cancel_code']
                                                    ?.toString() ??
                                                '';
                                            final desc = item['cancel_desc']
                                                    ?.toString() ??
                                                '';
                                            return '$code $desc';
                                          },
                                          titleText: (item) =>
                                              item['cancel_code']?.toString() ??
                                              'No code',
                                          subtitleText: (item) =>
                                              item['cancel_desc']?.toString() ??
                                              'No description',
                                          onTap: (item) {
                                            final code = item['cancel_code']
                                                    ?.toString() ??
                                                '';
                                            final desc = item['cancel_desc']
                                                    ?.toString() ??
                                                '';
                                            Navigator.of(context)
                                                .pop(); // Close dialog
                                            setState(() {
                                              selectedCancelCode = code;
                                              selectedCancelDescription =
                                                  '$code $desc';
                                              _canCelController.text =
                                                  selectedCancelDescription;
                                              fetchSaffCodeItems();
                                              print('$selectedCancelCode');
                                            });
                                          },
                                        );
                                      },
                                    ).then((_) {
                                      // Clear search controller when popup is closed
                                      _searchController.clear();
                                    });
                                  },
                                  onConfirmDialog: () async {
                                    if (isDialogShowing) return;

                                    setState(() {
                                      isDialogShowing =
                                          true; // Set flag to true when a dialog is about to be shown
                                    });
                                    await cancel_INHeadNonePO_WMS(
                                        selectedCancelCode ?? '');
                                    if (selectedCancelCode == null) {
                                      setState(() {
                                        isDialogShowing =
                                            false; // Reset the flag when the first dialog is closed
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogStyles
                                              .alertMessageDialog(
                                            context: context,
                                            content: Text('$po_message'),
                                            onClose: () {
                                              Navigator.of(context).pop();
                                            },
                                            onConfirm: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogStyles
                                              .alertMessageDialog(
                                            context: context,
                                            content: Text(
                                                'ยกเลิกรายการเสร็จสมบูรณ์'),
                                            onClose: () async {
                                              await cancel_INHeadNonePO_WMS(
                                                      selectedCancelCode!)
                                                  .then((_) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SSFGDT04_MENU(
                                                      pWareCode: gb.P_WARE_CODE,
                                                      pErpOuCode:
                                                          gb.P_ERP_OU_CODE,
                                                    ),
                                                  ),
                                                );
                                                Navigator.of(context).pop();
                                              }).catchError((error) {});
                                            },
                                            onConfirm: () async {
                                              await cancel_INHeadNonePO_WMS(
                                                      selectedCancelCode!)
                                                  .then((_) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SSFGDT04_MENU(
                                                      pWareCode: gb.P_WARE_CODE,
                                                      pErpOuCode:
                                                          gb.P_ERP_OU_CODE,
                                                    ),
                                                  ),
                                                );
                                                Navigator.of(context).pop();
                                              }).catchError((error) {
                                              });
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            ).then((_) {
                              // ลบค่าที่ค้นหาเมื่อ popup ถูกปิด ไม่ว่าจะกดไอคอนหรือกดที่อื่น
                              _canCelController.clear();
                            });
                          },
                          child: const Text(
                            'ยกเลิก',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: AppStyles.cancelButtonStyle(),
                        ),

                        // const SizedBox(width: 10), // ระยะห่างระหว่างปุ่ม
                        // ปุ่ม ถัดไป //
                        ElevatedButtonStyle.nextpage(
                          onPressed: isDateInvalid
                              ? null // ปิดปุ่มหากวันที่ไม่ถูกต้อง
                              : () async {
                                  if (_docDateController.text.isEmpty ||
                                      isDateInvalidNotifier.value) {
                                    isDateInvalidNotifier.value =
                                        true; // แสดงข้อความแจ้งเตือน
                                    return;
                                  }

                                  if (isNavigating)
                                    return; // ป้องกันการนำทางซ้ำ

                                  setState(() {
                                    isNextDisabled = true;
                                    isNavigating = true;
                                  });

                                  try {
                                    await update(
                                        widget.po_doc_type, widget.po_doc_no);
                                    await save_INHeadNonePO_WMS(
                                        selectedValue ?? widget.po_doc_no);
                                    checkUpdateData = false;

                                    if (poStatus == '0') {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SSFGDT04_GRID(
                                            po_doc_no: widget.po_doc_no,
                                            po_doc_type: widget.po_doc_type,
                                            pWareCode: widget.pWareCode,
                                            p_ref_no: _refNoController.text,
                                            mo_do_no: _moDoNoController.text,
                                          ),
                                        ),
                                      ).then((_) {
                                        setState(
                                            () {}); // รีเฟรชสถานะเมื่อกลับมาจากหน้าใหม่
                                      });
                                    } else if (poStatus == '1') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogStyles
                                              .alertMessageDialog(
                                            context: context,
                                            content: Text('$poMessage'),
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
                                  } finally {
                                    setState(() {
                                      isNextDisabled = false;
                                      isNavigating =
                                          false; // ปิดสถานะกำลังนำทาง
                                    });
                                  }
                                },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // เลขที่ใบเบิก WMS* //
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: AbsorbPointer(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                // labelText: 'เลขที่เอกสาร WMS*',
                                label: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'เลขที่เอกสาร WMS',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                16), // Color for the label
                                      ),
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight
                                                .bold), // Color for the asterisk
                                      ),
                                    ],
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey[300],
                                labelStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                              ),
                              controller: _docNoController,
                              onChanged: (value) => {
                                setState(() {
                                  docNo = value;
                                  if (docNo != _docNoController) {
                                    checkUpdateData = true;
                                  }
                                }),
                              },
                            ),
                            ),
                          ),

                          //ประเภทการรับ*//
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogStyles
                                        .customRequiredLovSearchDialog(
                                      context: context,
                                      headerText: 'ประเภทการรับ',
                                      searchController: _searchController,
                                      data: docTypeItems,
                                      docString: (item) =>
                                          '${item['doc_type']} ${item['doc_desc']}',
                                      titleText: (item) =>
                                          '${item['doc_type']}',
                                      subtitleText: (item) =>
                                          '${item['doc_desc'] ?? ''}',
                                      onTap: (item) {
                                        final doc = '${item['doc_desc']}';

                                        Navigator.of(context).pop();
                                        setState(() {
                                          String docType =
                                              _docTypeController.text;
                                          selectedDocType = doc;
                                          _docTypeController.text =
                                              selectedDocType ?? '';
                                          fetchRefReceiveItems();
                                          if (selectedDocType != docType) {
                                            checkUpdateData = true;
                                          }
                                        });
                                      },
                                    );
                                  },
                                ).then((_) {
                                  _searchController
                                      .clear(); // Clear search field when popup is closed
                                });
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  decoration: InputDecoration(
                                    // labelText: 'ประเภทการรับ',
                                    label: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'ประเภทการรับ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    16), // Color for the label
                                          ),
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight
                                                    .bold), // Color for the asterisk
                                          ),
                                        ],
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Color.fromARGB(255, 113, 113, 113),
                                    ),
                                  ),
                                  controller: _docTypeController,
                                  onChanged: (value) => {
                                    setState(() {
                                      docType = value;
                                      if (docType != _docTypeController) {
                                        checkUpdateData = true;
                                      }
                                    }),
                                  },
                                ),
                              ),
                            ),
                          ),

                          // วันที่บันทึก //
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomTextFormField(
                                  controller: _docDateController,
                                  labelText: 'วันที่บันทึก',
                                  keyboardType: TextInputType.number,
                                  showAsterisk: true,
                                  onChanged: (value) {
                                    docDate = value;
                                    print('วันที่ที่กรอก: $docDate');
                                    if (docDate != _selectDate) {
                                      checkUpdateData = true;
                                    }
                                  },
                                  isDateInvalidNotifier: isDateInvalidNotifier,
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogStyles.customLovSearchDialog(
                                      context: context,
                                      headerText:
                                          'อ้างอิงใบนำส่งเลขที่', // Title of the dialog
                                      searchController: _searchController,
                                      data: refReceiveItems,
                                      docString: (item) =>
                                          item['doc'].toString(),
                                      titleText: (item) =>
                                          item['doc']?.toString() ?? 'No code',
                                      subtitleText: (item) =>
                                          '', // Optional: Add more details if needed
                                      onTap: (item) async {
                                        final doc = item['doc'].toString();
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        setState(() {
                                          String refReceive =
                                              _refReceiveController.text;
                                          selectedRefReceive = doc;
                                          _refReceiveController.text =
                                              selectedRefReceive ?? '';
                                          fetchRefReceiveItems();
                                          if (selectedRefReceive !=
                                              refReceive) {
                                            checkUpdateData = true;
                                          }
                                        });

                                        // Fetch additional data and make the API call
                                        await changeRefReceiveItems(
                                          oder,
                                          moDoNo,
                                          note,
                                          selectedRefReceive,
                                        );
                                      },
                                    );
                                  },
                                ).then((_) {
                                  // Clear the searchController when the dialog is closed
                                  _searchController.clear();
                                });
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'อ้างอิงใบนำส่งเลขที่',
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Color.fromARGB(255, 113, 113, 113),
                                    ),
                                  ),
                                  controller: _refReceiveController,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogStyles.customLovSearchDialog(
                                      context: context,
                                      headerText:
                                          'อ้างอิง SO', // Customize the header text
                                      searchController: _searchController,
                                      data:
                                          refNoItems, // List of items to search
                                      docString: (item) => item['so_no']
                                          .toString(), // Customize the docString function
                                      titleText: (item) => item['so_no']
                                          .toString(), // Customize the title text
                                      subtitleText: (item) =>
                                          '${item['so_date_disp']} ${item['so_remark']}', // Customize subtitle text
                                      onTap: (item) {
                                        // Handle item selection
                                        final soNo = '${item['so_no'] ?? ''}';
                                        Navigator.of(context).pop();
                                        setState(() {
                                          String refNo = _refNoController.text;
                                          selectedRefNo = soNo;
                                          _refNoController.text =
                                              selectedSaffCode ?? '';
                                          fetchSaffCodeItems();
                                          if (selectedRefNo != refNo) {
                                            checkUpdateData = true;
                                          }
                                        });
                                      },
                                    );
                                  },
                                ).then((_) {
                                  // Clear the search field after the dialog is closed
                                  _searchController.clear();
                                });
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'อ้างอิง SO',
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: InputBorder.none,
                                      suffixIcon: Icon(
                                        Icons.arrow_drop_down,
                                        color:
                                            Color.fromARGB(255, 113, 113, 113),
                                      ),
                                    ),
                                    controller: _refNoController),
                              ),
                            ),
                          ),

                          // เลขที่คำสั่งผลผลิต //
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'เลขที่คำสั่งผลผลิต',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                              ),
                              controller: _moDoNoController,
                              onChanged: (value) => {
                                setState(() {
                                  moDoNo = value;
                                  if (moDoNo != _moDoNoController) {
                                    checkUpdateData = true;
                                  }
                                }),
                              },
                            ),
                          ),

                          // ผู้รับมอบสินค้า //
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogStyles
                                        .customRequiredLovSearchDialog(
                                      context: context,
                                      headerText: 'ผู้รับมอบสินค้า',
                                      searchController: _searchController,
                                      data: saffCodeItems,
                                      docString: (item) =>
                                          '${item['emp_id'] ?? ''} ${item['emp_name'] ?? ''}',
                                      titleText: (item) =>
                                          '${item['emp_id'] ?? ''}',
                                      subtitleText: (item) =>
                                          '${item['emp_name'] ?? ''}',
                                      onTap: (item) {
                                        // final empId = '${item['emp_id'] ?? ''}';
                                        final empName = '${item['emp_name'] ?? ''}';
                                        Navigator.of(context).pop();
                                        setState(() {
                                          String staffCode =
                                              _staffCodeController.text;
                                          // selectedSaffCode = empId;
                                          selectedSaffCode = empName;
                                          _staffCodeController.text =
                                              selectedSaffCode ?? '';
                                          fetchSaffCodeItems();
                                          if (selectedSaffCode != staffCode) {
                                            checkUpdateData = true;
                                          }
                                        });
                                      },
                                    );
                                  },
                                ).then((_) {
                                  // ลบค่าที่ค้นหาเมื่อ popup ถูกปิด ไม่ว่าจะกดไอคอนหรือกดที่อื่น
                                  _searchController.clear();
                                });
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(color: Colors.black),
                                    label: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'ผู้รับมอบสินค้า',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    16), // Color for the label
                                          ),
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight
                                                    .bold), // Color for the asterisk
                                          ),
                                        ],
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Color.fromARGB(255, 113, 113, 113),
                                    ),
                                  ),
                                  controller:
                                      _staffCodeController.text.isNotEmpty
                                          ? _staffCodeController
                                          : TextEditingController(
                                              text: selectedSaffCode),
                                ),
                              ),
                            ),
                          ),

                          // หมายเหตุ //
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: TextField(
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'หมายเหตุ',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                // floatingLabelBehavior: FloatingLabelBehavior.always, // บังคับให้ label อยู่ขอบบนเสมอ
                              ),
                              controller: _noteController,
                              onChanged: (value) {
                                setState(() {
                                  note = value;
                                  if (note != _noteController) {
                                    checkUpdateData = true;
                                  }
                                });
                              },
                            ),
                          ),

                          // เลขที่เอกสาร ERP //
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: AbsorbPointer(
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'เลขที่เอกสาร ERP',
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: InputBorder.none,
                                ),
                                controller: _erpDocNoController,
                                onChanged: (value) => {
                                  setState(() {
                                    erpDocNo = value;
                                    if (erpDocNo != _erpDocNoController) {
                                      checkUpdateData = true;
                                    }
                                  }),
                                },
                              ),
                            ),
                          ),

                          // Your content goes here
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomBar(
        currentPage: 'show',
      ),
    );
  }
}
