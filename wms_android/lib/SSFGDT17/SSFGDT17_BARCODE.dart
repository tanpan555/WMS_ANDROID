import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_VERIFY.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/styles.dart';

class SSFGDT17_BARCODE extends StatefulWidget {
  final String po_doc_no;
  final String? po_doc_type;
  final String? LocCode;

  final String? selectedwhCode;
  final String? selectedLocCode;
  final String? whOUTCode;
  final String? LocOUTCode;

  final String? pWareCode;
  final String? pWareName;

  SSFGDT17_BARCODE(
      {required this.po_doc_no,
      this.po_doc_type,
      this.LocCode,
      this.selectedwhCode,
      this.selectedLocCode,
      this.whOUTCode,
      this.LocOUTCode,
      this.pWareCode,
      this.pWareName});

  @override
  _SSFGDT17_BARCODEState createState() => _SSFGDT17_BARCODEState();
}

class _SSFGDT17_BARCODEState extends State<SSFGDT17_BARCODE> {
  String currentSessionID = '';

  late final TextEditingController DOC_NO =
      TextEditingController(text: widget.po_doc_no);
  late final TextEditingController BARCODE = TextEditingController();
  late final TextEditingController LOCATOR = TextEditingController(text: widget.LocCode ?? '');

  late final TextEditingController LOCATOR_FROM =
      TextEditingController();

  late final TextEditingController ITEM_CODE = TextEditingController();

  late final TextEditingController LOT_NUMBER = TextEditingController();
  late final TextEditingController QUANTITY = TextEditingController();
  late final TextEditingController LOCATOR_TO =
      TextEditingController(text: widget.LocOUTCode ?? ' ');
  late final TextEditingController BAL_LOT = TextEditingController();
  late final TextEditingController BAL_QTY = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final ERP_OU_CODE = gb.P_ERP_OU_CODE;
  final P_OU_CODE = gb.P_OU_CODE;
  final APP_USER = gb.APP_USER;

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    print('BARCODE  =============================');
    print('pWareCode: ${widget.pWareCode}');
    print('pWareName: ${widget.pWareName}');
    print(widget.LocCode);
    if (widget.LocCode == 'null') {
      LOCATOR.text = '';
    }

    // Add this condition for LOCATOR_TO
    if (widget.LocOUTCode == 'null') {
      LOCATOR_TO.text = '';
    }

    fetchLocationCodes();

    print(widget.selectedwhCode);
  }

  void _scanQRCode() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    ));
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      if (mounted) {
        setState(() {
          BARCODE.text = scanData.code!;
          fetchBarcodeData();
        });
      }
      controller.dispose();
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    DOC_NO.dispose();
    BARCODE.dispose();
    LOCATOR.dispose();
    LOCATOR_FROM.dispose();
    ITEM_CODE.dispose();
    LOT_NUMBER.dispose();
    QUANTITY.dispose();
    LOCATOR_TO.dispose();
    BAL_LOT.dispose();
    BAL_QTY.dispose();
    super.dispose();
  }

  List<dynamic> locCode = [];
  String? selectedLocCode;
  Future<void> fetchLocationCodes() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT17/Step_3_LOCATOR_LOV/$ERP_OU_CODE/${widget.selectedwhCode}'));
      print('$ERP_OU_CODE ${widget.selectedwhCode}');

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched Loc data: $jsonData');
        if (mounted) {
          setState(() {
            locCode = jsonData['items'];
            if (locCode.isNotEmpty) {
              selectedLocCode = widget.LocCode;
            }
          });
        }

        for (var item in locCode) {
          print('r value: ${item['r']}');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showStatusAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text(message),
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

  String? p_lot_number;
  String? p_quantity;
  String? p_curr_ware;
  String? p_curr_loc;
  String? p_bal_lot;
  String? p_bal_qty;
  String? p_item_code;
  String? p_control_lot;
  String? po_status;
  String? po_message;

  void fetchBarcodeData() async {
    final url = Uri.parse(
        '${gb.IP_API}/apex/wms/SSFGDT17/Step_3_scan_validate_xferBarcode/'
        '$ERP_OU_CODE/'
        '${widget.po_doc_no}/${BARCODE.text}/${widget.selectedwhCode}/$selectedLocCode/${widget.whOUTCode}/${widget.LocOUTCode}/$APP_USER');

    print('Request URL: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            p_lot_number = data['p_lot_number'];
            p_quantity = data['p_quantity'];
            p_curr_ware = data['p_curr_ware'];
            p_curr_loc = data['p_curr_loc'];
            p_bal_lot = data['p_bal_lot'];
            p_bal_qty = data['p_bal_qty'];
            p_item_code = data['p_item_code'];
            p_control_lot = data['p_control_lot'];
            po_status = data['po_status'];
            po_message = data['po_message'];

            // Check status and show alert if needed
            if (po_status == '1') {
              _showStatusAlert(po_message ?? 'เกิดข้อผิดพลาด');
              return;
            }

            // Only set initial values if fields are empty
            if (LOT_NUMBER.text.isEmpty) {
              LOT_NUMBER.text = p_lot_number ?? '';
            }
            if (QUANTITY.text.isEmpty) {
              QUANTITY.text = p_quantity ?? '';
            }
            LOCATOR_TO.text = p_curr_ware ?? '';
            BAL_LOT.text = p_bal_lot ?? '';
            BAL_QTY.text = p_bal_qty ?? '';
            ITEM_CODE.text = p_item_code ?? '';
          });
        }
      } else {
        print('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showLocatorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.displayTextFormFieldAndDropdown(
          context: context,
          headTextDialog: 'เปลี่ยน Locator', // Dialog header text
          labelText: 'เลือก Location ต้นทาง', // TextField label text
          controller: LOCATOR_FROM, // TextField controller
          onTap: () {
            // Show the custom LOV search dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogStyles.customLovSearchDialog(
                  context: context,
                  headerText: 'เลือก Location ต้นทาง',
                  searchController: _searchController,
                  data: locCode,
                  docString: (item) => '${item['r'] ?? ''} ${item['location_name'] ?? ''}',
                  titleText: (item) => item['r'].toString(),
                  subtitleText: (item) => '${item['location_name']}',
                  onTap: (item) {
                    final name = item['location_name']?.toString() ?? '';
                    final code = item['r']?.toString() ?? '';
                    Navigator.of(context).pop(); // Close LOV dialog
                    setState(() {
                      selectedLocCode = '$name';
                      LOCATOR_FROM.text = selectedLocCode ?? '';
                      LOCATOR.text = code;
                    });
                  },
                );
              },
            ).then((_) {
              _searchController.clear(); // Clear search input on close
            });
          },
          onCloseDialog: () {
            Navigator.of(context).pop(); // Close the main dialog
          },
          onConfirmDialog: () {
            Navigator.of(context).pop(); // Close the main dialog first
            // Show confirmation dialog
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return DialogStyles.alertMessageCheckDialog(
                  context: context,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('ต้องการเปลี่ยนแปลง Locator ต้นทาง หรือไม่ !!!'),
                    ],
                  ),
                  onClose: () {
                    Navigator.of(context).pop(); // Close confirmation dialog
                  },
                  onConfirm: () {
                    setState(() {
                      LOCATOR_FROM.text = selectedLocCode ?? '';
                    });
                    Navigator.of(context).pop(); // Close confirmation dialog
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  String? poStatus;
  String? poMessage;

  Future<void> chk_validateSave() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGDT17/Step_3_validateSave_confXfer_WMS/${widget.po_doc_no}/${gb.P_ERP_OU_CODE}'));
      print(widget.po_doc_no);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        if (mounted) {
          setState(() {
            poStatus = jsonData['po_status'];
            poMessage = jsonData['po_message'];
            print(response.statusCode);
            print(jsonData);
            print(poStatus);
            print(poMessage);
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF17153B),
      appBar:
          CustomAppBar(title: 'Move Locator', showExitWarning: checkUpdateData),
      body: Column(
        children: [
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                style: AppStyles.NextButtonStyle(),
                onPressed: () async {
                  await chk_validateSave();
                  if (poStatus == '0') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SSFGDT17_VERIFY(
                          po_doc_no: widget.po_doc_no,
                          po_doc_type: widget.po_doc_type,
                          selectedwhCode: widget.selectedwhCode,
                          pWareCode: widget.pWareCode,
                          pWareName: widget.pWareName,
                        ),
                      ),
                    );
                  }
                },
                child: Image.asset(
                  'assets/images/right.png',
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  GestureDetector(
                      child: AbsorbPointer(
                    child:
                        _buildTextField(DOC_NO, 'เลขที่เอกสาร', readOnly: true),
                  )),
                  _buildBarcodeTextField(),
                  GestureDetector(
                      child: AbsorbPointer(
                    child: _buildTextField(LOCATOR, 'Locator ต้นทาง',
                        readOnly: true),
                  )),
                  GestureDetector(
                      child: AbsorbPointer(
                    child:
                        _buildTextField(ITEM_CODE, 'Item Code', readOnly: true),
                  )),
                  SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'เปลี่ยน',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      _showLocatorDialog(context);
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextFieldNumber(LOT_NUMBER, 'Lot Number'),
                  _buildTextFieldNumber(QUANTITY, 'Quantity'),
                  GestureDetector(
                    child: AbsorbPointer(
                      child: _buildTextField(
                        LOCATOR_TO,
                        'Locator ปลายทาง',
                        readOnly: true,
                        initialValue: widget.LocOUTCode == 'null'
                            ? ''
                            : widget.LocOUTCode,
                      ),
                    ),
                  ),
                  GestureDetector(
                      child: AbsorbPointer(
                    child: _buildYellowTextField(BAL_LOT, 'รวมรายการโอน',
                        readOnly: true),
                  )),
                  GestureDetector(
                      child: AbsorbPointer(
                    child: _buildYellowTextField(BAL_QTY, 'รวมจำนวนโอน',
                        readOnly: true),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }

  bool checkUpdateData = false;

  Widget _buildYellowTextField(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly
              ? const Color.fromARGB(255, 251, 251, 123)
              : Colors.white,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false, String? initialValue}) {
    if (initialValue != null) {
      controller.text = initialValue;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : Colors.white,
          border: InputBorder.none,
        ),
        onSubmitted: (value) {
          // setState(() {
          checkUpdateData = true;
          // });
        },
      ),
    );
  }

  Widget _buildBarcodeTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: BARCODE,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Barcode',
              labelStyle: const TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
            ),
            onSubmitted: (text) {
              checkUpdateData = true;
              fetchBarcodeData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldNumber(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        readOnly: readOnly,
        keyboardType: TextInputType.number, // Allow only number input
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter
              .digitsOnly, // Filter out non-numeric characters
        ],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : Colors.white,
          border: InputBorder.none,
        ),
        onChanged: (text) {
          // You can implement any additional logic here
          fetchBarcodeData();
        },
      ),
    );
  }
}
