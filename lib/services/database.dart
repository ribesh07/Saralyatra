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

  Future<void> addDriverDetails(
      Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("saralyatra")
        .doc("driverDetailsDatabase")
        .collection("drivers")
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
    print('Adding message to chat room: $chatRoomId');
    print('Message ID: $messageId');
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
    try {
      // Check if chatroom exists first
      final chatRoomRef = FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId);
      
      final chatRoomDoc = await chatRoomRef.get();
      
      if (chatRoomDoc.exists) {
        // Update existing chatroom
        return await chatRoomRef.update(lastMessageInfoMap);
      } else {
        // Create chatroom with last message info if it doesn't exist
        Map<String, dynamic> chatRoomData = {
          "users": ["Agent", chatRoomId.split('_')[1]], // Extract username from chatRoomId
          ...lastMessageInfoMap,
        };
        return await chatRoomRef.set(chatRoomData);
      }
    } catch (e) {
      print('Error updating last message: $e');
      throw e;
    }
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
    print('Creating/checking chat room with ID: $chatRoomId');
    print('Chat room info: $chatRoomInfoMap');
    
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      print('Chat room $chatRoomId already exists');
      return true;
    } else {
      print('Creating new chat room $chatRoomId');
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
