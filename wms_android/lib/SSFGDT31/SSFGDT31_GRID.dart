import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGD17_VERIFY.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_BARCODE.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_FORM.dart';
import 'package:wms_android/SSFGDT31/SSFGD31_VERIFY.dart';
import 'package:wms_android/SSFGDT31/SSFGDT31_BARCODE.dart';
import 'package:wms_android/SSFGDT31/SSFGDT31_PICKINGSLIP.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/styles.dart';

class SSFGDT31_GRID extends StatefulWidget {
  final String po_doc_no;
  final String po_doc_type;
  final String pWareCode;
  final String v_ref_doc_no;
  final String v_ref_type;
  final String SCHID;
  final String DOC_DATE;

  SSFGDT31_GRID({
    Key? key,
    required this.po_doc_no,
    required this.po_doc_type,
    required this.pWareCode,
    required this.v_ref_doc_no,
    required this.v_ref_type,
    required this.SCHID,
    required this.DOC_DATE,
  }) : super(key: key);

  @override
  _SSFGDT31_GRIDState createState() => _SSFGDT31_GRIDState();
}

class _SSFGDT31_GRIDState extends State<SSFGDT31_GRID> {
  List<dynamic> items = [];
  String selectedItemDescName = '';
  String selectedPackDescName = '';

  final NumberFormat numberFormat = NumberFormat("#,##0");

  @override
  void initState() {
    super.initState();
    get_grid_data();
    print('SCHID: ${widget.SCHID}');
    print('DOC_DATE: ${widget.DOC_DATE}');
  }

  String? po_doc_type;
  String? po_doc_no;
  String? p_ware_code;
  String? po_status;
  String? po_message;

  Future<void> validateSave_NonePOLine_WMS() async {
    final url =
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/validateSave_NonePOLine_WMS/${widget.po_doc_type}/${widget.po_doc_no}/${widget.pWareCode}';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (mounted) {
          setState(() {
            po_doc_type = responseBody['po_doc_type'];
            po_doc_no = responseBody['po_doc_no'];
            p_ware_code = responseBody['p_ware_code'];
            po_status = responseBody['po_status'];
            po_message = responseBody['po_message'];

            print('po_doc_type: $po_doc_type');
            print('po_doc_no: $po_doc_no');
            print('p_ware_code: $p_ware_code');
            print('po_status: $po_status');
            print('po_message: $po_message');
          });
        }
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          po_status = 'Error';
          po_message = e.toString();
        });
      }
    }
  }

  String? vChkCol = '0';
  Future<void> get_grid_data() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/get_grid_data/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> fetchedItems = data['items'] ?? [];
        print(fetchedItems);

        if (fetchedItems.isNotEmpty) {
          if (mounted) {
            setState(() {
              items = fetchedItems;

              double vPackQty, vOldPackQty;
              vChkCol = '0';
              for (var item in items) {
                vPackQty = double.tryParse(
                        item['pack_qty'].toString().replaceAll(',', '')) ??
                    0;
                vOldPackQty = double.tryParse(
                        item['old_pack_qty']?.toString().replaceAll(',', '') ??
                            '0') ??
                    0;

                print('v_PACK_QTY: $vPackQty');
                print('v_OLD_PACK_QTY: $vOldPackQty');

                if (vPackQty > vOldPackQty) {
                  vChkCol = '1';
                }
              }

              print('v_chk_col: $vChkCol');
            });
          }
        } else {
          print('No items found.');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateLot({
    required int pack_qty,
    required int OLD_PACK_QTY,
    required String item_code,
    required String pack_code,
    required String rowid,
  }) async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/update_grid_pack_qty');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'pack_qty': pack_qty,
        'OLD_PACK_QTY': OLD_PACK_QTY,
        'item_code': item_code,
        'pack_code': pack_code,
        'rowid': rowid,
        'ROW_STATUS': 'U',
      }),
    );

    print('Updating form with data: ${jsonEncode({
          'pack_qty': pack_qty,
          'OLD_PACK_QTY': OLD_PACK_QTY,
          'item_code': item_code,
          'pack_code': pack_code,
          'rowid': rowid,
          'ROW_STATUS': 'U',
        })}');

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  Future<void> deleteLot({
    required String p_doc_type,
    required String p_doc_no,
    required int p_seq,
    required String p_item_code,
  }) async {
    final url =
        Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT31/delete_item_grid');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'p_doc_type': p_doc_type,
        'p_doc_no': p_doc_no,
        'p_seq': p_seq,
        'p_item_code': p_item_code,
        'p_erp_ou_code': gb.P_ERP_OU_CODE,
        'APP_USER': gb.APP_USER,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final poStatus = responseBody['po_status'];
      final poMessage = responseBody['po_message'];
      print('Status: $poStatus');
      print('Message: $poMessage');
      if (mounted) {
        setState(() {
          items.removeWhere((item) =>
              item['seq'] == p_seq && item['item_code'] == p_item_code);

          if (items.isEmpty) {
            vChkCol = '0';
          } else {
            vChkCol = '0';
            for (var item in items) {
              double vPackQty = double.tryParse(
                      item['pack_qty'].toString().replaceAll(',', '')) ??
                  0;
              double vOldPackQty = double.tryParse(
                      item['old_pack_qty']?.toString().replaceAll(',', '') ??
                          '0') ??
                  0;

              if (vPackQty > vOldPackQty) {
                vChkCol = '1';
                break;
              }
            }
          }
        });
      }

      print('vChkCol after deletion: $vChkCol');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> deleteAll() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/deleteAll_DTL_WMS');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'p49_prev_doc_type': widget.po_doc_type,
        'p49_prev_doc_no': widget.po_doc_no,
        'p_erp_ou_code': gb.P_ERP_OU_CODE,
        'app_user': gb.APP_USER,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final poStatus = responseBody['po_status'];
      final poMessage = responseBody['po_message'];
      print('Status: $poStatus');
      print('Message: $poMessage');
      if (mounted) {
        setState(() {
          items.clear();
          vChkCol = '0';
        });
      }
      await get_grid_data();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: 'รับคืนจากการเบิกผลิต', showExitWarning: false),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SSFGDT31_PICKINGSLIP(
                        po_doc_no: widget.po_doc_no,
                        po_doc_type: widget.po_doc_type,
                        pWareCode: widget.pWareCode,
                        v_ref_doc_no: widget.v_ref_doc_no,
                        v_ref_type: widget.v_ref_type,
                        SCHID: widget.SCHID,
                      ),
                    ),
                  );
                  print('Picking Slip');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(90, 40),
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text(
                  'Picking Slip',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                style: AppStyles.NextButtonStyle(),
                onPressed: () async {
                  await get_grid_data();
                  if (vChkCol == '1') {
                    print(
                        'Confirmationจำนวนรับคืนที่ระบุไม่ถูกต้อง (มากกว่าจำนวนจ่าย) กรุณาระบุใหม่ !!!');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons
                                    .notification_important, // Use the bell icon
                                color: Colors.red, // Set the color to red
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between the icon and the text
                              Text('แจ้งเตือน'), // Title text
                            ],
                          ),
                          content: const Text(
                              'Confirmation จำนวนรับคืนที่ระบุไม่ถูกต้อง (มากกว่าจำนวนจ่าย) กรุณาระบุใหม่ !!!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('ตกลง'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    await validateSave_NonePOLine_WMS();
                    print('==================');
                    print('po_status: $po_status');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SSFGDT31_VERIFY(
                          po_doc_no: widget.po_doc_no,
                          po_doc_type: widget.po_doc_type,
                          pWareCode: widget.pWareCode,
                          v_ref_doc_no: widget.v_ref_doc_no,
                          v_ref_type: widget.v_ref_type,
                          SCHID: widget.SCHID,
                          DOC_DATE: widget.DOC_DATE,
                        ),
                      ),
                    );
                  }

                  print('Right button pressed');
                },
                child: Image.asset(
                  'assets/images/right.png',
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow[200],
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.po_doc_no}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SSFGDT31_BARCODE(
                                    po_doc_no: widget.po_doc_no,
                                    po_doc_type: widget.po_doc_type,
                                    pWareCode: widget.pWareCode,
                                    v_ref_doc_no: widget.v_ref_doc_no,
                                    v_ref_type: widget.v_ref_type,
                                  ),
                                ),
                              );
                              if (result == true) {
                                await get_grid_data();
                              }
                              print('+Create');
                            },
                            style: AppStyles.createButtonStyle(),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white,
                                    width: 3), // White border for the circle
                              ),
                              padding: const EdgeInsets.all(
                                  2), // Padding to make the circle
                              child: const Icon(
                                Icons.add, // Plus icon inside the circle
                                color: Colors.white, // White plus icon
                                size: 24, // Icon size
                              ),
                            ),
                          ),
                          // Spacer(),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await deleteAll();
                              print('-Clear All');
                            },
                            style: AppStyles.ClearButtonStyle(),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white,
                                    width: 3), // White border for the circle
                              ),
                              padding: const EdgeInsets.all(
                                  3), // Padding for circle size
                              child: const Icon(
                                Icons.delete, // Trash icon inside the circle
                                color: Colors.white, // White trash icon
                                size: 20, // Icon size
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  final item = items[index - 1];
                  return InkWell(
                    // onTap: () {
                    //   setState(() {
                    //     selectedItemDescName = item['nb_item_name'] ?? '';
                    //     selectedPackDescName = item['nb_pack_name'] ?? '';
                    //   });
                    // },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      color: const Color.fromRGBO(204, 235, 252, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Lots No: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Text('${item['lots_no'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'จำนวนรับ: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Text(
                                          '${item['pack_qty'] != null ? numberFormat.format(item['pack_qty']) : ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Item: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Text('${item['item_code'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'จำนวนจ่าย: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Text(
                                          '${item['old_pack_qty'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Pack: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Text('${item['pack_code'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Locator: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Text(
                                          '${item['location_code'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'PD Location: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Text('${item['attribute1'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Reason: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Text('${item['attribute2'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'ใช้แทนจุด: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Text('${item['attribute3'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Replace Lot: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Text('${item['attribute4'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Item Desc: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: Colors.cyan[100],
                                      child: Text(
                                          '${item['nb_item_name'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Pack Desc: ',
                                      style: TextStyle(color: Colors.black)),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      color: Colors.amber[100],
                                      child: Text(
                                          '${item['nb_pack_name'] ?? ''}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      // color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: IconButton(
                                      iconSize: 20.0,
                                      icon: Image.asset(
                                        'assets/images/bin.png',
                                        width: 45.0,
                                        height: 45.0,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .notification_important, // Use the bell icon
                                                    color: Colors
                                                        .red, // Set the color to red
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          8), // Add some space between the icon and the text
                                                  Text(
                                                      'แจ้งเตือน'), // Title text
                                                ],
                                              ),
                                              content: const Text(
                                                  'ยืนยันที่จะลบหรือไม่'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('ยกเลิก'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    await deleteLot(
                                                      p_doc_type:
                                                          widget.po_doc_type,
                                                      p_doc_no:
                                                          widget.po_doc_no,
                                                      p_seq: item['seq'] ?? '',
                                                      p_item_code:
                                                          item['item_code'] ??
                                                              '',
                                                    );
                                                    print('===============');
                                                    print(widget.po_doc_type);
                                                    print(widget.po_doc_no);
                                                    print(item['seq']);
                                                    print(item['item_code']);
                                                  },
                                                  child: const Text('ตกลง'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    )),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: IconButton(
                                    iconSize: 20.0,
                                    icon: Image.asset(
                                      'assets/images/edit.png',
                                      width: 45.0,
                                      height: 45.0,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController
                                              packQtyController =
                                              TextEditingController(
                                            text:
                                                item['pack_qty']?.toString() ??
                                                    '',
                                          );

                                          return AlertDialog(
                                            title: const Text('แก้ไข'),
                                            content: TextField(
                                              controller: packQtyController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: 'Pack Quantity',
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  final newPackQty =
                                                      int.tryParse(
                                                              packQtyController
                                                                  .text) ??
                                                          0;

                                                  await updateLot(
                                                    pack_qty: newPackQty,
                                                    OLD_PACK_QTY:
                                                        item['pack_qty'],
                                                    item_code:
                                                        item['item_code'],
                                                    pack_code:
                                                        item['pack_code'],
                                                    rowid: item['rowid'],
                                                  );

                                                  setState(() {
                                                    item['pack_qty'] =
                                                        newPackQty;
                                                  });

                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }
}
