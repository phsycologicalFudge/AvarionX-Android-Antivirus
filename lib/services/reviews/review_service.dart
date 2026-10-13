import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const _prefKey = 'clean_scan_count';
  static const _reviewInterval = 3;

  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> onCleanScanCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_prefKey) ?? 0) + 1;
    await prefs.setInt(_prefKey, count);

    if ((count - 1) % _reviewInterval != 0) return;
    if (!await _inAppReview.isAvailable()) return;
    await _inAppReview.requestReview();
  }

  Future<void> openStoreListing() async {
    await _inAppReview.openStoreListing();
  }
}