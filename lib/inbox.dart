import 'package:flutter/material.dart';

class InboxApp extends StatelessWidget {
  const InboxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inbox Screen',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Inter', 
        brightness: Brightness.light,
      ),
    );
  }
}

class InboxScreen extends StatelessWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black12,
        centerTitle: false,
        title: const Text(
          'Inbox',
          style: TextStyle(
            color: Color(0xFF202342),
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFFFF7043), size: 28),
              onPressed: () {
              },
              tooltip: 'Menu',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 26,
              ),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'Add task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
              backgroundColor:  const Color(0xFFF7B500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: Colors.black45,
                elevation: 10,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}