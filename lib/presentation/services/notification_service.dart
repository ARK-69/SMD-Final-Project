import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../../model/place.dart';
import '../theme/app_theme.dart';

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  static const _channelId = 'favorite_locations';
  static const _channelName = 'Favorite locations';

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized || !_isAndroid) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> showFavoriteAdded(Place place) async {
    if (!_isAndroid) return;
    if (!_initialized) await initialize();

    final title = 'New location added to favourites';
    final body = '${place.title} has been added in the favourites';
    final imageBytes = await _loadLocationImage(place.imageUrl);
    final image = ByteArrayAndroidBitmap(imageBytes);

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Notifications when a place is added to favourites.',
      importance: Importance.high,
      priority: Priority.high,
      color: AppColors.purple,
      largeIcon: image,
      styleInformation: BigPictureStyleInformation(
        image,
        largeIcon: image,
        contentTitle: title,
        summaryText: body,
      ),
    );

    await _plugin.show(
      id: place.id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  Future<Uint8List> _loadLocationImage(String imageUrl) async {
    if (imageUrl.startsWith('http')) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
      } catch (_) {}
    } else {
      // Load from assets
      try {
        final data = await rootBundle.load(imageUrl);
        return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      } catch (_) {}
    }
    // Fallback to placeholder
    final data = await rootBundle.load(Place.localImageAsset);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  bool get _isAndroid {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }
}
