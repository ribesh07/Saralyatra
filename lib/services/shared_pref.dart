import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userImageKey = "USERIMAGEKEY";
  static String userUserNameKey = "USERUSERNAMEKEY";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserDisplayName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUserImage);
  }

  Future<bool> saveUserName(String getUserName1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userUserNameKey, getUserName1);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserName1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUserNameKey);
  }

  Future<String?> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }
}

// class SharedpreferenceHelper {
//   static const String keyUserId = "USER_ID";
//   static const String keyDisplayName = "DISPLAY_NAME";
//   static const String keyEmail = "EMAIL";
//   static const String keyImageUrl = "IMAGE_URL";
//   static const String keyUsername = "USERNAME";

//   Future<bool> saveUserId(String userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.setString(keyUserId, userId);
//   }

//   Future<bool> saveDisplayName(String name) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.setString(keyDisplayName, name);
//   }

//   Future<bool> saveEmail(String email) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.setString(keyEmail, email);
//   }

//   Future<bool> saveImageUrl(String url) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.setString(keyImageUrl, url);
//   }

//   Future<bool> saveUsername(String username) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.setString(keyUsername, username);
//   }

//   Future<String?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(keyUserId);
//   }

//   Future<String?> getDisplayName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(keyDisplayName);
//   }

//   Future<String?> getEmail() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(keyEmail);
//   }

//   Future<String?> getImageUrl() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(keyImageUrl);
//   }

//   Future<String?> getUsername() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(keyUsername);
//   }
// }
