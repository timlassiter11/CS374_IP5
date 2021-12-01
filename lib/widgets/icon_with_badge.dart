import 'package:flutter/material.dart';

class IconWithBadge extends StatelessWidget {
  const IconWithBadge(
    this.icon, {
    Key? key,
    this.badge,
    this.semanticLabel,
    this.textDirection,
    this.top = 0.0,
    this.right = 0.0,
  }) : super(key: key);

  final Icon icon;
  final Widget? badge;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final double top;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        if (badge != null)
          Positioned(
            child: badge!,
            top: top,
            right: right,
          )
      ],
    );
  }
}
