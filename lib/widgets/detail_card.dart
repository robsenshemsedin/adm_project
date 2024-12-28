import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final String content;

  DetailCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}
