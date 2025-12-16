import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final connectionStatusProvider = StreamProvider<bool>((ref) async* {
  // Initial check
  yield await ApiService.healthCheck();

  // Check every 30 seconds
  await for (var _ in Stream.periodic(const Duration(seconds: 30))) {
    yield await ApiService.healthCheck();
  }
});
