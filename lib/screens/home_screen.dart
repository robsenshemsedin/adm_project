// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'region_screen.dart';
import 'province_screen.dart';
import 'municipality_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();

  bool _isLoading = false;  // NEW: Loading state

  // Updated search function with loading state
  void navigateBasedOnSearch(String value) async {
    if (value.isEmpty) return;  // Prevent empty search

    setState(() {
      _isLoading = true;  // Show loading indicator
    });

    try {
      final searchResults = await searchData(value);

      if (searchResults['results'] != null && searchResults['results'].isNotEmpty) {
        final List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(searchResults['results']);
        final exactMatchResults = results
            .where((r) =>
                (r['region']?.toLowerCase() == value.toLowerCase()) ||
                (r['province']?.toLowerCase() == value.toLowerCase()) ||
                (r['municipality']?.toLowerCase() == value.toLowerCase()))
            .toList();

        final uniqueRegions = exactMatchResults.map((r) => r['region']).toSet();
        final uniqueProvinces = exactMatchResults.map((r) => r['province']).toSet();
        final uniqueMunicipalities = exactMatchResults.map((r) => r['municipality']).toSet();

        // Case 1: Region
        if (uniqueRegions.length == 1 && uniqueProvinces.isEmpty && uniqueMunicipalities.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegionScreen(regionName: uniqueRegions.first),
            ),
          ).then((_) {
            setState(() {
              _isLoading = false;  // Stop loading when navigating back
            });
          });
        }
        // Case 2: Province
        else if (uniqueProvinces.length == 1 && uniqueMunicipalities.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProvinceScreen(provinceName: uniqueProvinces.first),
            ),
          ).then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        }
        // Case 3: Municipality
        else if (uniqueMunicipalities.length == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MunicipalityScreen(municipalityName: uniqueMunicipalities.first),
            ),
          ).then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        } else {
          // Multiple or no clear matches
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegionScreen(
                regionName: uniqueRegions.isNotEmpty ? uniqueRegions.first : "Unknown Region",
              ),
            ),
          ).then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        }
      } else {
        // No results
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No match found for "$value"')),
        );
      }
    } catch (error) {
      // Handle errors
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Italian Census Explorer', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1689198348157-572a7e47b74c'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Italian Flag Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.3),
                  Colors.white.withOpacity(0.7),
                  Colors.red.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to the Italian Census Explorer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                      shadows: [Shadow(blurRadius: 4.0, color: Colors.black38, offset: Offset(2.0, 2.0))],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [BoxShadow(blurRadius: 6.0, color: Colors.black26, offset: Offset(0, 2))],
                    ),
                    child: TextField(
                      controller: searchController,
                      focusNode: inputFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Search for regions, provinces, or municipalities',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search, color: Colors.green[800]),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      onSubmitted: (value) {
                        navigateBasedOnSearch(value);
                      },
                    ),
                  ),
                  SizedBox(height: 24.0),
                  // Search Button with Loading Indicator
                  ElevatedButton(
                    onPressed: _isLoading ? null : () {
                      navigateBasedOnSearch(searchController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      backgroundColor: Colors.red[700],
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text('Search', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    inputFocusNode.dispose();
    super.dispose();
  }
}
