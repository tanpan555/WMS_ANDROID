import 'package:flutter/material.dart';
import '../appbar.dart';
import '../drawer.dart';
import 'SSINDT01_GRID_CONFIRM.dart';

class Ssindt01Scanbarcode extends StatefulWidget {
  const Ssindt01Scanbarcode({super.key});

  @override
  _ScanbarcodeState createState() => _ScanbarcodeState();
}

class _ScanbarcodeState extends State<Ssindt01Scanbarcode> {
  String? _selectedLocator;
  final List<String> _locators = [
    'Locator 1',
    'Locator 2',
    'Locator 3'
  ]; // Replace with your locator values

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Use the CustomAppBar
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(10, 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ย้อนกลับ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 245),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(10, 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Ssindt01Gridconfirm(),
                        ),
                      ); // Code for Next button
                    },
                    child: const Text(
                      'ถัดไป',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: _buildFormFields(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Set desired fraction of screen width
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.yellow[200], // Light yellow background
              border: Border.all(
                  color: Colors.black,
                  width: 2.0), // Black border with width 2.0
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                'WM-D00-0000000',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28, // Adjust the font size as needed
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Barcode',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 61, 61, 61),
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 50, // Adjust width and height as needed
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1, // Adjust height for vertical alignment
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Barcode',
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Locator',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 61, 61, 61),
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 50, // Adjust width and height as needed
            child: DropdownButtonFormField<String>(
              value: _selectedLocator,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLocator = newValue;
                });
              },
              items: _locators.map((String locator) {
                return DropdownMenuItem<String>(
                  value: locator,
                  child: Text(locator),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Locator',
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          // Additional text fields

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50, // Adjust width and height as needed
            child: TextField(
              controller:
                  TextEditingController(text: ' '), // Set the initial value
              obscureText: false, // Set to true if you want to hide the text
              readOnly: true, // Make the text field read-only
              decoration: InputDecoration(
                border: InputBorder.none, // Remove all borders
                filled: true, // Enable the fill color
                fillColor: Colors.grey[200], // Set the background color
                labelText: 'Lot Number',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0), // Adjust padding as needed
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50, // Adjust width and height as needed
            child: TextField(
              controller:
                  TextEditingController(text: ' '), // Set the initial value
              obscureText: false, // Set to true if you want to hide the text
              readOnly: true, // Make the text field read-only
              decoration: InputDecoration(
                border: InputBorder.none, // Remove all borders
                filled: true, // Enable the fill color
                fillColor: Colors.grey[200],
                labelText: 'Quantity',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50, // Adjust width and height as needed
            child: TextField(
              controller:
                  TextEditingController(text: ' '), // Set the initial value
              obscureText: false, // Set to true if you want to hide the text
              readOnly: true, // Make the text field read-only
              decoration: InputDecoration(
                border: InputBorder.none, // Remove all borders
                filled: true, // Enable the fill color
                fillColor: Colors.grey[200],
                labelText: 'Current Locator',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0),
                 // Enable the fill color
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50, // Adjust width and height as needed
            child: TextField(
              controller:
                  TextEditingController(text: ' '), // Set the initial value
              obscureText: false, // Set to true if you want to hide the text
              readOnly: true, // Make the text field read-only
              decoration: InputDecoration(
                border: InputBorder.none, // Remove all borders
                filled: true, // Enable the fill color
                fillColor: Colors.yellow[200],
                labelText: 'จำนวนล็อต/รายการรอจัดเก็บ',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0),
                 // Enable the fill color
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50, // Adjust width and height as needed
            child: TextField(
              controller:
                  TextEditingController(text: ' '), // Set the initial value
              obscureText: false, // Set to true if you want to hide the text
              readOnly: true, // Make the text field read-only
              decoration: InputDecoration(
                border: InputBorder.none, // Remove all borders
                filled: true, // Enable the fill color
                fillColor: Colors.yellow[200],
                labelText: 'จำนวน (หน่วยสต๊อก) รอจัดเก็บ',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0),
                 // Enable the fill color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
