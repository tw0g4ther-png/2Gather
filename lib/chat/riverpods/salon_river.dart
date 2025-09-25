import 'salon_messages_notifier.dart';
import 'salon_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageFirestoreRiver = ChangeNotifierProvider<SalonNotifier>((ref) {
  return SalonNotifier(providerRef: ref);
});
final salonMessagesNotifier = ChangeNotifierProvider<SalonMessagesNotifier>((ref) {
  return SalonMessagesNotifier(providerRef: ref);
});
