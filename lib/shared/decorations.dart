import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

InputDecoration textFieldDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white)),
  filled: true,
  fillColor: Colors.white
);


DateFormat dateTimeFormatter = DateFormat('MMMM dd, yyyy hh:mm a');

DateFormat dateFormatter = DateFormat('MMMM dd, yyyy');

DateFormat dateFormatter2 = DateFormat('MMM/dd/yyyy');
