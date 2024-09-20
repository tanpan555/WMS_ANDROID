import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGDT04_GRID.dart';
import 'SSFGDT04_MENU.dart';
import '../styles.dart';
// import 'package:dropdown_search/dropdown_search.dart';

class SSFGDT04_FORM extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจากเลือ lov
  // final String pAttr1;
  final String po_doc_no;
  final String? po_doc_type;

  SSFGDT04_FORM({
    Key? key,
    required this.pWareCode,
    // required this.pAttr1,
    required this.po_doc_no,
    required this.po_doc_type,
  }) : super(key: key);

  // SSFGDT04_FORM({required this.po_doc_no, this.po_doc_type});
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
  // String? p_cancel_code;

  TextEditingController _docNoController = TextEditingController();
  TextEditingController _docDateController = TextEditingController();
  TextEditingController _refNoController = TextEditingController();
  // TextEditingController _refReceiveController =
  //     TextEditingController(); // REF_RECEIVE
  TextEditingController _oderNoController = TextEditingController(); // order_no
  TextEditingController _moDoNoController = TextEditingController(); // mo_do_no
  TextEditingController _staffCodeController =
      TextEditingController(); // staff_code
  TextEditingController _noteController = TextEditingController();
  TextEditingController _erpDocNoController = TextEditingController();
  TextEditingController _custController = TextEditingController();
  TextEditingController _searchController =
      TextEditingController(); // เพิ่ม Controller สำหรับการค้นหา

  // เพิ่ม DateFormat สำหรับฟอร์แมทวันที่
  final DateFormat _dateTimeFormatter = DateFormat('dd/MM/yyyy');

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
      setState(() {
        fromItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        if (fromItems.isNotEmpty) {
          _docNoController.text = fromItems[0]['doc_no'] ?? '';
          if (fromItems[0]['cr_date'] != null &&
              fromItems[0]['cr_date'].isNotEmpty) {
            // แปลงค่าจาก String เป็น DateTime แล้วฟอร์แมตใหม่
            DateTime parsedDate = DateTime.parse(fromItems[0]['cr_date']);
            _docDateController.text = _dateTimeFormatter.format(parsedDate);
          }
          _refNoController.text = fromItems[0]['ref_no'] ?? ''; // REF_RECEIVE
          _oderNoController.text = fromItems[0]['order_no'] ?? ''; // order_no
          _moDoNoController.text = fromItems[0]['mo_do_no'] ?? ''; // mo_do_no
          _staffCodeController.text =
              fromItems[0]['staff_code'] ?? ''; // staff_code
          _noteController.text = fromItems[0]['note'] ?? '';
          _erpDocNoController.text = fromItems[0]['erp_doc_no'] ?? '';
        }
      });
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
      setState(() {
        docTypeItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        if (docTypeItems.isNotEmpty) {
          selectedDocType = docTypeItems[0]['doc_desc']; // Default selection
        }
      });
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
      setState(() {
        saffCodeItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
      });
    } else {
      throw Exception('Failed to load STAFF_CODE items');
    }
  }

  Future<void> fetchRefReceiveItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_REFRECEIVE/${gb.ATTR1}/${widget.pWareCode}'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      setState(() {
        refReceiveItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
      });
    } else {
      throw Exception('Failed to load REFRECEIVE items');
    }
  }

  Future<void> fetchRefNoItems() async {
    final response = await http.get(
        Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_2_REF_NO'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      setState(() {
        refNoItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
      });
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
      setState(() {
        cancelItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
      });
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
    // print('Hiiiiiiiii');
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
          'P_REF_RECEIVE': _refNoController.text,
          'P_ORDER_NO': _oderNoController.text,
          'P_MO_DO_NO': _moDoNoController.text,
          'P_STAFF_CODE': _staffCodeController.text,
          'P_NOTE': _noteController.text,
          'APP_USER': gb.APP_USER,
          'P_DOC_NO': po_doc_no,
          'P_ATTR1': gb.ATTR1,
          'P_DOC_TYPE': po_doc_type,
        })

        // print('Updating receive_qty with data: ${jsonEncode({
        //       'rowid': rowid,
        //       'receive_qty': receiveQty,
        //     })}'
        );

    print('Navigating to SSFGDT04_GRID with:');
    print('po_doc_no: ${widget.po_doc_no}');
    print('po_doc_type: ${widget.po_doc_type}');
    print('pWareCode: ${widget.pWareCode}');
    print('p_ref_no: ${_refNoController.text}');
    print('mo_do_no: ${_moDoNoController.text}');

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  Future<void> cancel_INHeadNonePO_WMS(
    String selectedCancelCode,
  ) async {
    // print('Hiiiiiiiii');
    // print(
    //     'update called with po_doc_type: $po_doc_type, po_doc_no: $po_doc_no, p_cancel_code: $p_cancel_code');
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

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: fromItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ปุ่ม ถัดไป และ ยกเลิก //
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ปุ่ม ยกเลิก //
                        ElevatedButton(
                          onPressed: () {
                            // แสดง popup ยืนยันการยกเลิก
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('สาเหตุการยกเลิก'),
                                  content: SizedBox(
                                    width: 300, // กำหนดความกว้างที่ต้องการ
                                    height: 150, // กำหนดความสูงที่ต้องการ
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        DropdownButtonFormField2<String>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'สาเหตุการยกเลิก',
                                            labelStyle: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          items: cancelItems.map((item) {
                                            return DropdownMenuItem<String>(
                                              // เชื่อมต่อ cancel_code และ cancel_desc ใน value
                                              value:
                                                  '${item['cancel_code'] ?? 'N/A'} ${item['cancel_desc'] ?? 'N/A'}',
                                              child: Text(
                                                '${item['cancel_code'] ?? 'N/A'} ${item['cancel_desc'] ?? 'N/A'}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            );
                                          }).toList(),

                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedCancelCode = value;
                                            });
                                          },
                                          onSaved: (value) {
                                            selectedCancelCode = value;
                                          },
                                          value:
                                              selectedCancelCode, // Set the default selected value
                                          buttonStyleData: const ButtonStyleData(
                                              // padding: EdgeInsets.only(right: 8),
                                              ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Color.fromARGB(
                                                  255, 113, 113, 113),
                                            ),
                                            iconSize: 24,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            maxHeight: 150,
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // ปิด popup
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (selectedCancelCode != null) {
                                          Navigator.of(context).pop();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('คำเตือน'),
                                                content: Text(
                                                    'ยกเลิกรายการเสร็จสมบูรณ์...'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('ตกลง'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      cancel_INHeadNonePO_WMS(
                                                              selectedCancelCode!)
                                                          .then((_) {
                                                        // Navigator.of(context)
                                                        //     .pop(
                                                        //   MaterialPageRoute(
                                                        //     builder: (context) =>
                                                        //         SSFGDT04_MENU(
                                                        //       pWareCode: gb
                                                        //           .P_WARE_CODE,
                                                        //       pErpOuCode: gb
                                                        //           .P_ERP_OU_CODE,
                                                        //     ),
                                                        //   ),
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                SSFGDT04_MENU(
                                                              pWareCode: gb
                                                                  .P_WARE_CODE,
                                                              pErpOuCode: gb
                                                                  .P_ERP_OU_CODE,
                                                            ),
                                                          ),
                                                          (route) =>
                                                              false, // ปิดเส้นทางทั้งหมดก่อนหน้านี้
                                                        );
                                                        // );
                                                      }).catchError((error) {
                                                        ScaffoldMessenger.of(
                                                                context)
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
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('คำเตือน'),
                                                content:
                                                    Text('โปรดเลือกเหตุยกเลิก'),
                                                actions: <Widget>[
                                                  TextButton(
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
                                        }
                                      },
                                      child: const Text('OK'),
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
                          // style: ElevatedButton.styleFrom(
                          //   backgroundColor: Color.fromARGB(255, 255, 255, 255), // สีปุ่มยกเลิก
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   minimumSize: const Size(70, 40),
                          //   padding: const EdgeInsets.all(10),
                          // ),
                        ),

                        // const SizedBox(width: 10), // ระยะห่างระหว่างปุ่ม
                        // ปุ่ม ถัดไป //
                        ElevatedButton(
                          onPressed: () async {
                            // print('Hiiiiiiiiiiiiiiiiiiiiiiiiiii');
                            // เรียกใช้งานฟังก์ชันเพื่ออัปเดตข้อมูล Form ก่อน
                            await update(widget.po_doc_type, widget.po_doc_no);
                            await save_INHeadNonePO_WMS(selectedValue ?? '');

                            // ตรวจสอบเงื่อนไขก่อนบันทึกข้อมูล
                            if (poStatus == '0') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SSFGDT04_GRID(
                                    po_doc_no:
                                        widget.po_doc_no, // ส่งค่า po_doc_no
                                    po_doc_type: widget.po_doc_type ??
                                        '', // ส่งค่า po_doc_type
                                    pWareCode: widget.pWareCode,
                                    p_ref_no: _refNoController.text,
                                    mo_do_no: _moDoNoController.text,
                                  ),
                                ),
                              );
                            } else if (poStatus == '1') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('คำเตือน'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${poMessage}'),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () async {
                                          // await cancel_INHeadNonePO_WMS(
                                          //     widget.po_doc_type,
                                          //     widget.po_doc_no,
                                          //     p_cancel_code);
                                          // await save_INHeadNonePO_WMS(
                                          //     selectedValue ?? '');
                                          // Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            // เพิ่มโค้ดสำหรับการทำงานของปุ่มถัดไปที่นี่
                          },
                          child: Image.asset(
                            'assets/images/right.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                            width: 20, // ปรับขนาดตามที่ต้องการ
                            height: 20, // ปรับขนาดตามที่ต้องการ
                          ),
                          // style: ElevatedButton.styleFrom(
                          //   backgroundColor:
                          //       const Color.fromARGB(255, 255, 255, 255),
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   minimumSize: const Size(60, 40),
                          //   padding: const EdgeInsets.all(0),
                          // ),
                          style: AppStyles.NextButtonStyle(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // เลขที่ใบเบิก WMS* //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'เลขที่เอกสาร WMS*',
                        filled: true,
                        fillColor: Colors.grey[300],
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _docNoController,
                    ),
                  ),

                  //ประเภทการจ่าย*//
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'ประเภทการรับ*',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      items: docTypeItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item['doc_desc'],
                                child: Text(
                                  item['doc_desc'] ?? 'doc_desc = null',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedDocType = value;
                        });
                      },
                      onSaved: (value) {
                        selectedDocType = value;
                      },
                      value: selectedDocType, // Set the default selected value
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 0),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        maxHeight: 150,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),

                  // วันที่บันทึก //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      controller: _docDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'วันที่บันทึก',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        // เลือกวันที่
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          // เพิ่มเวลาให้เป็นปัจจุบัน
                          DateTime currentTime = DateTime.now();
                          DateTime fullDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            // currentTime.hour,
                            // currentTime.minute,
                            // currentTime.second,
                          );

                          // Format fullDateTime as dd/MM/yyyy HH:mm
                          setState(() {
                            _docDateController.text =
                                _dateTimeFormatter.format(fullDateTime);
                          });
                        }
                      },
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'อ้างอิงใบนำส่งเลขที่',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // ปิด Popup
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
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (query) {
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: refReceiveItems
                                                .where((item) {
                                                  // แปลง schid เป็น int ก่อนการเปรียบเทียบ
                                                  final docString =
                                                      item['doc'].toString();
                                                  // final fgCode = item['fg_code']
                                                  //     .toString();
                                                  // final empName =
                                                  //     item['emp_name']
                                                  // .toString();
                                                  final searchQuery =
                                                      _searchController.text
                                                          .trim();

                                                  // ตรวจสอบว่า searchQuery เป็นจำนวนเต็มหรือไม่
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);

                                                  // แปลง schid เป็น int ถ้าค่ามันเป็นจำนวนเต็ม
                                                  final docInt =
                                                      int.tryParse(docString);

                                                  // เปรียบเทียบกับ searchQuery
                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      docString.contains(
                                                          searchQuery);

                                                  // ||
                                                  // fgCode.contains(
                                                  //     searchQuery) ||
                                                  // empName.contains(
                                                  //     searchQuery);
                                                })
                                                .toList()
                                                .length,
                                            itemBuilder: (context, index) {
                                              final filteredItems =
                                                  refReceiveItems.where((item) {
                                                final docString =
                                                    item['doc'].toString();
                                                // final fgCode =
                                                //     item['fg_code'].toString();
                                                // final empName =
                                                //     item['d'].toString();
                                                final searchQuery =
                                                    _searchController.text
                                                        .trim();

                                                final searchQueryInt =
                                                    int.tryParse(searchQuery);
                                                final docInt =
                                                    int.tryParse(docString);

                                                return (searchQueryInt !=
                                                            null &&
                                                        docInt != null &&
                                                        docInt ==
                                                            searchQueryInt) ||
                                                    docString
                                                        .contains(searchQuery);
                                                //     ||
                                                // // fgCode.contains(
                                                // //     searchQuery) ||
                                                // empName
                                                //     .contains(searchQuery);
                                              }).toList();

                                              final item = filteredItems[index];
                                              final doc =
                                                  item['doc'].toString();
                                              // final fgCode =
                                              //     item['fg_code'].toString();
                                              // final empName =
                                              //     item['d'].toString();
                                              // final displayValue =
                                              //     '$schid  $fgCode  $custName';

                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '$doc',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      // TextSpan(
                                                      //   text: '$empName',
                                                      //   style: TextStyle(
                                                      //     fontSize: 12,
                                                      //     fontWeight:
                                                      //         FontWeight.normal,
                                                      //     color: Colors.black,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    selectedRefReceive = doc;
                                                    // _custController.text =
                                                    //     '$empName';
                                                    fetchRefReceiveItems();
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
                        );
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
                          controller:
                              TextEditingController(text: selectedRefReceive),
                        ),
                      ),
                    ),
                  ),

                  // อ้างอิง SO //
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 8),
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //       labelText: 'อ้างอิง SO',
                  //       filled: true,
                  //       fillColor: Colors.white,
                  //       labelStyle: TextStyle(color: Colors.black),
                  //       border: InputBorder.none,
                  //     ),
                  //     controller: _oderNoController,
                  //   ),
                  // ),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'อ้างอิง SO',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // ปิด Popup
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
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (query) {
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: refNoItems
                                                .where((item) {
                                                  // แปลง schid เป็น int ก่อนการเปรียบเทียบ
                                                  final soNoString =
                                                      item['so_no'].toString();
                                                  final soDateDisp =
                                                      item['so_date_disp']
                                                          .toString();
                                                  final soDate = item['so_date']
                                                      .toString();
                                                  final soRemark =
                                                      item['so_remark']
                                                          .toString();
                                                  final arName = item['ar_name']
                                                      .toString();
                                                  final arCode = item['ar_code']
                                                      .toString();
                                                  final searchQuery =
                                                      _searchController.text
                                                          .trim();

                                                  // ตรวจสอบว่า searchQuery เป็นจำนวนเต็มหรือไม่
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);

                                                  // แปลง schid เป็น int ถ้าค่ามันเป็นจำนวนเต็ม
                                                  final soNoInt =
                                                      int.tryParse(soNoString);

                                                  // เปรียบเทียบกับ searchQuery
                                                  return (searchQueryInt !=
                                                              null &&
                                                          soNoInt != null &&
                                                          soNoInt ==
                                                              searchQueryInt) ||
                                                      soNoString.contains(
                                                          searchQuery) ||
                                                      soDateDisp.contains(
                                                          searchQuery) ||
                                                      soDate.contains(
                                                          searchQuery) ||
                                                      soRemark.contains(
                                                          searchQuery) ||
                                                      arName.contains(
                                                          searchQuery) ||
                                                      arCode.contains(
                                                          searchQuery);
                                                })
                                                .toList()
                                                .length,
                                            itemBuilder: (context, index) {
                                              final filteredItems =
                                                  refReceiveItems.where((item) {
                                                final soNoString =
                                                    item['so_no'].toString();
                                                final soDateDisp =
                                                    item['so_date_disp']
                                                        .toString();
                                                final soDate =
                                                    item['so_date'].toString();
                                                final soRemark =
                                                    item['so_remark']
                                                        .toString();
                                                final arName =
                                                    item['ar_name'].toString();
                                                final arCode =
                                                    item['ar_code'].toString();
                                                final searchQuery =
                                                    _searchController.text
                                                        .trim();

                                                final searchQueryInt =
                                                    int.tryParse(searchQuery);
                                                final soNoInt =
                                                    int.tryParse(soNoString);

                                                return (searchQueryInt !=
                                                            null &&
                                                        soNoInt != null &&
                                                        soNoInt ==
                                                            searchQueryInt) ||
                                                    soNoString.contains(
                                                        searchQuery) ||
                                                    soDateDisp.contains(
                                                        searchQuery) ||
                                                    soDate.contains(
                                                        searchQuery) ||
                                                    soRemark.contains(
                                                        searchQuery) ||
                                                    arName.contains(
                                                        searchQuery) ||
                                                    arCode
                                                        .contains(searchQuery);
                                              }).toList();

                                              final item = filteredItems[index];
                                              final soNo =
                                                  item['so_no'].toString();
                                              final soDateDisp =
                                                  item['so_date_disp']
                                                      .toString();
                                              final soDate =
                                                  item['so_date'].toString();
                                              final soRemark =
                                                  item['so_remark'].toString();
                                              final arName =
                                                  item['ar_name'].toString();
                                              final arCode =
                                                  item['ar_code'].toString();
                                              // final displayValue =
                                              //     '$schid  $fgCode  $custName';

                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '$soNo\n',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '$soDateDisp'
                                                            '$soDate',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '$soRemark'
                                                            '$arName'
                                                            '$arCode',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    selectedRefNo = soNo;
                                                    // _custController.text =
                                                    //     '$empName';
                                                    fetchRefNoItems();
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
                        );
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'อ้างอิง SO',
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromARGB(255, 113, 113, 113),
                            ),
                          ),
                          controller:
                              TextEditingController(text: selectedRefNo),
                        ),
                      ),
                    ),
                  ),

                  // เลขที่คำสั่งผลผลิต* //
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
                                    height: 300, // Adjust the height as needed
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'ผู้รับมอบสินค้า',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.close,color: Color.fromARGB(255, 113, 113, 113),),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close popup
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
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (query) {
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: saffCodeItems
                                                .where((item) {
                                                  final empIdString =
                                                      item['emp_id'].toString();
                                                  final empName =
                                                      item['emp_name']
                                                          .toString();
                                                  final searchQuery =
                                                      _searchController.text
                                                          .trim();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final empIdInt =
                                                      int.tryParse(empIdString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          empIdInt != null &&
                                                          empIdInt ==
                                                              searchQueryInt) ||
                                                      empIdString.contains(
                                                          searchQuery) ||
                                                      empName.contains(
                                                          searchQuery);
                                                })
                                                .toList()
                                                .length,
                                            itemBuilder: (context, index) {
                                              final filteredItems =
                                                  saffCodeItems.where((item) {
                                                final empIdString =
                                                    item['emp_id'].toString();
                                                final empName =
                                                    item['emp_name'].toString();
                                                final searchQuery =
                                                    _searchController.text
                                                        .trim();
                                                final searchQueryInt =
                                                    int.tryParse(searchQuery);
                                                final empIdInt =
                                                    int.tryParse(empIdString);

                                                return (searchQueryInt !=
                                                            null &&
                                                        empIdInt != null &&
                                                        empIdInt ==
                                                            searchQueryInt) ||
                                                    empIdString.contains(
                                                        searchQuery) ||
                                                    empName
                                                        .contains(searchQuery);
                                              }).toList();

                                              final item = filteredItems[index];
                                              final empId =
                                                  item['emp_id'].toString();
                                              final empName =
                                                  item['emp_name'].toString();

                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '$empId\n',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '$empName',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    selectedSaffCode = empName;
                                                    _staffCodeController.text =
                                                        empName;
                                                    fetchSaffCodeItems();
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
                        );
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'ผู้รับมอบสินค้า*',
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromARGB(255, 113, 113, 113),
                            ),
                          ),
                          controller: _staffCodeController.text.isNotEmpty
                              ? _staffCodeController
                              : TextEditingController(text: selectedSaffCode),
                        ),
                      ),
                    ),
                  ),
                  // หมายเหตุ //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'หมายเหตุ',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _noteController,
                    ),
                  ),

                  // เลขที่เอกสาร ERP //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
