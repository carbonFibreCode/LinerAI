import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linerai/data/service/cloud_service/chat_model.dart';
import 'package:linerai/utils/constants.dart';

class FirebaseCloudStorage {
  final chats = FirebaseFirestore.instance.collection('chats');

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared = FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Stream<Iterable<ChatMessage>> allChats({required String ownerUserId}) {
    return chats
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .orderBy(timeStampFieldName, descending: true)
        .limit(25)
        .snapshots()
        .map((event) => event.docs.map((doc) => ChatMessage.fromSnapshot(doc)));
  }

  Future<ChatMessage> createMessage(
      {required String ownerUserId, String? aichat, String? userChat}) async {
    final newMessage = await chats.add({
      ownerUserIdFieldName: ownerUserId,
      aiChatFieldName: aichat ?? '',
      userChatFieldName: userChat ?? '',
      timeStampFieldName: FieldValue.serverTimestamp(),
    });

    final fetchedChat = await newMessage.get();
    final data = fetchedChat.data() as Map<String, dynamic>;

    return ChatMessage(
      documentId: fetchedChat.id,
      ownerUserId: ownerUserId,
      aiChats: data[aiChatFieldName] ?? '',
      userChats: data[userChatFieldName] ?? '',
      timestamp: (data[timeStampFieldName] as Timestamp).toDate(),
    );
  }
}
