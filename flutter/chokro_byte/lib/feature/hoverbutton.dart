import 'package:flutter/material.dart';

class HoveringButtonSection extends StatefulWidget {
  final String label;
  HoveringButtonSection({required this.label});

  @override
  _HoveringButtonSectionState createState() => _HoveringButtonSectionState();
}

class _HoveringButtonSectionState extends State<HoveringButtonSection> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _isHovered ? Colors.white : Color(0xFF00244C),
          foregroundColor: _isHovered ? Colors.black : Colors.white,
          elevation: 0,
        ),
        child: Text(widget.label),
      ),
    );
  }
}
