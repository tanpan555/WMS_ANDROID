import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomTextFormField extends StatefulWidget {
  // final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final ValueNotifier<bool> isDateInvalidNotifier;

  const CustomTextFormField({
    Key? key,
    // this.hintText,
    this.labelText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.onChanged,
    required this.isDateInvalidNotifier,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final dateInputFormatter = DateInputFormatter();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        widget.controller?.text = formattedDate;
        widget.isDateInvalidNotifier.value = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: widget.isDateInvalidNotifier,
          builder: (context, isDateInvalid, child) {
            return TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
                dateInputFormatter,
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                labelText: widget.labelText,
                hintText: 'DD/MM/YYYY',
                hintStyle: const TextStyle(color: Colors.grey),
                labelStyle: isDateInvalid
                    ? const TextStyle(color: Colors.red)
                    : const TextStyle(color: Colors.black87),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ),
              onChanged: (value) {
                widget.isDateInvalidNotifier.value =
                    dateInputFormatter.noDateNotifier.value;
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: widget.isDateInvalidNotifier,
          builder: (context, isDateInvalid, child) {
            return isDateInvalid
                ? const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  ValueNotifier<bool> noDateNotifier = ValueNotifier<bool>(false);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit length to 8 characters (DDMMYYYY)
    if (text.length > 8) {
      text = text.substring(0, 8);
    }

    int oldCursorPosition = oldValue.selection.baseOffset;

    // Update noDateNotifier based on text length and validity
    if (text.isEmpty) {
      noDateNotifier.value = false;
    } else if (text.length <= 7) {
      noDateNotifier.value = true;
    } else if (text.length == 8) {
      String day = text.substring(0, 2);
      String month = text.substring(2, 4);
      String year = text.substring(4, 8);
      noDateNotifier.value = !isValidDate(day, month, year);
    } else {
      noDateNotifier.value = false;
    }

    // Format date text with slashes
    String formattedText = _formatDate(text);

    // Calculate new cursor position based on changes and slashes
    int newCursorPosition = _calculateNewCursorPosition(
        oldCursorPosition, oldValue.text, formattedText);

    // Ensure cursor position is within text length
    newCursorPosition = newCursorPosition.clamp(0, formattedText.length);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  String _formatDate(String text) {
    if (text.length > 4) {
      return text.substring(0, 2) +
          '/' +
          text.substring(2, 4) +
          '/' +
          text.substring(4);
    } else if (text.length > 2) {
      return text.substring(0, 2) + '/' + text.substring(2);
    }
    return text;
  }

  int _calculateNewCursorPosition(
      int oldPosition, String oldText, String newText) {
    if (oldText.length < newText.length) {
      if (oldPosition == 2 || oldPosition == 5) {
        return oldPosition + 2;
      } else {
        return oldPosition + 1;
      }
    } else if (oldText.length > newText.length) {
      if (oldPosition == 3 || oldPosition == 6) {
        return oldPosition - 1;
      } else {
        return oldPosition;
      }
    }
    return oldPosition;
  }

  bool isValidDate(String day, String month, String year) {
    int dayInt = int.parse(day);
    int monthInt = int.parse(month);
    int yearInt = int.parse(year);

    if (monthInt < 1 || monthInt > 12) {
      return false;
    }

    List<int> daysInMonth = [
      31,
      isLeapYear(yearInt) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    int maxDays = daysInMonth[monthInt - 1];

    if (dayInt < 1 || dayInt > maxDays) {
      return false;
    }

    return true;
  }

  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
