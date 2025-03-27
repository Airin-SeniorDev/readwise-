import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome to ReadWise+")),
      body: Center(
        child: Text(
          "🎉 คุณเข้าสู่ระบบสำเร็จแล้ว!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
