import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/styles.dart';
import 'SSINDT01_verify.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSINDT01_lotdetails.dart';
import 'package:wms_android/centered_message.dart';

class Ssindt01Grid extends StatefulWidget {
  final String poReceiveNo;
  final String? poPONO;
  final String pWareCode;
  final String pWareName;
  final String p_ou_code;

  Ssindt01Grid({
    required this.poReceiveNo,
    this.poPONO,
    required this.pWareCode,
    required this.pWareName,
    required this.p_ou_code,
  });
  @override
  _Ssindt01GridState createState() => _Ssindt01GridState();
}

class _Ssindt01GridState extends State<Ssindt01Grid> {
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> dataLotList = [];
  List<bool> selectedItems = [];

  int itemsPerPage = 5;
  int currentPage = 1;
  int totalItems = 0;
  List<Map<String, dynamic>> paginatedData = [];

  @override
  void initState() {
    super.initState();
    print('poReceiveNo: ${widget.poReceiveNo}');
    print('poPONO: ${widget.poPONO}');
    print('********************************************');
    print(widget.p_ou_code);
    sendGetRequestlineWMS();
    print(dataList.length);
  }

  void updatePaginatedData() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (endIndex > dataList.length) {
      endIndex = dataList.length;
    }

    setState(() {
      paginatedData = dataList.sublist(startIndex, endIndex);
      totalItems = dataList.length;
    });
  }

  void _loadNextPage() {
    if (currentPage < (dataList.length / itemsPerPage).ceil()) {
      setState(() {
        currentPage++;
        updatePaginatedData();
      });
    }
  }

  void _loadPrevPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        updatePaginatedData();
      });
    }
  }

  String _getPageIndicatorText() {
    if (paginatedData.isEmpty) {
      return ''; // Return an empty string if there are no cards
    }

    int startIndex = ((currentPage - 1) * itemsPerPage) + 1;
    int endIndex = startIndex + paginatedData.length - 1;
    return '$startIndex - $endIndex';
  }

  String? poStatus;
  String? poMessage;

  String? poStatusGrid;
  String? poMessageGrid;
// String?  result;
  Future<void> chk_grid() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSINDT01/Step_3_chk_grid/${widget.poReceiveNo}/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}'));

      print(widget.poReceiveNo);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        if (mounted) {
          setState(() {
            poStatusGrid = jsonData['po_status'];
            poMessageGrid = jsonData['po_message'];
            print(response.statusCode);
            print(jsonData);
            print(poStatusGrid);
            print(poMessageGrid);
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? vResult;

  Future<String?> fetchvResultStatus(String ITEM_CODE) async {
    final String apiUrl =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_3_item_chk/$ITEM_CODE';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['v_result'];
      } else {
        throw Exception('Failed to load vResult status');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          poStatus = 'Error';
          poMessage = e.toString();
        });
      }
      return null;
    }
  }

  Future<void> sendPostRequestlineWMS() async {
    final url = '${gb.IP_API}/apex/wms/SSINDT01/Step_3_get_po_test';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_po_no': widget.poPONO,
      'p_receive_no': widget.poReceiveNo,
      'p_ou': gb.P_OU_CODE,
      'p_erp_ou': gb.P_ERP_OU_CODE,
      'APP_USER': gb.APP_USER,
    });
    print('Request body: $body');

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
            poStatus = responseData['po_status'];
            poMessage = responseData['po_message'];
            // sendGetRequestlineWMS();
          });
        }
        print('Success: $responseData');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendGetRequestlineWMS() async {
    final url =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_3_pull_po/${widget.poReceiveNo}/${gb.P_ERP_OU_CODE}';
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        setState(() {
          dataList =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          selectedItems = List<bool>.filled(dataList.length, false);
          currentPage = 1; // Reset to first page when new data is loaded
          updatePaginatedData();
        });
        print('Success: $dataList');
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
        setState(() {
          dataList = [];
          selectedItems = [];
          paginatedData = [];
        });
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          dataList = [];
          selectedItems = [];
          paginatedData = [];
        });
      }
    }
  }

  Future<void> updateReceiveQty(String? rowid, String? receiveQty,
      String? rcvlot_supplier, String? rcvlot_size) async {
    final url =
        Uri.parse('${gb.IP_API}/apex/wms/SSINDT01/Step_3_WMS_PO_RECEIVE_DET');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'rowid': rowid,
        'receive_qty': receiveQty,
        'rcvlot_supplier': rcvlot_supplier,
        'rcvlot_size': rcvlot_size,
      }),
    );

    print('Updating receive_qty with data: ${jsonEncode({
          'rowid': rowid,
          'receive_qty': receiveQty,
          'rcvlot_supplier': rcvlot_supplier,
          'rcvlot_size': rcvlot_size,
        })}');

    if (response.statusCode == 200) {
      print('Receive quantity updated successfully');
      sendGetRequestlineWMS();
    } else {
      print('Failed to update receive quantity: ${response.statusCode}');
    }
  }

  Future<void> deleteReceiveQty(String recNo, String recSeq) async {
    final url = Uri.parse('${gb.IP_API}/apex/wms/SSINDT01/Step_3_del_po');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'rec_no': recNo,
        'rec_seq': recSeq,
        'p_doc_type': widget.poPONO,
        'p_erp_ou': gb.P_ERP_OU_CODE,
        'APP_USER': gb.APP_USER,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final poStatus = responseBody['po_status'];
      final poMessage = responseBody['po_message'];
      print('Status: $poStatus');
      print('Message: $poMessage');
      sendGetRequestlineWMS();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> getLotList(String poReceiveNo, String recSeq) async {
    final url =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_3_get_lot/$poReceiveNo/$recSeq/${gb.P_ERP_OU_CODE}';

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    print('Request URL: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        if (mounted) {
          setState(() {
            dataLotList =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('Success: $dataLotList');
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _showDetailsDialog(
      BuildContext context, Map<String, dynamic> data) async {
    TextEditingController receiveQtyController = TextEditingController(
      text: data['receive_qty']?.toString().replaceAll(',', '') ?? '',
    );

    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // ปิด Popup ได้เฉพาะปุ่ม Icon
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            clipBehavior: Clip.none, // Allow overflow
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    // ตรวจสอบการแก้ไข
                    final currentQuantity =
                        data['receive_qty']?.toString() ?? '-';
                    final editedQuantity =
                        receiveQtyController.text.replaceAll(',', '');

                    if (currentQuantity != editedQuantity) {
                      // แสดง dialog ยืนยัน
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogStyles.warningNotSaveDialog(
                            context: context,
                            textMessage:
                                'คุณต้องการออกจากหน้านี้โดยไม่บันทึกหรือไม่?',
                            onCloseDialog: () {
                              Navigator.of(context).pop(); // ปิด dialog ยืนยัน
                            },
                            onConfirmDialog: () {
                              Navigator.of(context).pop(); // ปิด dialog ยืนยัน
                              Navigator.of(context).pop(); // ปิด popup หลัก
                            },
                          );
                        },
                      );
                    } else {
                      Navigator.of(context).pop(); // ปิด popup หลักโดยตรง
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: ListBody(
                      children: <Widget>[
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                color: Colors.grey[300],
                                padding: const EdgeInsets.all(2),
                                child: TextFormField(
                                  enabled: false,
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    labelText: ' seq',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  initialValue:
                                      data['rec_seq']?.toString() ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.grey[300],
                                padding: const EdgeInsets.all(2),
                                child: TextFormField(
                                  enabled: false,
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    labelText: ' item',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  initialValue: data['item'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          textAlign: TextAlign.right,
                          controller: receiveQtyController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // Allows only numbers
                          ],
                          decoration: const InputDecoration(
                            labelText: 'จำนวนรับ',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                data['receive_qty'] = null;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: AppStyles.ConfirmChecRecievekButtonStyle(),
                onPressed: () async {
                  final cleanedText =
                      receiveQtyController.text.replaceAll(',', '');
                  if (cleanedText.isEmpty) {
                    // อัปเดตฐานข้อมูลด้วยค่า null
                    await updateReceiveQty(
                      data['rowid'],
                      null, // itemCode
                      data['rcvlot_supplier'], // poPackQty เป็น null
                      data['rcvlot_size'], // ratio
                    );

                    // อัปเดตสถานะใน state
                    setState(() {
                      data['receive_qty'] = null;
                    });

                    Navigator.of(context).pop(); // ปิด Popup
                  } else {
                    try {
                      final newQuantity = double.parse(cleanedText);
                      print('Updating receive_qty with value: $newQuantity');
                      if (newQuantity <= 0) {
                        // แสดง popup แจ้งเตือนเมื่อค่าที่ป้อนเป็น 0 หรือน้อยกว่า
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogStyles.alertMessageDialog(
                              context: context,
                              content: Text('โปรดใส่เลขที่มากกว่า 0'),
                              onClose: () {
                                Navigator.of(context).pop(); // ปิด dialog
                              },
                              onConfirm: () async {
                                Navigator.of(context).pop(); // ปิด dialog
                              },
                            );
                          },
                        );
                        return; // หยุดการทำงาน ไม่ให้ดำเนินการต่อ
                      }
                      // อัปเดตฐานข้อมูลด้วยค่าที่กรอก
                      await updateReceiveQty(
                        data['rowid'], // poPackCode
                        newQuantity.toString(), // itemCode
                        data['rcvlot_supplier'], // poPackQty
                        data['rcvlot_size'], // ratio
                      );

                      // อัปเดตสถานะใน state
                      setState(() {
                        sendGetRequestlineWMS();
                      });

                      Navigator.of(context).pop(); // ปิด Popup
                    } catch (e) {
                      print('Error parsing quantity: $e');
                    }
                  }
                },
                child: Image.asset('assets/images/check-mark.png',
                    width: 30, height: 30),
              ),
            ),
          ],
        );
      },
    );
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
      await getLotList(widget.poReceiveNo, recSeq);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _launchUrl() async {
    print(widget.poReceiveNo);
    // final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final Uri url = Uri.parse('${gb.IP_API}/jri/r' +
        'eport?&_repName=/WMS/WMS_SSINDT01&_repFormat=pdf&_dataSource=wms&_outFilename=${widget.poReceiveNo}.pdf&_repLocale=en_US&P_RECEIVE_NO=${widget.poReceiveNo}&P_OU_CODE=${gb.P_ERP_OU_CODE}&P_ITEM=');
    print(url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void showCustomDialog(
      BuildContext context, String poReceiveNo, String recSeq, String ouCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            children: <Widget>[
              Icon(Icons.info_outline, color: Colors.blue, size: 24.0),
              SizedBox(width: 10.0),
              Text('Save Lot'),
            ],
          ),
          content: Text(
            poMessage.toString(),
            style: TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                iconColor: Colors.red,
              ),
              child: Column(
                children: <Widget>[
                  Icon(Icons.cancel, color: Colors.red),
                  SizedBox(width: 5.0),
                  Text('ยกเลิก'),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                iconColor: Colors.blue,
              ),
              child: Column(
                children: <Widget>[
                  Icon(Icons.check, color: Colors.blue),
                  SizedBox(width: 5.0),
                  Text('OK'),
                ],
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await updateOkLot(poReceiveNo, recSeq);
                await sendGetRequestlineWMS();
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateLot(String lot_qty, String lot_supplier, String mfg_date,
      String OU_CODE, String RECEIVE_NO, String REC_SEQ, String lot_seq) async {
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
        'OU_CODE': OU_CODE,
        'RECEIVE_NO': RECEIVE_NO,
        'REC_SEQ': REC_SEQ,
        'lot_seq': lot_seq,
      }),
    );

    print('Updating form with data: ${jsonEncode({
          'lot_qty': lot_qty,
          'lot_supplier': lot_supplier,
          'mfg_date': mfg_date,
          'OU_CODE': OU_CODE,
          'RECEIVE_NO': RECEIVE_NO,
          'REC_SEQ': REC_SEQ,
          'lot_seq': lot_seq,
        })}');

    if (response.statusCode == 200) {
      print('Update successful');

      sendGetRequestlineWMS();
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  Future<void> updateOkLot(String v_rec_no, String v_rec_seq) async {
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
        'p_erp_ou': gb.P_ERP_OU_CODE,
        'p_ou': gb.P_OU_CODE,
        'app_user': gb.APP_USER,
      }),
    );

    print('Updating form with data: ${jsonEncode({
          'v_rec_no': v_rec_no,
          'v_rec_seq': v_rec_seq,
          'p_erp_ou': gb.P_ERP_OU_CODE,
          'p_ou': gb.P_OU_CODE,
          'app_user': gb.APP_USER,
        })}');

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  final DateFormat displayFormat = DateFormat("dd/MM/yyyy");
  final DateFormat apiFormat = DateFormat("MM/dd/yyyy");

  void showDetailsLotDialog(BuildContext context, Map<String, dynamic> item,
      String recSeq, String ou_code, Function refreshCallback) {
    String recNo = widget.poReceiveNo;
    String lotSeq = item['lot_seq']?.toString() ?? '';
    String poSeq = item['po_seq']?.toString() ?? '';

    TextEditingController lotQtyController = TextEditingController(
      text: item['lot_qty']?.toString() ?? '',
    );
    TextEditingController mfgDateController = TextEditingController();

    TextEditingController lotSupplierController = TextEditingController(
      text: item['lot_supplier']?.toString() ?? '',
    );
    lotQtyController.clear();
    lotSupplierController.clear();
    mfgDateController.clear();
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54, // Background color with some transparency
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Details for ${item['lot_product_no']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: lotQtyController,
                    labelText: 'LOT Qty',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      item['lot_qty'] = value;
                    },
                  ),
                  _buildDateField(
                    controller: mfgDateController,
                    labelText: 'mfg Date',
                    context: context,
                    onChanged: (value) {
                      item['mfg_date'] = value;
                    },
                  ),
                  _buildTextField(
                    controller: lotSupplierController,
                    labelText: 'Lot ผู้ผลิต',
                    onChanged: (value) {
                      item['lot_supplier'] = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildDialogButton(
                        label: 'DELETE',
                        color: Colors.red,
                        onPressed: () async {
                          await deleteLot(
                            recNo,
                            ou_code,
                            recSeq,
                            recNo,
                            lotSeq,
                            poSeq,
                          );
                          Navigator.of(context).pop();
                          await refreshCallback();
                        },
                      ),
                      _buildDialogButton(
                        label: 'SAVE',
                        color: Colors.green,
                        onPressed: () async {
                          await updateLot(
                            lotQtyController.text,
                            lotSupplierController.text,
                            mfgDateController.text,
                            ou_code,
                            recNo,
                            recSeq,
                            lotSeq,
                          );
                          sendGetRequestlineWMS();
                          Navigator.of(context).pop();
                          await refreshCallback();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
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
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String labelText,
    required BuildContext context,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          DateTime initialDate = DateTime.now();
          if (controller.text.isNotEmpty) {
            try {
              initialDate = displayFormat.parse(controller.text);
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
            controller.text = displayFormat.format(picked);
            if (onChanged != null) {
              onChanged(displayFormat.format(picked));
            }
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow1(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4.0, horizontal: 6), // Optional padding for better spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center, // Align both label and value to the center
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 12,
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            // Flexible allows the value to take only the necessary space
            child: CustomContainerStyles.styledContainer(
              value, // Pass the value to determine the container style
              padding:
                  5.0, // Adjust padding for better spacing inside the container
              child: Text(
                value,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 12,
                ), // Ellipsis for long text
                softWrap: true,
                maxLines: 2, // Limit to two lines if necessary
              ),
            ),
          ),
        ],
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
                  SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: TextEditingController(text: entry.value),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Key
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 12,
                      ),
                      softWrap: false,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 18),

                  Container(
                    constraints: BoxConstraints(
                      minWidth: 80,
                      maxWidth: 150,
                    ),
                    height: 30,
                    child: TextField(
                      controller: TextEditingController(text: entry.value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 10.0,
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
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
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

  String? poreject;
  Future<void> fetchPoStatus(String recSeq) async {
    final url =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_3_check_valid_savelot/${widget.poReceiveNo}/$recSeq/${gb.P_OU_CODE}/${gb.APP_USER}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (mounted) {
          setState(() {
            poStatus = responseBody['po_status'];
            poMessage = responseBody['po_message'];
            poreject = responseBody['v_type_reject'];
            print('po_status: $poStatus');
            print('po_message: $poMessage');
            print('v_type_reject: $poreject');
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

  void _showDeleteDialog() {
    if (dataList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No items to delete')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'เลือก Item ที่จะลบ',
                    style: TextStyle(
                      fontSize: 18.0,
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
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.blue[50],
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row for Checkbox and Item
                                Row(
                                  children: [
                                    // Checkbox placed before the item
                                    Checkbox(
                                      value: selectedItems[index],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selectedItems[index] = value ?? false;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Item: ',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Expanded(
                                      child:
                                          CustomContainerStyles.styledContainer(
                                        dataList[index]['item'],
                                        child: Text(
                                          '${dataList[index]['item'] ?? ''}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),

                                // Row for Item Desc
                                Row(
                                  children: [
                                    Text('Item Desc: ',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    Expanded(
                                      child:
                                          CustomContainerStyles.styledContainer(
                                        dataList[index]['item_desc'],
                                        child: Text(
                                          '${dataList[index]['item_desc'] ?? ''}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),

                                // Row for Pending Qty
                                Row(
                                  children: [
                                    Text('ค้างรับ: ',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    CustomContainerStyles.styledContainer(
                                      dataList[index]['pending_qty']
                                          ?.toString(),
                                      child: Text(
                                        '${dataList[index]['pending_qty'] ?? 0}',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              actions: <Widget>[
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: Text('ยกเลิก'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('ยืนยันลบ'),
                      onPressed: () {
                        // Check if at least one item is selected
                        int selectedCount =
                            selectedItems.where((item) => item).length;

                        if (selectedCount == 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogStyles.alertMessageDialog(
                                context: context,
                                content: Text('เลือกอย่างน้อย 1 รายการเพื่อลบ'),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogStyles.alertMessageCheckDialog(
                              context: context,
                              content: Text(
                                  'ต้องการลบ $selectedCount รายการหรือไม่ ?'),
                              onClose: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              onConfirm: () {
                                Navigator.of(context).pop();
                                _deleteSelectedItems();
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteSelectedItems() async {
    List<Future> deleteFutures = [];
    for (int i = 0; i < dataList.length; i++) {
      if (i < selectedItems.length && selectedItems[i]) {
        deleteFutures.add(deleteReceiveQty(
          dataList[i]['receive_no'],
          dataList[i]['rec_seq'].toString(),
        ));
      }
    }
    await Future.wait(deleteFutures);
    await sendGetRequestlineWMS();
  }

  @override
  Widget build(BuildContext context) {
    bool hasNextPage = currentPage < (dataList.length / itemsPerPage).ceil();
    bool hasPrevPage = currentPage > 1;
    return Scaffold(
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      iconSize: 20.0,
                      icon: Image.asset(
                        'assets/images/business.png',
                        width: 25.0,
                        height: 25.0,
                      ),
                      onPressed: () async {
                        if (dataList.length != 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogStyles.alertMessageCheckDialog(
                                context: context,
                                content: const Text(
                                    'ระบบมีการบันทึกรายการทิ้งไว้ หากดึง PO จะเคลียร์รายการทั้งหมดทิ้ง, ต้องการดึง PO ใหม่หรือไม่'),
                                onClose: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                onConfirm: () async {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DialogStyles.messageDialog(
                                        context: context,
                                        content: Text('complete'),
                                        onClose: () {
                                          Navigator.of(context)
                                              .pop(); // ปิด dialog
                                        },
                                        onConfirm: () async {
                                          Navigator.of(context)
                                              .pop(); // ปิด dialog
                                          await sendPostRequestlineWMS();
                                          await sendGetRequestlineWMS();
                                          // คุณสามารถใส่คำสั่งเพิ่มเติมได้ที่นี่
                                        },
                                        showCloseIcon: true,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogStyles.messageDialog(
                                context: context,
                                content: Text('complete'),
                                onClose: () {
                                  Navigator.of(context).pop(); // ปิด dialog
                                },
                                onConfirm: () async {
                                  Navigator.of(context).pop(); // ปิด dialog
                                  await sendPostRequestlineWMS();
                                  await sendGetRequestlineWMS();
                                  // คุณสามารถใส่คำสั่งเพิ่มเติมได้ที่นี่
                                },
                                showCloseIcon: true,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      iconSize: 20.0,
                      icon: Image.asset(
                        'assets/images/printer.png',
                        width: 25.0,
                        height: 25.0,
                      ),
                      onPressed: () async {
                        _launchUrl();
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      iconSize: 20.0,
                      icon: Image.asset(
                        'assets/images/bin.png',
                        width: 25.0,
                        height: 25.0,
                      ),
                      onPressed: () async {
                        _showDeleteDialog();
                      },
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: AppStyles.NextButtonStyle(),
                    onPressed: () async {
                      await chk_grid();
                      if (poStatusGrid == '0') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Ssindt01Verify(
                              poReceiveNo: widget.poReceiveNo,
                              poPONO: widget.poPONO,
                              pWareCode: widget.pWareCode,
                              pWareName: widget.pWareName,
                              p_ou_code: widget.p_ou_code,
                            ),
                          ),
                        );
                      } else if (poStatusGrid == '1') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogStyles.alertMessageDialog(
                              context: context,
                              content: Text(
                                  '${poMessageGrid ?? 'No message available'}'),
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
                    },
                    child: Image.asset(
                      'assets/images/right.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    color: const Color.fromARGB(255, 255, 242, 204),
                    child: Center(
                      child: Text(
                        '${widget.poPONO}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    color: const Color.fromARGB(255, 244, 244, 244),
                    child: Center(
                      child: Text(
                        '${widget.poReceiveNo}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  dataList.isNotEmpty
                      ? Column(
                          children: dataList.map((data) {
                            return InkWell(
                              child: Card(
                                elevation: 8,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Color.fromRGBO(204, 235, 252, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          '${data['item']?.toString() ?? ''}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Divider(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                      _buildInfoRow2({
                                        'จำนวนรับ :':
                                            data['receive_qty']?.toString() ??
                                                '-',
                                        'ค้างรับ :':
                                            data['pending_qty']?.toString() ??
                                                '-',
                                      }),
                                      _buildInfoRow2({
                                        'จำนวนรวม :':
                                            data['lot_total_nb']?.toString() ??
                                                '-',
                                        'UOM:': data['UOM']?.toString() ?? '-',
                                      }),
                                      _buildInfoRow3({
                                        'Locator :':
                                            data['locator_det']?.toString() ??
                                                '-',
                                      }),
                                      _buildInfoRow1(
                                        'Item Desc :',
                                        data['item_desc'] ?? '-',
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DialogStyles
                                                      .alertMessageCheckDialog(
                                                    context: context,
                                                    content: const Text(
                                                        'ยืนยันที่จะลบหรือไม่?'),
                                                    onClose: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    onConfirm: () async {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                      await deleteReceiveQty(
                                                        data['receive_no'],
                                                        data['rec_seq']
                                                            .toString(),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0), // Increase tappable area
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
                                          FutureBuilder<String?>(
                                            future: fetchvResultStatus(
                                                data['item']?.toString() ?? ''),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text('Error');
                                              } else if (snapshot.data == '1') {
                                                return ElevatedButton(
                                                  onPressed: () async {
                                                    final result =
                                                        await Navigator.push<
                                                            Map<String,
                                                                String>>(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            LotDialog(
                                                          item: data['item']
                                                                  ?.toString() ??
                                                              '',
                                                          itemDesc: data[
                                                                      'item_desc']
                                                                  ?.toString() ??
                                                              '',
                                                          recSeq: data[
                                                                      'rec_seq']
                                                                  ?.toString() ??
                                                              '',
                                                          lotQTY: data[
                                                                      'lot_qty']
                                                                  ?.toString() ??
                                                              '',
                                                          lotSize: data[
                                                                      'lot_Size']
                                                                  ?.toString() ??
                                                              '',
                                                          rowid: data['rowid']
                                                                  ?.toString() ??
                                                              '',
                                                          lotSupp: [
                                                            'lot_supplier'
                                                          ].toString(),
                                                          ouCode: data[
                                                                      'ou_code']
                                                                  ?.toString() ??
                                                              '',
                                                          poReceiveNo: widget
                                                              .poReceiveNo,
                                                          poPONO:
                                                              widget.poPONO ??
                                                                  '',
                                                        ),
                                                        fullscreenDialog: true,
                                                      ),
                                                    );
                                                    if (result == null) {
                                                      Timer(
                                                          Duration(seconds: 1),
                                                          () {
                                                        sendGetRequestlineWMS();
                                                      });
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 45, 68, 116),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                  ),
                                                  child: Text(
                                                    'LOT',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                );
                                              } else {
                                                return InkWell(
                                                  onTap: () {
                                                    _showDetailsDialog(
                                                        context, data);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .all(
                                                        15.0), // เพิ่มพื้นที่รอบๆปุ่ม
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      child: Image.asset(
                                                        'assets/images/edit.png',
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : const Column(
                          children: [
                            SizedBox(height: 60.0),
                            Center(child: CenteredMessage())
                          ],
                        ),
                  // Center(
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(top: 150),
                  //       child: Text(
                  //         'No data found',
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //     ),
                  //   ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous Button
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

                      // Page Indicator
                      Text(
                        _getPageIndicatorText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Next Button
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
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }
}
