import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/SSINDT01/SSINDT01_main.dart';
import 'package:wms_android/SSINDT01/SSINDT01_grid_data.dart';
import 'package:wms_android/styles.dart';
import 'SSINDT01_WARE.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;

class Ssindt01Form extends StatefulWidget {
  final String poReceiveNo;
  final String pWareCode;
  final String pWareName;
  final String p_ou_code;

  Ssindt01Form({
    required this.poReceiveNo,
    required this.pWareCode,
    required this.pWareName,
    required this.p_ou_code,
  });

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

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _CcodeController = TextEditingController();
  bool checkUpdateData = false;
  bool check = false;
  void checkIfHasData() {
    setState(() {
      if (poNoController.text.isNotEmpty ||
          receiveNoController.text.isNotEmpty ||
          erpReceiveNoController.text.isNotEmpty ||
          pkWareCodeController.text.isNotEmpty ||
          poTypeCodeController.text.isNotEmpty ||
          receiveDateController.text.isNotEmpty ||
          wareCodeController.text.isNotEmpty ||
          _searchController.text.isNotEmpty ||
          crByController.text.isNotEmpty ||
          invoiceNoController.text.isNotEmpty ||
          _CcodeController.text.isNotEmpty) {
        check = true;
        print(check);
      } else {
        check = false;
        print(check);
      }
    });
  }

  final DateFormat displayFormat = DateFormat("dd/MM/yyyy");
  final DateFormat apiFormat = DateFormat("MM/dd/yyyy");

  final _formKey = GlobalKey<FormState>();

  bool isDateValid = true;
  bool isInvoiceDateValid = true;

  List<dynamic> poType = [];
  String? selectedPoType;

  @override
  void initState() {
    super.initState();
    fetchReceiveHeadData(widget.poReceiveNo);
    fetchwhpoType();
    cancelCode();
    print('============================');
    print(wareCode);
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
        'http://172.16.0.82:8888/apex/wms/c/chk_valid_inhead/${widget.poReceiveNo}/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}';
    try {
      print(url);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (mounted) {
          setState(() {
            poStatus = responseBody['po_status'];
            poMessage = responseBody['po_message'];
            print('po_status: $poStatus');
            print('po_message: $poMessage');
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('$poMessage')),
            // );
          });
        }
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          poStatus = 'Error';
          poMessage = e.toString();
        });
      }
    }
  }

  Future<void> fetchwhpoType() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/PO_TYPE'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        if (mounted) {
          setState(() {
            poType = jsonData['items'];
          });
        }
        print(poType);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
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

  Future<void> fetchReceiveHeadData(String receiveNo) async {
    final String apiUrl =
        "http://172.16.0.82:8888/apex/wms/c/formtest/$receiveNo";

    final Map<String, String> queryParams = {
      'RECEIVE_NO': receiveNo,
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    try {
      final http.Response response = await http.get(uri);
      print(apiUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          if (mounted) {
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
                  ? displayFormat.format(apiFormat.parse(crDate))
                  : '';
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
          }
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
        if (mounted) {
          setState(() {
            cCode = (jsonData['items'] as List)
                .map((item) => item as Map<String, dynamic>)
                .toList();

            // selectedcCode = cCode.isNotEmpty ? cCode[0]['r'] : null;
            print('selectedcCode $selectedcCode');
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  String? pomsg;
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
        'APP_USER': gb.APP_USER,
        'p_ou': gb.P_ERP_OU_CODE,
        'p_erp_ou': gb.P_ERP_OU_CODE,
      }),
    );

    print('Cancel form with data: ${jsonEncode({
          'v_rec': widget.poReceiveNo,
          'v_cancel': selectedcCode,
          'APP_USER': gb.APP_USER,
          'p_ou': gb.P_OU_CODE,
          'p_erp_ou': gb.P_ERP_OU_CODE,
        })}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        poStatus = responseData['po_status'] ?? 'Unknown';
        pomsg = responseData['po_message'] ?? 'Unknown';
        print('po_status: $poStatus');
        print('po_message: $pomsg');
      } catch (e) {
        print('Error parsing response: $e');
      }
    } else {
      print('Failed to cancel: ${response.statusCode}');
    }
  }

  void _showDialog() {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'เลือกเหตุยกเลิก', // Title for the dialog
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหา', // Search hint
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black), // Black border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black), // Black border when focused
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black), // Black border when enabled
                        ),
                      ),
                      onChanged: (query) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cCode.length,
                        itemBuilder: (context, index) {
                          final item = cCode[index];
                          final code = item['r']?.toString() ?? 'No code';
                          final description =
                              item['d']?.toString() ?? 'No description';

                          // Filter based on search query
                          if (_searchController.text.isNotEmpty &&
                              !code.toLowerCase().contains(
                                  _searchController.text.toLowerCase()) &&
                              !description.toLowerCase().contains(
                                  _searchController.text.toLowerCase())) {
                            return SizedBox
                                .shrink(); // Filter out non-matching items
                          }

                          return ListTile(
                            title: SingleChildScrollView(
                              scrollDirection: Axis
                                  .horizontal, // Enable horizontal scrolling
                              child: Text(
                                '$code $description', // Combine code and description
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedcCode = code; // Set selected code
                                final selectedDescription =
                                    description; // Set selected description
                                _CcodeController.text =
                                    '$selectedcCode $selectedDescription'; // Append code and description
                                print('$selectedcCode, $selectedDescription');
                              });
                              Navigator.of(context).pop(); // Close the dialog
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

  void showCancelDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            // width: 600.0,
            height: 250.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Space between text and button
                    children: [
                      Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Add horizontal padding
                  child: GestureDetector(
                    onTap: _showDialog,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _CcodeController,
                        decoration: InputDecoration(
                          labelText: 'สาเหตุยกเลิก',
                          filled: true,
                          fillColor: Colors.white,
                          // Add black border to TextField
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black), // Black border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.black), // Black border when focused
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.black), // Black border when enabled
                          ),
                          labelStyle: TextStyle(color: Colors.black),
                          suffixIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Color.fromARGB(255, 113, 113, 113),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () async {
                          await cancel_from(selectedcCode ?? '');
                          if (selectedcCode == null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons
                                            .notification_important, // Use the bell icon
                                        color:
                                            Colors.red, // Set the color to red
                                      ),
                                      SizedBox(
                                          width:
                                              8), // Add some space between the icon and the text
                                      Text('แจ้งเตือน'), // Title text
                                    ],
                                  ),
                                  content: Text('$pomsg'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
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
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons
                                            .notification_important, // Use the bell icon
                                        color:
                                            Colors.red, // Set the color to red
                                      ),
                                      SizedBox(
                                          width:
                                              8), // Add some space between the icon and the text
                                      Text('แจ้งเตือน'), // Title text
                                    ],
                                  ),
                                  content: Text('ยกเลิกรายการเสร็จสมบูรณ์'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        cancel_from(selectedcCode!).then((_) {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SSINDT01_MAIN(
                                                pWareCode: widget.pWareCode,
                                                pWareName: widget.pWareName,
                                                p_ou_code: widget.p_ou_code,
                                                selectedValue: 'ทั้งหมด',
                                                apCode: 'ทั้งหมด',
                                                documentNumber: 'null',
                                              ),
                                            ),
                                          );
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(parentContext)
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final String updDateForm = DateFormat('MM/dd/yyyy').format(DateTime.now());

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
        'OU_CODE': 'LIK',
        'PO_REMARK': poRemark,
        'RECEIVE_DATE': receiveDate,
        'INVOICE_DATE': invoiceDate,
        'INVOICE_NO': invoiceNo,
        'PO_TYPE_CODE': poTypeCode,
        'UPD_BY': gb.APP_USER,
        'UPD_DATE': updDateForm,
      }),
    );

    print('Updating form with data: ${jsonEncode({
          'RECEIVE_NO': receiveNo,
          'PO_REMARK': poRemark,
          'RECEIVE_DATE': receiveDate,
          'INVOICE_DATE': invoiceDate,
          'INVOICE_NO': invoiceNo,
          'PO_TYPE_CODE': poTypeCode,
          'UPD_BY': gb.APP_USER,
          'UPD_DATE': updDateForm,
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
      if (mounted) {
        setState(() {
          invoiceDate = apiFormat.format(picked);
          invoiceDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          isInvoiceDateValid = true;
        });
      }
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
      if (mounted) {
        setState(() {
          receiveDate = apiFormat.format(picked);
          receiveDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          isDateValid = true; // Add this line to set isDateValid to true
        });
      }
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.notification_important, // Use the bell icon
                  color: Colors.red, // Set the color to red
                ),
                SizedBox(
                    width: 8), // Add some space between the icon and the text
                Text('แจ้งเตือน'), // Title text
              ],
            ),
            content: Text(
                'ต้องระบุเลขที่ใบกำกับ (invoice) และวันที่ตามใบกำกับ-แจ้งหนี้ ของผู้ขายให้ครบถ้วน'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    await updateForm_REMARK(
        receiveNo, poRemark, receiveDate, invoiceDate, invoiceNo, poTypeCode);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Ssindt01Grid(
          poReceiveNo: receiveNo,
          poPONO: poNo,
          pWareCode: widget.pWareCode,
          pWareName: widget.pWareName,
          p_ou_code: widget.p_ou_code,
        ),
      ),
    );
  }

  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 21, 59, 1),
      appBar: CustomAppBar(
          title: 'รับจากการสั่งซื้อ', showExitWarning: checkUpdateData),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: AppStyles.cancelButtonStyle(),
                    onPressed: _isButtonDisabled
                        ? null // Disable the button when it is pressed
                        : () {
                            showCancelDialog(context);
                          },
                    child: Text('ยกเลิก',
                        style: AppStyles.CancelbuttonTextStyle()),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: AppStyles.NextButtonStyle(),
                    onPressed: _isButtonDisabled
                        ? null // Disable the button when it is pressed
                        : () async {
                            if (isDateValid == false) {
                              return;
                            }

                            setState(() {
                              _isButtonDisabled = true;
                            });

                            try {
                              await fetchPoStatus(); // async operation
                              _updateForm();
                            } finally {
                              setState(() {
                                _isButtonDisabled =
                                    false; // Re-enable after operation
                              });
                            }
                          },
                    child: Image.asset(
                      'assets/images/right.png',
                      width: 20,
                      height: 20,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildFormFields(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }

  Widget _buildFormFields() {
    return Container(
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
              label: Row(
                children: [
                  const Text(
                    'เลขที่อ้างอิง (PO)',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 2), // Add a small space
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red, // Change asterisk color to red
                    ),
                  ),
                ],
              ),
              border: InputBorder.none,
            ),
            readOnly: true,
          ),
          const SizedBox(height: 8.0),
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
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height *
                                  0.7, // 70% of screen height
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'เลือกประเภทการรับ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Optional: Search field for filtering items
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
                                  child: Builder(
                                    builder: (context) {
                                      // Create a filtered list of items
                                      final filteredItems =
                                          poType.where((item) {
                                        final poTypeCode = item['po_type_code']
                                            .toString()
                                            .toLowerCase(); // Convert to lowercase
                                        final searchQuery = _searchController
                                            .text
                                            .trim()
                                            .toLowerCase(); // Convert to lowercase
                                        return poTypeCode.contains(searchQuery);
                                      }).toList();

                                      // Check if filtered items are empty
                                      if (filteredItems.isEmpty) {
                                        return Center(
                                          child: Text(
                                            'Data Not Found',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                          ),
                                        );
                                      }

                                      return ListView.builder(
                                        itemCount: filteredItems.length,
                                        itemBuilder: (context, index) {
                                          final item = filteredItems[index];
                                          final poTypeCode = item[
                                                  'po_type_code']
                                              .toString(); // Keep original case for display

                                          return ListTile(
                                            title: Text(
                                              poTypeCode,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                selectedPoType = poTypeCode;
                                                print(selectedPoType);
                                                poTypeCodeController.text =
                                                    poTypeCode;
                                                print(
                                                    poTypeCodeController.text);
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
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    label: Row(
                      children: [
                        const Text(
                          'ประเภทการรับ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 2), // Add a small space
                      ],
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 113, 113, 113),
                    ),
                  ),
                  controller: poTypeCodeController,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: receiveDateController,
            decoration: InputDecoration(
              label: Row(
                children: [
                  const Text(
                    'วันที่ตรวจรับ',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              hintText: 'DD/MM/YYYY',
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.black),
                onPressed: () {
                  _selectReceiveDate(context);
                },
              ),
            ),
            style: TextStyle(
              color: Colors.black,
            ),
            readOnly: false,
            onChanged: (value) {
              // Store the current cursor position and previous text
              final previousText = receiveDateController.text;
              final cursorPosition = receiveDateController.selection.start;
              final isDeleting = value.length < previousText.length;

              // Remove any non-digit characters
              String numbersOnly = value.replaceAll(RegExp(r'[^\d]'), '');

              // Handle deletion specifically
              if (isDeleting) {
                // If deleting at a slash position (position 2 or 5), move cursor back one more
                if (cursorPosition == 3 || cursorPosition == 6) {
                  numbersOnly = previousText
                          .replaceAll('/', '')
                          .substring(0, cursorPosition - 2) +
                      previousText
                          .replaceAll('/', '')
                          .substring(cursorPosition - 1);
                } else {
                  // Normal deletion
                  numbersOnly = previousText
                          .replaceAll('/', '')
                          .substring(0, cursorPosition - 1) +
                      previousText
                          .replaceAll('/', '')
                          .substring(cursorPosition);
                }
              }

              // Limit to 8 digits
              if (numbersOnly.length > 8) {
                numbersOnly = numbersOnly.substring(0, 8);
              }

              // Format the date string with slashes
              String formattedValue = '';
              for (int i = 0; i < numbersOnly.length; i++) {
                if (i == 2 || i == 4) {
                  formattedValue += '/';
                }
                formattedValue += numbersOnly[i];
              }

              // Calculate new cursor position
              int newCursorPosition = cursorPosition;

              if (isDeleting) {
                // When deleting, move cursor back appropriately
                if (cursorPosition == 3 || cursorPosition == 6) {
                  newCursorPosition = cursorPosition - 1;
                } else {
                  newCursorPosition = cursorPosition - 1;
                }
              } else {
                // When adding numbers
                if (numbersOnly.length >= 2 && cursorPosition > 2) {
                  newCursorPosition++;
                }
                if (numbersOnly.length >= 4 && cursorPosition > 5) {
                  newCursorPosition++;
                }
              }

              // Ensure cursor position is within bounds
              if (newCursorPosition < 0) {
                newCursorPosition = 0;
              }
              if (newCursorPosition > formattedValue.length) {
                newCursorPosition = formattedValue.length;
              }

              // Validate date if complete
              if (numbersOnly.length == 8) {
                try {
                  final day = int.parse(numbersOnly.substring(0, 2));
                  final month = int.parse(numbersOnly.substring(2, 4));
                  final year = int.parse(numbersOnly.substring(4, 8));

                  final date = DateTime(year, month, day);

                  if (date.year == year &&
                      date.month == month &&
                      date.day == day) {
                    setState(() {
                      isDateValid = true;
                    });
                  } else {
                    throw Exception('Invalid date');
                  }
                } catch (e) {
                  setState(() {
                    isDateValid = false;
                  });
                }
              } else {
                setState(() {
                  isDateValid = false;
                });
              }

              // Update controller with formatted value and cursor position
              setState(() {
                receiveDateController.value = TextEditingValue(
                  text: formattedValue,
                  selection: TextSelection.collapsed(offset: newCursorPosition),
                );
              });
            },
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          isDateValid == false
              ? const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                    controller: invoiceNoController,
                    decoration: InputDecoration(
                      label: Row(
                        children: [
                          const Text(
                            'เลขที่ใบแจ้งหนี้',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(width: 2), // Add a small space
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกเลขที่ใบแจ้งหนี้';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        checkUpdateData = true;
                      });
                      print('=======================');
                      print(checkUpdateData);
                    }),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: invoiceDateController,
            decoration: InputDecoration(
              label: Row(
                children: [
                  const Text(
                    'วันที่ใบแจ้งหนี้',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(width: 2), // Add a small space
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'DD/MM/YYYY',
              border: InputBorder.none,
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.black),
                onPressed: () {
                  _selectInvoiceDate(context); // Function to open date picker
                },
              ),
            ),
            style: TextStyle(
              color: Colors.black,
            ),
            readOnly: false,
            onChanged: (value) {
              setState(() {
                checkUpdateData = true;
              });
              // Remove all non-numeric characters (slashes)
              String numbersOnly = value.replaceAll('/', '');

              // Limit the number of digits to 8 (for DDMMYYYY)
              if (numbersOnly.length > 8) {
                numbersOnly = numbersOnly.substring(0, 8);
              }

              // Format the string into DD/MM/YYYY
              String formattedDate = '';
              for (int i = 0; i < numbersOnly.length; i++) {
                if (i == 2 || i == 4) {
                  formattedDate += '/'; // Add slashes after DD and MM
                }
                formattedDate += numbersOnly[i];
              }

              // Update the text field with the formatted date and move cursor to the end
              invoiceDateController.value = TextEditingValue(
                text: formattedDate,
                selection:
                    TextSelection.collapsed(offset: formattedDate.length),
              );

              // Validate the date if the length is correct (DD/MM/YYYY = 10 characters)
              bool isValidDate = false;
              if (numbersOnly.length == 8) {
                try {
                  final day = int.parse(numbersOnly.substring(0, 2));
                  final month = int.parse(numbersOnly.substring(2, 4));
                  final year = int.parse(numbersOnly.substring(4, 8));

                  final date = DateTime(year, month, day);
                  // Check if the date is valid
                  if (date.year == year &&
                      date.month == month &&
                      date.day == day) {
                    isValidDate = true;
                  }
                } catch (e) {
                  isValidDate = false;
                }
              }

              setState(() {
                isInvoiceDateValid = isValidDate;
              });
            },
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
              LengthLimitingTextInputFormatter(
                  10), // Limit to 10 characters (DD/MM/YYYY)
            ],
          ),
          isInvoiceDateValid == false
              ? const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 8.0),
          TextFormField(
            onChanged: (value) {
              setState(() {
                checkUpdateData = true;
              });
              print('=======================');
              print(checkUpdateData);
            },
            controller: poRemarkController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'หมายเหตุ'),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                  controller: sellerController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(224, 224, 224, 1),
                    labelText: 'ผู้ขาย',
                    labelStyle: const TextStyle(
                      color: Colors.black87,
                    ),
                    border: InputBorder.none,
                  ),
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextFormField(
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
                    border: InputBorder.none,
                  ),
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            style: const TextStyle(
              color: Colors.black87,
            ),
            controller: receiveNoController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              label: Row(
                children: [
                  const Text(
                    'เลขที่เอกสาร WMS',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 2), // Add a small space
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red, // Change asterisk color to red
                    ),
                  ),
                ],
              ),
              labelStyle: const TextStyle(
                color: Colors.black87,
              ),
              border: InputBorder.none,
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
              border: InputBorder.none,
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              // Add your custom logic when the TextFormField is tapped
              print("TextFormField tapped");
              // You can also open a dialog, navigate to another screen, etc.
            },
            child: AbsorbPointer(
              child: TextFormField(
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
                  // floatingLabelBehavior: FloatingLabelBehavior
                  //     .always, // Prevents the label from shrinking
                  border: InputBorder.none,
                ),
                readOnly: true, // To keep it read-only
              ),
            ),
          ),
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
              border: InputBorder.none,
            ),
            readOnly: true,
          ),
        ],
      ),
    );
  }
}
