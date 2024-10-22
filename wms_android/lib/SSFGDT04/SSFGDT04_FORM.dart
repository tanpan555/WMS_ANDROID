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

class SSFGDT04_FORM extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String po_doc_no;
  final String? po_doc_type;

  SSFGDT04_FORM({
    Key? key,
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

  TextEditingController _refNoController = TextEditingController();
  String refNo = '';
  TextEditingController _refReceiveController =
      TextEditingController(); // REF_RECEIVE
  String refReceive = '';

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
  int _cursorPosition = 0;
  bool checkUpdateData = false;

  bool check = false;
  void checkIfHasData() {
    setState(() {
      if (_docNoController.text.isNotEmpty ||
          _docDateController.text.isNotEmpty ||
          _refNoController.text.isNotEmpty ||
          _refReceiveController.text.isNotEmpty ||
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
    print('get form');
    print('po_doc_no : ${widget.po_doc_no} : ${widget.po_doc_no.runtimeType}');
    print(
        'po_doc_type : ${widget.po_doc_type} Type : ${widget.po_doc_type.runtimeType}');
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_form/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      if (mounted) {
        setState(() {
          fromItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
          if (fromItems.isNotEmpty) {
            _docNoController.text = fromItems[0]['doc_no'] ?? '';
            docNo = fromItems[0]['doc_no'] ?? '';
            if (fromItems[0]['cr_date'] != null &&
                fromItems[0]['cr_date'].isNotEmpty) {
              DateTime parsedDate = DateTime.parse(fromItems[0]['cr_date']);
              _docDateController.text = _dateTimeFormatter.format(parsedDate);
              docDate = fromItems[0]['cr_date'] ?? '';
            }
            _refNoController.text = fromItems[0]['ref_no'] ?? ''; // REF_RECEIVE
            refNo = fromItems[0]['ref_no'] ?? '';
            _oderNoController.text = fromItems[0]['order_no'] ?? ''; // order_no
            oder = fromItems[0]['order_no'] ?? '';
            _moDoNoController.text = fromItems[0]['mo_do_no'] ?? ''; // mo_do_no
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
      throw Exception('Failed to load from items');
    }
  }

  Future<void> fetchDocTypeItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_TYPE/${gb.ATTR1}'));

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
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_STAFF_CODE/${gb.P_ERP_OU_CODE}'));

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
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_REFRECEIVE/${gb.ATTR1}/${widget.pWareCode}'));

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
    final response = await http.get(
        Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_REF_NO'));

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
    final response = await http.get(
        Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_CANCEL'));

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
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_validateSave_INHeadNonePO_WMS/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${gb.APP_USER}';

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
    final url =
        Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_wms_ith');
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
          'P_STAFF_CODE': selectedSaffCode,
          'P_NOTE': _noteController.text,
          'APP_USER': gb.APP_USER,
          'P_DOC_NO': po_doc_no,
          'P_ATTR1': gb.ATTR1,
          'P_DOC_TYPE': po_doc_type,
        }));

    print('Navigating to SSFGDT04_GRID with:');
    print('po_doc_no: ${widget.po_doc_no}');
    print('po_doc_type: ${widget.po_doc_type}');
    print('pWareCode: ${widget.pWareCode}');
    print('ref_no: ${selectedRefReceive}');
    print('mo_do_no: ${_moDoNoController.text}');
    print('staff_code: ${selectedSaffCode}');
    // print('P_REF_RECEIVE: ${selectedRefReceive}');

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
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_cancel_INHeadNonePO_WMS');
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      // Format the date as dd-MM-yyyy for internal use
      String formattedDateForSearch =
          DateFormat('dd-MM-yyyy').format(pickedDate);
      // Format the date as dd/MM/yyyy for display
      String formattedDateForDisplay =
          DateFormat('dd/MM/yyyy').format(pickedDate);

      if (mounted) {
        setState(() {
          _docDateController.text = formattedDateForDisplay;
          selectedDate = formattedDateForSearch;

          // Set validation flag to false since the date is picked from the calendar
          chkDate = false;
          noDate = false; // Also ensure no error flag is set
        });
      }
    }
  }

  String formatDate(String input) {
    if (input.length == 8) {
      // Attempt to parse the input string as a date in ddMMyyyy format
      final day = int.tryParse(input.substring(0, 2));
      final month = int.tryParse(input.substring(2, 4));
      final year = int.tryParse(input.substring(4, 8));
      if (day != null && month != null && year != null) {
        final date = DateTime(year, month, day);
        if (date.year == year && date.month == month && date.day == day) {
          // Return the formatted date if valid
          return DateFormat('dd/MM/yyyy').format(date);
        }
      }
    }
    return input; // Return original input if invalid
  }

  @override
  void dispose() {
    _refReceiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'รับตรง (ไม่อ้าง PO)',
        // showExitWarning: true,
        showExitWarning: checkUpdateData,
      ),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: fromItems.isEmpty
          ? Center(child: CircularProgressIndicator())
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
                            // Show confirmation dialog for cancellation
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  // title: const Text('สาเหตุการยกเลิก'),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('สาเหตุการยกเลิก'),
                                      // Close icon
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.all(
                                      20), // Add padding around content
                                  content: SizedBox(
                                    width: 300, // Set desired width
                                    height: 150, // Set desired height
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                        return Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          height:
                                                              300, // Adjust the height as needed
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'สาเหตุการยกเลิก',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  IconButton(
                                                                    icon: Icon(Icons
                                                                        .close),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(); // Close popup
                                                                      _searchController
                                                                          .clear(); // ลบค่าที่ค้นหาเมื่อปิด popup
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              // Search Field
                                                              TextField(
                                                                controller:
                                                                    _searchController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'ค้นหา...',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                ),
                                                                onChanged:
                                                                    (query) {
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Expanded(
                                                                child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                    final filteredItems =
                                                                        cancelItems
                                                                            .where((item) {
                                                                      final code =
                                                                          item['cancel_code']
                                                                              .toString();
                                                                      final desc =
                                                                          item['cancel_desc']
                                                                              .toString();
                                                                      final searchQuery = _searchController
                                                                          .text
                                                                          .trim()
                                                                          .toLowerCase();
                                                                      final searchQueryInt =
                                                                          int.tryParse(
                                                                              searchQuery);
                                                                      final codeInt =
                                                                          int.tryParse(
                                                                              code);

                                                                      return (searchQueryInt != null &&
                                                                              codeInt !=
                                                                                  null &&
                                                                              codeInt ==
                                                                                  searchQueryInt) ||
                                                                          code.contains(
                                                                              searchQuery) ||
                                                                          desc
                                                                              .toLowerCase()
                                                                              .contains(searchQuery);
                                                                    }).toList();

                                                                    if (filteredItems
                                                                        .isEmpty) {
                                                                      return Center(
                                                                          child:
                                                                              Text('No data found')); // แสดงข้อความเมื่อไม่มีข้อมูล
                                                                    }

                                                                    return ListView
                                                                        .builder(
                                                                      itemCount:
                                                                          filteredItems
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        final item =
                                                                            filteredItems[index];
                                                                        final code =
                                                                            item['cancel_code'].toString();
                                                                        final desc =
                                                                            item['cancel_desc'].toString();

                                                                        return ListTile(
                                                                          contentPadding:
                                                                              EdgeInsets.zero,
                                                                          title:
                                                                              RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: '$code ',
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                                TextSpan(
                                                                                  text: '$desc',
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                            setState(() {
                                                                              selectedCancelCode = code;
                                                                              selectedCancelDescription = '$code $desc'; // อัปเดตค่าที่รวมกัน
                                                                              _canCelController.text = selectedCancelDescription; // แสดงใน TextField
                                                                              fetchSaffCodeItems();
                                                                              print('$selectedCancelCode');
                                                                            });
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
                                              ).then((_) {
                                                // ลบค่าที่ค้นหาเมื่อ popup ถูกปิด ไม่ว่าจะกดไอคอนหรือกดที่อื่น
                                                _searchController.clear();
                                              });
                                            },
                                            child: AbsorbPointer(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  labelText: 'สาเหตุการยกเลิก',
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                  border: OutlineInputBorder(),
                                                  suffixIcon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Color.fromARGB(
                                                        255, 113, 113, 113),
                                                  ),
                                                ),
                                                controller:
                                                    _canCelController, // ใช้ controller เดิมที่ปรับอัปเดตใน onTap
                                                maxLines:
                                                    2, // จำกัดจำนวนบรรทัดสูงสุดที่แสดง
                                                minLines: 1,
                                                style: TextStyle(
                                                  fontSize:
                                                      14, // ปรับขนาดตัวหนังสือตามต้องการ
                                                  color: Colors
                                                      .black, // สามารถเปลี่ยนสีตัวหนังสือได้ที่นี่
                                                ), // จำนวนบรรทัดขั้นต่ำที่แสดง
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // Spacing between buttons
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _canCelController.clear();
                                            // Close popup
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          child: Text('OK'),
                                          onPressed: () async {
                                            await cancel_INHeadNonePO_WMS(
                                                selectedCancelCode ?? '');
                                            if (selectedCancelCode == null) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .notification_important,
                                                              color: Colors.red,
                                                              size: 30,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text('แจ้งเตือน'),
                                                          ],
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.close),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    content:
                                                        Text('$po_message'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        child: Text('ตกลง'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .notification_important,
                                                              color: Colors.red,
                                                              size: 30,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text('แจ้งเตือน'),
                                                          ],
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.close),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    content: Text(
                                                        'ยกเลิกรายการเสร็จสมบูรณ์'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        child: Text('ตกลง'),
                                                        onPressed: () {
                                                          cancel_INHeadNonePO_WMS(
                                                                  selectedCancelCode!)
                                                              .then((_) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SSFGDT04_MENU(
                                                                  pWareCode: gb
                                                                      .P_WARE_CODE,
                                                                  pErpOuCode: gb
                                                                      .P_ERP_OU_CODE,
                                                                ),
                                                              ),
                                                            );
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }).catchError(
                                                                  (error) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'An error occurred: $error'),
                                                              ),
                                                            );
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
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
                        ElevatedButton(
                          onPressed: () async {
                            if (_docDateController.text.isEmpty) {
                              setState(() {
                                chkDate = true;
                              });
                              return;
                            }
                            if (!dateRegExp.hasMatch(_docDateController.text)) {
                              setState(() {
                                chkDate = true;
                              });
                              return;
                            }

                            DateInputFormatter formatter = DateInputFormatter();
                            TextEditingValue oldValue =
                                TextEditingValue(text: _docDateController.text);
                            TextEditingValue newValue =
                                TextEditingValue(text: _docDateController.text);
                            formatter.formatEditUpdate(oldValue, newValue);

                            if (formatter.noDate) {
                              setState(() {
                                chkDate = true;
                              });
                              return;
                            } else {
                              setState(() {
                                chkDate = false;
                              });
                            }

                            await update(widget.po_doc_type, widget.po_doc_no);
                            await save_INHeadNonePO_WMS(selectedValue ?? '');
                            checkUpdateData = false;

                            if (poStatus == '0') {
                              checkUpdateData = false;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SSFGDT04_GRID(
                                    po_doc_no:
                                        widget.po_doc_no, // Pass po_doc_no
                                    po_doc_type: widget.po_doc_type ??
                                        '', // Pass po_doc_type
                                    pWareCode: widget.pWareCode,
                                    p_ref_no: _refNoController.text,
                                    mo_do_no: _moDoNoController.text,
                                  ),
                                ),
                              ).then((_) {
                                setState(() {});
                              });
                            } else if (poStatus == '1') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.notification_important,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                            SizedBox(width: 8),
                                            Text('แจ้งเตือน'),
                                          ],
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                    content: Text('$poMessage'),
                                    actions: [
                                      TextButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                        child: const Text('ตกลง'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog on button press
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Image.asset(
                            'assets/images/right.png', // change to the path of your image
                            width: 20,
                            height: 20,
                          ),
                          style: AppStyles.NextButtonStyle(),
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
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return Container(
                                            padding: const EdgeInsets.all(16),
                                            height:
                                                300, // ปรับความสูงของ Popup ตามต้องการ
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'ประเภทการรับ *',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // ปิด Popup
                                                        _searchController
                                                            .clear(); // ลบค่าที่ค้นหาเมื่อปิด popup
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                // ช่องค้นหา
                                                TextField(
                                                  controller: _searchController,
                                                  decoration: InputDecoration(
                                                    hintText: 'ค้นหา',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onChanged: (query) {
                                                    setState(() {});
                                                  },
                                                ),
                                                const SizedBox(height: 10),
                                                Expanded(
                                                  child: Builder(
                                                    builder: (context) {
                                                      final filteredItems =
                                                          docTypeItems
                                                              .where((item) {
                                                        final typeString =
                                                            item['doc_type']
                                                                .toString();
                                                        final docString =
                                                            item['doc_desc']
                                                                .toString();
                                                        final searchQuery =
                                                            _searchController
                                                                .text
                                                                .trim()
                                                                .toLowerCase();
                                                        final searchQueryInt =
                                                            int.tryParse(
                                                                searchQuery);
                                                        final docInt =
                                                            int.tryParse(
                                                                docString);

                                                        return (searchQueryInt !=
                                                                    null &&
                                                                docInt !=
                                                                    null &&
                                                                docInt ==
                                                                    searchQueryInt) ||
                                                            typeString
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchQuery) ||
                                                            docString
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchQuery);
                                                      }).toList();

                                                      if (filteredItems
                                                          .isEmpty) {
                                                        return Center(
                                                            child: Text(
                                                                'No data found')); // แสดงข้อความเมื่อไม่มีข้อมูล
                                                      }

                                                      return ListView.builder(
                                                        itemCount: filteredItems
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              filteredItems[
                                                                  index];
                                                          final type =
                                                              item['doc_type']
                                                                  .toString();
                                                          final doc =
                                                              item['doc_desc']
                                                                  .toString();

                                                          return ListTile(
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            title: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        '$type\n',
                                                                    style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '$doc',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(() {
                                                                selectedDocType =
                                                                    doc;
                                                                _docTypeController
                                                                        .text =
                                                                    selectedDocType!;
                                                                fetchRefReceiveItems();
                                                              });
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
                                ).then((_) {
                                  // ลบค่าที่ค้นหาเมื่อ popup ถูกปิด ไม่ว่าจะกดไอคอนหรือกดที่อื่น
                                  _searchController.clear();
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
                                TextFormField(
                                  controller: _docDateController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // ยอมรับเฉพาะตัวเลข
                                    LengthLimitingTextInputFormatter(
                                        8), // จำกัดจำนวนตัวอักษรไม่เกิน 10 ตัว
                                    DateInputFormatter(), // กำหนดรูปแบบ __/__/____
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                    // labelText: 'วันที่บันทึก',
                                    label: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'วันที่บันทึก',
                                            style: chkDate == false &&
                                                    noDate == false
                                                ? const TextStyle(
                                                    color: Colors.black87,
                                                  )
                                                : const TextStyle(
                                                    color: Colors.red,
                                                  ),
                                          ),
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    hintText: 'DD/MM/YYYY',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    labelStyle:
                                        chkDate == false && noDate == false
                                            ? const TextStyle(
                                                color: Colors.black87,
                                              )
                                            : const TextStyle(
                                                color: Colors.red,
                                              ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons
                                          .calendar_today), // ไอคอนที่อยู่ขวาสุด
                                      onPressed: () async {
                                        // กดไอคอนเพื่อเปิด date picker
                                        _selectDate(context);
                                      },
                                    ),
                                  ),
                                  onChanged: (value) {
                                    selectedDate = value;
                                    print('selectedDate : $selectedDate');

                                    if (selectedDate !=
                                        _docDateController.text) {
                                      checkUpdateData = true;
                                    }

                                    setState(() {
                                      _cursorPosition = _docDateController
                                          .selection.baseOffset;
                                      _docDateController.value =
                                          _docDateController.value.copyWith(
                                        text: value,
                                        selection: TextSelection.fromPosition(
                                          TextPosition(offset: _cursorPosition),
                                        ),
                                      );
                                    });

                                    // Date format validation
                                    setState(() {
                                      // Regular expression to validate DD/MM/YYYY format
                                      RegExp dateRegExp =
                                          RegExp(r'^\d{2}/\d{2}/\d{4}$');
                                      if (!dateRegExp.hasMatch(selectedDate)) {
                                        // Show error if the manual input does not match the correct format
                                        chkDate = true;
                                        noDate = true;
                                      } else {
                                        chkDate =
                                            false; // If the format is correct, clear the error
                                        noDate = false;
                                      }
                                    });
                                  },
                                ),
                                chkDate == true || noDate == true
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                12, // ปรับขนาดตัวอักษรตามที่ต้องการ
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
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return Container(
                                            padding: const EdgeInsets.all(16),
                                            height:
                                                300, // ปรับความสูงของ Popup ตามต้องการ
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'อ้างอิงใบนำส่งเลขที่',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // ปิด Popup
                                                        _searchController
                                                            .clear(); // ลบค่าที่ค้นหาเมื่อปิด popup
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                // ช่องค้นหา
                                                TextField(
                                                  controller: _searchController,
                                                  decoration: InputDecoration(
                                                    hintText: 'ค้นหา',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onChanged: (query) {
                                                    setState(() {});
                                                  },
                                                ),
                                                const SizedBox(height: 10),
                                                Expanded(
                                                  child: Builder(
                                                    builder: (context) {
                                                      final filteredItems =
                                                          refReceiveItems
                                                              .where((item) {
                                                        final docString =
                                                            item['doc']
                                                                .toString();
                                                        final searchQuery =
                                                            _searchController
                                                                .text
                                                                .trim()
                                                                .toLowerCase();
                                                        final searchQueryInt =
                                                            int.tryParse(
                                                                searchQuery);
                                                        final docInt =
                                                            int.tryParse(
                                                                docString);

                                                        return (searchQueryInt !=
                                                                    null &&
                                                                docInt !=
                                                                    null &&
                                                                docInt ==
                                                                    searchQueryInt) ||
                                                            docString
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchQuery);
                                                      }).toList();

                                                      if (filteredItems
                                                          .isEmpty) {
                                                        return Center(
                                                            child: Text(
                                                                'No data found')); // แสดงข้อความเมื่อไม่มีข้อมูล
                                                      }

                                                      return ListView.builder(
                                                        itemCount: filteredItems
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              filteredItems[
                                                                  index];
                                                          final doc =
                                                              item['doc']
                                                                  .toString();

                                                          return ListTile(
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            title: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        '$doc',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(() {
                                                                selectedRefReceive =
                                                                    doc;
                                                                _refReceiveController
                                                                        .text =
                                                                    selectedRefReceive!;
                                                                fetchRefReceiveItems();
                                                                if (selectedRefReceive !=
                                                                    _refReceiveController) {
                                                                  checkUpdateData =
                                                                      true;
                                                                }
                                                              });
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
                                ).then((_) {
                                  // ลบค่าที่ค้นหาเมื่อ popup ถูกปิด ไม่ว่าจะกดไอคอนหรือกดที่อื่น
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
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return Container(
                                            padding: const EdgeInsets.all(16),
                                            height:
                                                300, // ปรับความสูงของ Popup ตามต้องการ
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'อ้างอิง SO',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // ปิด Popup
                                                        _searchController
                                                            .clear();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                // ช่องค้นหา
                                                TextField(
                                                  controller: _searchController,
                                                  decoration: InputDecoration(
                                                    hintText: 'ค้นหา',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onChanged: (query) {
                                                    setState(() {});
                                                  },
                                                ),
                                                const SizedBox(height: 10),
                                                Expanded(
                                                  child: refNoItems.isEmpty
                                                      ? Center(
                                                          child: Text(
                                                              'No data found')) // แสดงข้อความเมื่อไม่มีข้อมูล
                                                      : ListView.builder(
                                                          itemCount: refNoItems
                                                              .where((item) {
                                                                final soNoString =
                                                                    item['so_no']
                                                                        .toString();
                                                                final soDateDisp =
                                                                    item['so_date_disp']
                                                                        .toString();
                                                                final soDate = item[
                                                                        'so_date']
                                                                    .toString();
                                                                final soRemark =
                                                                    item['so_remark']
                                                                        .toString();
                                                                final arName = item[
                                                                        'ar_name']
                                                                    .toString();
                                                                final arCode = item[
                                                                        'ar_code']
                                                                    .toString();
                                                                final searchQuery =
                                                                    _searchController
                                                                        .text
                                                                        .trim()
                                                                        .toLowerCase();

                                                                final searchQueryInt =
                                                                    int.tryParse(
                                                                        searchQuery);
                                                                final soNoInt =
                                                                    int.tryParse(
                                                                        soNoString);

                                                                return (searchQueryInt != null &&
                                                                        soNoInt !=
                                                                            null &&
                                                                        soNoInt ==
                                                                            searchQueryInt) ||
                                                                    soNoString
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            searchQuery) ||
                                                                    soDateDisp
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            searchQuery) ||
                                                                    soDate
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            searchQuery) ||
                                                                    soRemark
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            searchQuery) ||
                                                                    arName
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            searchQuery) ||
                                                                    arCode
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            searchQuery);
                                                              })
                                                              .toList()
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final filteredItems =
                                                                refNoItems
                                                                    .where(
                                                                        (item) {
                                                              final soNoString =
                                                                  item['so_no']
                                                                      .toString();
                                                              final soDateDisp =
                                                                  item['so_date_disp']
                                                                      .toString();
                                                              final soDate = item[
                                                                      'so_date']
                                                                  .toString();
                                                              final soRemark =
                                                                  item['so_remark']
                                                                      .toString();
                                                              final arName = item[
                                                                      'ar_name']
                                                                  .toString();
                                                              final arCode = item[
                                                                      'ar_code']
                                                                  .toString();
                                                              final searchQuery =
                                                                  _searchController
                                                                      .text
                                                                      .trim()
                                                                      .toLowerCase();

                                                              final searchQueryInt =
                                                                  int.tryParse(
                                                                      searchQuery);
                                                              final soNoInt =
                                                                  int.tryParse(
                                                                      soNoString);

                                                              return (searchQueryInt != null &&
                                                                      soNoInt !=
                                                                          null &&
                                                                      soNoInt ==
                                                                          searchQueryInt) ||
                                                                  soNoString
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          searchQuery) ||
                                                                  soDateDisp
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          searchQuery) ||
                                                                  soDate
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          searchQuery) ||
                                                                  soRemark
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          searchQuery) ||
                                                                  arName
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          searchQuery) ||
                                                                  arCode
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          searchQuery);
                                                            }).toList();

                                                            final item =
                                                                filteredItems[
                                                                    index];
                                                            final soNo =
                                                                item['so_no']
                                                                    .toString();
                                                            final soDateDisp =
                                                                item['so_date_disp']
                                                                    .toString();
                                                            final soDate =
                                                                item['so_date']
                                                                    .toString();
                                                            final soRemark =
                                                                item['so_remark']
                                                                    .toString();
                                                            final arName =
                                                                item['ar_name']
                                                                    .toString();
                                                            final arCode =
                                                                item['ar_code']
                                                                    .toString();

                                                            return ListTile(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              title: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          '$soNo\n',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          '$soDateDisp$soDate',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          '$soRemark$arName$arCode',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                setState(() {
                                                                  selectedRefNo =
                                                                      soNo;
                                                                  fetchRefNoItems();
                                                                  if (selectedRefNo !=
                                                                      _refNoController) {
                                                                    checkUpdateData =
                                                                        true;
                                                                  }
                                                                });
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
                                ).then((_) {
                                  // ลบค่าที่ค้นหาเมื่อ popup ถูกปิด ไม่ว่าจะกดไอคอนหรือกดที่อื่น
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
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return Container(
                                            padding: const EdgeInsets.all(16),
                                            height:
                                                300, // Adjust the height as needed
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'ผู้รับมอบสินค้า *',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close popup
                                                        _searchController
                                                            .clear();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                // Search Field
                                                TextField(
                                                  controller: _searchController,
                                                  decoration: InputDecoration(
                                                    hintText: 'ค้นหา...',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onChanged: (query) {
                                                    setState(() {});
                                                  },
                                                ),
                                                const SizedBox(height: 10),
                                                Expanded(
                                                  child: Builder(
                                                    builder: (context) {
                                                      final filteredItems =
                                                          saffCodeItems
                                                              .where((item) {
                                                        final empIdString =
                                                            '${item['emp_id'] ?? ''}' //${item['schid'] ?? ''}
                                                                .toString();
                                                        final empName =
                                                            '${item['emp_name'] ?? ''}'
                                                                .toString();
                                                        final searchQuery =
                                                            _searchController
                                                                .text
                                                                .trim()
                                                                .toLowerCase();
                                                        final searchQueryInt =
                                                            int.tryParse(
                                                                searchQuery);
                                                        final empIdInt =
                                                            int.tryParse(
                                                                empIdString);

                                                        return (searchQueryInt !=
                                                                    null &&
                                                                empIdInt !=
                                                                    null &&
                                                                empIdInt ==
                                                                    searchQueryInt) ||
                                                            empIdString.contains(
                                                                searchQuery) ||
                                                            empName
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchQuery);
                                                      }).toList();

                                                      if (filteredItems
                                                          .isEmpty) {
                                                        return Center(
                                                          child: Text(
                                                              'No data found'),
                                                        ); // แสดงข้อความเมื่อไม่มีข้อมูล
                                                      }

                                                      return ListView.builder(
                                                        itemCount: filteredItems
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              filteredItems[
                                                                  index];
                                                          final empId =
                                                              '${item['emp_id'] ?? ''}'
                                                                  .toString();
                                                          final empName =
                                                              '${item['emp_name'] ?? ''}'
                                                                  .toString();

                                                          return ListTile(
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            title: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        '$empId\n',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '$empName',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(() {
                                                                selectedSaffCode =
                                                                    empId;
                                                                _staffCodeController
                                                                        .text =
                                                                    empName;
                                                                fetchSaffCodeItems();
                                                                if (selectedSaffCode !=
                                                                    _staffCodeController) {
                                                                  checkUpdateData =
                                                                      true;
                                                                }
                                                              });
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

  void showDialogAlert(
    BuildContext context,
    String messageAlert,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Align title and close icon
            children: [
              Row(
                children: const [
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
              // Close icon
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    messageAlert,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Close the dialog on button press
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ตกลง'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  bool dateColorCheck = false;
  bool monthColorCheck = false;
  bool noDate = false; // ตัวแปรเพื่อตรวจสอบว่ามีวันที่ไม่ถูกต้อง

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // กรองเฉพาะตัวเลข
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    String day = '';
    String month = '';
    String year = '';

    // เก็บตำแหน่งของเคอร์เซอร์ปัจจุบันก่อนจัดรูปแบบข้อความ
    int cursorPosition = newValue.selection.baseOffset;
    int additionalOffset = 0;

    // แยกค่า day, month, year
    if (text.length >= 2) {
      day = text.substring(0, 2);
    }

    if (text.length >= 4) {
      month = text.substring(2, 4);
    }

    if (text.length > 4) {
      year = text.substring(4);
    }

    dateColorCheck = false;
    monthColorCheck = false;

    // ตรวจสอบและตั้งค่า noDate ตามกรณีที่ต่างกัน
    if (text.length == 1) {
      noDate = true;
    } else if (text.length == 2) {
      noDate = true;
    } else if (text.length == 3) {
      noDate = true;
    } else if (text.length == 4) {
      noDate = true;
    } else if (text.length == 5) {
      noDate = true;
    } else if (text.length == 6) {
      noDate = true;
    } else if (text.length == 7) {
      noDate = true;
    } else if (text.length == 8) {
      noDate = false;
    } else {
      noDate = false;
    }

    // ตรวจสอบว่าค่าใน day ไม่เกิน 31
    if (day.isNotEmpty && !noDate) {
      int dayInt = int.parse(day);
      if (dayInt < 1 || dayInt > 31) {
        dateColorCheck = true;
        noDate = true;
      }
    }

    // ตรวจสอบว่าค่าใน month ไม่เกิน 12
    if (month.isNotEmpty && !noDate) {
      int monthInt = int.parse(month);
      if (monthInt < 1 || monthInt > 12) {
        monthColorCheck = true;
        noDate = true;
      }
    }

    // ตรวจสอบวันที่เฉพาะเมื่อพิมพ์ปีครบถ้วน
    if (day.isNotEmpty && month.isNotEmpty && year.length == 4 && !noDate) {
      if (!isValidDate(day, month, year)) {
        noDate = true;
      }
    }

    // จัดรูปแบบเป็น DD/MM/YYYY
    if (text.length > 2 && text.length <= 4) {
      text = text.substring(0, 2) + '/' + text.substring(2);
      if (cursorPosition > 2) {
        additionalOffset++;
      }
    } else if (text.length > 4 && text.length <= 8) {
      text = text.substring(0, 2) +
          '/' +
          text.substring(2, 4) +
          '/' +
          text.substring(4);
      if (cursorPosition > 2) {
        additionalOffset++;
      }
      if (cursorPosition > 4) {
        additionalOffset++;
      }
    }

    // จำกัดความยาวไม่เกิน 10 ตัว (รวม /)
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    // คำนวณตำแหน่งของเคอร์เซอร์หลังจากจัดรูปแบบ
    cursorPosition += additionalOffset;

    if (cursorPosition > text.length) {
      cursorPosition = text.length;
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  // ฟังก์ชันตรวจสอบว่าวันที่ถูกต้องหรือไม่
  bool isValidDate(String day, String month, String year) {
    int dayInt = int.parse(day);
    int monthInt = int.parse(month);
    int yearInt = int.parse(year);

    // ตรวจสอบเดือนที่เกินขอบเขต
    if (monthInt < 1 || monthInt > 12) {
      monthColorCheck = false;
      return false;
    }

    // ตรวจสอบจำนวนวันในแต่ละเดือน
    List<int> daysInMonth = [
      31,
      isLeapYear(yearInt) ? 29 : 28, // ตรวจสอบปีอธิกสุรทินเมื่อปีครบถ้วน
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    int maxDays = daysInMonth[monthInt - 1];

    // ตรวจสอบว่าค่าวันไม่เกินจำนวนวันที่ในเดือนนั้น ๆ
    if (dayInt < 1 || dayInt > maxDays) {
      dateColorCheck = false;
      return false;
    }

    dateColorCheck = true;
    monthColorCheck = true;
    return true;
  }

  // ฟังก์ชันตรวจสอบปีอธิกสุรทิน (leap year)
  bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true; // ปีที่หาร 400 ลงตัวเป็นปีอธิกสุรทิน
        } else {
          return false; // ปีที่หาร 100 ลงตัวแต่หาร 400 ไม่ลงตัวไม่ใช่ปีอธิกสุรทิน
        }
      } else {
        return true; // ปีที่หาร 4 ลงตัวแต่หาร 100 ไม่ลงตัวเป็นปีอธิกสุรทิน
      }
    } else {
      return false; // ปีที่หาร 4 ไม่ลงตัวไม่ใช่ปีอธิกสุรทิน
    }
  }
}
