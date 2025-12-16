class ApiConstants {
  static const String baseUrl = 'https://sud-api-jy24z.ondigitalocean.app';
  static const String apiKey = '832gx73f3i493fg9v2nnn';

  // Endpoints
  static const String health = '/health';
  static const String bins = '/bins/';
  static const String binsExtended = '/bins_extended/';
  static const String measurements = '/measurements/';

  // Headers
  static Map<String, String> get headers => {
    'X-API-Key': apiKey,
    'Content-Type': 'application/json',
  };
}
