import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
// import 'SSFGDT04_SCREEN_5.dart';
import 'package:intl/intl.dart';
import 'SSFGDT04_SCANBARCODE.dart';
import '../styles.dart';
// import 'package:wms_android/custom_drawer.dart';

class SSFGDT04_GRID extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจาก lov
  final String po_doc_no;
  final String po_doc_type;
  final String p_ref_no;
  final String mo_do_no;

  const SSFGDT04_GRID({
    super.key,
    required this.pWareCode,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.p_ref_no,
    required this.mo_do_no,
  });

  @override
  _SSFGDT04_GRIDState createState() => _SSFGDT04_GRIDState();
}

class _SSFGDT04_GRIDState extends State<SSFGDT04_GRID> {
  List<Map<String, dynamic>> gridItems = [];
  // List<Map<String, dynamic>> setqc = [];
  late TextEditingController _docNoController;
  List<dynamic> data = [];
  List<String> deletedItemCodes = [];
  String? poStatus;
  String? poMessage;
  String? setqc;

  @override
  void initState() {
    super.initState();
    fetchGridItems();
    fetchSetQC();
    _docNoController = TextEditingController(text: widget.po_doc_no);
  }

  Future<void> _showEditDialog(
      BuildContext context, Map<String, dynamic> item) async {
    final quantityController = TextEditingController(
      text: item['pack_qty'] != null
          ? NumberFormat('#,###').format(item['pack_qty'])
          : '',
    );

    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      barrierDismissible:
          true, // Can be dismissed by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          // Add a stack to allow placing the close button in the top right corner
          content: Stack(
            clipBehavior: Clip.none, // Allow overflow
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
              // Adding padding around the form to adjust the spacing
              Padding(
                padding: const EdgeInsets.only(
                    top: 40.0), // Adjust top padding to control space
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: ListBody(
                      children: <Widget>[
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'จำนวนรับ',
                            border: OutlineInputBorder(),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter a quantity';
                          //   }
                          //   if (int.tryParse(value) == null) {
                          //     return 'Please enter a valid number';
                          //   }
                          //   return null;
                          // },
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
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.green, // Add a border color
                    width: 1.5, // Border width
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(60, 40),
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    final newQuantity = NumberFormat('#,###')
                        .parse(quantityController.text)
                        .toString();

                    // Update the item in the gridItems list
                    await fetchUpdate(newQuantity, item['seq']);
                    setState(() {
                      fetchGridItems();
                    });

                    // Close the popup
                    Navigator.of(context).pop();
                  }
                },
                child: Image.asset(
                  'assets/images/check-mark.png',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUpdate(String? poPackQty, int poSeq) async {
    const url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_3_update_wms_itd';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'PACK_QTY': poPackQty,
      'SEQ': poSeq.toString(),
      'DOC_NO': widget.po_doc_no,
      'DOC_TYPE': widget.po_doc_type,
      'OU_CODE': gb.P_ERP_OU_CODE,
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

  Future<void> fetchGridItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_3_WMS_IN_TRAN_DETAIL/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}/${gb.P_OU_CODE}'));
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      setState(() {
        // Update gridItems with new data
        gridItems = List<Map<String, dynamic>>.from(data['items'] ?? []);

        // Filter out deleted items
        gridItems = gridItems
            .where((item) => !deletedItemCodes.contains(item['item_code']))
            .toList();
      });
    } else {
      throw Exception('Failed to load DOC_TYPE items');
    }
  }

  Future<void> fetchGetPo() async {
    const url = 'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_3_GET_PO';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'V_DOC_NO': widget.po_doc_no,
      'V_DOC_TYPE': widget.po_doc_type,
      'V_REF_NO': widget.p_ref_no,
      'V_MO_DO_NO': widget.mo_do_no,
      'V_WAREHOUSE': gb.P_WARE_CODE,
      'APP_USER': gb.APP_USER,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      'P_OU_CODE': gb.P_OU_CODE,
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

  Future<void> delete(String? poDocNo, String? poDocTpye, int poSeq,
      String? poItemCode) async {
    print(poDocNo);
    print(poDocTpye);
    print(poSeq);
    print(poItemCode);
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_3_delete_DTL_WMS');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'P_DOC_NO': poDocNo,
        'P_DOC_TYPE': poDocTpye,
        'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
        'APP_USER': gb.APP_USER,
        'P_SEQ': poSeq,
        'P_ITEM_CODE': poItemCode,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final poStatus = responseBody['po_status'];
      final poMessage = responseBody['po_message'];
      print('po_status: $poStatus');
      print('po_message: $poMessage');
      if (poStatus == 'success') {
        // Only update UI if deletion was successful
        setState(() {
          // Remove the item from the list
          gridItems.removeWhere((item) =>
              item['item_code'] == poItemCode && item['po_seq'] == poSeq);
          deletedItemCodes.add(poItemCode!);
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> fetchSetQC() async {
    // print('po_status $poQcPass Type: ${poQcPass.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_3_set_qc/${gb.P_ERP_OU_CODE}/${widget.po_doc_type}/${widget.po_doc_no}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> setQC =
            jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          setqc = setQC['v_qc_pass']; // อัปเดตค่าภายใน setState
        });
        print('setQC : $setQC type : ${setQC.runtimeType}');
      } else {
        print('setQC Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {});
      print('setQC ERROR IN Fetch Data : $e');
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
      appBar: const CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      // endDrawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Row with two buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (gridItems.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            // title: Center(child: Text('คำเตือน')),
                            content: const Text(
                                'ระบบมีการบันทึกรายการทิ้งไว้ หากดึง ใบผลิต จะเคลียร์รายการทั้งหมดทิ้ง, ต้องการดึงใบผลิตใหม่หรือไม่'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await fetchGetPo();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      await fetchGetPo();
                      if (poStatus == '0') {
                        // Show a warning for duplicate data
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              // title: Text('Duplicate Data'),
                              content: Text(poMessage ?? ''),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else if (poStatus == '1') {
                        // Show a different popup for status 1
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              // title: Text('Status Alert'),
                              content: Text(poMessage ?? ''),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
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
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(60, 40),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: Image.asset(
                    'assets/images/business.png', // Path to your image
                    width: 30, // Adjust width
                    height: 30, // Adjust height
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SSFGDT04_SCANBARCODE(
                          po_doc_no: widget.po_doc_no, // ส่งค่า po_doc_no
                          po_doc_type: widget.po_doc_type, // ส่งค่า po_doc_type
                          pWareCode: widget.pWareCode,
                          setqc: setqc ?? '',
                        ),
                      ),
                    );
                  },
                  style: AppStyles.NextButtonStyle(),
                  child: Image.asset(
                    'assets/images/right.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                    width: 20, // ปรับขนาดตามที่ต้องการ
                    height: 20, // ปรับขนาดตามที่ต้องการ
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: _buildCards(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _buildCards() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.po_doc_no,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
// Text with background color
          Container(
            width: double.infinity, // ทำให้กว้างเต็มที่
            padding:
                const EdgeInsets.symmetric(vertical: 8), // ปรับ padding ซ้ายขวาเป็น 0
            decoration: BoxDecoration(
              color: Colors.lightBlue[100], // Background color for the text
              borderRadius:
                  BorderRadius.circular(8), // Rounded corners (optional)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30), // Padding ซ้ายขวา
              child: Text(
                setqc ?? '',
                //'${widget.setqc}', // Text ที่ต้องการแสดง
                style: const TextStyle(
                  color: Colors.black, // Text color
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true, // ให้ ListView มีขนาดตามข้อมูล
            physics: const NeverScrollableScrollPhysics(), // ปิดการเลื่อน
            itemCount: gridItems.length,
            itemBuilder: (context, index) {
              final item = gridItems[index];
              return Card(
                color: Colors.lightBlue[100],
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          item['item_code'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Divider(color: Colors.black26, thickness: 1),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'จำนวนรับ:',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    // Format the number if it's not null, else display an empty string
                                    item['pack_qty'] != null
                                        ? NumberFormat('#,###')
                                            .format(item['pack_qty'])
                                        : '',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
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
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'จำนวน Pallet:',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color:
                                      Colors.white, // กำหนดสีพื้นหลังที่ต้องการ
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ), // เพิ่ม padding รอบๆข้อความ
                                  child: Text(
                                    item['count_qty'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
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
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'จำนวนรวม:',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color:
                                      Colors.white, // กำหนดสีพื้นหลังที่ต้องการ
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ), // เพิ่ม padding รอบๆข้อความ
                                  child: Text(
                                    item['count_qty_in'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
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
                      const SizedBox(height: 8),
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
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // title: Text('ยืนยันการลบรายการ'),
                                    content: const Text('ต้องการลบรายการหรือไม่?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('ยกเลิก'),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('ลบ'),
                                        onPressed: () async {
                                          final poItemCode =
                                              item['item_code'];
                                          final poSeq = item['seq'];
                                          await delete(
                                              widget.po_doc_no,
                                              widget.po_doc_type,
                                              poSeq,
                                              poItemCode);
                                          setState(() {
                                            gridItems.removeWhere((item) =>
                                                item['item_code'] ==
                                                    poItemCode &&
                                                item['seq'] == poSeq);
                                          });
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          // Edit button as image
                          IconButton(
                            icon: Image.asset(
                              'assets/images/edit.png', // Your edit image path //assets/images/edit.png
                              width: 30,
                              height: 30,
                            ),
                            onPressed: () {
                              _showEditDialog(context, item);
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
        ],
      ),
    );
  }
}
