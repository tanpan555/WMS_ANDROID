import 'package:flutter/material.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SSFGDT17_BARCODE extends StatefulWidget {
  final String po_doc_no;
  final String? po_doc_type;
  final String? LocCode;

  SSFGDT17_BARCODE({required this.po_doc_no, this.po_doc_type, this.LocCode});

  @override
  _SSFGDT17_BARCODEState createState() => _SSFGDT17_BARCODEState();
}

class _SSFGDT17_BARCODEState extends State<SSFGDT17_BARCODE> {
  String currentSessionID = '';

  late final TextEditingController DOC_NO = TextEditingController(text: widget.po_doc_no);
  late final TextEditingController BARCODE = TextEditingController();
  late final TextEditingController LOCATOR_FROM = TextEditingController(text: widget.LocCode ?? ' ');
  late final TextEditingController ITEM_CODE = TextEditingController();
  late final TextEditingController LOT_NUMBER = TextEditingController();
  late final TextEditingController QUANTITY = TextEditingController();
  late final TextEditingController LOCATOR_TO = TextEditingController();
  late final TextEditingController BAL_LOT = TextEditingController();
  late final TextEditingController BAL_QTY = TextEditingController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    print(widget.LocCode);
    if(widget.LocCode == 'null'){
    LOCATOR_FROM.text = '';
    }
    
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
      setState(() {
        BARCODE.text = scanData.code!;
      });
      controller.dispose();
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    DOC_NO.dispose();
    BARCODE.dispose();
    LOCATOR_FROM.dispose();
    ITEM_CODE.dispose();
    LOT_NUMBER.dispose();
    QUANTITY.dispose();
    LOCATOR_TO.dispose();
    BAL_LOT.dispose();
    BAL_QTY.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 100,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Go Next',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  print('Go Next');
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  _buildTextField(DOC_NO, '', readOnly: true),
                  _buildTextField(BARCODE, 'Barcode', readOnly: false),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Open Camera',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _scanQRCode,
                  ),
                  _buildTextField(LOCATOR_FROM, 'Locator ต้นทาง', readOnly: true),
                  _buildTextField(ITEM_CODE, 'Item Code', readOnly: false),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'เปลี่ยน',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: (){
                      print('test');
                    },
                  ),
                  _buildTextField(LOT_NUMBER, 'Lot Number'),
                  _buildTextField(QUANTITY, 'Quantity'),
                  _buildTextField(LOCATOR_TO, 'Locator ปลายทาง', readOnly: true),
                  _buildTextField(BAL_LOT, 'รวมรายการโอน', readOnly: false),
                  _buildTextField(BAL_QTY, 'รวมจำนวนโอน', readOnly: false),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: readOnly ? Colors.grey[600] : Colors.black,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
