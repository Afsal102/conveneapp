import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const BigButton({Key? key, required this.child, required this.onPressed, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all(Palette.niceBlack.withOpacity(0.4)),
        minimumSize: MaterialStateProperty.all(const Size(300, 60)),
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? Palette.niceBlack),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevation: MaterialStateProperty.all(10),
      ),
      child: child,
    );
  }
}

class MediumButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const MediumButton({Key? key, required this.child, required this.onPressed, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all(Palette.niceBlack.withOpacity(0.4)),
        minimumSize: MaterialStateProperty.all(const Size(250, 45)),
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? Palette.niceBlack),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevation: MaterialStateProperty.all(10),
      ),
      child: child,
    );
  }
}
