import 'package:flutter/material.dart';
import 'package:medrano_ass6/screen.dart';

void main(){
  runApp(ass6());
}

class ass6 extends StatelessWidget {
  const ass6({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ass6_screen(),
    );
  }
}