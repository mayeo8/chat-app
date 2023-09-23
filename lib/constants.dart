import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
    color: Color(0xff24c6dc),
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    fontFamily: 'Quicksand');

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
  filled: true,
  fillColor: Colors.white,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(
      color: Colors.lightBlueAccent,
      width: 2.0,
    ),
  ),
  color: Colors.white,
);
const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter your email',
  hintStyle: TextStyle(color: Colors.white),
  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
  border: OutlineInputBorder(),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
  ),
);

const kButtonTextDesign = TextStyle(
  fontSize: 18.0,
  fontFamily: 'Quicksand',
  fontWeight: FontWeight.w900,
);

const kButtonDesign = ButtonStyle(
  backgroundColor: MaterialStatePropertyAll(Colors.black),
  elevation: MaterialStatePropertyAll(5.0),
  padding: MaterialStatePropertyAll(
    EdgeInsets.all(14.0),
  ),
);
const kGradientContainerStyle = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.topLeft,
  colors: [
    Color(0xff005c97),
    Color(0xff363795),
  ],
);

const kTextFieldTextStyle = TextStyle(color: Colors.white);

SnackBar kSnackBar = const SnackBar(
  behavior: SnackBarBehavior.floating,
  backgroundColor: Colors.black54,
  elevation: 5.0,
  duration: Duration(seconds: 5),
  content: Text(
    'An error has occur unable to Register',
    style: TextStyle(
      fontFamily: 'Quicksand',
      fontWeight: FontWeight.w900,
    ),
  ),
);

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(
    context, message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black54,
      elevation: 5.0,
      duration: const Duration(seconds: 5),
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w900,
        ),
      ),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: () {},
      ),
    ),
  );
}
