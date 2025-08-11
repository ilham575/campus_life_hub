import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  initFCM() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print('Message opened app: ${message.notification?.title}');
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a foreground message: ${message.notification?.title}');
      // You can show a dialog or notification here
    });

  }

}