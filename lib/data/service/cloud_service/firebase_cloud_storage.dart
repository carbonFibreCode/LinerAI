import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linerai/data/service/cloud_service/chat_model.dart';
import 'package:linerai/utils/constants.dart';

class FirebaseCloudStorage {
  final chats = FirebaseFirestore.instance.collection('chats');

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Stream<Iterable<ChatMessage>> allChats({required String ownerUserId}) {
    final allChats = chats
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .orderBy('timestamp', descending : true)
        .snapshots()
        .map((event) => event.docs.map((doc) => ChatMessage.fromSnapshot(doc)));
    return allChats;
  }

  Future<ChatMessage> createMessage({required String ownerUserId}) async {
    final newMessage = await chats.add({
      ownerUserIdFieldName: ownerUserId,
      aiChat: '',
      userChat: '',
    });

    final fetchedChat = await newMessage.get();
    return ChatMessage(
      documentId: fetchedChat.id,
      ownerUserId: ownerUserId,
      aiChats: '',
      userChats: '',
      timestamp: DateTime.now(),
    );
  }
}
