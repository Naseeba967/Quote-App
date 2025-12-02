import 'package:code_alpha_quote_app/models/quote_model.dart';
import 'package:code_alpha_quote_app/services/api_services.dart';
import 'package:code_alpha_quote_app/services/storage_services.dart';

import 'package:flutter/material.dart';

enum QuoteStatus { initial, loading, loaded, error }

class QuoteProvider extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();
  final StorageService _storageService = StorageService(); 

  QuoteModel? _currentQuote;
  QuoteStatus _status = QuoteStatus.initial;
  String _error = '';
  List<QuoteModel> _favoriteQuotes = [];
  bool _isFavorite = false;

  // Getters
  QuoteModel? get currentQuote => _currentQuote;
  QuoteStatus get status => _status;
  String get errorMessage => _error;
  bool get isLoading => _status == QuoteStatus.loading;
  List<QuoteModel> get favoriteQuotes => _favoriteQuotes;
  bool get isFavorite => _isFavorite;
  int get favoritesCount => _favoriteQuotes.length;

  // Initialize - Load last saved quote and favorites
  Future<void> initialize() async {
    print('🚀 Initializing QuoteProvider...');
    _status = QuoteStatus.loading;
    notifyListeners();

    try {
      // Load favorite quotes
      _favoriteQuotes = await _storageService.getFavoriteQuotes();
      print('📚 Loaded ${_favoriteQuotes.length} favorites');

      // Try to fetch new quote from API
      await fetchNewQuote();
    } catch (e) {
      print('❌ Initialize error: $e');

      // Try to load last saved quote if API fails
      _currentQuote = await _storageService.getLastQuote();

      if (_currentQuote != null) {
        _status = QuoteStatus.loaded;
        _error = 'Showing cached quote (No internet)';
        await _checkIfFavorite();
      } else {
        _status = QuoteStatus.error;
        _error = e.toString().replaceAll('Exception: ', '');
      }
      notifyListeners();
    }
  }

  // Fetch new quote from API
  Future<void> fetchNewQuote() async {
    print('📥 Fetching new quote...');
    _status = QuoteStatus.loading;
    _error = '';
    notifyListeners();

    try {
      // Fetch from API
      _currentQuote = await _apiServices.fetchRandomQuote();

      // Save to local storage
      await _storageService.saveLastQuote(_currentQuote!);

      // Check if it's in favorites
      await _checkIfFavorite();

      _status = QuoteStatus.loaded;
      print('✅ Quote loaded: ${_currentQuote?.content}');
    } catch (e) {
      print('❌ Fetch error: $e');
      _status = QuoteStatus.error;
      _error = e.toString().replaceAll('Exception: ', '');

      // Try to load cached quote
      _currentQuote = await _storageService.getLastQuote();
      if (_currentQuote != null) {
        _status = QuoteStatus.loaded;
        _error = 'Showing cached quote. $_error';
        await _checkIfFavorite();
      }
    }

    notifyListeners();
  }

  // Save current quote to favorites
  // Future<void> saveFavorite() async {
  //   if (_currentQuote != null && !_isFavorite) {
  //     // Add check: only save if not already favorite
  //     try {
  //       await _storageService.saveFavoriteQuote(_currentQuote!);

  //       // Update favorite status FIRST
  //       _isFavorite = true;

  //       // Then reload favorites list
  //       _favoriteQuotes = await _storageService.getFavoriteQuotes();

  //       print('💾 Quote saved to favorites! Total: ${_favoriteQuotes.length}');
  //       notifyListeners();
  //     } catch (e) {
  //       debugPrint('❌ Error saving favorite: $e');
  //     }
  //   } else if (_isFavorite) {
  //     print('ℹ️ Quote already in favorites');
  //   }
  // }

  Future<void> saveFavorite() async {
    if (_currentQuote != null && !_isFavorite) {
      // Add check: only save if not already favorite
      try {
        await _storageService.saveFavoriteQuote(_currentQuote!);

        // Update favorite status FIRST
        _isFavorite = true;

        // Then reload favorites list
        _favoriteQuotes = await _storageService.getFavoriteQuotes();

        print('💾 Quote saved to favorites! Total: ${_favoriteQuotes.length}');
        notifyListeners();
      } catch (e) {
        print('❌ Error saving favorite: $e');
      }
    } else if (_isFavorite) {
      print('ℹ️ Quote already in favorites');
    }
  }

  // Remove current quote from favorites
  Future<void> removeFavorite() async {
    if (_currentQuote != null) {
      try {
        await _storageService.removeFavoriteQuote(_currentQuote!.id);

        // Reload favorites list
        _favoriteQuotes = await _storageService.getFavoriteQuotes();
        _isFavorite = false;

        print('🗑️ Quote removed from favorites!');
        notifyListeners();
      } catch (e) {
        print('❌ Error removing favorite: $e');
      }
    }
  }

  // Remove favorite by ID (for favorites screen)
  Future<void> removeFavoriteById(String quoteId) async {
    try {
      await _storageService.removeFavoriteQuote(quoteId);

      // Reload favorites list
      _favoriteQuotes = await _storageService.getFavoriteQuotes();

      // Update current quote favorite status if it matches
      if (_currentQuote?.id == quoteId) {
        _isFavorite = false;
      }

      print('🗑️ Quote removed from favorites!');
      notifyListeners();
    } catch (e) {
      print('❌ Error removing favorite: $e');
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite() async {
    if (_isFavorite) {
      await removeFavorite();
    } else {
      await saveFavorite();
    }
  }

  // Check if current quote is in favorites
  Future<void> _checkIfFavorite() async {
    if (_currentQuote != null) {
      _isFavorite = await _storageService.isFavorite(_currentQuote!.id);
    }
  }

  // Load all favorite quotes
  Future<void> loadFavorites() async {
    try {
      _favoriteQuotes = await _storageService.getFavoriteQuotes();
      print('📚 Loaded ${_favoriteQuotes.length} favorite quotes');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading favorites: $e');
    }
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      await _storageService.clearAllFavorites();
      _favoriteQuotes = [];
      _isFavorite = false;
      print('🗑️ All favorites cleared');
      notifyListeners();
    } catch (e) {
      print('❌ Error clearing favorites: $e');
    }
  }

  // Refresh quote (pull to refresh)
  Future<void> refreshQuote() async {
    print('🔄 Refreshing quote...');
    await fetchNewQuote();
  }
}
