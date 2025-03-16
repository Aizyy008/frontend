import "package:flutter/material.dart";

class RoundedFloatingActionButton extends StatefulWidget {
  Widget child;
  Function() function;
  double width;
  double height;
  Color buttonColor;
  String? heroTag; // Add this field
  RoundedFloatingActionButton({super.key, required this.child, required this.function, required this.width,  required this.height, required this.buttonColor, this.heroTag } );

  @override
  State<RoundedFloatingActionButton> createState() => _RoundedFloatingActionButtonState();
}

class _RoundedFloatingActionButtonState extends State<RoundedFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FloatingActionButton(
        backgroundColor: widget.buttonColor,
        onPressed: widget.function,
        heroTag: widget.heroTag ?? "",
        child: widget.child,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }
}