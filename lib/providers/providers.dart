import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/view_model/api_view_model.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

final portfolioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  final authState = ref.read(authViewModelProvider);
  final apiRepo = ref.read(portfolioViewModelProvider.notifier);
  return apiRepo.fetchPortfolioAllocation(authState.user!);
});
