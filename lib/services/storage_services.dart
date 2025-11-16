import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_model.dart';

class StorageService {
  // Keys for storing data
  static const String _lastQuoteKey = 'last_quote';
  static const String _favoriteQuotesKey = 'favorite_quotes';

  // Save the last fetched quote (for offline use)
  Future<void> saveLastQuote(QuoteModel quote) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final quoteJson = json.encode(quote.toJson());
      await prefs.setString(_lastQuoteKey, quoteJson);
      print('💾 Last quote saved successfully');
    } catch (e) {
      print('❌ Error saving last quote: $e');
    }
  }

  // Get the last saved quote
  Future<QuoteModel?> getLastQuote() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final quoteJson = prefs.getString(_lastQuoteKey);

      if (quoteJson != null) {
        final Map<String, dynamic> data = json.decode(quoteJson);
        print('📖 Last quote loaded from storage');
        return QuoteModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('❌ Error loading last quote: $e');
      return null;
    }
  }

  // Save a quote to favorites
  Future<void> saveFavoriteQuote(QuoteModel quote) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing favorites
      List<QuoteModel> favorites = await getFavoriteQuotes();

      // Check if quote already exists in favorites by comparing ID
      bool alreadyExists = favorites.any((q) => q.id == quote.id);

      if (!alreadyExists) {
        // Add new quote to favorites
        favorites.add(quote);

        // Convert to JSON list and save
        final List<Map<String, dynamic>> favoritesJsonList = favorites
            .map((q) => q.toJson())
            .toList();

        final favoritesJson = json.encode(favoritesJsonList);

        await prefs.setString(_favoriteQuotesKey, favoritesJson);

        print('💾 Quote saved to favorites! Total: ${favorites.length}');
        print('📝 Saved quotes IDs: ${favorites.map((q) => q.id).toList()}');
      } else {
        print('ℹ️ Quote already in favorites');
      }
    } catch (e) {
      print('❌ Error saving favorite quote: $e');
      rethrow;
    }
  }

  // Get all favorite quotes
  Future<List<QuoteModel>> getFavoriteQuotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoriteQuotesKey);

      if (favoritesJson != null && favoritesJson.isNotEmpty) {
        final List<dynamic> data = json.decode(favoritesJson);
        final favorites = data
            .map((json) {
              try {
                return QuoteModel.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('❌ Error parsing quote: $e');
                return null;
              }
            })
            .whereType<QuoteModel>()
            .toList();
        print('📚 Loaded ${favorites.length} favorite quotes');
        print('📝 Loaded quotes IDs: ${favorites.map((q) => q.id).toList()}');
        return favorites;
      }
      return [];
    } catch (e) {
      print('❌ Error loading favorite quotes: $e');
      return [];
    }
  }

  // Remove a quote from favorites
  Future<void> removeFavoriteQuote(String quoteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing favorites
      List<QuoteModel> favorites = await getFavoriteQuotes();

      // Remove the quote with matching ID
      favorites.removeWhere((q) => q.id == quoteId);

      // Save updated list
      final List<Map<String, dynamic>> favoritesJsonList = favorites
          .map((q) => q.toJson())
          .toList();

      final favoritesJson = json.encode(favoritesJsonList);

      await prefs.setString(_favoriteQuotesKey, favoritesJson);

      print('🗑️ Quote removed from favorites. Remaining: ${favorites.length}');
    } catch (e) {
      print('❌ Error removing favorite quote: $e');
      rethrow;
    }
  }

  // Check if a quote is in favorites
  Future<bool> isFavorite(String quoteId) async {
    try {
      final favorites = await getFavoriteQuotes();
      return favorites.any((q) => q.id == quoteId);
    } catch (e) {
      print('❌ Error checking favorite status: $e');
      return false;
    }
  }

  // Clear all favorite quotes
  Future<void> clearAllFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoriteQuotesKey);
      print('🗑️ All favorites cleared');
    } catch (e) {
      print('❌ Error clearing favorites: $e');
      rethrow;
    }
  }

  // Get total number of favorite quotes
  Future<int> getFavoritesCount() async {
    try {
      final favorites = await getFavoriteQuotes();
      return favorites.length;
    } catch (e) {
      print('❌ Error getting favorites count: $e');
      return 0;
    }
  }

  // Clear all stored data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('🗑️ All data cleared');
    } catch (e) {
      print('❌ Error clearing all data: $e');
      rethrow;
    }
  }
}
