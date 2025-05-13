import 'dart:convert';
import 'package:http/http.dart' as http;

class ConstantFunction {
  static Future<List<Map<String, dynamic>>> getResponse(String category) async {
    // Optional: Map Flutter tab category labels to more accurate API terms if needed
    final Map<String, String> categoryMap = {
      'breakfast': 'frühstück',
      'lunch': 'mittagessen',
      'dinner': 'abendessen',
      'quick': 'schnelle rezepte',
    };

    final String searchTerm = categoryMap[category.toLowerCase()] ?? category;

    final String apiUrl =
        'https://gustar-io-deutsche-rezepte.p.rapidapi.com/search_api?text=${Uri.encodeComponent(searchTerm)}';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'x-rapidapi-key': 'e0f3016ae2mshf0a11cff9724101p147173jsnfee31765dc98',
          'x-rapidapi-host': 'gustar-io-deutsche-rezepte.p.rapidapi.com',
        },
      );
      //1:-   e0f3016ae2mshf0a11cff9724101p147173jsnfee31765dc98
      //2:-   8fbb2845bbmsh718e3bdfc174476p10a0e3jsnd2dd8985e1e2

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map<String, dynamic> && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          print('Unexpected data format: ${data.runtimeType}');
        }
      } else {
        print('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }

    return [];
  }
}

/*
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConstantFunction {
  static Future<List<Map<String, dynamic>>> getResponse(String category) async {
    // Optional: Map Flutter tab category labels to more accurate API terms if needed
    final Map<String, String> categoryMap = {
      'breakfast': 'frühstück',
      'lunch': 'mittagessen',
      'dinner': 'abendessen',
      'quick': 'schnelle rezepte',
    };

    final String searchTerm = categoryMap[category.toLowerCase()] ?? category;

    final String apiUrl =
        'https://gustar-io-deutsche-rezepte.p.rapidapi.com/search_api?text=${Uri.encodeComponent(searchTerm)}';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          //'x-rapidapi-key': 'dba06875b7msh6a866afcf8eda2cp164acbjsnd019b278c54e',
          'x-rapidapi-host': 'gustar-io-deutsche-rezepte.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map<String, dynamic> && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          print('Unexpected data format: ${data.runtimeType}');
        }
      } else {
        print('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }

    return [];
  }
}
*/


/*
import 'dart:convert';

import 'package:http/http.dart' as http;
class ConstantFunction{
  static Future<List<Map<String,dynamic>>>getResponse(String findRecipe)async{
    String key='a53f1a3f5f314c4f8c25840a240e9d9d';
    String api='https://api.edamam.com/api/recipes/v2/0123456789abcdef0123456789abcdef?app_id=YOUR_APP_ID&app_key=YOUR_APP_KEY&type=public';

    final response=await http.get(Uri.parse(api));
    List<Map<String,dynamic>> recipe=[];
    if(response.statusCode==200){
      var data=jsonDecode(response.body);

      if(data['hits']!=null){
        for(var hit in data['hits']){
          recipe.add(hit['recipe']);
        }
      }
      return recipe;
    }
    return recipe;

  }
}
*/