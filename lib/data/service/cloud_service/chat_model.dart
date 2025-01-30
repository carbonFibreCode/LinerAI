import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linerai/utils/constants.dart';

@immutable
class ChatMessage {
  final String documentId;
  final String ownerUserId;
  final String aiChats;
  final String userChats;
  final DateTime timestamp;

  const ChatMessage({    required this.documentId,
    required this.ownerUserId,
    required this.aiChats,
    required this.userChats,
    required this.timestamp,
  });

  ChatMessage.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) : 
  documentId = snapshot.id,
  ownerUserId = snapshot.data()[ownerUserIdFieldName],
  aiChats = snapshot.data()[aiChat],
  userChats = snapshot.data()[userChat],  
  timestamp = DateTime.now();  
}
