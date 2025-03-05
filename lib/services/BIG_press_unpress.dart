import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BIG_PressUnpress extends StatefulWidget {
  final String? imageAssetUnPress;
  final String? imageAssetPress;
  final VoidCallback onTap;
  final Color? pressColor;
  final Color? unPressColor;
  final double height;
  final double width;
  final Widget? child;

  BIG_PressUnpress({
    this.imageAssetUnPress,
    this.imageAssetPress,
    required this.onTap,
    required this.height,
    required this.width,
    this.child,
    this.pressColor,
    this.unPressColor
  });

  @override
  _BIG_PressUnpressState createState() => _BIG_PressUnpressState();
}

class _BIG_PressUnpressState extends State<BIG_PressUnpress> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if(widget.imageAssetPress?.isNotEmpty ?? false)precacheImage(AssetImage(widget.imageAssetPress ?? ''), context);
    return GestureDetector(
      onTapDown: (_) => _handleTap(true),
      onTapUp: (_) => _handleTap(false),
      onTapCancel: _resetTap,
      onTap: (){
        widget.onTap();
      },
      child: buildContainer(),
    );
  }

  void _handleTap(bool isPressed) {
    setState(() {
      _isPressed = isPressed;
    });
  }

  void _resetTap() {
    _handleTap(false);
  }

  Widget buildContainer() {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: widget.imageAssetUnPress == null ? BorderRadius.circular(40) : null,
        color: _isPressed ? widget.pressColor : widget.unPressColor,
        image: widget.imageAssetUnPress != null && widget.imageAssetUnPress!.isNotEmpty && widget.imageAssetPress != null && widget.imageAssetPress!.isNotEmpty
            ? DecorationImage(
          image: AssetImage(_isPressed ? widget.imageAssetPress! : widget.imageAssetUnPress!),
          fit: BoxFit.contain,
        )
            : null,
      ),
      child: widget.child ?? const SizedBox.shrink(),
    );
  }
}
