import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL for the API
const String baseUrl = 'http://127.0.0.1:8000';

// Fetch regions
Future<List<String>> fetchRegions() async {
  final response = await http.get(Uri.parse('$baseUrl/regions'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<String>.from(data['regions']);
  } else {
    throw Exception('Failed to load regions');
  }
}

// Fetch region details
Future<Map<String, dynamic>> fetchRegionDetails(String regionName) async {
  final response = await http.get(Uri.parse('$baseUrl/regions/$regionName'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load region details');
  }
}

// Fetch province details
Future<Map<String, dynamic>> fetchProvinceDetails(String provinceName) async {
  final response = await http.get(Uri.parse('$baseUrl/provinces/$provinceName'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load province details');
  }
}

// Fetch municipality details
Future<Map<String, dynamic>> fetchMunicipalityDetails(String municipalityName) async {
  final response =
      await http.get(Uri.parse('$baseUrl/municipalities/$municipalityName'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load municipality details');
  }
}

// Search for regions, provinces, or municipalities
Future<Map<String, dynamic>> searchData(String query) async {

  final response = await http.get(Uri.parse('$baseUrl/search?query=$query'));
  
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to search data');
  }
}
