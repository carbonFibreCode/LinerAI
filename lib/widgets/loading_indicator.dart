import 'package:flutter/material.dart';

class LoadingIndicator {
  // Singleton pattern
  static final LoadingIndicator _instance = LoadingIndicator._internal();
  factory LoadingIndicator() => _instance;
  LoadingIndicator._internal();

  // We store the current overlay entry to remove it later
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  /// Call this to show the loading overlay anywhere
  void show(
    BuildContext context, {
    String? loadingText,
    Color overlayColor = const Color.fromRGBO(0, 0, 0, 0.5),
  }) {
    // If it's already displayed, do nothing
    if (_isVisible) return;

    // Create a new OverlayEntry with our loading indicator
    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Dark semi-transparent overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: overlayColor,
          ),
          // Centered loading container
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loadingText ?? 'Loading...',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Insert the overlay entry into the widget tree
    final overlay = Overlay.of(context);
    overlay.insert(_overlayEntry!);
    _isVisible = true;
  }

  /// Call this to hide the loading overlay
  void hide() {
    if (!_isVisible) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }
}