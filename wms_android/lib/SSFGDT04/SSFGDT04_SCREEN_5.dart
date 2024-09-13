import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
// import 'test.dart';

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
  List<String> _deletedItems = [];

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

  // Future<void> fetchIntefaceNonePO() async {
  //   final response = await http.get(Uri.parse(
  //       'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_5_Inteface_NonePO_WMS2ERP/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${gb.APP_USER}'));
  //   if (response.statusCode == 200) {
  //     final responseBody = utf8.decode(response.bodyBytes);
  //     final data = jsonDecode(responseBody);
  //     setState(() {
  //       // Update gridItems with new data
  //       gridItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
  //     });
  //   } else {
  //     throw Exception('Failed to load DOC_TYPE items');
  //   }
  // }

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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async{
                        await chk_IntefaceNonePO();
                    if (poStatus == '0') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            // title: Text('การบันทึก และส่งข้อมูลเข้า ERP สมบูรณ์'),
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
                    }else if (poStatus == '1') {
                        // Show a different popup for status 1
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              // title: Text('แจ้งเตือน'),
                              content: Text(poMessage ?? ''),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  // onPressed: () async {
                    // await fetchIntefaceNonePO();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => NewCardScreen(
                    //         //       po_doc_no:
                    //         //                     widget.po_doc_no, // ส่งค่า po_doc_no
                    //         //                 po_doc_type: widget.po_doc_type ??
                    //         //                     '', // ส่งค่า po_doc_type
                    //         //                 pWareCode: widget.pWareCode,
                    //         //                 // p_ref_no: _refNoController.text ?? '',
                    //         //                 // mo_do_no: _moDoNoController.text ?? '',
                    //         ),
                    //   ),
                    // );
                    // await fetchData();
                    // เพิ่มโค้ดสำหรับการทำงานของปุ่มถัดไปที่นี่
                  // },
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      // letterSpacing: 1.2,
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
                    // padding: const EdgeInsets.all(0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius:
                    BorderRadius.circular(8), // Rounded corners (optional)
              ),
              child: Text(
                '${widget.po_doc_no}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(height: 10), // Spacing between text and grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Number of columns in the grid
                  crossAxisSpacing: 8.0, // Horizontal spacing between items
                  mainAxisSpacing: 8.0, // Vertical spacing between items
                  childAspectRatio:
                      1.7, // Adjust aspect ratio to control card height
                ),
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
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align children to the left except title
                        children: [
                          // Centered Title
                          Center(
                            child: Text(
                              item['item_code'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                              textAlign:
                                  TextAlign.center, // Ensure text is centered
                            ),
                          ),
                          // Sub-information
                          // SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .end, // Align sub-information to the left
                            children: [
                              Text(
                                'จำนวนรับ: ${item['pack_qty'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'จำนวน Pallet: ${item['count_qty'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'จำนวนรวม: ${item['count_qty_in'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
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
