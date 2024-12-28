import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const SearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search region, province, municipality',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.search),
        ),
        onSubmitted: onSearch,
      ),
    );
  }
}
