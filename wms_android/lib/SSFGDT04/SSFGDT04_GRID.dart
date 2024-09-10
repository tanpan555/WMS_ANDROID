import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSFGDT04_GRID extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจาก lov
  final String po_doc_no;
  final String po_doc_type;
  final String p_ref_no;
  final String mo_do_no;
  SSFGDT04_GRID({
    Key? key,
    required this.pWareCode,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.p_ref_no,
    required this.mo_do_no,
  }) : super(key: key);

  @override
  _SSFGDT04_GRIDState createState() => _SSFGDT04_GRIDState();
}

class _SSFGDT04_GRIDState extends State<SSFGDT04_GRID> {
  List<Map<String, dynamic>> gridItems = [];
  late TextEditingController _docNoController;
  List<dynamic> data = [];
  String? poStatus;
  String? poMessage;

  @override
  void initState() {
    super.initState();
    fetchGridItems();
    // Initialize the controller and set the initial value to po_doc_no
    _docNoController = TextEditingController(text: widget.po_doc_no);
    
  }

  Future<void> fetchGridItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/WMS_IN_TRAN_DETAIL/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}/${gb.P_OU_CODE}'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      setState(() {
        gridItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        // if (docTypeItems.isNotEmpty) {
        //   selectedDocType = docTypeItems[0]['doc_desc']; // Default selection
        // }
      });
    } else {
      throw Exception('Failed to load DOC_TYPE items');
    }
  }

  // Future<void> fetchGetPo() async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_3_GET_PO/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${widget.p_ref_no}/${widget.mo_do_no}/${widget.po_doc_type}/${widget.po_doc_no}/${gb.P_WARE_CODE}/${gb.APP_USER}'));

  //     if (response.statusCode == 200) {
  //       final responseBody = utf8.decode(response.bodyBytes);
  //       final responseData = jsonDecode(responseBody);
  //       print('Fetched data: $responseData');

  //       setState(() {
  //         data = List<Map<String, dynamic>>.from(responseData['items'] ?? []);
  //       });
  //       print('dataMenu : $data');
  //     } else {
  //       throw Exception('Failed to load fetchData');
  //     }
  //   } catch (e) {
  //     setState(() {});
  //     print('ERROR IN Fetch Data : $e');
  //   }
  // }

  Future<void> fetchGetPo() async {
    final url = 'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_3_GET_PO/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${widget.p_ref_no}/${widget.mo_do_no}/${widget.po_doc_type}/${widget.po_doc_no}/${gb.P_WARE_CODE}/${gb.APP_USER}';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'V_DOC_NO': widget.po_doc_no,
      'V_DOC_TYPE': widget.po_doc_type,
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
          fetchGridItems();
        });
        print('Success: $responseData');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
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
            // Row with two buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: fetchGetPo,
                  // onPressed: () async {
                  //   await fetchGetPo();
                  // },
                  child: Image.asset(
                    'assets/images/business.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                    width: 30, // ปรับขนาดตามที่ต้องการ
                    height: 30, // ปรับขนาดตามที่ต้องการ
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(60, 40),
                    padding: const EdgeInsets.all(0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // await fetchData();
                    // เพิ่มโค้ดสำหรับการทำงานของปุ่มถัดไปที่นี่
                  },
                  child: Image.asset(
                    'assets/images/right.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                    width: 20, // ปรับขนาดตามที่ต้องการ
                    height: 20, // ปรับขนาดตามที่ต้องการ
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(60, 40),
                    padding: const EdgeInsets.all(0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Spacing between buttons and text
            // Container with background color around the Text widget
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
                      1.3, // Adjust aspect ratio to control card height
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
                                .start, // Align sub-information to the left
                            children: [
                              Text(
                                'จำนวนรับ: ${item['pack_qty'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'จำนวน Pallet: ${item['count_qty'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'จำนวนรวม: ${item['count_qty_in'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: 8),
                          // Row with delete and edit buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Align buttons to left and right
                            children: [
                              // Delete button as image
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/bin.png', // Your delete image path
                                  width: 30,
                                  height: 30,
                                ),
                                onPressed: () {
                                  // Add delete functionality
                                  print('Delete item $index');
                                },
                              ),
                              // Edit button as image
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/edit (1).png', // Your edit image path
                                  width: 30,
                                  height: 30,
                                ),
                                onPressed: () {
                                  // Add edit functionality
                                  print('Edit item $index');
                                },
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
