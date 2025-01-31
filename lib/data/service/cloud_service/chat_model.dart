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
  final bool isUser;

  const ChatMessage({    required this.documentId,
    required this.ownerUserId,
    required this.aiChats,
    required this.userChats,
    required this.timestamp,
    required this.isUser,
  });

  ChatMessage.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) : 
  documentId = snapshot.id,
  ownerUserId = snapshot.data()[ownerUserIdFieldName],
  aiChats = snapshot.data()[aiChatFieldName],
  userChats = snapshot.data()[userChatFieldName],  
  timestamp = snapshot.data()[timeStampFieldName] != null 
      ? (snapshot.data()[timeStampFieldName] as Timestamp).toDate() 
      : DateTime.now(), 
  isUser = snapshot.data()[isUserFieldName];
}
