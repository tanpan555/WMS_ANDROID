import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';

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
  String? itemDescription;
  String? code_Row;
  String? lot_Total;

  // TextEditingController itemDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('poReceiveNo: ${widget.poReceiveNo}');
    print('poPONO: ${widget.poPONO}');
    // sendGetRequestlineWMS();
    sendPostRequestlineWMS();
    _getLotTotal();
  }

  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FixedColumnWidth(100),
    1: FixedColumnWidth(100),
    2: FixedColumnWidth(50),
    3: FixedColumnWidth(100),
    4: FixedColumnWidth(100),
    5: FixedColumnWidth(100),
    6: FixedColumnWidth(100),
  };

  int _selectedItemCount = 0;
  String _selectedItem = '';

  String? poStatus;
  String? poMessage;

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

  Future<void> sendPostRequestlineWMS2() async {
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data['item'],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          content: SizedBox(
            width: 300.0,
            height: 100,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: receiveQtyController,
                    decoration: InputDecoration(
                      labelText: 'แก้ไขจำนวนรับ',
                    ),
                    keyboardType: TextInputType.number,
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
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () {
                      deleteReceiveQty(
                          data['receive_no'], data['rec_seq'].toString());
                      Navigator.of(context).pop();
                    },
                  ),
                  Row(
                    children: [
                      TextButton(
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () {
                          final updatedQty = receiveQtyController.text;
                          updateReceiveQty(data['rowid'], updatedQty);
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Close'),
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

  Widget _buildTableCellWithButton(String buttonText, bool isHeader) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isHeader ? Colors.grey[200] : Color.fromARGB(255, 52, 60, 84),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            minimumSize: Size(40, 30),
          ),
          onPressed: () {
            // showLotDialog(context);
          },
          child: Text(
            buttonText,
            style: TextStyle(
              color: isHeader ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
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

  Future<void> _getLotTotal() async {
    final String apiUrl =
        'http://172.16.0.82:8888/apex/wms/c/get_lot_total/${widget.poReceiveNo}';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(' widget.poReceiveNo ${widget.poReceiveNo}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('items')) {
          final List<dynamic> items = data['items'];
          print('Items data: $items, type: ${items.runtimeType}');
          print('Data: $data, type: ${data.runtimeType}');

          if (items is List && items.isNotEmpty) {
            for (var item in items) {
              if (item is Map && item.containsKey('total')) {
                lot_Total = item['total'].toString();
                print('lot_Total: $lot_Total, type: ${lot_Total.runtimeType}');
              } else {
                print('Item does not contain key "total" or is not a Map');
              }
            }
          } else {
            print('Items is not a List or is empty');
          }
        } else {
          print('Data is not a Map with key "items"');
        }
      } else {
        print('Failed to load data lot_Total');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void showLotDialog(BuildContext context, String item, String item_desc,
      String ou_code, String rec_seq) async {
    await getLotList(widget.poReceiveNo, rec_seq, ou_code);

    TextEditingController combinedController =
        TextEditingController(text: '$item $item_desc');
    TextEditingController lotCountController = TextEditingController();
    setState(() {
      sendGetRequestlineWMS();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lot Detail',
                style: TextStyle(
                    // color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // Adjust width as needed
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divider(
                  //   color: Colors.grey,
                  //   thickness: 1,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 103, 58, 183),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          minimumSize: Size(10, 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        onPressed: () {
                          // Code for Generate LOT button
                        },
                        child: const Text(
                          'Generate LOT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 103, 58, 183),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          minimumSize: Size(10, 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: combinedController,
                          decoration: InputDecoration(
                            labelText: 'Item',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: lotCountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'จำนวน LOT',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 103, 58, 183),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                minimumSize: Size(10, 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                              ),
                              onPressed: () async {
                                await postLot(
                                    widget.poReceiveNo, rec_seq, ou_code);
                                await getLotList(
                                    widget.poReceiveNo, rec_seq, ou_code);
                                await _getLotTotal();
                                setState(() {});
                              },
                              child: const Text(
                                'เพิ่ม',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 103, 58, 183),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                minimumSize: Size(10, 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                              ),
                              onPressed: () {
                                // Code for new button 2
                              },
                              child: const Text(
                                'ลบ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildTable999(ou_code: ou_code, rec_seq: rec_seq),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTable999({required String ou_code, required String rec_seq}) {
    // final int totalRowCount = getTotalRowCount();
    final Map<int, TableColumnWidth> columnWidths = {
      0: FixedColumnWidth(100),
      1: FixedColumnWidth(100),
      2: FixedColumnWidth(50),
      3: FixedColumnWidth(100),
      4: FixedColumnWidth(100),
      5: FixedColumnWidth(100),
      6: FixedColumnWidth(100),
    };

    String _selectedItem = '';
    int _selectedItemCount = 0;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Color.fromARGB(255, 224, 224, 224), width: 2.0),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            children: [
              Container(
                height:
                    300, // กำหนดความสูงให้ตาราง (จำเป็นสำหรับการเลื่อนแนวตั้ง)
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // กำหนดให้เลื่อนในแนวตั้ง
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // กำหนดให้เลื่อนในแนวนอน
                    child: Column(
                      children: [
                        Container(
                          color: Colors.grey[200],
                          child: Table(
                            border: TableBorder(
                              horizontalInside: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            columnWidths: columnWidths,
                            children: [
                              TableRow(
                                children: [
                                  _buildTableCell(' ', true),
                                  _buildTableCell('Seq', true),
                                  _buildTableCell('Lot QTY', true),
                                  _buildTableCell('Lot ผู้ผลิต', true),
                                  _buildTableCell('MFG Date.', true),
                                  _buildTableCell('Lot NO.', true),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Table(
                          border: TableBorder.all(
                            color: Color.fromARGB(255, 224, 224, 224),
                            width: 1.5,
                          ),
                          columnWidths: _columnWidths,
                          children: dataLotList.map((item) {
                            return TableRow(
                              children: [
                                TableCell(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 52, 60, 84),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      minimumSize: Size(30, 20),
                                    ),
                                    onPressed: () {
                                      showDetailsLotDialog(
                                          context, item, rec_seq, ou_code,
                                          () async {
                                        await getLotList(widget.poReceiveNo,
                                            rec_seq, ou_code);
                                        setState(() {});
                                      });
                                    },
                                    child: Text(
                                      'EDIT',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ),
                                ),
                                _buildTableCell(
                                  item['lot_seq']?.toString() ?? '',
                                  false,
                                ),
                                _buildTableCell(
                                  item['lot_qty']?.toString() ?? '',
                                  false,
                                ),
                                _buildTableCell(
                                    item['lot_supplier']?.toString() ?? '',
                                    false),
                                _buildTableCell(
                                    item['mfg_date']?.toString() ?? '', false),
                                _buildTableCell(
                                    item['lot_product_no']?.toString() ?? '',
                                    false),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light gray background
                  border: Border.all(
                    color: Color.fromARGB(255, 224, 224, 224), // Border color
                    width: 2.0, // Border width
                  ),
                  borderRadius: BorderRadius.circular(
                      4.0), // Optional: for rounded corners
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Align items to opposite ends
                  children: [
                    Visibility(
                      visible: _selectedItemCount >
                          0, // Show only when items are selected
                      child: Text(
                        '$_selectedItemCount rows selected',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      'Total ${dataLotList.length}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 8.0),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Set desired fraction of screen width
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white, // Light yellow background
              border: Border.all(
                  color: Colors.black,
                  width: 2.0), // Black border with width 2.0
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Center(
              child: Text(
                '$lot_Total',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 26, // Adjust the font size as needed
                ),
              ),
            ),
          ),
        ),
        // TextField(
        //   controller: TextEditingController(text: itemDescription),
        //   readOnly: true,
        //   decoration: InputDecoration(
        //     labelText: 'Item Desc',
        //     border: OutlineInputBorder(),
        //   ),
        //   style: TextStyle(
        //     color: Colors.black87,
        //     fontWeight: FontWeight.normal,
        //     fontSize: 16,
        //   ),
        // ),
        // const SizedBox(height: 8.0),
      ],
    );
  }

  final DateFormat displayFormat = DateFormat("dd/MM/yyyy");
  final DateFormat apiFormat = DateFormat("MM/dd/yyyy");

  void showDetailsLotDialog(BuildContext context, Map<String, dynamic> item,
      String recSeq, String ou_code, Function onDelete) {
    String recNo = widget.poReceiveNo;
    String lotSeq = item['lot_seq']?.toString() ?? '';
    String PoSeq = item['po_seq']?.toString() ?? '';

    TextEditingController mfgDateController = TextEditingController(
      text: item['mfg_date'] != null
          ? displayFormat.format(apiFormat.parse(item['mfg_date']))
          : '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // ปรับความโค้งมนของขอบ
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EDIT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          insetPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: item['lot_product_no'],
                    readOnly: true, // Make the field read-only
                    decoration: const InputDecoration(
                      labelText: 'Lot No.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: item['lot_qty']?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'LOT QTY',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: item['lot_supplier'],
                    decoration: const InputDecoration(
                      labelText: 'Supplier',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: mfgDateController,
                    decoration: InputDecoration(
                      labelText: 'Manufacture Date',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          // Trigger date picker when the icon is pressed
                          DateTime initialDate = DateTime.now();
                          if (mfgDateController.text.isNotEmpty) {
                            try {
                              initialDate =
                                  displayFormat.parse(mfgDateController.text);
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
                            final formattedDate = apiFormat.format(picked);
                            setState(() {
                              mfgDateController.text =
                                  displayFormat.format(picked);
                            });
                            item['mfg_date'] = formattedDate;
                          }
                        },
                      ),
                    ),
                    onTap: () async {
                      // Prevents keyboard from appearing
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: item['lot_seq']?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Lot Seq',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: item['po_seq']?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Po Seq',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 1, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(10, 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              child: const Text(
                'DELETE',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                await deleteLot(recNo, ou_code, recSeq, recNo, lotSeq, PoSeq);
                Navigator.of(context).pop();
                if (onDelete != null) {
                  await onDelete();
                }
              },
            ),

            //////////////////////////////////////////////////////////////////////////
            //  TextButton(
            //   child: const Text(
            //     'DELETE',
            //     style:
            //         TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            //   ),
            //   onPressed: () async {
            //     await deleteLot(recNo, ou_code, recSeq, recNo, lotSeq, poSeq);
            //     Navigator.of(context).pop();
            //     if (onDelete != null) {
            //       await onDelete();
            //     }
            //   },
            // ),
            //////////////////////////////////////////////////////////////////////////////////
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 17, 0, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(10, 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons
                        .save_outlined, // You can use any other icon from Icons class
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5), // Spacing between icon and text
                  const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  /// พีบน
  void _updateItemDescription(Map<String, dynamic> data) {
    setState(() {
      itemDescription = data['item_desc'] ?? 'ไม่มีข้อมูล';
      code_Row = data['rowid'] ?? 'rowID : มันไม่มา!!!';

      print('itemDescription : $itemDescription');
      print('code_Row : $code_Row');
    });
  }

  //// เอ็นจอยล่าง
  Widget _buildTableCell(String text, bool isHeader, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: isHeader ? 14 : 16,
            ),
            overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
            maxLines: 1, // Ensure single line
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Use the CustomAppBar
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
                      minimumSize: Size(10, 20),
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
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(10, 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Ssindt01Scanbarcode(),
                      //   ),
                      // ); // Code for Next button
                    },
                    child: const Text(
                      'ถัดไป',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: _buildFormFields(),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.yellow[200], // Light yellow background
              border: Border.all(
                  color: Colors.black,
                  width: 2.0), // Black border with width 2.0
              borderRadius: BorderRadius.circular(0),
            ),
            child: Center(
              child: Text(
                '${widget.poPONO}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20, // Adjust the font size as needed
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'เลขที่เอกสาร WMS*',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 14, // Adjust the font size as needed
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text(
              '${widget.poReceiveNo}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18, // Adjust the font size as needed
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 17, 0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: Size(10, 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                onPressed: sendPostRequestlineWMS2,
                child: const Text(
                  'ดึง PO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 17, 0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: Size(10, 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                onPressed: () {
                  // Code for Delete button
                },
                child: const Text(
                  'ลบ PO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 17, 0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: Size(10, 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                onPressed: () {},
                child: const Text(
                  'พิมพ์ Tag',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTable(),
          const SizedBox(height: 16.0),
          // Add more fields here as needed
        ],
      ),
    );
  }

  Widget _buildTable() {
    // final int totalRowCount = getTotalRowCount();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Color.fromARGB(255, 224, 224, 224),
                width: 2.0), // Border around the table
            borderRadius:
                BorderRadius.circular(4.0), // Optional: for rounded corners
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Container(
                      color:
                          Colors.grey[200], // Light gray background for header
                      child: Table(
                        border: TableBorder(
                            // Optional: Add border styling if needed
                            ),
                        columnWidths: _columnWidths, // Use the defined constant
                        children: [
                          TableRow(
                            children: [
                              _buildTableCell('Item', true),
                              _buildTableCell('จำนวนรับ', true),
                              _buildTableCell(' ', true),
                              _buildTableCell('ค้างรับ', true),
                              _buildTableCell('Locator', true),
                              _buildTableCell('จำนวน', true),
                              _buildTableCell('UOM', true),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 300, // Set a fixed height to the table body
                      child: Table(
                        border: TableBorder.all(
                          color: Color.fromARGB(255, 224, 224, 224),
                          width: 1.5,
                        ),
                        columnWidths: _columnWidths, // Use the defined constant
                        children: dataList.map((data) {
                          return TableRow(
                            children: [
                              _buildTableCell(
                                data['item']?.toString() ?? '',
                                false,
                                onTap: () => _updateItemDescription(data),
                              ),
                              _buildTableCell(
                                data['receive_qty']?.toString() ?? '',
                                false,
                                onTap: () => _showDetailsDialog(data),
                              ),
                              TableCell(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 52, 60, 84),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    minimumSize: Size(30, 20),
                                  ),

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
                                        data['ou_code']?.toString() ?? '');
                                  },
                                  // style: ElevatedButton.styleFrom(
                                  //   backgroundColor: Colors.purple,
                                  // ),
                                  child: Text(
                                    'LOT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              _buildTableCell(
                                  data['pending_qty']?.toString() ?? '', false),
                              _buildTableCell(
                                  data['locator_det']?.toString() ?? '', false),
                              _buildTableCell(
                                  data['lot_total_nb']?.toString() ?? '',
                                  false),
                              _buildTableCell(
                                  data['uom']?.toString() ?? '', false),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light gray background
                  border: Border.all(
                    color: Color.fromARGB(255, 224, 224, 224), // Border color
                    width: 2.0, // Border width
                  ),
                  borderRadius: BorderRadius.circular(
                      4.0), // Optional: for rounded corners
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Align items to opposite ends
                  children: [
                    Visibility(
                      visible: _selectedItemCount >
                          0, // Show only when items are selected
                      child: Text(
                        '$_selectedItemCount rows selected',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      'Total  ${dataList.length}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        // Add the display-only TextField here
        TextField(
          controller: TextEditingController(text: itemDescription),
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Item Desc',
            border: OutlineInputBorder(),
          ),
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16.0),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Set desired fraction of screen width
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white, // Light yellow background
              border: Border.all(
                  color: Colors.black,
                  width: 2.0), // Black border with width 2.0
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Center(
              child: Text(
                '$lot_Total',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28, // Adjust the font size as needed
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
