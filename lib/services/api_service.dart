import 'dart:convert';
import 'package:http/http.dart' as http;

// Base URL for the API
const String baseUrl = 'http://127.0.0.1:8000';

/// Fetch all regions
Future<List<String>> fetchRegions() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/regions'));
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['regions']);
    } else {
      throw Exception('Failed to load regions');
    }
  } catch (e) {
    print('Error fetching regions: $e');
    throw Exception('Error: $e');
  }
}

/// Fetch details of a specific region
Future<Map<String, dynamic>> fetchRegionDetails(String regionName) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/regions/$regionName'));
    print('Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load region details');
    }
  } catch (e) {
    print('Error fetching region details: $e');
    throw Exception('Error: $e');
  }
}

/// Fetch details of a specific province
Future<Map<String, dynamic>> fetchProvinceDetails(String provinceName) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/provinces/$provinceName'));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load province details');
    }
  } catch (e) {
    print('Error fetching province details: $e');
    throw Exception('Error: $e');
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



// Helper to convert population data to integers
Map<String, dynamic> _convertPopulationData(Map<String, dynamic> population) {
  return {
    'total': int.tryParse(population['total'].toString()) ?? 0,
    'male': int.tryParse(population['male'].toString()) ?? 0,
    'female': int.tryParse(population['female'].toString()) ?? 0,
    'age_groups': {
      '<5': int.tryParse(population['age_groups']['<5'].toString()) ?? 0,
      '5-9': int.tryParse(population['age_groups']['5-9'].toString()) ?? 0,
      '10-14': int.tryParse(population['age_groups']['10-14'].toString()) ?? 0,
    }
  };
}

// Helper to convert employment data to integers
Map<String, dynamic> _convertEmploymentData(Map<String, dynamic> employment) {
  return {
    'total_employed': int.tryParse(employment['total_employed'].toString()) ?? 0,
    'male_employed': int.tryParse(employment['male_employed'].toString()) ?? 0,
    'female_employed': int.tryParse(employment['female_employed'].toString()) ?? 0,
  };
}

// Helper to convert education data to integers
Map<String, dynamic> _convertEducationData(Map<String, dynamic> education) {
  return {
    'no_education': int.tryParse(education['no_education'].toString()) ?? 0,
    'elementary': int.tryParse(education['elementary'].toString()) ?? 0,
    'middle': int.tryParse(education['middle'].toString()) ?? 0,
    'high_school': int.tryParse(education['high_school'].toString()) ?? 0,
    'tertiary': int.tryParse(education['tertiary'].toString()) ?? 0,
  };
}


/// Search for regions, provinces, or municipalities
Future<Map<String, dynamic>> searchData(String query) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/search?query=$query'));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to search data');
    }
  } catch (e) {
    print('Error searching data: $e');
    throw Exception('Error: $e');
  }
}

/// Fetch employment summary for a region
Future<Map<String, dynamic>> fetchEmploymentSummary(String regionName) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/regions/$regionName/employment_summary'));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load employment summary');
    }
  } catch (e) {
    print('Error fetching employment summary: $e');
    throw Exception('Error: $e');
  }
}
