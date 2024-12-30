import 'package:flutter/material.dart';
import 'region_screen.dart';
import 'province_screen.dart';
import 'municipality_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();

void navigateBasedOnSearch(String value) async {
  try {
    // Perform search query using the API
    final searchResults = await searchData(value);

    if (searchResults['results'] != null && searchResults['results'].isNotEmpty) {
      // Explicitly cast results to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(searchResults['results']);

      // Filter results to include exact matches for region, province, or municipality
      final exactMatchResults = results
          .where((r) =>
              (r['region']?.toLowerCase() == value.toLowerCase()) ||
              (r['province']?.toLowerCase() == value.toLowerCase()) ||
              (r['municipality']?.toLowerCase() == value.toLowerCase()))
          .toList();

      // Extract unique regions, provinces, and municipalities
      final uniqueRegions = exactMatchResults.map((r) => r['region']).toSet();
      final uniqueProvinces = exactMatchResults.map((r) => r['province']).toSet();
      final uniqueMunicipalities = exactMatchResults.map((r) => r['municipality']).toSet();

      // Case 1: If the search is for a single region
      if (uniqueRegions.length == 1 &&
          uniqueProvinces.isEmpty &&
          uniqueMunicipalities.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegionScreen(
              regionName: uniqueRegions.first,
          
            ),
          ),
        );
      }
      // Case 2: If the search is for a single province
      else if (uniqueProvinces.length == 1 &&
          uniqueMunicipalities.isNotEmpty &&
          uniqueMunicipalities.length != 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProvinceScreen(
              provinceName: uniqueProvinces.first,
           
            ),
          ),
        );
      }
      // Case 3: If the search is for a single municipality
      else if (uniqueMunicipalities.length == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MunicipalityScreen(
              municipalityName: uniqueMunicipalities.first,
           
            ),
          ),
        );
      } else {
        // If multiple results exist or no clear match, show region screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegionScreen(
              regionName: uniqueRegions.isNotEmpty ? uniqueRegions.first : "Unknown Region",
             
            ),
          ),
        );
      }
    } else {
      // No match found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No match found for "$value"')),
      );
    }
  } catch (error) {
    // Handle errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Italian Census Explorer',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[800], // Inspired by the green in the Italian flag
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1689198348157-572a7e47b74c?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'), // Replace with any relevant background image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Transparent Overlay for Italian Flag Colors
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.3), // Italian green
                  Colors.white.withOpacity(0.7), // White middle section
                  Colors.red.withOpacity(0.3), // Italian red
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
                  // Title Text
                  Text(
                    'Welcome to the Italian Census Explorer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Search Bar Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
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
                  // Search Button
                  ElevatedButton(
                    onPressed: () {
                      navigateBasedOnSearch(searchController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.red[700], // Italian red
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
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
