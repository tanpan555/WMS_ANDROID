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
  // late DateFormat _dateTimeFormatter;
  List<Map<String, dynamic>> fromItems = [];
  List<Map<String, dynamic>> docTypeItems = [];
  List<Map<String, dynamic>> saffCodeItems = [];
  List<Map<String, dynamic>> refReceiveItems = [];
  List<Map<String, dynamic>> refNoItems = [];
  List<Map<String, dynamic>> cancelItems = [];
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
  final dateRegExp =
      RegExp(r"^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$");

  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false;
  bool chkDate = false;
  // int _cursorPosition = 0;
  bool checkUpdateData = false;
  bool isDialogShowing = false;
  bool isDateInvalid = false;
  bool isNextDisabled = false;
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
        '${gb.IP_API}/apex/wms/SSFGDT04/Step_2_validateSave_INHeadNonePO_WMS/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${gb.APP_USER}';

    final headers = {
      'Content-Type': 'application/json',
    };
    print(po_doc_no);
    print(gb.P_OU_CODE);
    print(gb.P_ERP_OU_CODE);
    print(gb.APP_SESSION);
    print(gb.APP_USER);

    final body = jsonEncode({
      'V_DOC_NO': po_doc_no,
      'P_WARE_CODE': gb.P_WARE_CODE,
      'P_OU_CODE': gb.P_OU_CODE,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      'APP_SESSION': gb.APP_SESSION,
      // 'APP_USER': gb.APP_USER,
      // 'p_ware_code': 'WH001',
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
            // po_doc_type = responseData['po_doc_type'];
            poStatus = responseData['po_status'];
            poMessage = responseData['po_message'];

            print('po_doc_no : $po_doc_no Type : ${po_doc_no.runtimeType}');
            // print('po_doc_type : $po_doc_type Type : ${po_doc_type.runtimeType}');
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
          // 'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
          'P_REF_RECEIVE': selectedRefReceive,
          'P_ORDER_NO': _oderNoController.text,
          'P_MO_DO_NO': _moDoNoController.text,
          'P_STAFF_CODE': _staffCodeController.text,
          // 'P_STAFF_CODE': selectedSaffCode,
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
    // print('STAFF_CODE: ${selectedSaffCode}');
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

  // Future<void> _selectDate(BuildContext context) async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //     initialEntryMode: DatePickerEntryMode.calendarOnly,
  //   );

  //   if (pickedDate != null) {
  //     // Format the date as dd-MM-yyyy for internal use
  //     String formattedDateForSearch =
  //         DateFormat('dd-MM-yyyy').format(pickedDate);
  //     // Format the date as dd/MM/yyyy for display
  //     String formattedDateForDisplay =
  //         DateFormat('dd/MM/yyyy').format(pickedDate);

  //     if (mounted) {
  //       setState(() {
  //         _docDateController.text = formattedDateForDisplay;
  //         selectedDate = formattedDateForSearch;

  //         // Set validation flag to false since the date is picked from the calendar
  //         chkDate = false;
  //         noDate = false; // Also ensure no error flag is set
  //       });
  //     }
  //   }
  // }

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

  // String formatDate(String input) {
  //   if (input.length == 8) {
  //     // Attempt to parse the input string as a date in ddMMyyyy format
  //     final day = int.tryParse(input.substring(0, 2));
  //     final month = int.tryParse(input.substring(2, 4));
  //     final year = int.tryParse(input.substring(4, 8));
  //     if (day != null && month != null && year != null) {
  //       final date = DateTime(year, month, day);
  //       if (date.year == year && date.month == month && date.day == day) {
  //         // Return the formatted date if valid
  //         return DateFormat('dd/MM/yyyy').format(date);
  //       }
  //     }
  //   }
  //   return input; // Return original input if invalid
  // }

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
                                            onClose: () {
                                              Navigator.of(context).pop();
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
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'An error occurred: $error'),
                                                  ),
                                                );
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
  // style: AppStyles.NextButtonStyle(),
  onPressed: isDateInvalid
      ? null // ปิดปุ่มหากวันที่ไม่ถูกต้อง
      : () async {
          if (_docDateController.text.isEmpty || isDateInvalid) {
            setState(() {
              chkDate = true;
            });
            return;
          }

          setState(() {
            isNextDisabled = true;
          });

          try {
            await update(widget.po_doc_type, widget.po_doc_no);
            await save_INHeadNonePO_WMS(selectedValue ?? '');
            checkUpdateData = false;

            if (poStatus == '0') {
              Navigator.push(
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
              ).then((_) => setState(() {}));
            } else if (poStatus == '1') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogStyles.alertMessageDialog(
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
              isNextDisabled = false; // เปิดปุ่มใหม่หลังการทำงาน
            });
          }
        },
  // child: Image.asset(
  //   'assets/images/right.png', // เปลี่ยนเส้นทางของรูปภาพตามต้องการ
  //   width: 20,
  //   height: 20,
  // ),
),

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
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                // labelText: 'เลขที่เอกสาร WMS*',
                                label: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'เลขที่ใบเบิก WMS',
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
                                      docString: (item) {
                                        final typeString =
                                            item['doc_type'].toString();
                                        final docString =
                                            item['doc_desc'].toString();
                                        return '$typeString $docString';
                                      },
                                      titleText: (item) =>
                                          item['doc_type']?.toString() ??
                                          'No code',
                                      subtitleText: (item) =>
                                          item['doc_desc']?.toString() ??
                                          'No description',
                                      onTap: (item) {
                                        final doc = item['doc_desc'].toString();

                                        Navigator.of(context).pop();
                                        setState(() {
                                          selectedDocType = doc;
                                          _docTypeController.text =
                                              selectedDocType!;
                                          fetchRefReceiveItems();
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
                                // TextFormField(
                                //   controller: _docDateController,
                                //   keyboardType: TextInputType.number,
                                //   inputFormatters: [
                                //     FilteringTextInputFormatter
                                //         .digitsOnly, // ยอมรับเฉพาะตัวเลข
                                //     LengthLimitingTextInputFormatter(
                                //         8), // จำกัดจำนวนตัวอักษรไม่เกิน 10 ตัว
                                //     DateInputFormatter(), // กำหนดรูปแบบ __/__/____
                                //   ],
                                //   decoration: InputDecoration(
                                //     border: InputBorder.none,
                                //     filled: true,
                                //     fillColor: Colors.white,
                                //     // labelText: 'วันที่บันทึก',
                                //     label: RichText(
                                //       text: TextSpan(
                                //         children: [
                                //           TextSpan(
                                //             text: 'วันที่บันทึก',
                                //             style: chkDate == false &&
                                //                     noDate == false
                                //                 ? const TextStyle(
                                //                     color: Colors.black87,
                                //                   )
                                //                 : const TextStyle(
                                //                     color: Colors.red,
                                //                   ),
                                //           ),
                                //           TextSpan(
                                //             text: ' *',
                                //             style: TextStyle(
                                //               color: Colors.red,
                                //               fontSize: 16,
                                //               fontWeight: FontWeight.bold,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //     hintText: 'DD/MM/YYYY',
                                //     hintStyle: TextStyle(color: Colors.grey),
                                //     labelStyle:
                                //         chkDate == false && noDate == false
                                //             ? const TextStyle(
                                //                 color: Colors.black87,
                                //               )
                                //             : const TextStyle(
                                //                 color: Colors.red,
                                //               ),
                                //     suffixIcon: IconButton(
                                //       icon: const Icon(Icons
                                //           .calendar_today), // ไอคอนที่อยู่ขวาสุด
                                //       onPressed: () async {
                                //         // กดไอคอนเพื่อเปิด date picker
                                //         _selectDate(context);
                                //       },
                                //     ),
                                //   ),
                                //   onChanged: (value) {
                                //     selectedDate = value;
                                //     print('selectedDate : $selectedDate');

                                //     if (selectedDate !=
                                //         _docDateController.text) {
                                //       checkUpdateData = true;
                                //     }

                                //     setState(() {
                                //       _cursorPosition = _docDateController
                                //           .selection.baseOffset;
                                //       _docDateController.value =
                                //           _docDateController.value.copyWith(
                                //         text: value,
                                //         selection: TextSelection.fromPosition(
                                //           TextPosition(offset: _cursorPosition),
                                //         ),
                                //       );
                                //     });

                                //     // Date format validation
                                //     setState(() {
                                //       // Regular expression to validate DD/MM/YYYY format
                                //       RegExp dateRegExp =
                                //           RegExp(r'^\d{2}/\d{2}/\d{4}$');
                                //       if (!dateRegExp.hasMatch(selectedDate)) {
                                //         // Show error if the manual input does not match the correct format
                                //         chkDate = true;
                                //         noDate = true;
                                //       } else {
                                //         chkDate =
                                //             false; // If the format is correct, clear the error
                                //         noDate = false;
                                //       }
                                //     });
                                //   },
                                // ),
                                // chkDate == true || noDate == true
                                //     ? const Padding(
                                //         padding: EdgeInsets.only(top: 4.0),
                                //         child: Text(
                                //           'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                                //           style: TextStyle(
                                //             color: Colors.red,
                                //             fontWeight: FontWeight.bold,
                                //             fontSize:
                                //                 12, // ปรับขนาดตัวอักษรตามที่ต้องการ
                                //           ),
                                //         ))
                                //     : const SizedBox.shrink(),
                                TextFormField(
  controller: _docDateController,
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(8),
    dateInputFormatter, // ใช้ตัวจัดรูปแบบวันที่ที่คุณสร้าง
  ],
  decoration: InputDecoration(
    border: InputBorder.none,
    filled: true,
    fillColor: Colors.white,
    label: RichText(
      text: TextSpan(
        text: 'วันที่บันทึก',
        style: isDateInvalid
            ? const TextStyle(color: Colors.red)
            : const TextStyle(color: Colors.black87),
        children: [
          TextSpan(
            text: ' *',
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    ),
    hintText: 'DD/MM/YYYY',
    hintStyle: const TextStyle(color: Colors.grey),
    labelStyle: isDateInvalid
        ? const TextStyle(color: Colors.red)
        : const TextStyle(color: Colors.black87),
    suffixIcon: IconButton(
      icon: const Icon(Icons.calendar_today),
      onPressed: () async {
        _selectDate(context);
      },
    ),
  ),
  onChanged: (value) {
    setState(() {
      docDate = value;
      isDateInvalid = dateInputFormatter.noDateNotifier.value; // ตรวจสอบจาก formatter
      if (docDate != _docDateController.text) {
        checkUpdateData = true;
      }
    });
  },
),

                          isDateInvalid == true
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ))
                              : const SizedBox.shrink(),
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
                                      onTap: (item) {
                                        // When an item is tapped
                                        final doc = item['doc'].toString();
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        setState(() {
                                          selectedRefReceive = doc;
                                          _refReceiveController.text =
                                              selectedRefReceive!;
                                          fetchRefReceiveItems();
                                          if (selectedRefReceive !=
                                              _refReceiveController.text) {
                                            checkUpdateData = true;
                                          }
                                        });
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
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        setState(() {
                                          selectedRefNo =
                                              item['so_no'].toString();
                                          fetchRefNoItems();
                                          if (selectedRefNo !=
                                              _refNoController) {
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
                                        final empId = '${item['emp_id'] ?? ''}';
                                        // final empName =
                                        //     '${item['emp_name'] ?? ''}';

                                        // Pop the dialog
                                        Navigator.of(context).pop();

                                        setState(() {
                                          selectedSaffCode = empId;
                                          _staffCodeController.text =
                                              selectedSaffCode ?? '';
                                          fetchSaffCodeItems();
                                          if (selectedSaffCode !=
                                              _staffCodeController.text) {
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
                              minLines: 2,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'หมายเหตุ',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .always, // บังคับให้ label อยู่ขอบบนเสมอ
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

// class DateInputFormatter extends TextInputFormatter {
//   bool dateColorCheck = false;
//   bool monthColorCheck = false;
//   bool noDate = false; // ตัวแปรเพื่อตรวจสอบว่ามีวันที่ไม่ถูกต้อง

//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     String text = newValue.text;

//     // กรองเฉพาะตัวเลข
//     text = text.replaceAll(RegExp(r'[^0-9]'), '');

//     String day = '';
//     String month = '';
//     String year = '';

//     // เก็บตำแหน่งของเคอร์เซอร์ปัจจุบันก่อนจัดรูปแบบข้อความ
//     int cursorPosition = newValue.selection.baseOffset;
//     int additionalOffset = 0;

//     // แยกค่า day, month, year
//     if (text.length >= 2) {
//       day = text.substring(0, 2);
//     }

//     if (text.length >= 4) {
//       month = text.substring(2, 4);
//     }

//     if (text.length > 4) {
//       year = text.substring(4);
//     }

//     dateColorCheck = false;
//     monthColorCheck = false;

//     // ตรวจสอบและตั้งค่า noDate ตามกรณีที่ต่างกัน
//     if (text.length == 1) {
//       noDate = true;
//     } else if (text.length == 2) {
//       noDate = true;
//     } else if (text.length == 3) {
//       noDate = true;
//     } else if (text.length == 4) {
//       noDate = true;
//     } else if (text.length == 5) {
//       noDate = true;
//     } else if (text.length == 6) {
//       noDate = true;
//     } else if (text.length == 7) {
//       noDate = true;
//     } else if (text.length == 8) {
//       noDate = false;
//     } else {
//       noDate = false;
//     }

//     // ตรวจสอบว่าค่าใน day ไม่เกิน 31
//     if (day.isNotEmpty && !noDate) {
//       int dayInt = int.parse(day);
//       if (dayInt < 1 || dayInt > 31) {
//         dateColorCheck = true;
//         noDate = true;
//       }
//     }

//     // ตรวจสอบว่าค่าใน month ไม่เกิน 12
//     if (month.isNotEmpty && !noDate) {
//       int monthInt = int.parse(month);
//       if (monthInt < 1 || monthInt > 12) {
//         monthColorCheck = true;
//         noDate = true;
//       }
//     }

//     // ตรวจสอบวันที่เฉพาะเมื่อพิมพ์ปีครบถ้วน
//     if (day.isNotEmpty && month.isNotEmpty && year.length == 4 && !noDate) {
//       if (!isValidDate(day, month, year)) {
//         noDate = true;
//       }
//     }

//     // จัดรูปแบบเป็น DD/MM/YYYY
//     if (text.length > 2 && text.length <= 4) {
//       text = text.substring(0, 2) + '/' + text.substring(2);
//       if (cursorPosition > 2) {
//         additionalOffset++;
//       }
//     } else if (text.length > 4 && text.length <= 8) {
//       text = text.substring(0, 2) +
//           '/' +
//           text.substring(2, 4) +
//           '/' +
//           text.substring(4);
//       if (cursorPosition > 2) {
//         additionalOffset++;
//       }
//       if (cursorPosition > 4) {
//         additionalOffset++;
//       }
//     }

//     // จำกัดความยาวไม่เกิน 10 ตัว (รวม /)
//     if (text.length > 10) {
//       text = text.substring(0, 10);
//     }

//     // คำนวณตำแหน่งของเคอร์เซอร์หลังจากจัดรูปแบบ
//     cursorPosition += additionalOffset;

//     if (cursorPosition > text.length) {
//       cursorPosition = text.length;
//     }

//     return TextEditingValue(
//       text: text,
//       selection: TextSelection.collapsed(offset: cursorPosition),
//     );
//   }

//   // ฟังก์ชันตรวจสอบว่าวันที่ถูกต้องหรือไม่
//   bool isValidDate(String day, String month, String year) {
//     int dayInt = int.parse(day);
//     int monthInt = int.parse(month);
//     int yearInt = int.parse(year);

//     // ตรวจสอบเดือนที่เกินขอบเขต
//     if (monthInt < 1 || monthInt > 12) {
//       monthColorCheck = false;
//       return false;
//     }

//     // ตรวจสอบจำนวนวันในแต่ละเดือน
//     List<int> daysInMonth = [
//       31,
//       isLeapYear(yearInt) ? 29 : 28, // ตรวจสอบปีอธิกสุรทินเมื่อปีครบถ้วน
//       31,
//       30,
//       31,
//       30,
//       31,
//       31,
//       30,
//       31,
//       30,
//       31
//     ];
//     int maxDays = daysInMonth[monthInt - 1];

//     // ตรวจสอบว่าค่าวันไม่เกินจำนวนวันที่ในเดือนนั้น ๆ
//     if (dayInt < 1 || dayInt > maxDays) {
//       dateColorCheck = false;
//       return false;
//     }

//     dateColorCheck = true;
//     monthColorCheck = true;
//     return true;
//   }

//   // ฟังก์ชันตรวจสอบปีอธิกสุรทิน (leap year)
//   bool isLeapYear(int year) {
//     if (year % 4 == 0) {
//       if (year % 100 == 0) {
//         if (year % 400 == 0) {
//           return true; // ปีที่หาร 400 ลงตัวเป็นปีอธิกสุรทิน
//         } else {
//           return false; // ปีที่หาร 100 ลงตัวแต่หาร 400 ไม่ลงตัวไม่ใช่ปีอธิกสุรทิน
//         }
//       } else {
//         return true; // ปีที่หาร 4 ลงตัวแต่หาร 100 ไม่ลงตัวเป็นปีอธิกสุรทิน
//       }
//     } else {
//       return false; // ปีที่หาร 4 ไม่ลงตัวไม่ใช่ปีอธิกสุรทิน
//     }
//   }
// }
