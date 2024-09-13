import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
// import 'test.dart';
// import '../bottombar.dart';

class SSFGDT04_Screen_5 extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจาก lov
  final String po_doc_no;
  final String po_doc_type;
  // // final String p_ref_no;
  // // final String mo_do_no;

  SSFGDT04_Screen_5({
    Key? key,
    required this.pWareCode,
    required this.po_doc_no,
    required this.po_doc_type,
    //   // required this.p_ref_no,
    //   // required this.mo_do_no,
  }) : super(key: key);
  @override
  _SSFGDT04Screen5State createState() => _SSFGDT04Screen5State();
}

class _SSFGDT04Screen5State extends State<SSFGDT04_Screen_5> {
  List<Map<String, dynamic>> gridItems = [];
  late TextEditingController _docNoController;
  // List<String> _deletedItems = [];

  @override
  void initState() {
    super.initState();
    fetchGridItems();
    // fetchIntefaceNonePO();
    _docNoController = TextEditingController(text: widget.po_doc_no);
  }

  Future<void> fetchGridItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_5_WMS_IN_TRAN_DETAIL/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}/${gb.P_OU_CODE}'));
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      setState(() {
        // Update gridItems with new data
        gridItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
      });
    } else {
      throw Exception('Failed to load DOC_TYPE items');
    }
  }

  String? poStatus;
  String? poMessage;
  String? poErpDocNo;

  Future<void> chk_IntefaceNonePO() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_5_Inteface_NonePO_WMS2ERP/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${gb.APP_USER}'));
      print(widget.po_doc_no);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = json.decode(responseBody);
        setState(() {
          poStatus = data['po_status'];
          poMessage = data['po_message'];
          poErpDocNo = data['po_erp_doc_no'];
          print(response.statusCode);
          print(data);
          print(poStatus);
          print(poMessage);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _docNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Padding(
        padding: const EdgeInsets.all(20), // เพิ่ม padding รอบๆ
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // จัดให้อยู่เริ่มต้นแนวตั้ง
          children: [
            // ElevatedButton ที่จะอยู่ด้านบน
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await chk_IntefaceNonePO();
                    if (poStatus == '0') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text('${poErpDocNo ?? ''}'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (poStatus == '1') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(poMessage ?? ''),
                            actions: [
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
                    }
                  },
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.green, // Add a border color
                      width: 2, // Border width
                    ),
                    backgroundColor: Colors.green[100],
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(60, 40),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // เพิ่มระยะห่างระหว่างปุ่มและ Container
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white, // สีพื้นหลังของ Container
                  borderRadius:
                      BorderRadius.circular(8), // มุมโค้งของ Container
                ),
                child: Text(
                  '${widget.po_doc_no}', // ข้อความที่จะแสดง
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
                height: 10), // เพิ่มระยะห่างระหว่าง Container และ Card
            Expanded(
              child: ListView.builder(
                itemCount: gridItems.length, // Number of items in the grid
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return Card(
                    color: Colors.lightBlue[100],
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(
                          20), // Add padding inside the card
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Let the column adjust based on content size
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Space out the widgets vertically
                        children: [
                          // Centered Title
                          Center(
                            child: Text(
                              item['item_code'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign:
                                  TextAlign.center, // Ensure text is centered
                            ),
                          ),
                          const Divider(
                      color: Colors.black26, // สีเส้น Divider เบาลง
                      thickness: 1,
                    ),
                          SizedBox(height: 8),
                          // Sub-information with Left-Right Layout
                          Column(
                            children: [
                              // Row for "จำนวนรับ" and value
                              Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // จัดให้อยู่ทางซ้ายในแนวนอน
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'จำนวนรับ:',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color:
                                    Colors.white, // กำหนดสีพื้นหลังที่ต้องการ
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ), // เพิ่ม padding รอบๆข้อความ
                                child: Text(
                                  (item['pack_qty'] ?? '').toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), // ระยะห่างระหว่างข้อมูล

                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // จัดให้อยู่ทางซ้ายในแนวนอน
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'จำนวน Pallet:',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color:
                                    Colors.white, // กำหนดสีพื้นหลังที่ต้องการ
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ), // เพิ่ม padding รอบๆข้อความ
                                child: Text(
                                  item['count_qty'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // จัดให้อยู่ทางซ้ายในแนวนอน
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'จำนวนรวม:',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color:
                                    Colors.white, // กำหนดสีพื้นหลังที่ต้องการ
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ), // เพิ่ม padding รอบๆข้อความ
                                child: Text(
                                  item['count_qty_in'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
