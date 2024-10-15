import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wms_android/styles.dart';

class SSFGDT31_PICKINGSLIP extends StatefulWidget {
  final String po_doc_no;
  final String po_doc_type;
  final String pWareCode;
  final String v_ref_doc_no;
  final String v_ref_type;
  final String SCHID;

  SSFGDT31_PICKINGSLIP({
    Key? key,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.pWareCode,
    required this.v_ref_doc_no,
    required this.v_ref_type,
    required this.SCHID,
  }) : super(key: key);

  @override
  _SSFGDT31_PICKINGSLIPState createState() => _SSFGDT31_PICKINGSLIPState();
}

class _SSFGDT31_PICKINGSLIPState extends State<SSFGDT31_PICKINGSLIP> {
  @override
  void initState() {
    super.initState();
    // get_slip_data();
    // getPDF();
  }

//  -----------------------------  p  -----------------------------  \\
  String? P_LIN_ID;
  String? V_DS_PDF;
  String? P_MO_DO_NO;
  String? P_OU_CODE;
  String? P_ERP_OU_CODE;
//  -----------------------------  LH  -----------------------------  \\
  String? LH_PICKING_SLIP;
  String? LH_MO_DO_NO;
  //  -----------------------------  LB  -----------------------------  \\
  String? LB_MATERIAL_CODE;
  String? LB_LOT;
  String? LB_COMB;
  String? LB_USAGE_QTY;
  String? LB_WARE_CODE;
  String? LB_LOCATION_CODE;

  List<dynamic> items = [];

  Future<void> getSlipData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT31/picking_slip_data/${gb.P_ERP_OU_CODE}/${gb.P_OU_CODE}/${widget.SCHID}'));

      print('Response body: ${response.body}'); // Debugging line

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // Update the items state
        if (mounted) {
          setState(() {
            items = data;
          });
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching slip data: $e');
    }
  }

  Future<void> getPDF() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_GET_PDF/${gb.P_ERP_OU_CODE}/${gb.P_OU_CODE}/${widget.SCHID}/${gb.BROWSER_LANGUAGE}/${gb.P_DS_PDF}'));

      print('Response body: ${response.body}'); // แสดงข้อมูลที่ได้รับจาก API

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataPDF = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
        if (mounted) {
          if (mounted) {
            setState(() {
              P_LIN_ID = dataPDF['P_LIN_ID'] ?? '';
              V_DS_PDF = dataPDF['V_DS_PDF'] ?? '';
              P_MO_DO_NO = dataPDF['P_MO_DO_NO'] ?? '';
              P_OU_CODE = dataPDF['P_OU_CODE'] ?? '';
              P_ERP_OU_CODE = dataPDF['P_ERP_OU_CODE'] ?? '';

              LH_PICKING_SLIP = dataPDF['LH_PICKING_SLIP'] ?? '';
              LH_MO_DO_NO = dataPDF['LH_MO_DO_NO'] ?? '';
              LB_MATERIAL_CODE = dataPDF['LB_MATERIAL_CODE'] ?? '';
              LB_LOT = dataPDF['LB_LOT'] ?? '';
              LB_COMB = dataPDF['LB_COMB'] ?? '';
              LB_USAGE_QTY = dataPDF['LB_USAGE_QTY'] ?? '';
              LB_WARE_CODE = dataPDF['LB_WARE_CODE'] ?? '';
              LB_LOCATION_CODE = dataPDF['LB_LOCATION_CODE'] ?? '';

              _launchUrl();
            });
          }
        }
      } else {
        // จัดการกรณีที่ response status code ไม่ใช่ 200
        print('โพสต์ข้อมูลล้มเหลว. รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in submit Data: $e');
    }
  }

  Future<void> _launchUrl() async {
    final uri = Uri.parse('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/WMS_SSFGDT09L_Picking_Slip'
        '&_repFormat=pdf'
        '&_dataSource=${gb.P_DS_PDF}'
        '&_outFilename=${widget.po_doc_no}.pdf'
        '&_repLocale=en_US'
        '&P_LIN_ID=$P_LIN_ID'
        '&V_DS_PDF=$V_DS_PDF'
        '&P_MO_DO_NO=$P_MO_DO_NO'
        '&P_OU_CODE=$P_OU_CODE'
        '&P_ERP_OU_CODE=$P_ERP_OU_CODE'
        '&LH_PICKING_SLIP=$LH_PICKING_SLIP'
        '&LH_MO_DO_NO=$LH_MO_DO_NO'
        '&LB_MATERIAL_CODE=$LB_MATERIAL_CODE'
        '&LB_LOT=$LB_LOT'
        '&LB_COMB=$LB_COMB'
        '&LB_USAGE_QTY=$LB_USAGE_QTY'
        '&LB_WARE_CODE=$LB_WARE_CODE'
        '&LB_LOCATION_CODE=$LB_LOCATION_CODE');

    print(uri);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    print('http://172.16.0.82:8888/jri/report?'
        '&_repName=/WMS/SSFGOD02A5'
        '&_repFormat=pdf'
        '&_dataSource=${gb.P_DS_PDF}'
        '&_outFilename=${widget.po_doc_no}.pdf'
        '&_repLocale=en_US'
        '&P_LIN_ID=$P_LIN_ID'
        '&V_DS_PDF=$V_DS_PDF'
        '&P_MO_DO_NO=$P_MO_DO_NO'
        '&P_OU_CODE=$P_OU_CODE'
        '&P_ERP_OU_CODE=$P_ERP_OU_CODE'
        '&LH_PICKING_SLIP=$LH_PICKING_SLIP'
        '&LH_MO_DO_NO=$LH_MO_DO_NO'
        '&LB_MATERIAL_CODE=$LB_MATERIAL_CODE'
        '&LB_LOT=$LB_LOT'
        '&LB_COMB=$LB_COMB'
        '&LB_USAGE_QTY=$LB_USAGE_QTY'
        '&LB_WARE_CODE=$LB_WARE_CODE'
        '&LB_LOCATION_CODE=$LB_LOCATION_CODE');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Picking Slip', showExitWarning: false),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await getPDF();
                        },
                        style: AppStyles.NextButtonStyle(),
                        child: Image.asset(
                          'assets/images/printer.png', // ใส่ภาพจากไฟล์ asset
                          width: 25, // กำหนดขนาดภาพ
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No Data Found',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Item: ${item['material_code']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'LOT: ${item['lot_no']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Comb: ${item['comb']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'ความต้องการใช้: ${item['usage_qty']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Warehouse: ${item['ware_code']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Locator: ${item['location_code']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          )),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }
}
