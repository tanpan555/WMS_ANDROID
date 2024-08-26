import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/SSINDT01/SSINDT01_main.dart';
import 'package:wms_android/SSINDT01/SSINDT01_grid_data.dart';

class Ssindt01Form extends StatefulWidget {
  final String poReceiveNo;

  Ssindt01Form({required this.poReceiveNo});

  @override
  _Ssindt01FormState createState() => _Ssindt01FormState();
}

class _Ssindt01FormState extends State<Ssindt01Form> {
  String poNo = '';
  String receiveNo = '';
  String erpReceiveNo = '';
  String pkWareCode = '';
  String crDate = '';
  String poTypeCode = '';
  String receiveDate = '';
  String wareCode = '';
  String crBy = '';
  String invoiceNo = '';
  String invoiceDate = '';
  String seller = '';
  String poRemark = '';
  String ouCode = '';
  String updBy = '';
  String updDate = '';

  final TextEditingController poNoController = TextEditingController();
  final TextEditingController receiveNoController = TextEditingController();
  final TextEditingController erpReceiveNoController = TextEditingController();
  final TextEditingController pkWareCodeController = TextEditingController();
  final TextEditingController poTypeCodeController = TextEditingController();
  final TextEditingController receiveDateController = TextEditingController();
  final TextEditingController wareCodeController = TextEditingController();
  final TextEditingController crByController = TextEditingController();
  final TextEditingController invoiceNoController = TextEditingController();
  final TextEditingController invoiceDateController = TextEditingController();
  final TextEditingController sellerController = TextEditingController();
  final TextEditingController poRemarkController = TextEditingController();
  final TextEditingController ouCodeController = TextEditingController();
  final TextEditingController updByController = TextEditingController();
  final TextEditingController updDateController = TextEditingController();
  final TextEditingController crDateController = TextEditingController();

  final DateFormat displayFormat = DateFormat("dd/MM/yyyy");
  final DateFormat apiFormat = DateFormat("MM/dd/yyyy");

  final _formKey = GlobalKey<FormState>();

  List<dynamic> poType = [];
  String? selectedPoType;

  @override
  void initState() {
    super.initState();
    fetchReceiveHeadData(widget.poReceiveNo);
    fetchwhpoType();
    cancelCode();
  }

  @override
  void dispose() {
    poNoController.dispose();
    receiveNoController.dispose();
    erpReceiveNoController.dispose();
    pkWareCodeController.dispose();
    poTypeCodeController.dispose();
    receiveDateController.dispose();
    wareCodeController.dispose();
    crByController.dispose();
    invoiceNoController.dispose();
    invoiceDateController.dispose();
    sellerController.dispose();
    poRemarkController.dispose();
    ouCodeController.dispose();
    updByController.dispose();
    updDateController.dispose();
    crDateController.dispose();
    super.dispose();
  }

  String? poStatus;
  String? poMessage;
  Future<void> fetchPoStatus() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/c/chk_valid_inhead/${widget.poReceiveNo}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          poStatus = responseBody['po_status'];
          poMessage = responseBody['po_message'];
          print('po_status: $poStatus');
          print('po_message: $poMessage');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('$poMessage')),
          // );
        });
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      setState(() {
        poStatus = 'Error';
        poMessage = e.toString();
      });
    }
  }

  Future<void> fetchwhpoType() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/PO_TYPE'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        setState(() {
          poType = jsonData['items'];
        });
        print(poType);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchReceiveHeadData(String receiveNo) async {
    final String apiUrl =
        "http://172.16.0.82:8888/apex/wms/c/formtest/$receiveNo";

    final Map<String, String> queryParams = {
      'RECEIVE_NO': receiveNo,
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];

          setState(() {
            poNo = item['po_no'] ?? '';
            receiveNo = item['receive_no'] ?? '';
            erpReceiveNo = item['erp_receive_no'] ?? '';
            pkWareCode = item['pk_ware_code'] ?? '';
            crDate = item['cr_date'] ?? '';
            poTypeCode = item['po_type_code'] ?? '';
            receiveDate = item['receive_date'] ?? '';
            wareCode = item['ware_code'] ?? '';
            crBy = item['cr_by'] ?? '';
            invoiceNo = item['invoice_no'] ?? '';
            invoiceDate = item['invoice_date'] ?? '';
            seller = item['seller'] ?? '';
            poRemark = item['po_remark'] ?? '';
            ouCode = item['ou_code'] ?? '';
            updBy = item['upd_by'] ?? '';
            updDate = item['upd_date'] ?? '';

            poNoController.text = poNo;
            receiveNoController.text = receiveNo;
            erpReceiveNoController.text = erpReceiveNo;
            pkWareCodeController.text = pkWareCode;
            crDateController.text = crDate.isNotEmpty ? crDate : '';
            poTypeCodeController.text = poTypeCode;

            wareCodeController.text = wareCode;
            crByController.text = crBy;
            invoiceNoController.text = invoiceNo;
            receiveDateController.text = receiveDate.isNotEmpty
                ? displayFormat.format(apiFormat.parse(receiveDate))
                : '';
            invoiceDateController.text = invoiceDate.isNotEmpty
                ? displayFormat.format(apiFormat.parse(invoiceDate))
                : '';
            sellerController.text = seller;
            poRemarkController.text = poRemark;
            ouCodeController.text = ouCode;
            updByController.text = updBy;
            updDateController.text = updDate;

            selectedPoType = poTypeCode;
          });
        } else {
          print('No items found.');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<Map<String, dynamic>> cCode = [];
  String? selectedcCode;
  bool isLoading = true;
  String errorMessage = '';

  Future<void> cancelCode() async {
    try {
      final response = await http.get(
          Uri.parse('http://172.16.0.82:8888/apex/wms/c/cancel_from_list'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          cCode = (jsonData['items'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
          selectedcCode = cCode.isNotEmpty ? cCode[0]['r'] : null;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> cancel_from(String selectedcCode) async {
    final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/cancel_from');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'v_rec': widget.poReceiveNo,
        'v_cancel': selectedcCode,
      }),
    );

    print('Cancel form with data: ${jsonEncode({
          'v_rec': widget.poReceiveNo,
          'v_cancel': selectedcCode,
        })}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final poStatus = responseData['po_status'] ?? 'Unknown';
        final pomsg = responseData['po_message'] ?? 'Unknown';
        print('po_status: $poStatus');
        print('po_message: $pomsg');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$pomsg')),
        );
      } catch (e) {
        print('Error parsing response: $e');
      }
    } else {
      print('Failed to cancel: ${response.statusCode}');
    }
  }

  void showCancelDialog() {
    String? selectedcCode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 600.0,
            height: 250.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Cancel', style: TextStyle(fontSize: 20.0)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 350,
                    child: DropdownButtonFormField<String>(
                      value: selectedcCode,
                      isExpanded: true,
                      items: cCode.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['r'],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['r'] ?? 'No code',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                item['d'] ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        selectedcCode = newValue;
                      },
                      decoration: InputDecoration(
                        labelText: 'Cancel Code',
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          if (selectedcCode != null) {
                            Navigator.of(context).pop();
                            cancel_from(selectedcCode!).then((_) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SSINDT01_MAIN(),
                              ));
                            }).catchError((error) {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Please select a cancel code')),
                            );
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateForm_REMARK(
      String receiveNo,
      String poRemark,
      String receiveDate,
      String invoiceDate,
      String invoiceNo,
      String poTypeCode) async {
    final url =
        Uri.parse('http://172.16.0.82:8888/apex/wms/c/UP_FORM_PO_REMARK');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'RECEIVE_NO': receiveNo,
        'PO_REMARK': poRemark,
        'RECEIVE_DATE': receiveDate,
        'INVOICE_DATE': invoiceDate,
        'INVOICE_NO': invoiceNo,
        'PO_TYPE_CODE': poTypeCode,
      }),
    );

    print('Updating form with data: ${jsonEncode({
          'RECEIVE_NO': receiveNo,
          'PO_REMARK': poRemark,
          'RECEIVE_DATE': receiveDate,
          'INVOICE_DATE': invoiceDate,
          'INVOICE_NO': invoiceNo,
          'PO_TYPE_CODE': poTypeCode,
        })}');

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  Future<void> _selectInvoiceDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (invoiceDate.isNotEmpty) {
      try {
        initialDate = apiFormat.parse(invoiceDate);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      setState(() {
        invoiceDate = apiFormat.format(picked);
        invoiceDateController.text = displayFormat.format(picked);
      });
    }
  }

  Future<void> _selectReceiveDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (receiveDate.isNotEmpty) {
      try {
        initialDate = apiFormat.parse(receiveDate);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      setState(() {
        receiveDate = apiFormat.format(picked);
        receiveDateController.text = displayFormat.format(picked);
      });
    }
  }

  void _updateForm() async {
    final receiveNo = receiveNoController.text;
    final poRemark = poRemarkController.text;
    final receiveDate =
        apiFormat.format(displayFormat.parse(receiveDateController.text));
    final invoiceDate =
        apiFormat.format(displayFormat.parse(invoiceDateController.text));
    final invoiceNo = invoiceNoController.text;
    final poTypeCode = selectedPoType?.split(' ').first ?? '';

    if (invoiceNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรอก INVOICE NO ก่อน')),
      );
      return;
    }

    await updateForm_REMARK(
        receiveNo, poRemark, receiveDate, invoiceDate, invoiceNo, poTypeCode);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            Ssindt01Grid(poReceiveNo: receiveNo, poPONO: poNo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ'),
      // drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(10, 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ย้อนกลับ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 43, 43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(10, 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      showCancelDialog();
                    },
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(10, 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      fetchPoStatus();
                      _updateForm();
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildFormFields(),
                  // child: _buildFormFields(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  // @override
  Widget _buildFormFields() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: const TextStyle(
              color: Colors.black87,
            ),
            controller: poNoController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              labelText: 'เลขที่อ้างอิง (PO)*',
              labelStyle: const TextStyle(
                color: Colors.black87,
              ),
            ),
            readOnly: true,
          ),
          // _buildDisabledTextField(
          //   label: 'เลขที่อ้างอิง (PO)*',
          //   initialValue: widget.item['title'] ?? 'PO-XX1234-5678',
          // ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'ประเภทรายการ',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.white),
            ),
            value: selectedPoType,
            items: poType.map<DropdownMenuItem<String>>((dynamic value) {
              return DropdownMenuItem<String>(
                value: value['po_type_code'],
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    value['po_type_code'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedPoType = newValue;
                poTypeCodeController.text = newValue ?? '';
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: receiveDateController,
            decoration: InputDecoration(
              labelText: 'วันที่เลือก',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today,
                    color: Colors.white), 
                onPressed: () {
                  _selectReceiveDate(context);
                },
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
            readOnly: true,
            onTap: () => _selectReceiveDate(context),
          ),

          const SizedBox(height: 16.0),
          TextFormField(
            controller: invoiceNoController,
            decoration: InputDecoration(
              labelText: 'เลขที่ใบแจ้งหนี้ *',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
            style: TextStyle(
              color: Colors.white, 
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกเลขที่ใบแจ้งหนี้';
              }
              return null;
            },
          ),

          const SizedBox(height: 16.0),
          TextFormField(
            controller: invoiceDateController,
            decoration: InputDecoration(
              labelText: 'วันที่ใบแจ้งหนี้',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today,
                    color: Colors.white),
                onPressed: () {
                  _selectInvoiceDate(context);
                },
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
            readOnly: true,
            onTap: () => _selectInvoiceDate(context),
          ),

          const SizedBox(height: 16.0),
          TextFormField(
            controller: poRemarkController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
                labelText: 'PO Remark'),
          ),
          const SizedBox(height: 16.0),

          TextFormField(
            style: const TextStyle(
              color: Colors.black87,
            ),
            controller: sellerController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              labelText: 'ผู้ขาย',
              labelStyle: const TextStyle(
                color: Colors.black87,
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            style: const TextStyle(
              color: Colors.black87,
            ),
            controller: receiveNoController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              labelText: 'เลขที่เอกสาร WMS*',
              labelStyle: const TextStyle(
                color: Colors.black87,
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            style: const TextStyle(
              color: Colors.black87,
            ),
            controller: wareCodeController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              labelText: 'รับเข้าคลัง',
              labelStyle: const TextStyle(
                color: Colors.black87,
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            style: const TextStyle(
              color: Colors.black87,
            ),
            controller: erpReceiveNoController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              labelText: 'เลขที่ใบรับคลัง',
              labelStyle: const TextStyle(
                color: Colors.black87,
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            style: const TextStyle(
              color: Colors.black87,
            ),
            controller: crByController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              labelText: 'ผู้รับ',
              labelStyle: const TextStyle(
                color: Colors.black87,
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16.0),
          const SizedBox(height: 16.0),
          TextFormField(
            style: const TextStyle(
              color: Colors.black87,
            ),
            controller: crDateController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              labelText: 'วันที่บันทึก',
              labelStyle: const TextStyle(
                color: Colors.black87,
              ),
            ),
            readOnly: true,
          ),
        ],
      ),
    );
  }
}
