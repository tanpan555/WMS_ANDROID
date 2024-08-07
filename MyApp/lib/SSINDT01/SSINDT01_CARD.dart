import 'package:flutter/material.dart';
import '../appbar.dart'; // Import the CustomAppBar
import '../drawer.dart'; // Import the CustomDrawer
import 'SSINDT01_FROM.dart'; // Import From
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:bs_flutter_card/bs_flutter_card.dart';

class Ssindt01Card extends StatefulWidget {
  const Ssindt01Card({super.key});

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Ssindt01Card> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final int _cardsPerPage = 15;
  int _currentPage = 0;
  

  List<dynamic> data = [];
  List<dynamic> displayedData = [];
  bool isLoading = true;
  String errorMessage = '';

  String searchQuery = '';

  List<dynamic> apCodes = [];
  String? selectedApCode;

  List<dynamic> warehouses = [];
  String? selectedWarehouse;

  @override
  void initState() {
    super.initState();
    fetchApCodes();
    fetchwhCodes();
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
          selectedApCode = 'ทั้งหมด';
          fetchWareCodes();
        });
      } else {
        throw Exception('Failed to load AP codes');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> fetchwhCodes() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/WH/WHCode'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched data: $jsonData');

        setState(() {
          warehouses = jsonData['items'];
          if (data.isNotEmpty) {
            selectedWarehouse = warehouses[0]['ware_code'];
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchWareCodes() async {
    try {
      final apCodeParam = selectedApCode != null && selectedApCode != 'ทั้งหมด'
          ? '?ap_code=$selectedApCode'
          : '';
      final response = await http.get(
          Uri.parse('http://172.16.0.82:8888/apex/wms/c/list$apCodeParam'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          data = jsonData['items'] ?? [];
          filterData();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void filterData() {
    setState(() {
      displayedData = data.where((item) {
        final poNo = item['po_no']?.toString().toLowerCase() ?? '';
        final matchesSearchQuery = poNo.contains(searchQuery.toLowerCase());
        final matchesApCode =
            selectedApCode == 'ทั้งหมด' || item['ap_code'] == selectedApCode;
        return matchesSearchQuery && matchesApCode;
      }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
  }

  void _performSearch() {
    // Implement search functionality here
    print('Searching for: ${_searchController.text}');
  }

  void _performSearch1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Warehouse'),
          content: SizedBox(
            width:
                double.maxFinite, // Make the dialog width as wide as possible
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedWarehouse, // Selected value
                        decoration: const InputDecoration(
                          labelText: 'เลือกคลังปฏิบัติงาน',
                          border: OutlineInputBorder(),
                        ),
                        items: warehouses.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['ware_code'],
                            child: Text(item['ware_code'] ?? 'No code'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedWarehouse = value;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  // Update the button label with the selected value
                  // Button label will automatically update
                });
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

// Sample data for dropdown

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _navigateToPage2(Map<String, String> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ssindt01From(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = List.generate(
      20,
      (index) => {'title': '${index + 1}', 'details': 'Details${index + 1}'},
    );

    final int startIndex = _currentPage * _cardsPerPage;
    final int endIndex = (_currentPage + 1) * _cardsPerPage;
    final List<Map<String, String>> currentItems = items.sublist(
      startIndex,
      endIndex > items.length ? items.length : endIndex,
    );

    return Scaffold(
      appBar: const CustomAppBar(), // Use the CustomAppBar
      drawer: const CustomDrawer(), // Use the CustomDrawer
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      color: Colors.deepPurple,
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'รับจากการสั่งซื้อ',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            child: TextButton(
                              onPressed: _performSearch1,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        12.0), // Adjust horizontal padding as needed
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical:
                                        8.0), // Adjust vertical padding as needed
                                child: Text(
                                  selectedWarehouse ?? 'Select Warehouse',
                                  style: const TextStyle(
                                      fontSize:
                                          14.0), // Adjust font size if needed
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 60,
                            height: 40,
                            child: TextButton(
                              onPressed: _clearSearch,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text('Clear'),
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 70,
                            height: 40,
                            child: TextButton(
                              onPressed: _performSearch,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text('Search'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'ประเภทรายการ',
                              border: OutlineInputBorder(),
                            ),
                            items: <String>['1', '2'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'ผู้ขาย',
                              border: OutlineInputBorder(),
                            ),
                            items: <String>['1', '2'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                          const SizedBox(height: 10),
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'เลขที่เอกสาร',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          ...currentItems
                              .map((item) => GestureDetector(
                                    onTap: () => _navigateToPage2(item),
                                    child: Card(
                                      color: const Color(0xFF5BF5BF),
                                      elevation: 8.0,
                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item['ap_name'] ?? 'No Name'),
                                            const Divider(
                                              color: Colors.black12,
                                              thickness: 1,
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                            '${item['po_no'] ?? 'No PO_NO'}\n'
                                            'สถานะ: ${item['status_desc'] ?? 'No Status'}\n'
                                            'Receive Date: ${item['receive_date'] ?? 'No Receive Date'}\n'
                                            'Item: ${item['item_stype_desc'] ?? 'No item'}\n'
                                            'receive no: ${item['receive_no'] ?? 'No item'}\n'
                                            'Warehouse: ${item['warehouse'] ?? 'No item'}\n'),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          if (_currentPage > 0 || endIndex < items.length)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (_currentPage > 0)
                                  TextButton(
                                    onPressed: _previousPage,
                                    child: const Text('Previous'),
                                  ),
                                if (endIndex < items.length)
                                  TextButton(
                                    onPressed: _nextPage,
                                    child: const Text('Next'),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Ssindt01Card(),
  ));
}
