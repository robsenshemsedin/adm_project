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

      // Extract unique regions, provinces, and municipalities
      final uniqueRegions = results.map((r) => r['region']).toSet();
      final uniqueProvinces = results.map((r) => r['province']).toSet();
      final uniqueMunicipalities = results.map((r) => r['municipality']).toSet();

      // Case 1: If the search is for a single province
      if (uniqueProvinces.length == 1 && uniqueMunicipalities.isNotEmpty && uniqueMunicipalities.length != 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProvinceScreen(
              provinceName: uniqueProvinces.first,
              data: results.where((r) => r['province'] == uniqueProvinces.first).toList(),
            ),
          ),
        );
      }
      else if (uniqueMunicipalities.length == 1) {
        // If the search is for a single municipality, navigate to MunicipalityScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MunicipalityScreen(
              municipalityName: uniqueMunicipalities.first,
              data: results.where((r) => r['municipality'] == uniqueMunicipalities.first).toList(),
            ),
          ),
        );
      } else {
        // If multiple results exist, show the region screen with filtered data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegionScreen(
              regionName: uniqueRegions.first,
              data: results,
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
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              focusNode: inputFocusNode,
              decoration: InputDecoration(
                labelText: 'Search region, province, municipality',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    navigateBasedOnSearch(searchController.text);
                    inputFocusNode.unfocus(); // Ensure the TextField loses focus
                  },
                ),
              ),
              onSubmitted: (value) {
                navigateBasedOnSearch(value);
              },
            ),
          ],
        ),
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
