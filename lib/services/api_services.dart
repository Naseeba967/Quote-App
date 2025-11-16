import 'dart:convert';
import 'dart:io';

import 'package:code_alpha_quote_app/constants/api_constant.dart';
import 'package:code_alpha_quote_app/models/quote_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<QuoteModel> fetchRandomQuote() async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.randomQuoteEndpoint}',
      );

      final response = await http
          .get(url)
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        // Print raw response for debugging
        print('Raw Response: ${response.body}');

        final dynamic decodedData = json.decode(response.body);
        print('Decoded Type: ${decodedData.runtimeType}');
        print('Decoded Data: $decodedData');

        // Handle if API returns a list
        if (decodedData is List) {
          if (decodedData.isEmpty) {
            throw Exception('No quotes available');
          }

          // Ensure the first element is a Map
          final firstItem = decodedData[0];
          if (firstItem is! Map<String, dynamic>) {
            throw Exception('Invalid quote format');
          }

          return QuoteModel.fromJson(firstItem);
        }
        // Handle if API returns a single object
        else if (decodedData is Map<String, dynamic>) {
          return QuoteModel.fromJson(decodedData);
        } else {
          throw Exception(
            'Unexpected response format: ${decodedData.runtimeType}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('Quote not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on http.ClientException {
      throw Exception('Failed to connect to server.');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
