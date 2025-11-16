class ApiConstants {
  static const String baseUrl = 'https://corsproxy.io/?https://zenquotes.io';

  // static const String baseUrl = 'https://zenquotes.io';
  static const String randomQuoteEndpoint = '/api/random';
  static const String quotesEndpoint = '/quotes';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
