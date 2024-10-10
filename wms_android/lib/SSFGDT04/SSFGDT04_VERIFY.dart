import 'package:flutter/material.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:intl/intl.dart';
import '../styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'SSFGDT04_MENU.dart';
// import 'package:wms_android/custom_drawer.dart';

class SSFGDT04_VERIFY extends StatefulWidget {
  final String pWareCode;
  final String po_doc_no;
  final String po_doc_type;
  final String setqc;

  const SSFGDT04_VERIFY({
    super.key,
    required this.pWareCode,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.setqc,
  });

  @override
  _SSFGDT04_VERIFYState createState() => _SSFGDT04_VERIFYState();
}

class _SSFGDT04_VERIFYState extends State<SSFGDT04_VERIFY> {
  List<Map<String, dynamic>> gridItems = [];
  late TextEditingController _docNoController;
  String pDsPdf = gb.P_DS_PDF;

  String? V_DS_PDF;
  String? LIN_ID;
  String? OU_CODE;
  String? USER_ID;
  String? PROGRAM_ID;
  String? P_SESSION;

  String? S_DOC_TYPE;
  String? S_DOC_NO;
  String? E_DOC_TYPE;
  String? E_DOC_NO;
  String? FLAG;

  String? LH_PAGE;
  String? LH_DATE;
  String? LH_WARE;
  String? LH_DOC_NO;
  String? LH_DOC_DATE;
  String? LH_DOC_TYPE;
  String? LH_PROGRAM_NAME;
  String? LH_REF_NO1;
  String? LH_REF_NO2;

  String? LB_ITEM_CODE;
  String? LB_ITEM_NAME;
  String? LB_LOCATION;
  String? LB_UMS;
  String? LB_TRAN_QTY;
  String? LB_TRAN_UCOST;
  String? LB_TRAN_AMT;

  String? LT_NOTE;
  String? LT_TOTAL;
  String? LT_INPUT;
  String? LT_RECEIVE;
  String? LT_CHECK;

  String? LB_PALLET_NO;
  String? LB_PALLET_QTY;
  String? LH_MO_DO_NO;

  @override
  void initState() {
    super.initState();
    fetchGridItems();
    _docNoController = TextEditingController(text: widget.po_doc_no);
  }

  Future<void> fetchGridItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_5_WMS_IN_TRAN_DETAIL/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}/${gb.P_OU_CODE}'));
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      if (mounted) {
        setState(() {
          gridItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        });
      }
    } else {
      throw Exception('Failed to load DOC_TYPE items');
    }
  }

  String? poStatus;
  String? poMessage;
  String? poErpDocNo;
  String? vTypeComplete;

  Future<void> chk_IntefaceNonePO() async {
    print(poErpDocNo);
    print(vTypeComplete);
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_5_Inteface_NonePO_WMS2ERP/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${gb.APP_USER}'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = json.decode(responseBody);
        if (mounted) {setState(() {
          poStatus = data['po_status'];
          poMessage = data['po_message'];
          poErpDocNo = data['po_erp_doc_no'];
          vTypeComplete = data['v_type_complete'];
        });}
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getPDF(String poDocNo) async {
    // po_doc_no = 'WM00-24090776';
    // po_doc_type = 'FGI03';
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT04/Step_5_GET_PDF/${gb.P_DS_PDF}/${gb.BROWSER_LANGUAGE}/${widget.po_doc_no}/${gb.P_ERP_OU_CODE}/${gb.APP_USER}/${gb.APP_SESSION}/${gb.FLAG}'));

      print('Response body: ${response.body}'); // แสดงข้อมูลที่ได้รับจาก API

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataPDF = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
        if (mounted) {setState(() {
          V_DS_PDF = dataPDF['V_DS_PDF'] ?? '';
          LIN_ID = dataPDF['LIN_ID'] ?? '';
          OU_CODE = dataPDF['OU_CODE'] ?? '';
          USER_ID = dataPDF['USER_ID'] ?? '';
          PROGRAM_ID = dataPDF['PROGRAM_ID'] ?? '';
          P_SESSION = dataPDF['P_SESSION'] ?? '';

          S_DOC_TYPE = dataPDF['S_DOC_TYPE'] ?? '';
          S_DOC_NO = dataPDF['S_DOC_NO'] ?? '';
          E_DOC_TYPE = dataPDF['E_DOC_TYPE'] ?? '';
          E_DOC_NO = dataPDF['E_DOC_NO'] ?? '';
          FLAG = dataPDF['FLAG'] ?? '';

          LH_PAGE = dataPDF['LH_PAGE'] ?? '';
          LH_DATE = dataPDF['LH_DATE'] ?? '';
          LH_WARE = dataPDF['LH_WARE'] ?? '';
          LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
          LH_DOC_NO = dataPDF['LH_DOC_NO'] ?? '';
          LH_DOC_DATE = dataPDF['LH_DOC_DATE'] ?? '';
          LH_DOC_TYPE = dataPDF['LH_DOC_TYPE'] ?? '';
          LH_PROGRAM_NAME = dataPDF['LH_PROGRAM_NAME'] ?? '';
          LH_REF_NO1 = dataPDF['LH_REF_NO1'] ?? '';
          LH_REF_NO2 = dataPDF['LH_REF_NO2'] ?? '';

          LB_ITEM_CODE = dataPDF['LB_ITEM_CODE'] ?? '';
          LB_ITEM_NAME = dataPDF['LB_ITEM_NAME'] ?? '';
          LB_LOCATION = dataPDF['LB_LOCATION'] ?? '';
          LB_UMS = dataPDF['LB_UMS'] ?? '';
          LB_TRAN_QTY = dataPDF['LB_TRAN_QTY'] ?? '';
          LB_TRAN_UCOST = dataPDF['LB_TRAN_UCOST'] ?? '';
          LB_TRAN_AMT = dataPDF['LB_TRAN_AMT'] ?? '';

          LT_NOTE = dataPDF['LT_NOTE'] ?? '';
          LT_TOTAL = dataPDF['LT_TOTAL'] ?? '';
          LT_INPUT = dataPDF['LT_INPUT'] ?? '';
          LT_RECEIVE = dataPDF['LT_RECEIVE'] ?? '';
          LT_CHECK = dataPDF['LT_CHECK'] ?? '';

          LB_PALLET_NO = dataPDF['LB_PALLET_NO'] ?? '';
          LB_PALLET_QTY = dataPDF['LB_PALLET_QTY'] ?? '';
          LH_MO_DO_NO = dataPDF['LH_MO_DO_NO'] ?? '';

          _launchUrl(poDocNo);
        });}
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in submit Data: $e');
    }
  }

  Future<void> _launchUrl(String poDocNo) async {
    final uri = Uri.parse('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/SSFGOD01'
        '&_repFormat=pdf'
        '&_dataSource=${gb.P_DS_PDF}'
        '&_outFilename=$poDocNo.pdf'
        '&_repLocale=en_US'
        '&V_DS_PDF=$V_DS_PDF'
        '&LIN_ID=$LIN_ID'
        '&OU_CODE=${gb.P_ERP_OU_CODE}'
        '&USER_ID=$USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&P_SESSION=$P_SESSION'
        '&S_DOC_TYPE=$S_DOC_TYPE'
        '&S_DOC_NO=$S_DOC_NO'
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_NO=$E_DOC_NO'
        '&FLAG=${gb.FLAG}'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        '&LH_WARE=$LH_WARE'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_DOC_DATE=$LH_DOC_DATE'
        '&LH_DOC_TYPE=$LH_DOC_TYPE'
        '&LH_PROGRAM_NAME=$LH_PROGRAM_NAME'
        '&LH_REF_NO1=$LH_REF_NO1'
        '&LH_REF_NO2=$LH_REF_NO2'
        '&LB_ITEM_CODE=$LB_ITEM_CODE'
        '&LB_ITEM_NAME=$LB_ITEM_NAME'
        '&LB_LOCATION=$LB_LOCATION'
        '&LB_UMS=$LB_UMS'
        '&LB_TRAN_QTY=$LB_TRAN_QTY'
        '&LB_TRAN_UCOST=$LB_TRAN_UCOST'
        '&LB_TRAN_AMT=$LB_TRAN_AMT'
        '&LT_NOTE=$LT_NOTE'
        '&LT_TOTAL=$LT_TOTAL'
        '&LT_INPUT=$LT_INPUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_CHECK=$LT_CHECK'
        '&LB_PALLET_NO=$LB_PALLET_NO'
        '&LB_PALLET_QTY=$LB_PALLET_QTY'
        '&LH_MO_DO_NO=$LH_MO_DO_NO');

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    print('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/SSFGOD01'
        '&_repFormat=pdf'
        '&_dataSource=${gb.P_DS_PDF}'
        '&_outFilename=$poDocNo.pdf'
        '&_repLocale=en_US'
        '&V_DS_PDF=$V_DS_PDF'
        '&LIN_ID=$LIN_ID'
        '&OU_CODE=${gb.P_ERP_OU_CODE}'
        '&USER_ID=$USER_ID'
        '&PROGRAM_ID=$PROGRAM_ID'
        '&P_SESSION=$P_SESSION'
        '&S_DOC_TYPE=$S_DOC_TYPE'
        '&S_DOC_NO=$S_DOC_NO'
        '&E_DOC_TYPE=$E_DOC_TYPE'
        '&E_DOC_NO=$E_DOC_NO'
        '&FLAG=${gb.FLAG}'
        '&LH_PAGE=$LH_PAGE'
        '&LH_DATE=$LH_DATE'
        '&LH_WARE=$LH_WARE'
        '&LH_DOC_NO=$LH_DOC_NO'
        '&LH_DOC_DATE=$LH_DOC_DATE'
        '&LH_DOC_TYPE=$LH_DOC_TYPE'
        '&LH_PROGRAM_NAME=$LH_PROGRAM_NAME'
        '&LH_REF_NO1=$LH_REF_NO1'
        '&LH_REF_NO2=$LH_REF_NO2'
        '&LB_ITEM_CODE=$LB_ITEM_CODE'
        '&LB_ITEM_NAME=$LB_ITEM_NAME'
        '&LB_LOCATION=$LB_LOCATION'
        '&LB_UMS=$LB_UMS'
        '&LB_TRAN_QTY=$LB_TRAN_QTY'
        '&LB_TRAN_UCOST=$LB_TRAN_UCOST'
        '&LB_TRAN_AMT=$LB_TRAN_AMT'
        '&LT_NOTE=$LT_NOTE'
        '&LT_TOTAL=$LT_TOTAL'
        '&LT_INPUT=$LT_INPUT'
        '&LT_RECEIVE=$LT_RECEIVE'
        '&LT_CHECK=$LT_CHECK'
        '&LB_PALLET_NO=$LB_PALLET_NO'
        '&LB_PALLET_QTY=$LB_PALLET_QTY'
        '&LH_MO_DO_NO=$LH_MO_DO_NO');
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
      // endDrawer:CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                            title: Row(
                              children: [
                                Icon(
                                  Icons
                                      .notification_important, // ไอคอนแจ้งเตือน
                                  color: Colors.red, // สีแดง
                                  size: 30,
                                ),
                                SizedBox(
                                    width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
                                Text('แจ้งเตือน'),
                              ],
                            ),
                            content: Text('$poErpDocNo'),
                            actions: <Widget>[
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.grey),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(); // ปิด popup แรก
                                  // เปิด popup ที่สอง
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .notification_important, // ไอคอนแจ้งเตือน
                                              color: Colors.red, // สีแดง
                                              size: 30,
                                            ),
                                            SizedBox(
                                                width:
                                                    8), // ระยะห่างระหว่างไอคอนกับข้อความ
                                            Text('แจ้งเตือน'),
                                          ],
                                        ),
                                        content: const Text(
                                            'ต้องการพิมพ์เอกสารใบรับหรือไม่ ?'),
                                        actions: <Widget>[
                                          TextButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              side: const BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // ปิด popup ที่สอง
                                              // ทำงานเมื่อผู้ใช้กด "Cancel"
                                            },
                                            child: const Text('Cancel',style: TextStyle(
                                                  fontSize:
                                                      16, // ปรับขนาดตัวหนังสือตามต้องการ
                                                  color: Colors
                                                      .black, // สามารถเปลี่ยนสีตัวหนังสือได้ที่นี่
                                                )),
                                          ),
                                          TextButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              side: const BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // ปิด popup ที่สอง

                                              // เรียก getPDF
                                              getPDF(widget.po_doc_no)
                                                  .then((_) {
                                                // หลังจากเรียก getPDF เสร็จแล้ว, กลับไปยังหน้า SSFGDT04_MENU
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SSFGDT04_MENU(
                                                      pWareCode: gb.P_WARE_CODE,
                                                      pErpOuCode:
                                                          gb.P_ERP_OU_CODE,
                                                    ),
                                                  ),
                                                  (Route<dynamic> route) =>
                                                      false, // ลบหน้าอื่นๆ ออกจาก stack
                                                );
                                              });
                                            },
                                            child: const Text('OK',
                                                style: TextStyle(
                                                  fontSize:
                                                      16, // ปรับขนาดตัวหนังสือตามต้องการ
                                                  color: Colors
                                                      .black, // สามารถเปลี่ยนสีตัวหนังสือได้ที่นี่
                                                )),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('OK',
                                    style: TextStyle(
                                      fontSize:
                                          16, // ปรับขนาดตัวหนังสือตามต้องการ
                                      color: Colors
                                          .black, // สามารถเปลี่ยนสีตัวหนังสือได้ที่นี่
                                    )),
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
                            title: Row(
                              children: [
                                Icon(
                                  Icons
                                      .notification_important, // ไอคอนแจ้งเตือน
                                  color: Colors.red, // สีแดง
                                  size: 30,
                                ),
                                SizedBox(
                                    width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
                                Text('แจ้งเตือน'),
                              ],
                            ),
                            content: Text(poMessage ?? ''),
                            actions: [
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.grey),
                                ),
                                child: const Text('OK',
                                    style: TextStyle(
                                      fontSize:
                                          16, // ปรับขนาดตัวหนังสือตามต้องการ
                                      color: Colors
                                          .black, // สามารถเปลี่ยนสีตัวหนังสือได้ที่นี่
                                    )),
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
                  style: AppStyles.ConfirmbuttonStyle(),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
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
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
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
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 80),
            decoration: BoxDecoration(
              color: Colors.lightBlue[100], // Background color for the text
              borderRadius:
                  BorderRadius.circular(8), // Rounded corners (optional)
            ),
            child: Text(
              widget.setqc, // Text ที่ต้องการแสดง
              style: const TextStyle(
                color: Colors.black, // Text color
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
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
