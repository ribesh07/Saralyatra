import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saralyatra/services/shared_pref.dart';

// Create
class DatabaseMethod {
  // Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
  //   return await FirebaseFirestore.instance
  //       .collection("saralyatra")
  //       .doc(id)
  //       .set(userInfoMap);
  // }

  Future<void> addUserDetails(
      Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("saralyatra")
        .doc("userDetailsDatabase")
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

// Read
  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return FirebaseFirestore.instance.collection("Employee").snapshots();
  }

// Update
  Future updateUserDetail(
      String id, Map<String, dynamic> updateUserInfo) async {
    return await FirebaseFirestore.instance
        .collection("saralyatra")
        .doc("userDetailsDatabase")
        .collection("users")
        .doc(id)
        .update(updateUserInfo);
  }

// Delete
  Future deleteUserDetail(String id) async {
    return await FirebaseFirestore.instance
        .collection("saralyatra")
        .doc("userDetailsDatabase")
        .collection("users")
        .doc(id)
        .delete();
  }

  Future<DocumentSnapshot> getUserById(String id) async {
    return await FirebaseFirestore.instance
        .collection("saralyatra")
        .doc("userDetailsDatabase")
        .collection("users")
        .doc(id)
        .get();
  }

  Future addUser(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addMessage(
    String chatRoomId,
    String messageId,
    Map<String, dynamic> messageInfoMap,
  ) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }
  // Future addMessage(
  //   String chatRoomId,
  //   String messageId,
  //   Map<String, dynamic> messageInfoMap,
  // ) async {
  //   return await FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .doc(chatRoomId)
  //       .collection("chats")
  //       .doc(messageId)
  //       .set(messageInfoMap);
  // }

  updateLastMessageSend(
    String chatRoomId,
    Map<String, dynamic> lastMessageInfoMap,
  ) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  // Future<QuerySnapshot> search(String username) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("SearchKey", isEqualTo: username.substring(0, 1).toUpperCase())
  //       .get();
  // }

  createChatRoom(
    String chatRoomId,
    Map<String, dynamic> chatRoomInfoMap,
  ) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  // Future<Stream<QuerySnapshot>> getChatRooms() async {
  //   String? myUsername = await SharedpreferenceHelper().getUserName();
  //   return await FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .where("users", arrayContains: myUsername!)
  //       .orderBy("lastMessageSendTs", descending: true)
  //       .snapshots();
  // }

  // Future<Stream<QuerySnapshot>> getChatRooms() async {
  //   String? myUsername = await SharedpreferenceHelper().getUserName();

  //   final snapshots = FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .where("users", arrayContains: myUsername!)
  //       .orderBy("lastMessageSendTs", descending: true)
  //       .snapshots();
  //   return snapshots;
  // }
}
