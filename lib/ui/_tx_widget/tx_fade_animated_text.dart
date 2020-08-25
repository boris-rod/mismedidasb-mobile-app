import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXFadeAnimatedText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TXFadeAnimatedTextState();
}

class _TXFadeAnimatedTextState extends State<TXFadeAnimatedText>
    with TickerProviderStateMixin {
  AnimationController animation;
  Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.1, end: 1.0).animate(animation);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation.forward();
      }
    });
    animation.forward();
  }

  @override
  void dispose() {
    animation.stop();
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeInFadeOut,
      child: TXTextWidget(
        text: "pide cita con un especialista",
        color: Colors.white,
        size: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
