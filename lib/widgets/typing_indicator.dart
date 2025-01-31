import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TypingIndicator extends StatelessWidget {
  final String message;

  TypingIndicator({this.message = "Doing the Deed"});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(55, 0, 0, 0),
                blurRadius: 10,
              ),
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: 8,
            ),
            BouncingDots(), // Custom animated dots
          ],
        ),
      ),
    );
  }
}

class BouncingDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [1, 2, 3].map((i) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade600,
            shape: BoxShape.circle,
          ),
        )
            .animate(
              delay: (i * 200).ms, // Correct: Converts to Duration
              onPlay: (controller) => controller.repeat(), // Loop animation
            )
            .scale(
              duration: 600.ms, // Correct: Converts to Duration
              begin: Offset(0.5, 0.5),
              end: Offset(1, 1),
            );
      }).toList(),
    );
  }
}
