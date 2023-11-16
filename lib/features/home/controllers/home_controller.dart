import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/common/domain/entities/property.dart';
import 'package:homly/features/home/controllers/property_list_controller.dart';

final selectedIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final selectedPropertyFutureProvider = FutureProvider<Property?>((ref) async {
  final index = ref.watch(selectedIndexProvider);
  final future = ref.watch(userPropertyListControllerProvider);
  return future.maybeWhen(
    skipLoadingOnRefresh: false,
    data: (properties) {
      if (properties.isEmpty) return null;
      return properties[index];
    },
    orElse: () {
      return null;
    },
  );
});
