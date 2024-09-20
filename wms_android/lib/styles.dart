import 'package:flutter/material.dart';

class AppStyles {
  static ButtonStyle ConfirmbuttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 212, 245, 212),
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  static TextStyle ConfirmbuttonTextStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static ButtonStyle cancelButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      minimumSize: const Size(70, 40),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }

  static TextStyle CancelbuttonTextStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static ButtonStyle NextButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(60, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle CheckButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(60, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle ConfirmChecRecievekButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Colors.green, width: 2), // Added green border
    ),
    minimumSize: const Size(60, 40),
    padding: const EdgeInsets.all(0),
  );
}

}
