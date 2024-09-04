import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_CREATE.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';

import 'package:http/http.dart' as http;
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:dropdown_search/dropdown_search.dart';

class SSFGD17_VERIFY extends StatefulWidget {
  final String po_doc_no;
  final String? po_doc_type;
  final String? selectedwhCode;

  const SSFGD17_VERIFY(
      {required this.po_doc_no, this.po_doc_type, this.selectedwhCode});

  @override
  _SSFGD17_VERIFYState createState() => _SSFGD17_VERIFYState();
}

class _SSFGD17_VERIFYState extends State<SSFGD17_VERIFY> {
  String currentSessionID = '';
  String nb_ware_code = '';
  String nb_to_wh = '';
  String cr_date = '';

  String? item_code = '';
  String? lots_no = '';
  String? location_code = '';
  String? pack_qty = '';
  String? to_loc = '';
  int? req;

  List<Map<String, dynamic>> items = [];

  final TextEditingController NB_WARE_CODEController = TextEditingController();
  final TextEditingController NB_TO_WHController = TextEditingController();
  final TextEditingController CR_DATEController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;

    fetchData();
    getList();
  }

  int _displayLimit = 15;
  final ScrollController _scrollController = ScrollController();

  void _loadMoreItems() {
    setState(() {
      _displayLimit += 15;
    });
  }

  Future<void> getList() async {
    final url = Uri.parse(
        "http://172.16.0.82:8888/apex/wms/SSFGDT17/Verify_Card/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}");
    print(url);

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> fetchedItems = data['items'];

        if (fetchedItems.isNotEmpty) {
          setState(() {
            items = fetchedItems.map((item) {
              return {
                'item_code': item['item_code'] ?? '',
                'lots_no': item['lots_no'] ?? '',
                'location_code': item['location_code'] ?? '',
                'pack_qty': item['pack_qty'] ?? '',
                'to_loc': item['to_loc'] ?? '',
                'rowid': item['rowid'] ?? '',
                'doc_type': item['doc_type'] ?? '',
                'seq': item['seq'] ?? '',
                'doc_no': item['doc_no'] ?? '',
              };
            }).toList();
          });

          print(items);
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

  Future<void> fetchData() async {
    final url = Uri.parse(
        "http://172.16.0.82:8888/apex/wms/SSFGDT17/verify_form/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}");

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];

          setState(() {
            nb_ware_code = item['nb_ware_code'] ?? '';
            nb_to_wh = item['nb_to_wh'] ?? '';
            cr_date = item['cr_date'] ?? '';

            NB_WARE_CODEController.text = nb_ware_code;
            NB_TO_WHController.text = nb_to_wh;
            CR_DATEController.text = cr_date;
          });
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

  Future<void> updateItem() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT17/update_card_item_verify');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'ITEM_CODE': itemCodeController.text,
        'LOTS_NO': lotNoController.text,
        'LOCATION_CODE': locCodeController.text,
        'TO_LOC': toLocController.text,
        'PACK_QTY': packQtyController.text,
        'APP_USER': gb.APP_USER,
        'rowid': rowid,
      }),
    );

    print('Updating form with data: ${jsonEncode({
          'ITEM_CODE': itemCodeController.text,
          'LOTS_NO': lotNoController.text,
          'LOCATION_CODE': locCodeController.text,
          'TO_LOC': toLocController.text,
          'PACK_QTY': packQtyController.text,
          'APP_USER': gb.APP_USER,
          'rowid': rowid,
        })}');

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  }

  Future<void> deleteItem() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT17/delete_item_verify');
    print(Doc_type);
    print(doc_no);
    print(req);
    print(itemCodeController.text);
    print(gb.APP_USER);
    print(gb.P_ERP_OU_CODE);
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'v_doc_type': Doc_type,
        'v_rec_no': doc_no,
        'v_rec_seq': req,
        'v_item_code': itemCodeController.text,
        'APP_USER': gb.APP_USER,
        'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      }),
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final responseBody = jsonDecode(response.body);
        final poStatus = responseBody['po_status'];
        final poMessage = responseBody['po_message'];
        print('Status: $poStatus');
        print('Message: $poMessage');
      }
      getList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  String? poStatus;
  String? poMessage;

  Future<void> chk_validateSave() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT17/inteface_XFer2ERP/${widget.po_doc_no}/${gb.P_ERP_OU_CODE}/${gb.ATTR1}'));
      print(widget.po_doc_no);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          poStatus = jsonData['po_status'];
          poMessage = jsonData['po_message'];
          print(response.statusCode);
          print(jsonData);
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

  TextEditingController itemCodeController = TextEditingController();
  TextEditingController lotNoController = TextEditingController();
  TextEditingController locCodeController = TextEditingController();
  TextEditingController packQtyController = TextEditingController();
  TextEditingController toLocController = TextEditingController();
  String? rowid;
  String? Doc_type;
  String? doc_no;

  void _showItemDialog(Map<String, dynamic> item) {
    itemCodeController.text = item['item_code'] ?? '';
    lotNoController.text = item['lots_no'] ?? '';
    locCodeController.text = item['location_code'] ?? '';
    packQtyController.text = item['pack_qty'].toString() ?? '';
    toLocController.text = item['to_loc'] ?? '';
    rowid = item['rowid'] ?? '';
    Doc_type = item['doc_type'] ?? '';
    doc_no = item['doc_no'] ?? '';

    req = item['seq'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('รายละเอียด '),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: itemCodeController,
                  decoration: InputDecoration(
                    labelText: 'Item Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  ),
                  readOnly: false,
                ),
                SizedBox(height: 18),
                TextFormField(
                  controller: lotNoController,
                  decoration: InputDecoration(
                    labelText: 'Lots No',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  ),
                  readOnly: false,
                ),
                SizedBox(height: 18),
                TextFormField(
                  controller: locCodeController,
                  decoration: InputDecoration(
                    labelText: 'Location Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  ),
                  readOnly: false,
                ),
                SizedBox(height: 18),
                TextFormField(
                  controller: packQtyController,
                  decoration: InputDecoration(
                    labelText: 'Pack Qty',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  ),
                  readOnly: false,
                ),
                SizedBox(height: 18),
                TextFormField(
                  controller: toLocController,
                  decoration: InputDecoration(
                    labelText: 'To Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  ),
                  readOnly: false,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                await updateItem();
                Navigator.of(context).pop();
                getList();
              },
              child: const Text('ตกลง'),
            ),
            TextButton(
              onPressed: () async {
                bool confirmDelete = await _showConfirmDeleteDialog();
                if (confirmDelete) {
                  await deleteItem();
                  Navigator.of(context).pop();
                  getList();
                }
              },
              child: const Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showConfirmDeleteDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ยืนยันการลบ'),
              content: Text('คุณแน่ใจหรือว่าต้องการลบรายการนี้?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('ยกเลิก'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF17153B),
    appBar: const CustomAppBar(title: 'Move Locator'),
    body: Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    minimumSize: const Size(10, 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  onPressed: () {
                    chk_validateSave();
                    if (poStatus == '0') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('การบันทึก และส่งข้อมูลเข้า ERP สมบูรณ์'),
                            content: Text('เลขที่เอกสาร : ${widget.po_doc_no}'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SSFGDT17_CREATE(
                                        pWareCode: widget.selectedwhCode ?? ''),
                                    ),
                                  );
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 24,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              color: const Color.fromARGB(255, 255, 242, 204),
              child: Center(
                child: Text(
                  '${widget.po_doc_no}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: 365,
              height: 75,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                  controller: NB_WARE_CODEController,
                  decoration: const InputDecoration(
                    labelText: 'Warehouse ต้นทาง',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                    border: InputBorder.none,
                  ),
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: 365,
              height: 75,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                  controller: NB_TO_WHController,
                  decoration: const InputDecoration(
                    labelText: 'Warehouse ปลายทาง',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                    border: InputBorder.none,
                  ),
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: 365,
              height: 75,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                  controller: CR_DATEController,
                  decoration: const InputDecoration(
                    labelText: 'วันที่บันทึกโอน',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                    border: InputBorder.none,
                  ),
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: (_displayLimit < items.length)
                    ? _displayLimit + 1
                    : items.length,
                itemBuilder: (context, index) {
                  if (index == _displayLimit) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: _loadMoreItems,
                        child: const Text('แสดงเพิ่มเติม'),
                      ),
                    );
                  }
                  final item = items[index];
                  return Card(
                    color: const Color.fromRGBO(204, 235, 252, 1.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        'Item : ${item['item_code']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Lots No: ${item['lots_no']}'),
                          Text('ต้นทาง: ${item['location_code']}'),
                          Text('จำนวนโอน: ${item['pack_qty']}'),
                          Text('ปลายทาง: ${item['to_loc']}'),
                          Text('seq ${item['seq']}'),
                        ],
                      ),
                      onTap: () => _showItemDialog(item),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: BottomBar(),
  );
}


}
