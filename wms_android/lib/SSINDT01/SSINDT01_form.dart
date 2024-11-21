import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/SSINDT01/SSINDT01_main.dart';
import 'package:wms_android/SSINDT01/SSINDT01_grid_data.dart';
import 'package:wms_android/styles.dart';
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
        '${gb.IP_API}/apex/wms/SSINDT01/Step_2_chk_valid_inhead/${widget.poReceiveNo}/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}';

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
          .get(Uri.parse('${gb.IP_API}/apex/wms/SSINDT01/Step_2_PO_TYPE'));

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

  Future<void> fetchReceiveHeadData(String receiveNo) async {
    final String apiUrl =
        "${gb.IP_API}/apex/wms/SSINDT01/Step_2_formtest/$receiveNo/${gb.P_ERP_OU_CODE}";

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
              crDateController.text = crDate;
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
          Uri.parse('${gb.IP_API}/apex/wms/SSINDT01/Step_2_cancel_from_list'));

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
    final url = Uri.parse('${gb.IP_API}/apex/wms/SSINDT01/Step_2_cancel_from');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'V_REC': widget.poReceiveNo,
        'V_CANCEL': selectedcCode,
        'APP_USER': gb.APP_USER,
        'P_OU': gb.P_ERP_OU_CODE,
        'P_ERP_OU': gb.P_ERP_OU_CODE,
      }),
    );
    print('Selected code before sending: $selectedcCode');

    print('Cancel form with data: ${jsonEncode({
          'V_REC': widget.poReceiveNo,
          'V_CANCEL': selectedcCode,
          'APP_USER': gb.APP_USER,
          'P_OU': gb.P_OU_CODE,
          'P_ERP_OU': gb.P_ERP_OU_CODE,
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

//ค้นหาสาเหตุการยกเลิก
  void searchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.customLovSearchDialog(
          context: context,
          headerText: 'เลือกสาเหตุการยกเลิก',
          searchController: _searchController,
          data: cCode,
          docString: (item) {
            // Define how to extract search text from each item
            return '${item['r']?.toString() ?? ''} ${item['d']?.toString() ?? ''}';
          },
          titleText: (item) {
            // Define the main text to display in ListTile
            return item['r']?.toString() ?? 'No code';
          },
          subtitleText: (item) {
            // Define the subtitle text to display in ListTile
            return item['d']?.toString() ?? 'No description';
          },
          onTap: (item) {
            // Handle item selection
            selectedcCode =
                item['r']?.toString() ?? ''; // Update selectedcCode here
            final selectedDescription = item['d']?.toString() ?? '';
            _CcodeController.text = '$selectedcCode $selectedDescription';
            print('$selectedcCode, $selectedDescription');
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  bool isDialogShowing = false;
// สาเหตุการยกเลิก
  void showCancelDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return DialogStyles.cancelDialog(
          context: context,
          controller: _CcodeController,
          // cancel button
          onCloseDialog: () {
            Navigator.of(context).pop();
          },
          onTap: searchDialog, // Open search dialog
          // OK button
          onConfirmDialog: () async {
            if (isDialogShowing) return;

            setState(() {
              isDialogShowing =
                  true; // Set flag to true when a dialog is about to be shown
            });
            await cancel_from(selectedcCode ?? '');
            if (selectedcCode == null) {
              setState(() {
                isDialogShowing =
                    false; // Reset the flag when the first dialog is closed
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogStyles.alertMessageDialog(
                    context: context,
                    content: Text('$pomsg'),
                    onClose: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () async {
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
                  return DialogStyles.alertMessageDialog(
                    context: context,
                    content: Text('ยกเลิกรายการเสร็จสมบูรณ์'),
                    onClose: () {
                      Navigator.of(context).pop(); // Close dialog on close
                    },
                    onConfirm: () async {
                      await cancel_from(selectedcCode!).then((_) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(
                          MaterialPageRoute(
                            builder: (context) => SSINDT01_MAIN(
                              pWareCode: widget.pWareCode,
                              pWareName: widget.pWareName,
                              p_ou_code: widget.p_ou_code,
                              selectedValue: 'ทั้งหมด',
                              apCode: 'ทั้งหมด',
                              documentNumber: 'null',
                            ),
                          ),
                        );
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('An error occurred: $error'),
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
      _CcodeController.clear();
    });
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
        Uri.parse('${gb.IP_API}/apex/wms/SSINDT01/Step_2_UP_FORM_PO_REMARK');
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
        'UPD_BY': gb.APP_USER,
        'UPD_DATE': updDateForm,
        'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
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
          'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
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
          receiveDate = apiFormat.format(picked);
          receiveDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          isDateValid = true;
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
          return DialogStyles.alertMessageDialog(
            context: context,
            content: Text(
                'ต้องระบุเลขที่ใบกำกับ (invoice) และวันที่ตามใบกำกับ-แจ้งหนี้ ของผู้ขายให้ครบถ้วน'),
            onClose: () {
              Navigator.of(context).pop();
            },
            onConfirm: () async {
              // await fetchPoStatusconform(vReceiveNo);
              Navigator.of(context).pop();
            },
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
      // backgroundColor: Color.fromRGBO(23, 21, 59, 1),
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
                            if (isDateValid == false ||
                                isInvoiceDateValid == false) {
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
                    return DialogStyles.customLovSearchDialog(
                      context: context,
                      headerText: 'เลือกประเภทการรับ',
                      searchController: _searchController,
                      data: poType,
                      docString: (item) => item['po_type_code'].toString(),
                      titleText: (item) => item['po_type_code'].toString(),
                      subtitleText: (item) =>
                          '', // You can add a subtitle if needed
                      // subtitleText: (item) => item['po_type_desc'].toString(),
                      onTap: (item) {
                        final poTypeCode = '${item['po_type_code'] ?? ''}';
                        Navigator.of(context).pop();
                        setState(() {
                          selectedPoType = poTypeCode;
                          print(selectedPoType);
                          poTypeCodeController.text = selectedPoType ?? '';
                          print(poTypeCodeController.text);
                        });
                      },
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
                  controller: poTypeCodeController.text.isNotEmpty
                  ? poTypeCodeController
                  :TextEditingController(
                                              text: selectedPoType),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: receiveDateController,
            decoration: InputDecoration(
              label: RichText(
                text: TextSpan(
                  text: 'วันที่ตรวจรับ', // ชื่อ label
                  style: isDateValid == false
                      ? const TextStyle(color: Colors.red)
                      : const TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: ' *', // เพิ่มเครื่องหมาย *
                      style: TextStyle(
                        color: Colors.red, // สีแดงสำหรับ *
                      ),
                    ),
                  ],
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'DD/MM/YYYY',
              border: InputBorder.none,
              labelStyle: TextStyle(color: Colors.black),
              hintStyle: TextStyle(color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.black),
                onPressed: () => _selectReceiveDate(context),
              ),
            ),
            style: TextStyle(color: Colors.black),
            readOnly: false,
            onChanged: (value) {
              setState(() {
                checkUpdateData = true;
              });

              // Get current cursor position and text
              final cursorPosition = receiveDateController.selection.start;
              final text = value.replaceAll('/', '');

              // Handle backspace/delete
              if (value.length < receiveDateController.text.length) {
                String newText = receiveDateController.text.replaceAll('/', '');
                if (cursorPosition > 0) {
                  newText = newText.substring(0, cursorPosition - 1) +
                      newText.substring(cursorPosition);
                }

                // Format the date with slashes
                String formattedText = '';
                for (int i = 0; i < newText.length; i++) {
                  if (i == 2 || i == 4) formattedText += '/';
                  formattedText += newText[i];
                }

                // Calculate new cursor position
                int newPosition = cursorPosition - 1;
                if (newPosition > 2) newPosition++;
                if (newPosition > 5) newPosition++;
                if (newPosition > formattedText.length) {
                  newPosition = formattedText.length;
                }

                receiveDateController.value = TextEditingValue(
                  text: formattedText,
                  selection: TextSelection.collapsed(offset: newPosition),
                );
                return;
              }

              // Format new input
              String formattedText = '';
              String numbers = text.replaceAll(RegExp(r'[^\d]'), '');

              if (numbers.length > 8) numbers = numbers.substring(0, 8);

              for (int i = 0; i < numbers.length; i++) {
                if (i == 2 || i == 4) formattedText += '/';
                formattedText += numbers[i];
              }

              // Calculate new cursor position
              int newPosition = cursorPosition;
              if (cursorPosition >= 2 && formattedText.length > 2)
                newPosition++;
              if (cursorPosition >= 5 && formattedText.length > 5)
                newPosition++;
              if (newPosition > formattedText.length) {
                newPosition = formattedText.length;
              }

              // Validate date if complete
              if (numbers.length == 8) {
                try {
                  final day = int.parse(numbers.substring(0, 2));
                  final month = int.parse(numbers.substring(2, 4));
                  final year = int.parse(numbers.substring(4, 8));
                  final date = DateTime(year, month, day);
                  setState(() {
                    isDateValid = date.year == year &&
                        date.month == month &&
                        date.day == day;
                  });
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

              // Update text field
              receiveDateController.value = TextEditingValue(
                text: formattedText,
                selection: TextSelection.collapsed(offset: newPosition),
              );
            },
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
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
              label: RichText(
                text: TextSpan(
                  text: 'วันที่ใบแจ้งหนี้', // ชื่อ label
                  style: isInvoiceDateValid == false
                      ? const TextStyle(color: Colors.red)
                      : const TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: ' *', // เพิ่มเครื่องหมาย *
                      style: TextStyle(
                        color: Colors.red, // สีแดงสำหรับ *
                      ),
                    ),
                  ],
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'DD/MM/YYYY',
              border: InputBorder.none,
              labelStyle: TextStyle(color: Colors.black),
              hintStyle: TextStyle(color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.black),
                onPressed: () => _selectInvoiceDate(context),
              ),
            ),
            style: TextStyle(color: Colors.black),
            readOnly: false,
            onChanged: (value) {
              setState(() {
                checkUpdateData = true;
              });

              // Get current cursor position and text
              final cursorPosition = invoiceDateController.selection.start;
              final text = value.replaceAll('/', '');

              // Handle backspace/delete
              if (value.length < invoiceDateController.text.length) {
                String newText = invoiceDateController.text.replaceAll('/', '');
                if (cursorPosition > 0) {
                  newText = newText.substring(0, cursorPosition - 1) +
                      newText.substring(cursorPosition);
                }

                // Format the date with slashes
                String formattedText = '';
                for (int i = 0; i < newText.length; i++) {
                  if (i == 2 || i == 4) formattedText += '/';
                  formattedText += newText[i];
                }

                // Calculate new cursor position
                int newPosition = cursorPosition - 1;
                if (newPosition > 2) newPosition++;
                if (newPosition > 5) newPosition++;
                if (newPosition > formattedText.length) {
                  newPosition = formattedText.length;
                }

                invoiceDateController.value = TextEditingValue(
                  text: formattedText,
                  selection: TextSelection.collapsed(offset: newPosition),
                );
                return;
              }

              // Format new input
              String formattedText = '';
              String numbers = text.replaceAll(RegExp(r'[^\d]'), '');

              if (numbers.length > 8) numbers = numbers.substring(0, 8);

              for (int i = 0; i < numbers.length; i++) {
                if (i == 2 || i == 4) formattedText += '/';
                formattedText += numbers[i];
              }

              // Calculate new cursor position
              int newPosition = cursorPosition;
              if (cursorPosition >= 2 && formattedText.length > 2)
                newPosition++;
              if (cursorPosition >= 5 && formattedText.length > 5)
                newPosition++;
              if (newPosition > formattedText.length) {
                newPosition = formattedText.length;
              }

              // Validate date if complete
              if (numbers.length == 8) {
                try {
                  final day = int.parse(numbers.substring(0, 2));
                  final month = int.parse(numbers.substring(2, 4));
                  final year = int.parse(numbers.substring(4, 8));
                  final date = DateTime(year, month, day);
                  setState(() {
                    isInvoiceDateValid = date.year == year &&
                        date.month == month &&
                        date.day == day;
                  });
                } catch (e) {
                  setState(() {
                    isInvoiceDateValid = false;
                  });
                }
              } else {
                setState(() {
                  isInvoiceDateValid = false;
                });
              }

              // Update text field
              invoiceDateController.value = TextEditingValue(
                text: formattedText,
                selection: TextSelection.collapsed(offset: newPosition),
              );
            },
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
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
                // floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'หมายเหตุ'),
            minLines: 1,
            maxLines: 5,
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
              const SizedBox(width: 8),
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
          const SizedBox(height: 8),
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
          const SizedBox(height: 8),
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
                  ),// Prevents the label from shrinking
                  border: InputBorder.none,
                ),
                readOnly: true, // To keep it read-only
              ),
            ),
          ),
          const SizedBox(height: 8),
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
