import '../app_services.dart';

class AppNotification {
  static Future<void> show({required String title, String body = ''}) {
    return AppServices.nativeBridge.showNotification(title: title, body: body);
  }
}
