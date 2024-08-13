// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';


// class Ssindt01GridData extends StatefulWidget {
//   final String poReceiveNo;
//   final String? poPONO;

//   Ssindt01GridData({required this.poReceiveNo, this.poPONO});
//   @override
//   _Ssindt01GridDataState createState() => _Ssindt01GridDataState();
// }

// class _Ssindt01GridDataState extends State<Ssindt01GridData> {
//   List<Map<String, dynamic>> dataList = [];
//   List<Map<String, dynamic>> dataLotList = [];

//   @override
//   void initState() {
//     super.initState();
//     print('poReceiveNo: ${widget.poReceiveNo}');
//     print('poPONO: ${widget.poPONO}');
//     sendGetRequestlineWMS();

//   }

//   String? poStatus;
//   String? poMessage;

//   Future<void> sendPostRequestlineWMS() async {
//     final url = 'http://172.16.0.82:8888/apex/wms/c/get_po_test';

//     final headers = {
//       'Content-Type': 'application/json',
//     };

//     final body = jsonEncode({
//       'p_po_no': widget.poPONO,
//       'p_receive_no': widget.poReceiveNo,
//     });
//     print('Request body: $body');

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         setState(() {
//           poStatus = responseData['po_status'];
//           poMessage = responseData['po_message'];
//           sendGetRequestlineWMS();
//         });
//         print('Success: $responseData');
//       } else {
//         print('Failed to post data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Future<void> postLot(String poReceiveNo, String recSeq, String ouCode) async {
//     final url = 'http://172.16.0.82:8888/apex/wms/c/add_lot';

//     final headers = {
//       'Content-Type': 'application/json',
//     };

//     final body = jsonEncode({
//       'p_ou': ouCode,
//       'p_receive_no': poReceiveNo,
//       'p_rec_seq': recSeq,
//     });
//     print('Request body: $body');

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         setState(() {
//           poStatus = responseData['po_status'];
//           poMessage = responseData['po_message'];
//           sendGetRequestlineWMS();
//         });
//         print('Success: $responseData');
//       } else {
//         print('Failed to post data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Future<void> sendGetRequestlineWMS() async {
//     final url =
//         'http://172.16.0.82:8888/apex/wms/c/pull_po/${widget.poReceiveNo}';

//     final headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//     };

//     print('Request URL: $url');

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final responseBody = utf8.decode(response.bodyBytes);
//         final responseData = jsonDecode(responseBody);

//         setState(() {
//           dataList =
//               List<Map<String, dynamic>>.from(responseData['items'] ?? []);
//         });
//         print('Success: $dataList');
//       } else {
//         print('Failed to get data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Future<void> updateReceiveQty(String rowid, String receiveQty) async {
//     final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/UPDATE_QTY');
//     final response = await http.put(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'rowid': rowid,
//         'receive_qty': receiveQty,
//       }),
//     );

//     print('Updating receive_qty with data: ${jsonEncode({
//           'rowid': rowid,
//           'receive_qty': receiveQty,
//         })}');

//     if (response.statusCode == 200) {
//       print('Receive quantity updated successfully');
//       sendGetRequestlineWMS();
//     } else {
//       print('Failed to update receive quantity: ${response.statusCode}');
//     }
//   }

//   Future<void> deleteReceiveQty(String recNo, String recSeq) async {
//     final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/del_po');
//     final response = await http.delete(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'rec_no': recNo,
//         'rec_seq': recSeq,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final responseBody = jsonDecode(response.body);
//       final poStatus = responseBody['po_status'];
//       final poMessage = responseBody['po_message'];
//       print('Status: $poStatus');
//       print('Message: $poMessage');
//       sendGetRequestlineWMS();
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//   }

//   Future<void> getLotList(
//       String poReceiveNo, String recSeq, String ouCode) async {
//     final url =
//         'http://172.16.0.82:8888/apex/wms/c/get_lot/$poReceiveNo/$recSeq/$ouCode';

//     final headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//     };

//     print('Request URL: $url');

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         final responseBody = utf8.decode(response.bodyBytes);
//         final responseData = jsonDecode(responseBody);

//         setState(() {
//           dataLotList =
//               List<Map<String, dynamic>>.from(responseData['items'] ?? []);
//         });
//         print('Success: $dataLotList');
//       } else {
//         print('Failed to get data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   void _showDetailsDialog(Map<String, dynamic> data) {
//     TextEditingController receiveQtyController = TextEditingController(
//       text: data['receive_qty']?.toString().replaceAll(',', '') ?? '',
//     );

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   data['item'],
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           contentPadding:
//               EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//           content: SizedBox(
//             width: 300.0,
//             height: 100,
//             child: SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[
//                   TextField(
//                     controller: receiveQtyController,
//                     decoration: InputDecoration(
//                       labelText: 'แก้ไขจำนวนรับ',
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     child: Text(
//                       'Delete',
//                       style: TextStyle(
//                         color: Colors.red,
//                       ),
//                     ),
//                     onPressed: () {
//                       deleteReceiveQty(
//                           data['receive_no'], data['rec_seq'].toString());
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   Row(
//                     children: [
//                       TextButton(
//                         child: Text(
//                           'Apply',
//                           style: TextStyle(
//                             color: Colors.green,
//                           ),
//                         ),
//                         onPressed: () {
//                           final updatedQty = receiveQtyController.text;
//                           updateReceiveQty(data['rowid'], updatedQty);
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                       TextButton(
//                         child: Text('Close'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> deleteLot(String recNo, String pOu, String recSeq, String PoNo,
//       String lotSeq, String PoSeq) async {
//     final url = Uri.parse('http://172.16.0.82:8888/apex/wms/c/del_lot');
//     print('recNo $recNo');
//     print('pOu $pOu');
//     print('recSeq $recSeq');
//     print('PoNo $PoNo');
//     print('lotSeq $lotSeq');
//     print('PoSeq $PoSeq');
//     final response = await http.delete(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'p_receive_no': recNo,
//         'p_rec_seq': recSeq,
//         'p_po_no': recNo,
//         'p_po_seq': PoSeq,
//         'p_lot_seq': lotSeq,
//         'p_ou': pOu,
//       }),
//     );

//     if (response.statusCode == 200) {
//       if (response.body.isNotEmpty) {
//         final responseBody = jsonDecode(response.body);
//         final poStatus = responseBody['po_status'];
//         final poMessage = responseBody['po_message'];
//         print('Status: $poStatus');
//         print('Message: $poMessage');
//       }
//       await getLotList(widget.poReceiveNo, recSeq, pOu);
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//   }




// Future<void> _launchUrl() async {
//   print(widget.poReceiveNo);
//   final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
// final Uri url = Uri.parse(
//   'http://172.16.0.82:8888/jri/report?&_repName=/WMS_SSINDT01&_repFormat=pdf&_dataSource=wms&_outFilename=WM-D01-$timestamp.pdf&_repLocale=en_US&P_RECEIVE_NO=${widget.poReceiveNo}&P_OU_CODE=000&P_ITEM='
// );
//   print(url);
//   if (!await launchUrl(url)) {
//     throw Exception('Could not launch $url');
//   }
// }

//   void showLotDialog(BuildContext context, String item, String item_desc,
//       String ou_code, String rec_seq) async {

//     await getLotList(widget.poReceiveNo, rec_seq, ou_code);

//     TextEditingController combinedController =
//         TextEditingController(text: '$item $item_desc');
//     TextEditingController lotCountController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Dialog(
//               child: Container(
//                 width: 500.0,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Text('LOT Details',
//                             style: TextStyle(fontSize: 20.0)),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: TextField(
//                           controller: combinedController,
//                           decoration: InputDecoration(
//                             labelText: 'Item and Description',
//                             border: OutlineInputBorder(),
//                           ),
//                           style: TextStyle(fontSize: 16.0),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: TextField(
//                           controller: lotCountController,
//                           decoration: InputDecoration(
//                             labelText: 'จำนวน LOT',
//                             border: OutlineInputBorder(),
//                           ),
//                           style: TextStyle(fontSize: 16.0),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Text('OU_CODE: $ou_code REC_SEQ: $rec_seq'),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: dataLotList.isNotEmpty
//                             ? SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: DataTable(
//                                   columns: [
//                                     DataColumn(label: Text('')),
//                                     DataColumn(label: Text('Product No')),
//                                     DataColumn(label: Text('lot_qty')),
//                                     DataColumn(label: Text('mfg_date')),
//                                     DataColumn(label: Text('lot_supplier')),
//                                     DataColumn(label: Text('Lot Seq')),
//                                   ],
//                                   rows: dataLotList.map((item) {
//                                     return DataRow(
//                                       cells: [
//                                         DataCell(
//                                           ElevatedButton(
//                                             onPressed: () {
//                                               showDetailsLotDialog(
//                                                   context,
//                                                   item,
//                                                   rec_seq,
//                                                   ou_code, () async {
//                                                 await getLotList(
//                                                     widget.poReceiveNo,
//                                                     rec_seq,
//                                                     ou_code);
//                                                 setState(() {});
//                                               });
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.purple,
//                                             ),
//                                             child: Text('EDIT',
//                                                 style: TextStyle(
//                                                     color: Colors.white)),
//                                           ),
//                                         ),
//                                         DataCell(Text(item['lot_product_no']
//                                                 ?.toString() ??
//                                             '')),
//                                         DataCell(Text(
//                                             item['lot_qty']?.toString() ?? '')),
//                                         DataCell(Text(
//                                             item['mfg_date']?.toString() ??
//                                                 '')),
//                                         DataCell(Text(
//                                             item['lot_supplier']?.toString() ??
//                                                 '')),
//                                         DataCell(Text(
//                                             item['lot_seq']?.toString() ?? '')),
//                                       ],
//                                     );
//                                   }).toList(),
//                                 ),
//                               )
//                             : Text('No LOT details available'),
//                       ),
//                       ButtonBar(
//                         children: <Widget>[
//                           TextButton(
//                             child: Text('OK'),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       ),
//                       ButtonBar(
//                         children: <Widget>[
//                           TextButton(
//                             child: Text('ADD'),
//                             onPressed: () async {
//                               await postLot(
//                                   widget.poReceiveNo, rec_seq, ou_code);
//                               await getLotList(
//                                   widget.poReceiveNo, rec_seq, ou_code);
//                               setState(() {});
//                             },
//                           ),
//                         ],
//                       ),
//                       ButtonBar(
//                         children: <Widget>[
//                           ElevatedButton(
//               onPressed: _launchUrl,
              
//               child: Text('DOWNLOAD'),
//             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void showDetailsLotDialog(BuildContext context, Map<String, dynamic> item,
//       String recSeq, String ou_code, Function onDelete) {
//     String recNo = widget.poReceiveNo;
//     String lotSeq = item['lot_seq']?.toString() ?? '';
//     String PoSeq = item['po_seq']?.toString() ?? '';

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             width: 400.0,
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Text('Details for ${item['lot_product_no']}',
//                     style: TextStyle(fontSize: 20.0)),
//                 SizedBox(height: 16.0),
//                 Text('LOT Qty: ${item['lot_qty']}'),
//                 Text('Manufacture Date: ${item['mfg_date']}'),
//                 Text('Supplier: ${item['lot_supplier']}'),
//                 Text('Lot Seq: ${item['lot_seq']}'),
//                 Text('Po Seq: ${item['po_seq']}'),
//                 SizedBox(height: 16.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     TextButton(
//                       child: Text('DELETE'),
//                       onPressed: () async {
//                         await deleteLot(
//                             recNo, ou_code, recSeq, recNo, lotSeq, PoSeq);
//                         Navigator.of(context).pop();
//                         if (onDelete != null) {
//                           await onDelete();
//                         }
//                       },
//                     ),
//                     TextButton(
//                       child: Text('Close'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Grid Page'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: sendPostRequestlineWMS,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//               ),
//               child: Text(
//                 'ดึงข้อมูล',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: dataList.isEmpty
//           ? Center(child: Text('No data available'))
//           : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 border: TableBorder(
//                     verticalInside: BorderSide(
//                         width: 0.1,
//                         color: Colors.black,
//                         style: BorderStyle.solid)),
//                 columnSpacing: 12.0,
//                 columns: [
//                   DataColumn(label: Text('')),
//                   DataColumn(label: Text('Item')),
//                   DataColumn(label: Text('จำนวนรับ')),
//                   DataColumn(label: Text('ค้างรับ')),
//                   DataColumn(label: Text('Locator')),
//                   DataColumn(label: Text('จำนวนรวม')),
//                   DataColumn(label: Text('UOM')),
//                 ],
//                 rows: dataList.map((data) {
//                   return DataRow(
//                     cells: [
//                       DataCell(
//                         ElevatedButton(
//                           onPressed: () {
//                             showLotDialog(
//                               context,
//                               data['item']?.toString() ?? '',
//                               data['item_desc']?.toString() ?? '',
//                               data['ou_code']?.toString() ?? '',
//                               data['rec_seq']?.toString() ?? '',
//                             );
//                             getLotList(
//                                 widget.poReceiveNo,
//                                 data['rec_seq']?.toString() ?? '',
//                                 data['ou_code']?.toString() ?? '');
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.purple,
//                           ),
//                           child: Text('LOT',
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                       DataCell(
//                         InkWell(
//                           onTap: () => _showDetailsDialog(data),
//                           child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text(data['item']?.toString() ?? '')),
//                         ),
//                       ),
//                       DataCell(
//                         InkWell(
//                           onTap: () => _showDetailsDialog(data),
//                           child: Align(
//                               alignment: Alignment.centerLeft,
//                               child:
//                                   Text(data['receive_qty']?.toString() ?? '')),
//                         ),
//                       ),
//                       DataCell(
//                         InkWell(
//                           onTap: () => _showDetailsDialog(data),
//                           child: Align(
//                               alignment: Alignment.center,
//                               child:
//                                   Text(data['pending_qty']?.toString() ?? '')),
//                         ),
//                       ),
//                       DataCell(
//                         InkWell(
//                           onTap: () => _showDetailsDialog(data),
//                           child: Align(
//                               alignment: Alignment.center,
//                               child:
//                                   Text(data['locator_det']?.toString() ?? '')),
//                         ),
//                       ),
//                       DataCell(
//                         InkWell(
//                           onTap: () => _showDetailsDialog(data),
//                           child: Align(
//                               alignment: Alignment.center,
//                               child:
//                                   Text(data['lot_total_nb']?.toString() ?? '')),
//                         ),
//                       ),
//                       DataCell(
//                         InkWell(
//                           onTap: () => _showDetailsDialog(data),
//                           child: Align(
//                               alignment: Alignment.center,
//                               child: Text(data['uom']?.toString() ?? '')),
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//     );
//   }
// }
