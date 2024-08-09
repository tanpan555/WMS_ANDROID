import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wms/grid.dart';
import 'package:wms/CardTest.dart';

class form extends StatefulWidget {
  final String poReceiveNo;

  form({required this.poReceiveNo});

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<form> {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update successful')),
      );
    } else {
      print('Failed to update: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: ${response.statusCode}')),
      );
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
        builder: (context) => GridPage(poReceiveNo: receiveNo, poPONO: poNo),
      ),
    );
  }

  List<dynamic> data = [];
  bool isLoading = true;
  String errorMessage = '';

  List<Map<String, dynamic>> cCode = [];
  String? selectedcCode;

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to parse response')),
        );
      }
    } else {
      print('Failed to cancel: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel: ${response.statusCode}')),
      );
    }
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$poMessage')),
          );
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                builder: (context) => CardTest(),
                              ));
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error occurred: $error')),
                              );
                            });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Page'), automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showCancelDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('ยกเลิก', style: TextStyle(color: Colors.white)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: poNoController,
                  decoration: InputDecoration(
                      labelText: 'PO No', filled: true, fillColor: Colors.grey),
                  readOnly: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: receiveNoController,
                  decoration: InputDecoration(
                      labelText: 'Receive No',
                      filled: true,
                      fillColor: Colors.grey),
                  readOnly: true,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: TextFormField(
                controller: erpReceiveNoController,
                decoration: InputDecoration(
                    labelText: 'ERP Receive No',
                    filled: true,
                    fillColor: Colors.grey),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: crDateController,
                  decoration: InputDecoration(
                      labelText: 'CR Date',
                      filled: true,
                      fillColor: Colors.grey),
                  readOnly: true,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                value: selectedPoType,
                items: poType.map<DropdownMenuItem<String>>((dynamic value) {
                  return DropdownMenuItem<String>(
                    value: value['po_type_code'],
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        value['po_type_code'],
                        overflow: TextOverflow.ellipsis,
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
                decoration: InputDecoration(labelText: 'PO Type Code'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: receiveDateController,
                  decoration: InputDecoration(labelText: 'Receive Date'),
                  readOnly: true,
                  onTap: () => _selectReceiveDate(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: wareCodeController,
                  decoration: InputDecoration(
                      labelText: 'Ware Code',
                      filled: true,
                      fillColor: Colors.grey),
                  readOnly: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: crByController,
                  decoration: InputDecoration(
                      labelText: 'CR By', filled: true, fillColor: Colors.grey),
                  readOnly: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: invoiceNoController,
                  decoration: InputDecoration(labelText: 'Invoice No'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: invoiceDateController,
                  decoration: InputDecoration(labelText: 'Invoice Date'),
                  readOnly: true,
                  onTap: () => _selectInvoiceDate(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: sellerController,
                  decoration: InputDecoration(
                      labelText: 'Seller',
                      filled: true,
                      fillColor: Colors.grey),
                  readOnly: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: poRemarkController,
                  decoration: InputDecoration(labelText: 'PO Remark'),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                _updateForm();
                fetchPoStatus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
