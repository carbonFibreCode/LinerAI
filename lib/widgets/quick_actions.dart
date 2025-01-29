import 'package:flutter/material.dart';
import 'package:linerai/utils/constants.dart';

class QuickActions extends StatefulWidget {
  final Function(String) onTap;

  const QuickActions({Key? key, required this.onTap}) : super(key: key);

  @override
  _QuickActionsState createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int? _pressedIndex; // Track which button is pressed

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(int index, String text) {
    setState(() {
      _pressedIndex = index; // Set the pressed button index
    });
    _controller.forward().then((_) {
      _controller.reverse();
      setState(() {
        _pressedIndex = null; // Reset the pressed button index
      });
      widget.onTap(text); // Trigger the onTap callback
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      "Tell me a joke 😂",
      "Motivate me 💪",
      "Cheer me up 🌈",
      "Advice for today 🌱",
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 0,
      children: buttons.asMap().entries.map((entry) {
        final index = entry.key;
        final text = entry.value;
        return ScaleTransition(
          scale: _pressedIndex == index ? _scaleAnimation : AlwaysStoppedAnimation(1.0),
          child: ActionChip(
            label: Text(text),
            backgroundColor: Color.fromRGBO(
              AppColors.primary.red,
              AppColors.primary.green,
              AppColors.primary.blue,
              0.4, // 40% opacity
            ),
            onPressed: () => _onTap(index, text),
          ),
        );
      }).toList(),
    );
  }
}