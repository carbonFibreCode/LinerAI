import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:linerai/utils/constants.dart';

class ResponseBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ResponseBubble({
    required this.text,
    this.isUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (!isUser)
              BoxShadow(
                color: const Color.fromARGB(55, 185, 142, 255),
                blurRadius: 10,
              ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? AppColors.primary : Colors.grey.shade800,
            fontSize: 16,
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
    );
  }
}
