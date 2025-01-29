import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../TextFormFieldCheckDate.dart';

// LOT DETAILS
class LotDialog extends StatefulWidget {
  final String item;
  final String itemDesc;
  final String ouCode;
  final String recSeq;
  final String poReceiveNo;
  final String poPONO;
  final String lotQTY;
  final String lotSize;
  final String rowid;
  final String lotSupp;

  LotDialog({
    required this.item,
    required this.itemDesc,
    required this.ouCode,
    required this.recSeq,
    required this.poReceiveNo,
    required this.poPONO,
    required this.lotQTY,
    required this.lotSize,
    required this.rowid,
    required this.lotSupp,
  });

  @override
  _LotDialogState createState() => _LotDialogState();
}

class _LotDialogState extends State<LotDialog> {
  TextEditingController lotCountController = TextEditingController();
  TextEditingController lotSupplierController = TextEditingController();
  String? poStatus;
  String? poMessage;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> dataLotList = [];
  int itemsPerPage = 5;
  int currentPage = 1;
  int totalItems = 0;
  List<Map<String, dynamic>> paginatedLotList = [];
  DateTime? selectedDate;
  final ValueNotifier<bool> isDateInvalidNotifier = ValueNotifier<bool>(false);

  // Add these methods for pagination control
  void updatePaginatedLotList() {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, dataLotList.length);
    setState(() {
      paginatedLotList = dataLotList.sublist(startIndex, endIndex);
    });
  }

  void _loadNextPage() {
    if (currentPage < (dataLotList.length / itemsPerPage).ceil()) {
      setState(() {
        currentPage++;
        updatePaginatedLotList();
      });
      _scrollToTop();
    }
  }

  void _loadPrevPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        updatePaginatedLotList();
      });
      _scrollToTop();
    }
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0); // เลื่อนไปยังตำแหน่งเริ่มต้น (index 0)
    }
  }

  String _getPageIndicatorText() {
    if (paginatedLotList.isEmpty) {
      return ''; // Return an empty
    }
    int startIndex = ((currentPage - 1) * itemsPerPage) + 1;
    int endIndex = startIndex + paginatedLotList.length - 1;
    return '$startIndex - $endIndex';
  }

  @override
  void initState() {
    super.initState();
    print('poReceiveNo: ${widget.poReceiveNo}');
    print('poPONO: ${widget.poPONO}');
    getLotList(widget.poReceiveNo, widget.recSeq);
    sendGetRequestlineWMS();
    print('======================================');
    print(widget.ouCode);
    lotCountController.text = widget.lotQTY == '' ? '0' : widget.lotQTY;
  }

  Future<void> genLot(
    String v_WMS_NO,
    String v_PO_NO,
    String v_rec_seq,
    String v_lot_qty,
    String v_lot_size,
    String v_rowid,
    String v_supp,
  ) async {
    final url = '${gb.IP_API}/apex/wms/SSINDT01/Test_gen_lot';
    final headers = {'Content-Type': 'application/json'};
    print(url);
    final body = jsonEncode({
      'v_WMS_NO': v_WMS_NO,
      'v_PO_NO': v_PO_NO,
      'v_rec_seq': v_rec_seq,
      'v_lot_qty': v_lot_qty,
      'v_lot_size': v_lot_size,
      'v_rowid': v_rowid,
      'v_supp': v_supp,
      'P_OU_CODE': gb.P_OU_CODE,
      'APP_USER': gb.APP_USER,
    });
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      print(body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          print('v_WMS_NO : $v_WMS_NO');
          print('v_PO_NO : $v_PO_NO');
          print('v_rec_seq : $v_rec_seq');
          print('v_lot_qty : $v_lot_qty');
          print('v_lot_size : $v_lot_size');
          print('v_rowid : $v_rowid');
          print('v_supp : $v_supp');
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];
        });

        AlertDialog(
          title: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Space between text and button
            children: [
              Icon(
                Icons.notification_important, // Use the bell icon
                color: Colors.red, // Set the color to red
              ),
              SizedBox(width: 8),
              Text(
                'แจ้งเตือน',
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
          content: Text(poMessage ?? ''),
          actions: <Widget>[
            TextButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );

        // Call sendGetRequestlineWMS after successfully generating lot
        await sendGetRequestlineWMS();
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateOkLot(
    String v_rec_no,
    String v_rec_seq,
  ) async {
    final url =
        Uri.parse('${gb.IP_API}/apex/wms/SSINDT01/Step_3_update_ok_lot');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'v_rec_no': v_rec_no,
        'v_rec_seq': v_rec_seq,
        'p_ou': gb.P_OU_CODE,
        'p_erp_ou': gb.P_ERP_OU_CODE,
        'app_user': gb.APP_USER,
      }),
    );

    print('Updating form with data: ${jsonEncode({
          'v_rec_no': v_rec_no,
          'v_rec_seq': v_rec_seq,
          'p_ou': gb.P_OU_CODE,
          'p_erp_ou': gb.P_ERP_OU_CODE,
          'app_user': gb.APP_USER,
        })}');

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  Future<void> postLot(String poReceiveNo, String recSeq) async {
    final url = '${gb.IP_API}/apex/wms/SSINDT01/Step_3_add_lot';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_ou': gb.P_ERP_OU_CODE,
      'p_receive_no': poReceiveNo,
      'p_rec_seq': recSeq,
      'APP_USER': gb.APP_USER,
    });
    print('Request body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('Response status code: ${response.statusCode}'); // Debug line
      print('Response body: ${response.body}'); // Debug line

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          setState(() {
            poStatus = responseData['po_status'];
            poMessage = responseData['po_message'];
            sendGetRequestlineWMS();
          });
          print('Success: $responseData');
        } else {
          print('Empty response body.');
        }
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getLotList(String poReceiveNo, String recSeq) async {
    final url =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_3_get_lot/$poReceiveNo/$recSeq/${gb.P_ERP_OU_CODE}';
    print(url);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);

        setState(() {
          dataLotList =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          updatePaginatedLotList(); // Update pagination list
        });
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendGetRequestlineWMS() async {
    final url =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_3_pull_po/${widget.poReceiveNo}/${gb.P_ERP_OU_CODE}';
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};

    print('Request URL: $url');

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);

        setState(() {
          dataList =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('Success: $dataList');

        // แสดงจำนวนLOT
        // lotCountController.text = dataLotList.length.toString();
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  final DateFormat displayFormat = DateFormat("dd/MM/yyyy");
  final DateFormat apiFormat = DateFormat("dd/MM/yyyy");

  bool check = false;

  void showDetailsLotDialog(BuildContext context, Map<String, dynamic> item,
      String recSeq, String ou_code, Function refreshCallback) {
    String recNo = widget.poReceiveNo;
    String lotSeq = item['lot_seq']?.toString() ?? '';
    bool isMfgDateValid = true;
    bool check = false;
    // Create a copy of the item map to work with
    Map<String, dynamic> workingItem = Map.from(item);

    TextEditingController lotQtyController =
        TextEditingController(text: workingItem['lot_qty']?.toString() ?? '');
    TextEditingController mfgDateController = TextEditingController();
    TextEditingController lotSupplierController = TextEditingController(
      text: workingItem['lot_supplier']?.toString() ?? '',
    );
    String originalMfgDate = '';
    try {
      if (workingItem['mfg_date'] != null &&
          workingItem['mfg_date'].toString().isNotEmpty) {
        final date = displayFormat.parse(workingItem['mfg_date'].toString());
        mfgDateController.text = displayFormat.format(date);
        originalMfgDate = mfgDateController.text;
      } else {
        item['mfg_date'] = '';
        originalMfgDate = '';
      }
    } catch (e) {
      print('Error parsing initial date: $e');
      mfgDateController.text = '';
      originalMfgDate = '';
    }

    void clearFields() {
      workingItem['lot_qty'] = item['lot_qty'];
      workingItem['lot_supplier'] = item['lot_supplier'];
      workingItem['mfg_date'] = item['mfg_date'];

      lotQtyController.text = item['lot_qty']?.toString() ?? '';
      lotSupplierController.text = item['lot_supplier']?.toString() ?? '';
      mfgDateController.text = originalMfgDate;
      isMfgDateValid = true;
      isDateInvalidNotifier.value = false;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            Widget buildMfgDateField() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: mfgDateController,
                    labelText: 'MFG Date',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      try {
                        selectedDate = DateFormat('dd/MM/yyyy').parse(value);
                      } catch (e) {
                        selectedDate = null; // Set to null if parsing fails
                        print('Invalid date format: $value');
                      }
                      setState(() {
                        check = true;
                      });
                      print('วันที่: $selectedDate');
                    },
                    isDateInvalidNotifier: isDateInvalidNotifier,
                    showBorder:
                        true, // Set to false if you don't want the border
                  ),
                ],
              );
            }

            return Center(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 30.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue: lotSeq,
                                    decoration: InputDecoration(
                                      label: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Seq',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    readOnly: true,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        check = true;
                                        checkUpdateData = true;
                                      });
                                    },
                                    initialValue: item['lot_product_no'] ?? '',
                                    decoration: InputDecoration(
                                      labelText: 'Lot No',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.0),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  check = true;
                                });
                              },
                              controller: lotQtyController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'LOT QTY',
                                labelStyle: TextStyle(
                                  color: Colors.black87,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  checkUpdateData = true;
                                });
                              },
                              controller: lotSupplierController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Lot ผู้ผลิต',
                                labelStyle: TextStyle(
                                  color: Colors.black87,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 16.0),
                            buildMfgDateField(),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: AppStyles
                                      .ConfirmChecRecievekButtonStyle(),
                                  onPressed: isMfgDateValid
                                      ? () async {
                                          if (isDateInvalidNotifier.value) {
                                            isDateInvalidNotifier.value =
                                                true; // แสดงข้อความแจ้งเตือน
                                            return;
                                          }
                                          item['mfg_date'] =
                                              mfgDateController.text;
                                          await updateLot(
                                            lotQtyController.text,
                                            lotSupplierController.text,
                                            mfgDateController.text,
                                            recNo,
                                            recSeq,
                                            lotSeq,
                                          );
                                          sendGetRequestlineWMS();
                                          Navigator.of(context).pop();
                                          if (refreshCallback != '') {
                                            await refreshCallback();
                                          }
                                        }
                                      : null,
                                  child: Image.asset(
                                    'assets/images/check-mark.png',
                                    width: 25.0,
                                    height: 25.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        top: -15.0,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            if (check == true) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogStyles.warningNotSaveDialog(
                                    context: context,
                                    textMessage:
                                        'คุณต้องการออกจากหน้านี้โดยไม่บันทึกหรือไม่?',
                                    onCloseDialog: () {
                                      Navigator.of(context)
                                          .pop(); // Close dialog
                                    },
                                    onConfirmDialog: () {
                                      clearFields(); // Reset to original values
                                      Navigator.of(context)
                                          .pop(); // Close dialog
                                      Navigator.of(context)
                                          .pop(); // Close main screen or perform desired action
                                    },
                                  );
                                },
                              );
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildInfoRow2(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 12,
                          ),
                          softWrap: false,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: TextEditingController(text: entry.value),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 254, 247, 230),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 0,
                          ),
                        ),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.right,
                        readOnly: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow3(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 12,
                          ),
                          softWrap: false,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: TextEditingController(text: entry.value),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 254, 247, 230),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 8,
                          ),
                        ),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                        readOnly: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool isInvoiceDateValid = true;
  String? poreject;
  Future<void> fetchPoStatus(String recSeq) async {
    final url =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_3_check_valid_savelot/${widget.poReceiveNo}/$recSeq/${gb.P_OU_CODE}/${gb.APP_USER}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          poStatus = responseBody['po_status'];
          poMessage = responseBody['po_message'];
          poreject = responseBody['v_type_reject'];
          print('po_status: $poStatus');
          print('po_message: $poMessage');
          print('v_type_reject: $poreject');
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

  Future<void> updateLot(String lot_qty, String lot_supplier, String mfg_date,
      String receiveNo, String rec_seq, String lot_seq) async {
    final url = Uri.parse('${gb.IP_API}/apex/wms/SSINDT01/Step_3_save_lot_det');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'lot_qty': lot_qty,
        'lot_supplier': lot_supplier,
        'mfg_date': mfg_date,
        'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
        'RECEIVE_NO': receiveNo,
        'REC_SEQ': rec_seq,
        'lot_seq': lot_seq,
        // 'APP_USER': gb.APP_USER,
      }),
    );

    print('Updating form with data: ${jsonEncode({
          'lot_qty': lot_qty,
          'lot_supplier': lot_supplier,
          'mfg_date': mfg_date,
          'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
          'RECEIVE_NO': receiveNo,
          'REC_SEQ': rec_seq,
          'lot_seq': lot_seq,
        })}');

    if (response.statusCode == 200) {
      print('Update successful');

      sendGetRequestlineWMS();
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  Future<void> deleteLot(String recNo, String pOu, String recSeq, String PoNo,
      String lotSeq, String PoSeq) async {
    final url = Uri.parse('${gb.IP_API}/apex/wms/SSINDT01/Step_3_del_lot');
    print('recNo $recNo');
    print('pOu $pOu');
    print('recSeq $recSeq');
    print('PoNo $PoNo');
    print('lotSeq $lotSeq');
    print('PoSeq $PoSeq');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'p_receive_no': recNo,
        'p_rec_seq': recSeq,
        'p_po_no': recNo,
        'p_po_seq': PoSeq,
        'p_lot_seq': lotSeq,
        'p_ou': pOu,
        'APP_USER': gb.APP_USER,
      }),
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final responseBody = jsonDecode(response.body);
        final poStatus = responseBody['po_status'];
        final poMessage = responseBody['po_message'];
        print('Status: $poStatus');
        print('Message: $poMessage');
      }

      // Store current page before reloading
      final prevPage = currentPage;
      await getLotList(widget.poReceiveNo, recSeq);

      // Check if current page is empty
      setState(() {
        final startIndex = (prevPage - 1) * itemsPerPage;
        if (startIndex >= dataLotList.length && dataLotList.isNotEmpty) {
          // Move to the last page that has data
          currentPage = ((dataLotList.length - 1) ~/ itemsPerPage) + 1;
        } else {
          currentPage = prevPage; // Stay on the current page
        }
        updatePaginatedLotList();
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Widget _buildDialogButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 2,
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void showCustomDialog(
      BuildContext context, String poReceiveNo, String recSeq, String ouCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageCheckDialog(
          context: context,
          content: Text(
            poMessage.toString(),
          ),
          onClose: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          onConfirm: () async {
            Navigator.pop(context, {
              'status': 'dialog',
              'poReceiveNo': widget.poReceiveNo,
              'recSeq': widget.recSeq,
              'ouCode': widget.ouCode,
            });
            Navigator.of(context).pop();
            await updateOkLot(poReceiveNo, recSeq);
            await sendGetRequestlineWMS();
          },
        );
      },
    );
  }

  final NumberFormat numberFormat = NumberFormat("#,##0");

  get initialDateString => null;

  void _showAlertDialogGenLot(BuildContext context) {
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

  bool checkUpdateData = false;

  @override
  Widget build(BuildContext context) {
    bool hasNextPage = currentPage < (dataLotList.length / itemsPerPage).ceil();
    bool hasPrevPage = currentPage > 1;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'LOT Details',
        showExitWarning: checkUpdateData,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              // OK Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text('SAVE'),
                    onPressed: () async {
                      await fetchPoStatus(widget.recSeq);
                      if (poreject == '1') {
                        showCustomDialog(context, widget.poReceiveNo,
                            widget.recSeq, widget.ouCode);
                      } else {
                        Navigator.pop(context, {
                          'status': 'pass',
                          'poReceiveNo': widget.poReceiveNo,
                          'recSeq': widget.recSeq,
                          'ouCode': widget.ouCode,
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Item Description
              TextField(
                controller: TextEditingController(
                    text: '${widget.item} ${widget.itemDesc}'),
                decoration: InputDecoration(
                  labelText: 'Item and Description',
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
                style: TextStyle(fontSize: 16),
                readOnly: true,
              ),
              SizedBox(height: 4),

              // Lot Count Controls
              Row(
                children: [
                  // remove lot button
                  IconButton(
                    icon: Icon(Icons.remove, size: 50, color: Colors.white),
                    onPressed: () {
                      int currentValue = int.parse(lotCountController.text);
                      setState(() {
                        // checkUpdateData = true;
                        lotCountController.text =
                            (currentValue > 0 ? currentValue - 1 : 0)
                                .toString();
                      });
                    },
                  ),

                  // จำนวน LOT
                  Expanded(
                    child: TextField(
                      controller: lotCountController,
                      decoration: InputDecoration(
                        labelText: 'จำนวน LOT',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.black87),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),

                  // add lot button
                  IconButton(
                    icon: Icon(Icons.add, size: 50, color: Colors.white),
                    onPressed: () {
                      // int currentValue = int.parse(lotCountController.text);
                      int currentValue =
                          int.tryParse(lotCountController.text) ?? 0;
                      setState(() {
                        // checkUpdateData = true;
                        lotCountController.text = (currentValue + 1).toString();
                      });
                    },
                  ),
                ],
              ),

              // ADD and GENLOT Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text('ADD',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      onPressed: () async {
                        await postLot(widget.poReceiveNo, widget.recSeq);
                        await getLotList(widget.poReceiveNo, widget.recSeq);
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent),
                        child: Text('GENLOT',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        onPressed: () async {
                          await genLot(
                            widget.poReceiveNo,
                            widget.poPONO,
                            widget.recSeq,
                            lotCountController.text,
                            widget.lotSize,
                            widget.rowid,
                            lotSupplierController.text,
                          );
                          if (poStatus == '1') {
                            _showAlertDialogGenLot(context);
                          }
                          await getLotList(widget.poReceiveNo, widget.recSeq);
                          setState(() {
                            // ลบcardแล้วแต่แสดงจำนวนLOTเป็นจำนวนเดิม
                            // lotCountController.text =
                            //     dataLotList.length.toString();
                          });
                        }),
                  ),
                ],
              ),
              SizedBox(height: 4),

              // Lot List with Pagination
              if (dataLotList.isNotEmpty) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: paginatedLotList.length,
                  itemBuilder: (context, index) {
                    var item = paginatedLotList[index];
                    return SizedBox(
                      width: 300.0,
                      child: Card(
                        elevation: 4.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Color.fromRGBO(204, 235, 252, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                  'Seq:', item['lot_seq_nb']?.toString() ?? ''),
                              SizedBox(height: 8),
                              _buildInfoRow('Lot No:',
                                  item['lot_product_no']?.toString() ?? ''),
                              SizedBox(height: 8),
                              _buildInfoRow(
                                  'Lot QTY:',
                                  item['lot_qty'] != null
                                      ? numberFormat.format(item['lot_qty'])
                                      : ''),
                              SizedBox(height: 8),
                              _buildInfoRow('Lot ผู้ผลิต:',
                                  item['lot_supplier']?.toString() ?? ''),
                              SizedBox(height: 8),
                              _buildInfoRow('MFG Date:',
                                  item['mfg_date']?.toString() ?? ''),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _buildDeleteButton(item),
                                  Spacer(),
                                  _buildEditButton(item),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Pagination Controls
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    hasPrevPage
                        ? ElevatedButton(
                            onPressed: _loadPrevPage,
                            style: ButtonStyles.previousButtonStyle,
                            child: ButtonStyles.previousButtonContent,
                          )
                        : ElevatedButton(
                            onPressed: null,
                            style: ButtonStyles.disablePreviousButtonStyle,
                            child: ButtonStyles.disablePreviousButtonContent,
                          ),
                    Text(
                      _getPageIndicatorText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    hasNextPage
                        ? ElevatedButton(
                            onPressed: _loadNextPage,
                            style: ButtonStyles.nextButtonStyle,
                            child: ButtonStyles.nextButtonContent(),
                          )
                        : ElevatedButton(
                            onPressed: null,
                            style: ButtonStyles.disableNextButtonStyle,
                            child: ButtonStyles.disablePreviousButtonContent,
                          ),
                  ],
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: const Center(
                    child: Text(
                      'No data found',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }

// delete button
  Widget _buildDeleteButton(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogStyles.alertMessageCheckDialog(
                context: context,
                content: const Text('ยืนยันที่จะลบหรือไม่?'),
                onClose: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                onConfirm: () async {
                  Navigator.of(context).pop();
                  await deleteLot(
                    widget.poReceiveNo,
                    widget.ouCode,
                    widget.recSeq,
                    widget.poReceiveNo,
                    item['lot_seq']?.toString() ?? '',
                    item['po_seq']?.toString() ?? '',
                  );
                },
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0), // Increase tappable area
          child: Container(
            width: 30,
            height: 30,
            child: Image.asset(
              'assets/images/bin.png', // Delete image path
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

// dit button
  Widget _buildEditButton(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          showDetailsLotDialog(
            context,
            item,
            widget.recSeq,
            widget.ouCode,
            () async {
              await getLotList(widget.poReceiveNo, widget.recSeq);
              setState(() {});
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0), // เพิ่มพื้นที่รอบๆปุ่ม
          child: Container(
            width: 30,
            height: 30,
            child: Image.asset(
              'assets/images/edit.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4.0), // Optional padding for better spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center, // Align both label and value to the center
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Flexible(
            child: CustomContainerStyles.styledContainer(
              value, // Pass the value to determine the container style
              padding:
                  5.0, // Adjust padding for better spacing inside the container
              child: Text(
                value,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis), // Ellipsis for long text
                softWrap: true,
                maxLines: 2, // Limit to two lines if necessary
              ),
            ),
          ),
        ],
      ),
    );
  }
}
