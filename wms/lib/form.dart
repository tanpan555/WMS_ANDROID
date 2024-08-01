import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class form extends StatefulWidget {
  final String poReceiveNo;

  form({required this.poReceiveNo});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<form> {
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

  final DateFormat inputFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  final DateFormat displayFormat = DateFormat("dd/MM/yyyy");

  List<dynamic> poType = [];
  String? selectedPoType;

  @override
  void initState() {
    super.initState();
    fetchReceiveHeadData(widget.poReceiveNo);
    fetchwhpoType();
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

  Future<void> fetchwhpoType() async {
  try {
    final response = await http.get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/PO_TYPE'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(responseBody);

      setState(() {
        poType = jsonData['items'];
        if (poType.isNotEmpty && selectedPoType == null) {
          selectedPoType = poType[0]['po_type_code'];
        }
      });
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
            crDateController.text = crDate.isNotEmpty
                ? displayFormat.format(inputFormat.parse(crDate))
                : '';
            poTypeCodeController.text = poTypeCode;
            receiveDateController.text = receiveDate;
            wareCodeController.text = wareCode;
            crByController.text = crBy;
            invoiceNoController.text = invoiceNo;
            invoiceDateController.text = invoiceDate;
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (crDate.isNotEmpty) {
      try {
        initialDate = displayFormat.parse(crDate);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        crDate = displayFormat.format(picked);
        crDateController.text = crDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: poNoController,
              decoration: InputDecoration(labelText: 'PO No'),
            ),
            TextField(
              controller: receiveNoController,
              decoration: InputDecoration(labelText: 'Receive No'),
              readOnly: true,
            ),
            TextField(
              controller: erpReceiveNoController,
              decoration: InputDecoration(labelText: 'ERP Receive No'),
            ),
            TextField(
              controller: pkWareCodeController,
              decoration: InputDecoration(labelText: 'PK Ware Code'),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: crDateController,
                  decoration: InputDecoration(labelText: 'CR Date'),
                ),
              ),
            ),
            DropdownButtonFormField<String>(
                        value: selectedPoType,
                        items: poType.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['po_type_code'],
                            child: Text(item['po_type_name'] ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPoType = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'PO Type Code'),
                      ),

            TextField(
              controller: receiveDateController,
              decoration: InputDecoration(labelText: 'Receive Date'),
            ),
            TextField(
              controller: wareCodeController,
              decoration: InputDecoration(
                labelText: 'Ware Code',
                filled: true,
                fillColor: Colors.grey,
              ),
              readOnly: true,
            ),
            TextField(
              controller: crByController,
              decoration: InputDecoration(labelText: 'CR By'),
            ),
            TextField(
              controller: invoiceNoController,
              decoration: InputDecoration(labelText: 'Invoice No'),
            ),
            TextField(
              controller: invoiceDateController,
              decoration: InputDecoration(labelText: 'Invoice Date'),
            ),
            TextField(
              controller: sellerController,
              decoration: InputDecoration(
                labelText: 'Seller',
                filled: true,
                fillColor: Colors.grey,
              ),
              readOnly: true,
            ),
            TextField(
              controller: poRemarkController,
              decoration: InputDecoration(labelText: 'PO Remark'),
            ),
            TextField(
              controller: ouCodeController,
              decoration: InputDecoration(labelText: 'OU Code'),
            ),
            TextField(
              controller: updByController,
              decoration: InputDecoration(
                labelText: 'Upd By',
                filled: true,
                fillColor: Colors.grey,
              ),
              readOnly: true,
            ),
            TextField(
              controller: updDateController,
              decoration: InputDecoration(
                labelText: 'Upd Date',
                filled: true,
                fillColor: Colors.grey,
              ),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
