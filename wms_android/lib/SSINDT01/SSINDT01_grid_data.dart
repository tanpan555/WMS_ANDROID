import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/styles.dart';
// import 'package:wms_android/custom_drawer.dart';
import 'SSINDT01_verify.dart';
import 'package:wms_android/bottombar.dart';
// import 'package:wms/test.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    print('poReceiveNo: ${widget.poReceiveNo}');
    print('poPONO: ${widget.poPONO}');
    print('********************************************');
    sendGetRequestlineWMS();
    print(dataList.length);
  }

  String? poStatus;
  String? poMessage;

  String? poStatusGrid;
  String? poMessageGrid;
// String?  result;
  Future<void> chk_grid() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/c/chk_grid/${widget.poReceiveNo}/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}'));
      print(widget.poReceiveNo);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          poStatusGrid = jsonData['po_status'];
          poMessageGrid = jsonData['po_message'];
          print(response.statusCode);
          print(jsonData);
          print(poStatusGrid);
          print(poMessageGrid);
        });
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
        'http://172.16.0.82:8888/apex/wms/c/item_chk/$ITEM_CODE';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['v_result'];
      } else {
        throw Exception('Failed to load vResult status');
      }
    } catch (e) {
      setState(() {
        poStatus = 'Error';
        poMessage = e.toString();
      });
      return null;
    }
  }

  Future<void> sendPostRequestlineWMS() async {
    final url = 'http://172.16.0.82:8888/apex/wms/c/get_po_test';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_po_no': widget.poPONO,
      'p_receive_no': widget.poReceiveNo,
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
        setState(() {
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];
          // sendGetRequestlineWMS();
        });
        print('Success: $responseData');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> postLot(String poReceiveNo, String recSeq, String ouCode) async {
    final url = 'http://172.16.0.82:8888/apex/wms/c/add_lot';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_ou': ouCode,
      'p_receive_no': poReceiveNo,
      'p_rec_seq': recSeq,
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
        setState(() {
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];
          sendGetRequestlineWMS();
        });
        print('Success: $responseData');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> genLot(String v_WMS_NO, String v_PO_NO, String v_rec_seq,
      String v_lot_qty, String OU_CODE) async {
    final url = 'http://172.16.0.82:8888/apex/wms/c/gen_lot';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'v_WMS_NO': v_WMS_NO,
      'v_PO_NO': v_PO_NO,
      'v_rec_seq': v_rec_seq,
      'v_lot_qty': v_lot_qty,
      'OU_CODE': OU_CODE,
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

        setState(() {
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];

          sendGetRequestlineWMS();
        });

        if (poMessage != null && poMessage!.isNotEmpty) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(poMessage!)),
          // );

          AlertDialog(
            title: Center(child: Text('คำเตือน')),
            content: Text(poMessage!),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }

        if (poMessage == null && poMessage!.isEmpty) {
          AlertDialog(
            title: Center(child: Text('คำเตือน')),
            content: Text("สำเร็จ"),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
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
        'http://172.16.0.82:8888/apex/wms/c/pull_po/${widget.poReceiveNo}';
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

        setState(() {
          dataList =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('RUN sendGetRequestlineWMS ********************');
        print('Success: $dataList');
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateReceiveQty(String rowid, String receiveQty) async {
    final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/UPDATE_QTY');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'rowid': rowid,
        'receive_qty': receiveQty,
      }),
    );

    print('Updating receive_qty with data: ${jsonEncode({
          'rowid': rowid,
          'receive_qty': receiveQty,
        })}');

    if (response.statusCode == 200) {
      print('Receive quantity updated successfully');
      sendGetRequestlineWMS();
    } else {
      print('Failed to update receive quantity: ${response.statusCode}');
    }
  }

  Future<void> deleteReceiveQty(String recNo, String recSeq) async {
    final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/del_po');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'rec_no': recNo,
        'rec_seq': recSeq,
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

  Future<void> getLotList(
      String poReceiveNo, String recSeq, String ouCode) async {
    final url =
        'http://172.16.0.82:8888/apex/wms/c/get_lot/$poReceiveNo/$recSeq/$ouCode';

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

        setState(() {
          dataLotList =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('Success: $dataLotList');
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showDetailsDialog(Map<String, dynamic> data) {
    TextEditingController receiveQtyController = TextEditingController(
      text: data['receive_qty']?.toString().replaceAll(',', '') ?? '',
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[300], // Add your desired background color here
              child: Text(
                data['item'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            content: SizedBox(
              width: 300.0,
              height: 75.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: receiveQtyController,
                        decoration: InputDecoration(
                          labelText: 'จำนวนรับ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1.0),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: AppStyles.ConfirmChecRecievekButtonStyle(),
                      onPressed: () {
                        final updatedQty = receiveQtyController.text;
                        updateReceiveQty(data['rowid'], updatedQty);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Image.asset(
                        'assets/images/check-mark.png',
                        width: 25.0,
                        height: 25.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
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

  Future<void> deleteLot(String recNo, String pOu, String recSeq, String PoNo,
      String lotSeq, String PoSeq) async {
    final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/del_lot');
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
      await getLotList(widget.poReceiveNo, recSeq, pOu);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _launchUrl() async {
    print(widget.poReceiveNo);
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final Uri url = Uri.parse('http://172.16.0.82:8888/jri/r' +
        'eport?&_repName=/WMS/WMS_SSINDT01&_repFormat=pdf&_dataSource=wms&_outFilename=WM-D01-$timestamp.pdf&_repLocale=en_US&P_RECEIVE_NO=${widget.poReceiveNo}&P_OU_CODE=000&P_ITEM=');
    print(url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void showLotDialog(BuildContext context, String item, String itemDesc,
      String ouCode, String recSeq) async {
    await getLotList(widget.poReceiveNo, recSeq, ouCode);

    TextEditingController combinedController =
        TextEditingController(text: '$item $itemDesc');
    TextEditingController lotCountController = TextEditingController(text: '0');
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Material(
                type: MaterialType.transparency,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'LOT Details',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: combinedController,
                            decoration: InputDecoration(
                              labelText: 'Item and Description',
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  int currentValue =
                                      int.parse(lotCountController.text);
                                  setState(() {
                                    currentValue =
                                        currentValue > 0 ? currentValue - 1 : 0;
                                    lotCountController.text =
                                        currentValue.toString();
                                  });
                                },
                              ),
                              Expanded(
                                child: TextField(
                                  controller: lotCountController,
                                  decoration: InputDecoration(
                                    labelText: 'จำนวน LOT',
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  int currentValue =
                                      int.parse(lotCountController.text);
                                  setState(() {
                                    currentValue++;
                                    lotCountController.text =
                                        currentValue.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          dataLotList.isNotEmpty
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: dataLotList.map((item) {
                                      return Card(
                                        elevation: 4.0,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Seq: ${item['lot_seq_nb']?.toString() ?? ''}'),
                                              SizedBox(height: 8),
                                              Text(
                                                  'Lot QTY: ${item['lot_qty']?.toString() ?? ''}'),
                                              SizedBox(height: 8),
                                              Text(
                                                  'MFG Date: ${item['mfg_date']?.toString() ?? ''}'),
                                              SizedBox(height: 8),
                                              Text(
                                                  'Lot ผู้ผลิต: ${item['lot_supplier']?.toString() ?? ''}'),
                                              SizedBox(height: 8),
                                              Text(
                                                  'Product No: ${item['lot_product_no']?.toString() ?? ''}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 16),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDetailsLotDialog(
                                                      context,
                                                      item,
                                                      recSeq,
                                                      ouCode, () async {
                                                    await getLotList(
                                                        widget.poReceiveNo,
                                                        recSeq,
                                                        ouCode);
                                                    setState(() {});
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.purple,
                                                ),
                                                child: Text('EDIT',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : Text('No LOT details available',
                                  style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: Text('ADD',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    await postLot(
                                        widget.poReceiveNo, recSeq, ouCode);
                                    await getLotList(
                                        widget.poReceiveNo, recSeq, ouCode);
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                  ),
                                  child: Text('GENLOT',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 9)),
                                  onPressed: () async {
                                    await genLot(
                                        widget.poReceiveNo,
                                        widget.poPONO.toString(),
                                        recSeq,
                                        lotCountController.text,
                                        ouCode);
                                    await getLotList(
                                        widget.poReceiveNo, recSeq, ouCode);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              child: Text('OK'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await fetchPoStatus(recSeq);
                                if (poreject == '1') {
                                  showCustomDialog(context, widget.poReceiveNo,
                                      recSeq, ouCode);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: anim1,
            child: child,
          ),
        );
      },
    );
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
                  Text('Cancel'),
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
                await updateOkLot(poReceiveNo, recSeq, ouCode);
                await sendGetRequestlineWMS();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateLot(String lot_qty, String lot_supplier, String mfg_date,
      String OU_CODE, String RECEIVE_NO, String REC_SEQ, String lot_seq) async {
    final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/save_lot_det');
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

  Future<void> updateOkLot(
      String v_rec_no, String v_rec_seq, String p_erp_ou) async {
    final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/update_ok_lot');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'v_rec_no': v_rec_no,
        'v_rec_seq': v_rec_seq,
        'p_erp_ou': p_erp_ou,
      }),
    );

    print('Updating form with data: ${jsonEncode({
          'v_rec_no': v_rec_no,
          'v_rec_seq': v_rec_seq,
          'p_erp_ou': p_erp_ou,
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
    TextEditingController mfgDateController = TextEditingController(
      text: item['mfg_date'] != null
          ? displayFormat.format(displayFormat.parse(item['mfg_date']))
          : '',
    );
    TextEditingController lotSupplierController = TextEditingController(
      text: item['lot_supplier']?.toString() ?? '',
    );

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
                          if (refreshCallback != null) {
                            await refreshCallback();
                          }
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
                          if (refreshCallback != null) {
                            await refreshCallback();
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
                        fillColor: const Color.fromARGB(255, 254, 247, 230),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
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
        'http://172.16.0.82:8888/apex/wms/c/check_valid_savelot/${widget.poReceiveNo}/$recSeq/${gb.P_OU_CODE}/${gb.APP_USER}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  const SizedBox(width: 8.0),
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
                              return AlertDialog(
                                title: Center(child: Text('คำเตือน')),
                                content: Text(
                                    'ระบบมีการบันทึกรายการทิ้งไว้ หากดึง PO จะเคลียร์รายการทั้งหมดทิ้ง, ต้องการดึง PO ใหม่หรือไม่'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await sendPostRequestlineWMS();
                                      await sendGetRequestlineWMS();
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
                                // title: Center(child: Text('คำเตือน')),
                                content: Text('Complete.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await sendPostRequestlineWMS();
                                      await sendGetRequestlineWMS();
                                    },
                                  ),
                                ],
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
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.notifications, // Use the bell icon
                                    color: Colors.red, // Set the color to red
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add some space between the icon and the text
                                  Text('แจ้งเตือน'), // Title text
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${poMessageGrid ?? 'No message available'}'),
                                ],
                              ),
                              actions: [
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

            // dataList.isEmpty
            //     ? Center(
            //         child: Text(
            //         'No data available',
            //         style: TextStyle(color: Colors.white),
            //       ))
            //     :
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await sendGetRequestlineWMS();
                },
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
                    ...dataList.map((data) {
                      final rowColor = dataList.indexOf(data).isEven
                          ? Colors.white
                          : Colors.grey[100];

                      return InkWell(
                        child: Card(
                          elevation: 8,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 1),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    '${data['item']?.toString() ?? ''}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Divider(
                                    color: const Color.fromARGB(255, 0, 0, 0)),
                                _buildInfoRow2({
                                  'จำนวนรับ:':
                                      data['receive_qty']?.toString() ?? '-',
                                  'ค้างรับ:':
                                      data['pending_qty']?.toString() ?? '-',
                                }),
                                _buildInfoRow2({
                                  'จำนวนรวม:':
                                      data['lot_total_nb']?.toString() ?? '-',
                                  'UOM:': data['UOM']?.toString() ?? '-',
                                }),
                                _buildInfoRow3({
                                  'Locator:':
                                      data['locator_det']?.toString() ?? '-',
                                }),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      iconSize: 20.0,
                                      icon: Image.asset(
                                        'assets/images/bin.png',
                                        width: 45.0,
                                        height: 45.0,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .notifications, // Use the bell icon
                                                    color: Colors
                                                        .red, // Set the color to red
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          8), // Add some space between the icon and the text
                                                  Text(
                                                      'แจ้งเตือน'), // Title text
                                                ],
                                              ),
                                              content:
                                                  Text('ยืนยันที่จะลบหรือไม่'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('ยกเลิก'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await deleteReceiveQty(
                                                      data['receive_no'],
                                                      data['rec_seq']
                                                          .toString(),
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('ตกลง'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
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
                                              final result = await Navigator
                                                  .push<Map<String, String>>(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LotDialog(
                                                    item: data['item']
                                                            ?.toString() ??
                                                        '',
                                                    itemDesc: data['item_desc']
                                                            ?.toString() ??
                                                        '',
                                                    ouCode: data['ou_code']
                                                            ?.toString() ??
                                                        '',
                                                    recSeq: data['rec_seq']
                                                            ?.toString() ??
                                                        '',
                                                    poReceiveNo:
                                                        widget.poReceiveNo,
                                                    poPONO: widget.poPONO ?? '',
                                                  ),
                                                  fullscreenDialog: true,
                                                ),
                                              );
                                              if (result == null) {
                                                Timer(Duration(seconds: 1), () {
                                                  sendGetRequestlineWMS();
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 45, 68, 116),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              padding: EdgeInsets.symmetric(
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
                                          return IconButton(
                                            iconSize: 20.0,
                                            icon: Image.asset(
                                              'assets/images/edit.png',
                                              width: 45.0,
                                              height: 45.0,
                                            ),
                                            onPressed: () async {
                                              _showDetailsDialog(data);
                                            },
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
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class LotDialog extends StatefulWidget {
  final String item;
  final String itemDesc;
  final String ouCode;
  final String recSeq;
  final String poReceiveNo;
  final String poPONO;

  LotDialog({
    required this.item,
    required this.itemDesc,
    required this.ouCode,
    required this.recSeq,
    required this.poReceiveNo,
    required this.poPONO,
  });

  @override
  _LotDialogState createState() => _LotDialogState();
}

class _LotDialogState extends State<LotDialog> {
  final TextEditingController lotCountController =
      TextEditingController(text: '0');
  String? poStatus;
  String? poMessage;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> dataLotList = [];

  @override
  void initState() {
    super.initState();
    print('poReceiveNo: ${widget.poReceiveNo}');
    print('poPONO: ${widget.poPONO}');
    getLotList(widget.poReceiveNo, widget.recSeq, widget.ouCode);
    sendGetRequestlineWMS();
    print('======================================');
  }

  Future<void> genLot(String v_WMS_NO, String v_PO_NO, String v_rec_seq,
      String v_lot_qty, String OU_CODE) async {
    final url = 'http://172.16.0.82:8888/apex/wms/c/gen_lot';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'v_WMS_NO': v_WMS_NO,
      'v_PO_NO': v_PO_NO,
      'v_rec_seq': v_rec_seq,
      'v_lot_qty': v_lot_qty,
      'OU_CODE': OU_CODE,
      'APP_USER': gb.APP_USER,
    });
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(poMessage ?? "เพิ่มข้อมูลเรียบร้อย")),
        // );

        AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notifications, // Use the bell icon
                color: Colors.red, // Set the color to red
              ),
              SizedBox(
                  width: 8), // Add some space between the icon and the text
              Text('แจ้งเตือน'), // Title text
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
      String v_rec_no, String v_rec_seq, String p_erp_ou) async {
    final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/update_ok_lot');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'v_rec_no': v_rec_no,
        'v_rec_seq': v_rec_seq,
        'p_erp_ou': p_erp_ou,
      }),
    );

    print('Updating form with data: ${jsonEncode({
          'v_rec_no': v_rec_no,
          'v_rec_seq': v_rec_seq,
          'p_erp_ou': p_erp_ou,
        })}');

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  Future<void> postLot(String poReceiveNo, String recSeq, String ouCode) async {
    final url = 'http://172.16.0.82:8888/apex/wms/c/add_lot';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_ou': ouCode,
      'p_receive_no': poReceiveNo,
      'p_rec_seq': recSeq,
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
        setState(() {
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];
          sendGetRequestlineWMS();
        });
        print('Success: $responseData');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getLotList(
      String poReceiveNo, String recSeq, String ouCode) async {
    final url =
        'http://172.16.0.82:8888/apex/wms/c/get_lot/$poReceiveNo/$recSeq/$ouCode';
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    print('Request URL: $url');

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);

        print('Response Data: $responseData');

        // Assuming 'items' is the correct key containing the list
        setState(() {
          dataLotList =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
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
        'http://172.16.0.82:8888/apex/wms/c/pull_po/${widget.poReceiveNo}';
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
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
    TextEditingController mfgDateController = TextEditingController(
      text: item['mfg_date'] != null
          ? displayFormat.format(displayFormat.parse(item['mfg_date']))
          : '',
    );
    TextEditingController lotSupplierController = TextEditingController(
      text: item['lot_supplier']?.toString() ?? '',
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
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
                                initialValue: lotSeq ?? '',
                                decoration: InputDecoration(
                                  label: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Seq',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  labelStyle: TextStyle(color: Colors.black),
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
                                initialValue: item['lot_product_no'] ?? '',
                                decoration: InputDecoration(
                                  labelText: 'Lot No',
                                  labelStyle: TextStyle(color: Colors.black),
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
                        _buildTextField(
                          controller: lotQtyController,
                          labelText: 'LOT QTY',
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            item['lot_qty'] = value;
                          },
                        ),
                        _buildTextField(
                          controller: lotSupplierController,
                          labelText: 'Lot ผู้ผลิต',
                          onChanged: (value) {
                            item['lot_supplier'] = value;
                          },
                        ),
                        _buildDateField(
                          controller: mfgDateController,
                          labelText: 'MFG Date',
                          context: context,
                          onChanged: (value) {
                            item['mfg_date'] = value;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: AppStyles.ConfirmChecRecievekButtonStyle(),
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
                                if (refreshCallback != null) {
                                  await refreshCallback();
                                }
                              },
                              child: Image.asset(
                                'assets/images/check-mark.png',
                                width: 45.0,
                                height: 45.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Close Button Positioned at the top right corner
                  Positioned(
                    right: 0.0,
                    top: -15.0,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
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

  bool isDateValid = false;
  Widget _buildDateField({
    required TextEditingController controller,
    required String labelText,
    required BuildContext context,
    ValueChanged<String>? onChanged,
  }) {
    // Variable to track date validity
    bool isDateValid = true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            readOnly: false, // Make it read-only to enforce date selection
            onChanged: (value) {
              if (value.length == 8) {
                try {
                  // Parsing input format (ddMMyyyy) to DateTime
                  DateTime parsedDate = DateTime.parse(
                    "${value.substring(4, 8)}-${value.substring(2, 4)}-${value.substring(0, 2)}",
                  );

                  // Formatting it to the desired format (dd/MM/yyyy)
                  String formattedDate = displayFormat.format(parsedDate);
                  controller.text = formattedDate;
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: formattedDate.length),
                  );

                  // Update the date validity
                  isDateValid = true;
                  if (onChanged != null) {
                    onChanged(formattedDate); // Notify the parent widget
                  }
                } catch (e) {
                  print('Error parsing date: $e');
                  // Update the date validity
                  isDateValid = false;
                }
              } else {
                // Update the date validity for incorrect length
                isDateValid = false;
              }
            },
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today_outlined, color: Colors.black),
                onPressed: () async {
                  FocusScope.of(context).unfocus(); // Hide keyboard

                  DateTime initialDate = DateTime.now();
                  if (controller.text.isNotEmpty) {
                    try {
                      // Attempt to parse the current text in the field
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
                    String formattedDate = displayFormat.format(picked);
                    controller.text =
                        formattedDate; // Show the selected date in the field

                    // Notify the parent widget
                    if (onChanged != null) {
                      onChanged(formattedDate);
                    }
                  }
                },
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
              LengthLimitingTextInputFormatter(8), // Limit to 8 digits
            ],
          ),
          // Display error message if date is invalid
          isDateValid == false
              ? const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'กรุณากรองวันที่ให้ถูกต้องตามรูปแบบ DD/MM/YYYY',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  String? poreject;
  Future<void> fetchPoStatus(String recSeq) async {
    final url =
        'http://172.16.0.82:8888/apex/wms/c/check_valid_savelot/${widget.poReceiveNo}/$recSeq/${gb.P_OU_CODE}/${gb.APP_USER}';
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
      String OU_CODE, String RECEIVE_NO, String REC_SEQ, String lot_seq) async {
    final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/save_lot_det');
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

  Future<void> deleteLot(String recNo, String pOu, String recSeq, String PoNo,
      String lotSeq, String PoSeq) async {
    final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/del_lot');
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
      await getLotList(widget.poReceiveNo, recSeq, pOu);
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
                  Text('Cancel'),
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
                Navigator.pop(context, {
                  'status': 'dialog',
                  'poReceiveNo': widget.poReceiveNo,
                  'recSeq': widget.recSeq,
                  'ouCode': widget.ouCode,
                });
                Navigator.of(context).pop();
                await updateOkLot(poReceiveNo, recSeq, ouCode);
                await sendGetRequestlineWMS();

                // setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  final NumberFormat numberFormat = NumberFormat("#,##0");

  void _showAlertDialogGenLot(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notifications, // Use the bell icon
                color: Colors.red, // Set the color to red
              ),
              SizedBox(
                  width: 8), // Add some space between the icon and the text
              Text('แจ้งเตือน'), // Title text
            ],
          ),
          content: Text('$poMessage'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'LOT Details'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text('OK'),
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      int currentValue = int.parse(lotCountController.text);
                      setState(() {
                        lotCountController.text =
                            (currentValue > 0 ? currentValue - 1 : 0)
                                .toString();
                      });
                    },
                  ),
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
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      int currentValue = int.parse(lotCountController.text);
                      setState(() {
                        lotCountController.text = (currentValue + 1).toString();
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('ADD', style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        await postLot(
                            widget.poReceiveNo, widget.recSeq, widget.ouCode);
                        await getLotList(
                            widget.poReceiveNo, widget.recSeq, widget.ouCode);
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                        ),
                        child: Text('GENLOT',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                        onPressed: () async {
                          await genLot(
                              widget.poReceiveNo,
                              widget.poPONO.toString(),
                              widget.recSeq,
                              lotCountController.text,
                              widget.ouCode);
                          print(poStatus);
                          print(poMessage);
                          if (poStatus == '1') {
                            _showAlertDialogGenLot(context);
                          }
                          await getLotList(
                              widget.poReceiveNo, widget.recSeq, widget.ouCode);
                          setState(() {});
                        }),
                  ),
                ],
              ),
              SizedBox(height: 4),
              dataLotList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dataLotList.length,
                      itemBuilder: (context, index) {
                        var item = dataLotList[index];
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
                                  _buildInfoRow3({
                                    'Seq:':
                                        item['lot_seq_nb']?.toString() ?? '',
                                  }),
                                  _buildInfoRow3({
                                    'Lot No:':
                                        item['lot_product_no']?.toString() ??
                                            '',
                                  }),
                                  _buildInfoRow2({
                                    'Lot QTY:': item['lot_qty'] != null
                                        ? numberFormat.format(item['lot_qty'])
                                        : '',
                                  }),
                                  _buildInfoRow3({
                                    'Lot ผู้ผลิต:':
                                        item['lot_supplier']?.toString() ?? '',
                                  }),
                                  _buildInfoRow3({
                                    'MFG Date:':
                                        item['mfg_date']?.toString() ?? '',
                                  }),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: IconButton(
                                          iconSize: 20.0,
                                          icon: Image.asset(
                                            'assets/images/bin.png',
                                            width: 45.0,
                                            height: 45.0,
                                          ),
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .notifications, // Use the bell icon
                                                        color: Colors
                                                            .red, // Set the color to red
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              8), // Add some space between the icon and the text
                                                      Text(
                                                          'แจ้งเตือน'), // Title text
                                                    ],
                                                  ),
                                                  content: Text(
                                                      'ยืนยันที่จะลบหรือไม่'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('ยกเลิก'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await deleteLot(
                                                          widget.poReceiveNo,
                                                          widget.ouCode,
                                                          widget.recSeq,
                                                          widget.poReceiveNo,
                                                          item['lot_seq']
                                                                  ?.toString() ??
                                                              '',
                                                          item['po_seq']
                                                                  ?.toString() ??
                                                              '',
                                                        );
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('ตกลง'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: IconButton(
                                          iconSize: 20.0,
                                          icon: Image.asset(
                                            'assets/images/edit.png',
                                            width: 45.0,
                                            height: 45.0,
                                          ),
                                          onPressed: () {
                                            showDetailsLotDialog(
                                              context,
                                              item,
                                              widget.recSeq,
                                              widget.ouCode,
                                              () async {
                                                await getLotList(
                                                    widget.poReceiveNo,
                                                    widget.recSeq,
                                                    widget.ouCode);
                                                setState(() {});
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text('No LOT details available',
                          style: TextStyle(color: Colors.white)),
                    ),
              // SizedBox(height: 16),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.green,
              //         ),
              //         child: Text('ADD', style: TextStyle(color: Colors.white)),
              //         onPressed: () async {
              //           await postLot(
              //               widget.poReceiveNo, widget.recSeq, widget.ouCode);
              //           await getLotList(
              //               widget.poReceiveNo, widget.recSeq, widget.ouCode);
              //           setState(() {});
              //         },
              //       ),
              //     ),
              //     SizedBox(width: 12),
              //     Expanded(
              //       child: ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.greenAccent,
              //           ),
              //           child: Text('GENLOT',
              //               style:
              //                   TextStyle(color: Colors.white, fontSize: 12)),
              //           onPressed: () async {
              //             await genLot(
              //                 widget.poReceiveNo,
              //                 widget.poPONO.toString(),
              //                 widget.recSeq,
              //                 lotCountController.text,
              //                 widget.ouCode);
              //             print(poStatus);
              //             print(poMessage);
              //             if (poStatus == '1') {
              //               _showAlertDialogGenLot(context);
              //             }
              //             await getLotList(
              //                 widget.poReceiveNo, widget.recSeq, widget.ouCode);
              //             setState(() {});
              //           }),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 16),
              // Center(
              //   child: ElevatedButton(
              //     child: Text('OK'),
              //     onPressed: () async {
              //       await fetchPoStatus(widget.recSeq);
              //       if (poreject == '1') {
              //         showCustomDialog(context, widget.poReceiveNo,
              //             widget.recSeq, widget.ouCode);
              //       } else {
              //         Navigator.pop(context, {
              //           'status': 'pass',
              //           'poReceiveNo': widget.poReceiveNo,
              //           'recSeq': widget.recSeq,
              //           'ouCode': widget.ouCode,
              //         });
              //       }
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
