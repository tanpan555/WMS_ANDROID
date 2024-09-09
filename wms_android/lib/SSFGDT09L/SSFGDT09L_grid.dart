import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';

class Ssfgdt09lGrid extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String pAttr1;
  final String docNo;
  final String docType;
  // final String moDoNo;
  // final String refNo;
  final String statusCase;
  Ssfgdt09lGrid({
    Key? key,
    required this.pWareCode,
    required this.pAttr1,
    required this.docNo,
    required this.docType,
    // required this.moDoNo,
    // required this.refNo,
    required this.statusCase,
  }) : super(key: key);
  @override
  _Ssfgdt09lGridState createState() => _Ssfgdt09lGridState();
}

class _Ssfgdt09lGridState extends State<Ssfgdt09lGrid> {
  //
  List<dynamic> dataCard = [];
  List<Map<String, dynamic>> dataCardForTest = [
    {
      'rowid': '1',
      'bin_del': 'test bin_del 1',
      'item_code': 'test item_code 1',
      'nb_item_name': 'test nb_item_name 1',
      'pack_code': 'test pack_code 1',
      'nb_pack_name': 'test nb_pack_name 1',
      'location_code': 'test location_code 1',
      'pack_qty': 'test pack_qty 1',
      'pre_qty': 'test pre_qty 1',
      'grade': 'test grade 1',
      'lots_no': 'test lots_no 1',
      'product_date': 'test product_date 1',
      'nb_diff_qty': 'test nb_diff_qty',
      'lot': 'test lot 1',
      'pd_location': 'test pd_location 1',
      'reason_mismatch': 'test reason_mismatch 1',
      'seq': 'test seq 1',
      'attribute3': 'test attribute3 1',
      'attribute4': 'test attribute4 1',
    },
    {
      'rowid': '2',
      'bin_del': 'test bin_del 2',
      'item_code': 'test item_code 2',
      'nb_item_name': 'test nb_item_name 2',
      'pack_code': 'test pack_code 2',
      'nb_pack_name': 'test nb_pack_name 2',
      'location_code': 'test location_code 2',
      'pack_qty': 'test pack_qty 2',
      'pre_qty': 'test pre_qty 2',
      'grade': 'test grade 2',
      'lots_no': 'test lots_no 2',
      'product_date': 'test product_date 2',
      'nb_diff_qty': 'test nb_diff_qty',
      'lot': 'test lot 2',
      'pd_location': 'test pd_location 2',
      'reason_mismatch': 'test reason_mismatch 2',
      'seq': 'test seq 2',
      'attribute3': 'test attribute3 2',
      'attribute4': 'test attribute4 2',
    },
    {
      'rowid': '3',
      'bin_del': 'test bin_del 3',
      'item_code': 'test item_code 3',
      'nb_item_name': 'test nb_item_name 3',
      'pack_code': 'test pack_code 3',
      'nb_pack_name': 'test nb_pack_name 3',
      'location_code': 'test location_code 3',
      'pack_qty': 'test pack_qty 3',
      'pre_qty': 'test pre_qty 3',
      'grade': 'test grade 3',
      'lots_no': 'test lots_no 3',
      'product_date': 'test product_date 3',
      'nb_diff_qty': 'test nb_diff_qty',
      'lot': 'test lot 3',
      'pd_location': 'test pd_location 3',
      'reason_mismatch': 'test reason_mismatch 3',
      'seq': 'test seq 3',
      'attribute3': 'test attribute3 3',
      'attribute4': 'test attribute4 3',
    },
    {
      'rowid': '4',
      'bin_del': 'test bin_del 4',
      'item_code': 'test item_code 4',
      'nb_item_name': 'test nb_item_name 4',
      'pack_code': 'test pack_code 4',
      'nb_pack_name': 'test nb_pack_name 4',
      'location_code': 'test location_code 4',
      'pack_qty': 'test pack_qty 4',
      'pre_qty': 'test pre_qty 4',
      'grade': 'test grade 4',
      'lots_no': 'test lots_no 4',
      'product_date': 'test product_date 4',
      'nb_diff_qty': 'test nb_diff_qty',
      'lot': 'test lot 4',
      'pd_location': 'test pd_location 4',
      'reason_mismatch': 'test reason_mismatch 4',
      'seq': 'test seq 4',
      'attribute3': 'test attribute3 4',
      'attribute4': 'test attribute4 4',
    },
    {
      'rowid': '5',
      'bin_del': 'test bin_del 5',
      'item_code': 'test item_code 5',
      'nb_item_name': 'test nb_item_name 5',
      'pack_code': 'test pack_code 5',
      'nb_pack_name': 'test nb_pack_name 5',
      'location_code': 'test location_code 5',
      'pack_qty': 'test pack_qty 5',
      'pre_qty': 'test pre_qty 5',
      'grade': 'test grade 5',
      'lots_no': 'test lots_no 5',
      'product_date': 'test product_date 5',
      'nb_diff_qty': 'test nb_diff_qty',
      'lot': 'test lot 5',
      'pd_location': 'test pd_location 5',
      'reason_mismatch': 'test reason_mismatch 5',
      'seq': 'test seq 5',
      'attribute3': 'test attribute3 5',
      'attribute4': 'test attribute4 5',
    },
  ];
  @override
  void initState() {
    super.initState();
    fetchData();
    print('docNo : ${widget.docNo} Type : ${widget.docNo.runtimeType}');
    print('docType : ${widget.docType} Type : ${widget.docType.runtimeType}');
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_SelectDataGrid/${widget.pWareCode}/${widget.docType}/${widget.docNo}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        setState(() {
          dataCard =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataCard : $dataCard');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data : $e');
    }
  }

  Future<void> updatePackQty(
      int packQty, String itemCode, String packCode, String rowID) async {
    print('packQty in updatePackQty: $packQty type : ${packQty.runtimeType}');
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_UpdatePackQty';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pack_qty': packQty,
      'item_code': itemCode,
      'pack_code': packCode,
      'rowid': rowID,
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
          // fetchData();
        });
        print('Success: $responseData');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('มันจั๊กอะไรกะตรงนี้เนี่ยยยยยยยยยย Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    minimumSize: const Size(10, 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: const Text(
                    'Picking Slip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // --------------------------------------------------------------------
                // const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    iconSize: 20.0,
                    icon: Image.asset(
                      'assets/images/right.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // --------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                      border: Border.all(
                        color: Colors.black, // ขอบสีดำ
                        width: 2.0, // ความกว้างของขอบ 2.0
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // เพิ่มมุมโค้งให้กับ Container
                    ),
                    child: Center(
                      child: Text(
                        '${widget.docNo}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow[200], // พื้นหลังสีเหลืองอ่อน
                      border: Border.all(
                        color: Colors.black, // ขอบสีดำ
                        width: 2.0, // ความกว้างของขอบ 2.0
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // เพิ่มมุมโค้งให้กับ Container
                    ),
                    child: Center(
                      child: Text(
                        '230303001',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // ปรับขนาดตัวอักษรตามที่ต้องการ
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // --------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    minimumSize: const Size(10, 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: const Text(
                    '+Create',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // --------------------------------------------------------------------
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    minimumSize: const Size(10, 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: const Text(
                    '+Clear All',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // --------------------------------------------------------------------
              ],
            ),
            //  Container(
            // height: MediaQuery.of(context).size.height * 0.8,
            // width: MediaQuery.of(context).size.width * 0.8,
            // height: 300,
            // width: 300,
            // child:
            Expanded(
              child: ListView(
                // shrinkWrap: true,
                // children: dataCardForTest.map((item) {
                // สำหรับ test
                children: dataCard.map((item) {
                  // Color cardColor;
                  // String statusText;
                  // String iconImageYorN;

                  // switch (item['card_status_desc']) {
                  //   case 'ปกติ':
                  //     cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                  //     statusText = 'ปกติ';
                  //     break;
                  //   case 'ยืนยันการจ่าย' || 'ยืนยันการรับ':
                  //     cardColor = Color.fromRGBO(146, 208, 80, 1.0);
                  //     statusText = 'ยืนยันการรับ';
                  //     break;
                  //   case 'ยกเลิก':
                  //     cardColor = Color.fromRGBO(208, 206, 206, 1.0);
                  //     statusText = 'ยกเลิก';
                  //     break;
                  //   case 'ระหว่างบันทึก':
                  //     cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                  //     statusText = 'ระหว่างบันทึก';
                  //     break;
                  //   case 'อ้างอิงแล้ว':
                  //     cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                  //     statusText = 'อ้างอิงแล้ว';
                  //     break;
                  //   default:
                  //     cardColor = Color.fromRGBO(255, 255, 255, 1.0);
                  //     statusText = 'Unknown';
                  // }

                  // switch (item['qc_yn']) {
                  //   case 'Y':
                  //     iconImageYorN = 'assets/images/rt_machine_on.png';
                  //     break;
                  //   case 'N':
                  //     iconImageYorN = 'assets/images/rt_machine_off.png';
                  //     break;
                  //   default:
                  //     iconImageYorN = 'assets/images/rt_machine_off.png';
                  // }

                  return Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Color.fromRGBO(204, 235, 252, 1.0),
                    child: InkWell(
                      onTap: () {
                        // checkStatusCard(item['po_no'] ?? '',
                        //     item['p_doc_no'] ?? '', item['p_doc_type'] ?? '');

                        // print(
                        //     'po_no in Card : ${item['po_no']} Type : ${item['po_no'].runtimeType}');
                        // print(
                        //     'p_doc_no in Card : ${item['p_doc_no']} Type : ${item['p_doc_no'].runtimeType}');
                        // print(
                        //     'p_doc_type in Card : ${item['p_doc_type']} Type : ${item['p_doc_type'].runtimeType}');
                      },
                      borderRadius: BorderRadius.circular(15.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // InkWell(
                                //   onTap: () {},
                                //   child: Container(
                                //     width: 100,
                                //     height: 40,
                                //     // color: cardColor, // เปลี่ยนสีพื้นหลังที่นี่
                                //     child: Image.asset(
                                //       'assets/images/printer.png',
                                //       fit: BoxFit.contain,
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Item : ${item['item_code'] ?? ''}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Lot No : ${item['lots_no'] ?? ''}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                // -------------------------------------------------------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'จำนวนที่จ่าย : ${NumberFormat('#,###,###,###,###,###').format(item['pack_qty'] ?? '')}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Pack : ${item['pack_code'] ?? ''}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                // -------------------------------------------------------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Locator : ${item['location_code'] ?? ''}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'PD Location : ${item['pd_location'] ?? ''}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                // -------------------------------------------------------------
                                Text(
                                  'Reason : ${item['reason_mismatch'] ?? ''}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(height: 4.0),
                                // -------------------------------------------------------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'ใช้แทนจุด : ${item['attribute3'] ?? ''}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Replace Lot# : ${item['attribute4'] ?? ''} ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                // -------------------------------------------------------------
                                // Text(
                                //   'No : ${item['seq']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Item : ${item['item_code']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Lot No : ${item['lots_no']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'จำนวนที่จ่าย : ${item['pack_qty']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Pack : ${item['pack_code']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Locator : ${item['location_code']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'PD Location : ${item['pd_location']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Reason : ${item['reason_mismatch']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'ใช้แทนจุด : ${item['attribute3']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Replace Lot# : ${item['attribute4']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Item Desc : ${item['nb_item_name']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),
                                // Text(
                                //   'Pack Desc : ${item['nb_pack_name']}',
                                //   style: TextStyle(color: Colors.black),
                                // ),

                                SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        // color: cardColor, // เปลี่ยนสีพื้นหลังที่นี่
                                        child: Image.asset(
                                          'assets/images/bin.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDetailsDialog(
                                          context,
                                          item['pack_qty'],
                                          item['nb_item_name'] ?? '',
                                          item['nb_pack_name'] ?? '',
                                          item['item_code'] ?? '',
                                          item['pack_code'] ?? '',
                                          item['rowid'] ?? '',
                                        );
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        // color: cardColor, // เปลี่ยนสีพื้นหลังที่นี่
                                        child: Image.asset(
                                          'assets/images/edit (1).png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // ),
            // --------------------------------------------------------------------
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void showDetailsDialog(BuildContext context, int packQty, String nbItemName,
      String nbPackName, String itemCode, String packCode, String rowID) {
    String formattedSysQty =
        NumberFormat('#,###,###,###,###,###').format(packQty);
    TextEditingController packQtyController =
        TextEditingController(text: formattedSysQty.toString());
    TextEditingController nbItemNameController =
        TextEditingController(text: nbItemName.toString());
    TextEditingController nbPackNameController =
        TextEditingController(text: nbPackName.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('รายละเอียด'), // หัวเรื่องของ Dialog
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // จัดชิดซ้าย
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: packQtyController,
                    // readOnly: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'จำนวนที่จ่าย',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: nbItemNameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Item Desc',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: nbPackNameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Pack Desc',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                int updatedPackQty =
                    int.tryParse(packQtyController.text) ?? packQty;

                Navigator.of(context).pop();
                await updatePackQty(updatedPackQty, itemCode, packCode, rowID);
                await fetchData();
                setState(() {});
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog เมื่อกดปุ่มนี้
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogcomf(
    BuildContext context,
    String messageCard,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'Error',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    messageCard,
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ย้อนกลับ'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
