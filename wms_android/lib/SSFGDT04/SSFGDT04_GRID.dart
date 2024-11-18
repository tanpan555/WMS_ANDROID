import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:intl/intl.dart';
import 'SSFGDT04_SCANBARCODE.dart';
import '../styles.dart';

class SSFGDT04_GRID extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจาก lov
  final String? po_doc_no;
  final String? po_doc_type;
  final String p_ref_no;
  final String mo_do_no;

  const SSFGDT04_GRID({
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
  List<String> deletedItemCodes = [];
  String? poStatus;
  String? poMessage;
  String? setqc;
  bool isLoading = true;
  int currentPage = 0;
  int itemsPerPage = 5; // จำนวนการ์ดต่อหน้า
  List<dynamic> dataCard = [];
  String? next;
  String? previous;
  String errorMessage = '';

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
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
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
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: ListBody(
                      children: <Widget>[
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                color: Colors.grey[300],
                                padding: const EdgeInsets.all(2),
                                child: TextFormField(
                                  enabled: false,
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    labelText: ' seq',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  initialValue: item['seq']?.toString() ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.grey[300],
                                padding: const EdgeInsets.all(2),
                                child: TextFormField(
                                  enabled: false,
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    labelText: ' item',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  initialValue: item['item_code'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          textAlign: TextAlign.right,
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allows only numbers
                          ],
                          decoration: const InputDecoration(
                            labelText: 'จำนวนรับ',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            // Check if the field is empty
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกจำนวนรับ';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            // Clear the value from the card when empty
                            if (value.isEmpty) {
                              setState(() {
                                item['pack_qty'] = null;
                              });
                            }
                          },
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
                  side: const BorderSide(color: Colors.green, width: 1.5),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(60, 40),
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () async {
                  if (quantityController.text.isEmpty) {
                    setState(() {
                      item['pack_qty'] = null; // Clear the quantity on card
                    });
                    Navigator.of(context).pop();
                    return;
                  }

                  if (formKey.currentState?.validate() ?? false) {
                    final String cleanedText =
                        quantityController.text.replaceAll(',', '');
                    try {
                      final newQuantity = double.parse(cleanedText).toString();
                      await fetchUpdate(
                        item['item_code'], // itemCode
                        item['pack_code'], // poPackCode
                        newQuantity, // poPackQty
                        item['rowid'], // ratio
                      );
                      setState(() {
                        fetchGridItems();
                      });
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Error parsing quantity: $e');
                    }
                  }
                },
                child: Image.asset('assets/images/check-mark.png',
                    width: 30, height: 30),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow1(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Key
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      softWrap: false,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 18),

                  Container(
                    constraints: BoxConstraints(
                      minWidth: 80,
                      maxWidth: 160,
                    ),
                    height: 30,
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: entry.value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10.0,
                        ),
                      ),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.right,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow2(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Key
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      softWrap: false,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 18),

                  Container(
                    constraints: BoxConstraints(
                      minWidth: 80,
                      maxWidth: 160,
                    ),
                    height: 30,
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: entry.value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10.0,
                        ),
                      ),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow3(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Key
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      softWrap: false,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 18),

                  Container(
                    constraints: BoxConstraints(
                      minWidth: 80,
                      maxWidth: 160,
                    ),
                    height: 30,
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: entry.value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 10.0,
                        ),
                      ),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow4(Map<String, String> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: info.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Key
                  Container(
                    height: 30,
                    // alignment: Alignment.centerLeft,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      softWrap: false,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 18),

                  Container(
                    constraints: BoxConstraints(
                      minWidth: 80,
                      maxWidth: 160,
                    ),
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> fetchUpdate(String? itemCode, String? poPackCode,
      String? poPackQty, String? rowid) async {
    final url = '${gb.IP_API}/apex/wms/SSFGDT04/Step_3_set_pack_QTY';

    final headers = {
      'Content-Type': 'application/json',
    };
    // ตรวจสอบว่า poPackQty ไม่เป็น null หรือว่าง
    if (poPackQty == null || poPackQty.isEmpty) {
      print('Error: poPackQty is null or empty');
      return;
    }
    final body = jsonEncode({
      'item_code': itemCode,
      'pack_code': poPackCode,
      'pack_qty': poPackQty,
      'rowid': rowid,
    });

    print('Request body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // ตรวจสอบการตอบกลับจาก API
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print('Success: $responseData');

          // โหลดข้อมูลใหม่หากการอัปเดตสำเร็จ
          if (mounted) {
            setState(() {
              fetchGridItems(); // เรียกใช้ fetchGridItems เพื่ออัปเดตข้อมูลใน UI
            });
          }
        } else {
          print('Error: Response body is empty');
        }
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error Update: $e');
    }
  }

  Future<void> fetchGridItems([String? url]) async {
    if (!mounted) return; // ตรวจสอบว่าตัว component ยังถูก mount อยู่หรือไม่
    setState(() {
      isLoading = true;
    });
    final String requestUrl = url ??
        '${gb.IP_API}/apex/wms/SSFGDT04/Step_3_WMS_IN_TRAN_DETAIL/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}/${gb.P_OU_CODE}';
    try {
      final response = await http.get(Uri.parse(requestUrl));
      print(requestUrl);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);
        if (!mounted) return;
        if (mounted) {
          setState(() {
            // Reset to the first page
            currentPage = 0;

            // ตรวจสอบข้อมูลก่อนการอัปเดต
            if (parsedResponse is Map && parsedResponse.containsKey('items')) {
              dataCard = parsedResponse['items'];
            } else {
              dataCard = [];
            }

            // อัปเดตและกรองข้อมูลใน gridItems
            gridItems = List<Map<String, dynamic>>.from(
                    parsedResponse['items'] ?? [])
                .where((item) => !deletedItemCodes.contains(item['item_code']))
                .toList();

            // คำนวณจำนวน totalCards
            int totalCards = dataCard.length;

            List<dynamic> getCurrentPageItems() {
              int startIndex = currentPage * itemsPerPage;
              int endIndex = (startIndex + itemsPerPage > totalCards)
                  ? totalCards
                  : startIndex + itemsPerPage;
              return dataCard.sublist(
                  startIndex, endIndex); // ดึงเฉพาะ card ในหน้าปัจจุบัน
            }

            isLoading = false;
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      if (!mounted) return;

      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error occurred: $e';
        });
      }
    }
  }

  String? getLink(List<dynamic> links, String rel) {
    final link =
        links.firstWhere((item) => item['rel'] == rel, orElse: () => null);
    return link != null ? link['href'] : null;
  }

  void _loadPrevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        // No need to call fetchData here, just update the UI
      });
      _scrollToTop();
    }
  }

  void _loadNextPage() {
    if ((currentPage + 1) * itemsPerPage < dataCard.length) {
      setState(() {
        currentPage++;
        // No need to call fetchData here, just update the UI
      });
      _scrollToTop();
    }
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0); // เลื่อนไปยังตำแหน่งเริ่มต้น (index 0)
    }
  }

  Future<void> fetchGetPo() async {
    final url = '${gb.IP_API}/apex/wms/SSFGDT04/Step_3_GET_PO';

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
        if (mounted) {
          setState(() {
            poStatus = responseData['po_status'];
            poMessage = responseData['po_message'];
            fetchGridItems();
          });
        }
        print('Success: $responseData');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> delete(
      String? poDocNo, String? poDocTpye, int poSeq, String? poItemCode) async {
    print(poDocNo);
    print(poDocTpye);
    print(poSeq);
    print(poItemCode);
    final url =
        Uri.parse('${gb.IP_API}/apex/wms/SSFGDT04/Step_3_delete_DTL_WMS');
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
        if (mounted) {
          setState(() {
            // Remove the item from the list
            gridItems.removeWhere((item) =>
                item['item_code'] == poItemCode && item['po_seq'] == poSeq);
            deletedItemCodes.add(poItemCode!);
          });
        }
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> fetchSetQC() async {
    // print('po_status $poQcPass Type: ${poQcPass.runtimeType}');
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT04/Step_3_set_qc/${gb.P_ERP_OU_CODE}/${widget.po_doc_type}/${widget.po_doc_no}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> setQC =
            jsonDecode(utf8.decode(response.bodyBytes));
        if (mounted) {
          setState(() {
            setqc = setQC['v_qc_pass']; // อัปเดตค่าภายใน setState
          });
        }
        print('setQC : $setQC type : ${setQC.runtimeType}');
      } else {
        print('setQC Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
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
    int totalCards = dataCard.length;
    bool hasPreviousPage = currentPage > 0;
    bool hasNextPage = (currentPage + 1) * itemsPerPage < totalCards;
    return Scaffold(
      appBar:
          CustomAppBar(title: 'รับตรง (ไม่อ้าง PO)', showExitWarning: false),
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
                          return DialogStyles.alertMessageCheckDialog(
                            context: context,
                            content: const Text(
                                'ระบบมีการบันทึกรายการทิ้งไว้ หากดึง ใบผลิต จะเคลียร์รายการทั้งหมดทิ้ง, ต้องการดึงใบผลิตใหม่หรือไม่'),
                            onClose: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            onConfirm: () async {
                              Navigator.of(context).pop(); // Close the dialog
                              await fetchGetPo(); // Call the fetchGetPo function after confirming
                            },
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
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(poMessage ?? ''),
                                  // Close icon
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                ],
                              ),
                              // content: Text(poMessage ?? ''),
                              actions: [
                                TextButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.grey),
                                  ),
                                  child: const Text('ตกลง'),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogStyles.alertMessageDialog(
                              context: context,
                              content: Text(poMessage ?? ''),
                              onClose: () {
                                Navigator.of(context).pop();
                              },
                              onConfirm: () async {
                                // await fetchPoStatusconform(vReceiveNo);
                                Navigator.of(context).pop();
                              },
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
                // child: _buildCards(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.po_doc_no ?? '',
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
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          setqc ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    gridItems.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Text(
                                'No data found',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // itemCount: gridItems.length,
                            controller: _scrollController,
                            itemCount:
                                itemsPerPage + 1, // +1 for the pagination row
                            itemBuilder: (context, index) {
                              if (index < itemsPerPage) {
                                int actualIndex =
                                    (currentPage * itemsPerPage) + index;

                                // Check if we have reached the end of the data
                                if (actualIndex >= dataCard.length) {
                                  return const SizedBox.shrink();
                                }

                                final item = dataCard[actualIndex];

                                return Card(
                                  elevation: 8.0,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.lightBlue[100],
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                              const Divider(
                                                  color: Colors.black26,
                                                  thickness: 1),
                                              const SizedBox(height: 8),
                                              _buildInfoRow1({
                                                'จำนวนรับ :': item[
                                                            'pack_qty'] !=
                                                        null
                                                    ? NumberFormat('#,###')
                                                        .format(
                                                            item['pack_qty'])
                                                    : '',
                                              }),
                                              _buildInfoRow2({
                                                'จำนวน Pallet :':
                                                    item['count_qty'] ?? '',
                                              }),
                                              _buildInfoRow3({
                                                'จำนวนรวม :':
                                                    item['count_qty_in'] ?? '',
                                              }),
                                              _buildInfoRow4({
                                                'Item Desc :':
                                                    item['nb_item_name'] ?? '',
                                              }),
                                              const SizedBox(height: 8),
                                              // Row with delete and edit buttons
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween, // Align buttons
                                                children: [
                                                  // Delete button as image
                                                  IconButton(
                                                    icon: Image.asset(
                                                      'assets/images/bin.png', // Delete image path
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return DialogStyles
                                                              .alertMessageCheckDialog(
                                                            context: context,
                                                            content: const Text(
                                                                'ต้องการลบรายการหรือไม่?'),
                                                            onClose: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                            },
                                                            onConfirm:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                              // await fetchGetPo(); // Call the fetchGetPo function after confirming
                                                              final poItemCode =
                                                                  item[
                                                                      'item_code'];
                                                              final poSeq =
                                                                  item['seq'];
                                                              await delete(
                                                                  widget
                                                                      .po_doc_no,
                                                                  widget
                                                                      .po_doc_type,
                                                                  poSeq,
                                                                  poItemCode);
                                                              if (mounted) {
                                                                setState(() {
                                                                  gridItems.removeWhere((item) =>
                                                                      item['item_code'] ==
                                                                          poItemCode &&
                                                                      item['seq'] ==
                                                                          poSeq);
                                                                });
                                                              }
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  // Edit button as image
                                                  IconButton(
                                                    icon: Image.asset(
                                                      'assets/images/edit.png', // Edit image path
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                    onPressed: () {
                                                      _showEditDialog(
                                                          context, item);
                                                    },
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
                              } else {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Previous Button
                                    hasPreviousPage
                                        ? ElevatedButton.icon(
                                            onPressed: _loadPrevPage,
                                            icon: const Icon(
                                              Icons.arrow_back_ios_rounded,
                                              color: Colors.black,
                                              size: 20.0,
                                            ),
                                            label: const Text(
                                              'Previous',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            style:
                                                AppStyles.PreviousButtonStyle(),
                                          )
                                        : ElevatedButton.icon(
                                            onPressed: null,
                                            icon: const Icon(
                                              Icons.arrow_back_ios_rounded,
                                              color:
                                                  Color.fromARGB(0, 23, 21, 59),
                                              size: 20.0,
                                            ),
                                            label: const Text(
                                              'Previous',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            style: AppStyles
                                                .DisablePreviousButtonStyle(),
                                          ),

                                    // Page Indicator
                                    Text(
                                      '${(currentPage * itemsPerPage) + 1}-${(currentPage + 1) * itemsPerPage > totalCards ? totalCards : (currentPage + 1) * itemsPerPage}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // Next Button
                                    hasNextPage
                                        ? ElevatedButton(
                                            onPressed: _loadNextPage,
                                            style: AppStyles
                                                .NextRecordDataButtonStyle(),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Next',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(width: 7),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.black,
                                                  size: 20.0,
                                                ),
                                              ],
                                            ),
                                          )
                                        : ElevatedButton(
                                            onPressed: null,
                                            style: AppStyles
                                                .DisableNextRecordDataButtonStyle(),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Next',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        0, 23, 21, 59),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(width: 7),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Color.fromARGB(
                                                      0, 23, 21, 59),
                                                  size: 20.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }
}
