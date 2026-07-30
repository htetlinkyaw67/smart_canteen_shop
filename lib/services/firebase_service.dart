import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {

  final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;


  Future<String?> getFcmToken() async {

    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();


    if(settings.authorizationStatus ==
        AuthorizationStatus.authorized){

      String? token =
          await _firebaseMessaging.getToken();

      return token;
    }

    return null;
  }
}