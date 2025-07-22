import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userImageKey = "USERIMAGEKEY";
  static String userUserNameKey = "USERUSERNAMEKEY";
  static String userCardIDKey = "USERCARDIDKEY";
  static String userBalanceKey = "USERBALANCEKEY"; // Added for user balance
  static String driverIdKey = "DRIVERKEY";
  static String driverEmailKey = "USEREMAILKEY";
  static String driverImageKey = "USERIMAGEKEY";
  static String driverDriverNameKey = "USERUSERNAMEKEY";
  static String role = "ROLE";
  static String contact = "CONTACT";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveDriverId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(driverIdKey, getUserId);
  }

  Future<bool> saveUserDisplayName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveRole(String getRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(role, getRole);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveDriverEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(driverEmailKey, getUserEmail);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUserImage);
  }

  Future<bool> saveDriverImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(driverImageKey, getUserImage);
  }

  Future<bool> saveUserName(String getUserName1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userUserNameKey, getUserName1);
  }

  Future<bool> saveDriverName(String getUserName1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(driverDriverNameKey, getUserName1);
  }

  Future<bool> saveUserCardID(String getUserCardID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userCardIDKey, getUserCardID);
  }

  Future<String?> getUserCardID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userCardIDKey);
  }

  Future<bool> saveUserBalance(String getUserBalance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userBalanceKey, getUserBalance);
  }

  Future<String?> getUserBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userBalanceKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(contact);
  }

  Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(role);
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

  static String sessionTokenKey = "SESSION_TOKEN";

  Future<bool> saveSessionToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(sessionTokenKey, token);
  }

  Future<String?> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(sessionTokenKey);
  }

  Future<void> clearSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(sessionTokenKey);
  }
}
