import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wms_android/styles.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as globals;

class Ssfgdt09lPickingSlip extends StatefulWidget {
  final String pErpOuCode;
  final String pOuCode;
  final String pMoDoNO;
  final String pDocNo;

  Ssfgdt09lPickingSlip({
    Key? key,
    required this.pErpOuCode,
    required this.pOuCode,
    required this.pMoDoNO,
    required this.pDocNo,
  }) : super(key: key);
  @override
  _Ssfgdt09lPickingSlipState createState() => _Ssfgdt09lPickingSlipState();
}

class _Ssfgdt09lPickingSlipState extends State<Ssfgdt09lPickingSlip> {
  List<dynamic> dataCard = [];
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

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_PickingSilp/${widget.pErpOuCode}/${widget.pOuCode}/${widget.pMoDoNO}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataCard =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataCard : $dataCard');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('ERROR IN Fetch Data : $e');
    }
  }

  Future<void> getPDF() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_3_GET_PDF/${globals.P_OU_CODE}/${globals.P_ERP_OU_CODE}/${widget.pMoDoNO}/${globals.BROWSER_LANGUAGE}/${globals.P_DS_PDF}'));

      print('Response body: ${response.body}'); // แสดงข้อมูลที่ได้รับจาก API

      if (response.statusCode == 200) {
        // ถอดรหัสข้อมูล JSON จาก response
        final Map<String, dynamic> dataPDF = jsonDecode(utf8
            .decode(response.bodyBytes)); // ถอดรหัส response body เป็น UTF-8
        print('dataPDF : $dataPDF type : ${dataPDF.runtimeType}');
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
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=${widget.pDocNo}.pdf'
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
        '&_dataSource=${globals.P_DS_PDF}'
        '&_outFilename=${widget.pDocNo}.pdf'
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
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'Picking Silp'),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    getPDF();
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: dataCard.map((item) {
                  return Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Color.fromRGBO(204, 235, 252, 1.0),
                    child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(15.0),
                        child: Stack(children: [
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Item : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5.0),
                                              color: Colors.white,
                                              child: Text(
                                                item['material_code'] ?? '',
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    // ---------------------------------------------------- \\
                                    SizedBox(
                                      child: Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Lot : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5.0),
                                              color: Colors.white,
                                              child: Text(
                                                item['lot_no'] ?? '',
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    // ---------------------------------------------------- \\
                                    SizedBox(
                                      child: Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Comb : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5.0),
                                              color: Colors.white,
                                              child: Text(
                                                item['comb'] ?? '',
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    // ---------------------------------------------------- \\
                                    SizedBox(
                                      child: Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'ความต้องการใช้ : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5.0),
                                              color: Colors.white,
                                              child: Text(
                                                NumberFormat(
                                                        '#,###,###,###,###,###')
                                                    .format(item['usage_qty'] ??
                                                        ''),
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    // ---------------------------------------------------- \\
                                    SizedBox(
                                      child: Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Warehouse : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5.0),
                                              color: Colors.white,
                                              child: Text(
                                                item['ware_code'] ?? '',
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    // ---------------------------------------------------- \\
                                    SizedBox(
                                      child: Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Locator : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5.0),
                                              color: Colors.white,
                                              child: Text(
                                                item['location_code'] ?? '',
                                                style: const TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    // ---------------------------------------------------- \\
                                  ]))
                        ])),
                  );
                }).toList(),
              ),
            ),
          ])),
      bottomNavigationBar: BottomBar(),
    );
  }
}
