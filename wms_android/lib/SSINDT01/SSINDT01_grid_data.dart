import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
import 'SSINDT01_verify.dart';
import 'package:wms_android/bottombar.dart';
// import 'package:wms/test.dart';

class Ssindt01Grid extends StatefulWidget {
  final String poReceiveNo;
  final String? poPONO;

  Ssindt01Grid({required this.poReceiveNo, this.poPONO});
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

    // sendGetRequestlineWMS();
  }

  String? poStatus;
  String? poMessage;

  String? poStatusGrid;
  String? poMessageGrid;

  Future<void> chk_grid() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/c/chk_grid/${widget.poReceiveNo}'));
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(poMessage!)),
          );
        }

        if (poMessage == null && poMessage!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("เพิ่มข้อมูลเรียบร้อย")),
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Text(
              data['item'],
              style: TextStyle(
                color: Colors.white,
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
                        labelText: 'แก้ไขจำนวนรับ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      deleteReceiveQty(
                          data['receive_no'], data['rec_seq'].toString());
                      Navigator.of(context).pop();
                    },
                  ),
                  Row(
                    children: [
                       SizedBox(height: 16),
  ElevatedButton(
    child: Text(
      'Apply',
      style: TextStyle(color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
    ),
    
    onPressed: () {
      final updatedQty = receiveQtyController.text;
      updateReceiveQty(data['rowid'], updatedQty);
      Navigator.of(context).pop();
    },
  ),
  SizedBox(height: 16),
  ElevatedButton(
    child: Text('Close'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  ),
],

                  ),
                ],
              ),
            ),
          ],
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
        'eport?&_repName=/WMS_SSINDT01&_repFormat=pdf&_dataSource=wms&_outFilename=WM-D01-$timestamp.pdf&_repLocale=en_US&P_RECEIVE_NO=${widget.poReceiveNo}&P_OU_CODE=000&P_ITEM=');
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

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
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
                            int currentValue = int.parse(lotCountController.text);
                            setState(() {
                              currentValue = currentValue > 0 ? currentValue - 1 : 0;
                              lotCountController.text = currentValue.toString();
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: lotCountController,
                            decoration: InputDecoration(
                              labelText: 'จำนวน LOT',
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: 16),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            int currentValue = int.parse(lotCountController.text);
                            setState(() {
                              currentValue++;
                              lotCountController.text = currentValue.toString();
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
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
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
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            showDetailsLotDialog(
                                                context, item, recSeq, ouCode,
                                                () async {
                                              await getLotList(
                                                  widget.poReceiveNo,
                                                  recSeq,
                                                  ouCode);
                                              setState(() {});
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.purple,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 16),
                        ElevatedButton(
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
                        SizedBox(width: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: Text('GENLOT',
                              style: TextStyle(color: Colors.white)),
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
                        SizedBox(width: 16),
                        ElevatedButton(
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
                      ],
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.blueGrey[800],
            ),
          ),
        ],
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
        'http://172.16.0.82:8888/apex/wms/c/check_valid_savelot/${widget.poReceiveNo}/$recSeq';
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
    appBar: const CustomAppBar(),
    drawer: const CustomDrawer(),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
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
                const SizedBox(width: 8.0),
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
                  onPressed: sendPostRequestlineWMS,
                  child: const Text(
                    'ดึง PO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
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
                  onPressed: _launchUrl,
                  child: const Text(
                    'พิมพ์ Tag',
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
                    minimumSize: const Size(10, 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                  ),
                  onPressed: () async {
                    await chk_grid();
                    if (poStatusGrid == '0') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Ssindt01Verify(
                            poReceiveNo: widget.poReceiveNo,
                            poPONO: widget.poPONO,
                          ),
                        ),
                      );
                    } else if (poStatusGrid == '1') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(poMessageGrid ?? ''),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          dataList.isEmpty
              ? Center(child: Text('No data available'))
              : Expanded(
                  child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index];
                      final rowColor =
                          index.isEven ? Colors.white : Colors.grey[100];

                      return InkWell(
                        onTap: () {
                          _showDetailsDialog(data);
                        },
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.blueGrey[50]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Item: ${data['item']?.toString() ?? ''}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[800],
                                      ),
                                    ),
                                    FutureBuilder<String?>(
                                      future: fetchvResultStatus(
                                          data['item']?.toString() ?? ''),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text('Error');
                                        } else if (snapshot.data == '1') {
                                          return ElevatedButton(
                                            onPressed: () {
                                              showLotDialog(
                                                context,
                                                data['item']?.toString() ?? '',
                                                data['item_desc']?.toString() ?? '',
                                                data['ou_code']?.toString() ?? '',
                                                data['rec_seq']?.toString() ?? '',
                                              );
                                              getLotList(
                                                widget.poReceiveNo,
                                                data['rec_seq']?.toString() ?? '',
                                                data['ou_code']?.toString() ?? '',
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.purple,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                            ),
                                            child: Text(
                                              'LOT',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Divider(color: Colors.grey[300]),
                                SizedBox(height: 12),
                                _buildInfoRow('จำนวนรับ',
                                    data['receive_qty']?.toString() ?? ''),
                                _buildInfoRow('ค้างรับ',
                                    data['pending_qty']?.toString() ?? ''),
                                _buildInfoRow('Locator',
                                    data['locator_det']?.toString() ?? ''),
                                _buildInfoRow('จำนวนรวม',
                                    data['lot_total_nb']?.toString() ?? ''),
                                _buildInfoRow(
                                    'UOM', data['uom']?.toString() ?? ''),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    ),
    bottomNavigationBar: BottomBar(),
  );
}

}
