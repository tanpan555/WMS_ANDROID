import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wms_android/SSINDT01/SSINDT01_main.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/styles.dart';

class SSINDT01_SEARCH extends StatefulWidget {
  final String pWareCode;
  final String pWareName;
  final String p_ou_code;

  const SSINDT01_SEARCH(
      {Key? key,
      required this.pWareCode,
      required this.pWareName,
      required this.p_ou_code})
      : super(key: key);

  @override
  _SSINDT01_SEARCHState createState() => _SSINDT01_SEARCHState();
}

class _SSINDT01_SEARCHState extends State<SSINDT01_SEARCH> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> statusItems = [
    'ทั้งหมด',
    'รายการใบสั่งซื้อ',
    'รายการรอรับดำเนินการ'
  ];

  String currentSessionID = '';
  List<dynamic> apCodes = [];
  String errorMessage = '';
  String? _selectedValue = 'ทั้งหมด';
  String? selectedApCode = 'ทั้งหมด'; // Initialize with 'ทั้งหมด'

  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _selectedApCodeController =
      TextEditingController();
  final TextEditingController _selectedProductTypeController =
      TextEditingController(); // Controller for product type

  @override
  void initState() {
    super.initState();
    currentSessionID = SessionManager().sessionID;
    fetchApCodes();
    print('Search Global Ware Code: ${gb.P_WARE_CODE}');
    log('Search Global Ware Code: ${gb.P_WARE_CODE}');
  }

  Future<void> fetchApCodes() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/AP_CODE'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          apCodes = jsonData['items'] ?? [];
          apCodes.insert(0, {'ap_code': 'ทั้งหมด', 'ap_name': 'ทั้งหมด'});
        });
      } else {
        throw Exception('Failed to load AP codes');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        print(
            'errorMessage : $errorMessage Type : ${errorMessage.runtimeType}');
      });
    }
  }

  void _resetForm() {
    setState(() {
      _selectedValue = 'ทั้งหมด';
      selectedApCode = 'ทั้งหมด';
      _documentNumberController.clear();
      _selectedApCodeController.clear();
      errorMessage = '';
    });
  }

  void _showProductTypeDialog() {
    TextEditingController _productTypeSearchController =
        TextEditingController(); // Controller for search field
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              // Filter the product type list based on search query
              List<String> filteredProductTypes = statusItems.where((item) {
                final query = _productTypeSearchController.text.toLowerCase();
                return item.toLowerCase().contains(query);
              }).toList();

              return Container(
                padding: const EdgeInsets.all(16),
                height: 300, // Adjust the height as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'เลือกประเภทสินค้า', // Title
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: filteredProductTypes.isEmpty
                          ? Center(
                              child: Text(
                                'ไม่พบข้อมูล', // Message when no data found
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredProductTypes.length,
                              itemBuilder: (context, index) {
                                final item = filteredProductTypes[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ListTile(
                                    title: Text(item),
                                    onTap: () {
                                      setState(() {
                                        _selectedValue =
                                            item; // Update the selection
                                        _selectedProductTypeController.text =
                                            item; // Update the controller
                                      });
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                height: 300, // Adjust the height as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'เลือกผู้ขาย', // Title
                            style: TextStyle(
                              fontSize:
                                  18, // Same font size as the search TextField
                              fontWeight:
                                  FontWeight.bold, // Consistent bold style
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Search TextField
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหา',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical:
                              10, // Same vertical padding for consistent height
                          horizontal: 10, // Padding inside the TextField
                        ),
                        hintStyle: TextStyle(
                          fontSize: 18, // Same font size as the title
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18, // Same font size as the title
                      ),
                      onChanged: (query) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),

                    // List of Filtered Items
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Filter apCodes based on search query
                          final filteredApCodes = apCodes.where((item) {
                            final apCode = item['ap_code'].toLowerCase();
                            final searchQuery =
                                _searchController.text.toLowerCase();
                            return apCode.contains(searchQuery);
                          }).toList();

                          if (filteredApCodes.isEmpty) {
                            return Center(
                              child: Text(
                                'No data found', // Show message when no data is found
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: filteredApCodes.length,
                            itemBuilder: (context, index) {
                              final item = filteredApCodes[index];
                              final apCode = item['ap_code'];
                              final apName = item['ap_name'];

                              return Container(
                                margin: const EdgeInsets.only(
                                    bottom: 8), // Add margin between items
                                padding: const EdgeInsets.all(
                                    8), // Padding inside the container
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //       color: Colors
                                //           .grey), // Add border around each item
                                //   borderRadius: BorderRadius.circular(
                                //       5), // Optional rounded corners
                                // ),
                                child: ListTile(
                                  title: Text(
                                    apCode,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    apName,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedApCode =
                                          apCode; // Set selected code
                                      _selectedApCodeController.text =
                                          selectedApCode ??
                                              ''; // Update the controller's text
                                    });
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'รับจากการสั่งซื้อ'),
      backgroundColor: const Color(0xFF17153B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _showProductTypeDialog,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _selectedProductTypeController,
                      decoration: InputDecoration(
                        labelText: 'ประเภทสินค้า',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: _showDialog,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _selectedApCodeController,
                      decoration: InputDecoration(
                        labelText: 'ผู้ขาย',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.black),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _documentNumberController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'เลขที่เอกสาร',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _resetForm,
                      child: Image.asset('assets/images/eraser_red.png',
                          width: 50, height: 25),
                      style: AppStyles.EraserButtonStyle(),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        final documentNumber =
                            _documentNumberController.text.isNotEmpty
                                ? _documentNumberController.text
                                : 'null';

                        print('selectedApCode $selectedApCode');
                        print(_selectedValue);
                        print(documentNumber);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SSINDT01_MAIN(
                              pWareCode: widget.pWareCode,
                              pWareName: widget.pWareName,
                              p_ou_code: widget.p_ou_code,
                              selectedValue: _selectedValue ?? 'ทั้งหมด',
                              apCode: selectedApCode ?? 'ทั้งหมด',
                              documentNumber: documentNumber,
                            ),
                          ),
                        );
                      },
                      style: AppStyles.SearchButtonStyle(),
                      child: Image.asset('assets/images/search_color.png',
                          width: 50, height: 25),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
