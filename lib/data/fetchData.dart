import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future fetchData() async {
    final response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/af07fbfc-8c1a-4b31-90eb-207d1860c6bc'));

    if (response.statusCode == 200) {
      // Decode the response body as a Dart Map for type safety
      final decodedData = jsonDecode(response.body);
      return decodedData;
    } else {
      // Throw an exception with more specific error information
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}
