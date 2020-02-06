import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXPullToRefreshWidget extends StatefulWidget {
  final ValueChanged<bool> onRefresh;
  final Widget child;

  const TXPullToRefreshWidget({this.onRefresh, @required this.child});

  @override
  State<StatefulWidget> createState() => _P2BPullToRefreshState();
}

class _P2BPullToRefreshState extends State<TXPullToRefreshWidget> {
  final double refreshBoxH = 80;
  double verticalOffSet = 0;
  double currentY = 0;
  bool verticalMajor = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onVerticalDragStart: (dragDetails) {
          currentY = dragDetails.globalPosition.dy;
//          print('x offset: ${dragDetails.globalPosition.dx}');
//          print('y offset ${dragDetails.globalPosition.dy}');
        },
        onVerticalDragUpdate: (dragUpdateDetails) {
          setState(() {
            if (!verticalMajor) {
              if (dragUpdateDetails.globalPosition.dy > currentY) {
                if (verticalOffSet >= refreshBoxH) {
                  widget.onRefresh(true);
                  verticalMajor = true;
//                  print('notified');
                } else
                  verticalOffSet =
                      (dragUpdateDetails.globalPosition.dy - currentY) / 2.5;
//                print('drag update ${dragUpdateDetails.globalPosition.dy}');
              }
            }
          });
        },
        onVerticalDragEnd: (dragEndDetails) {
          setState(() {
            verticalMajor = false;
            currentY = 0;
            verticalOffSet = 0;
          });
//          print('tap up details ${dragEndDetails.velocity.pixelsPerSecond.dy}');
        },
        child: Column(
          children: <Widget>[
            Container(
              height: verticalOffSet,
              color: Colors.white,
              child: Center(
                child: TXTextWidget(text: '',),
              ),
            ),
            Expanded(
              child: Container(
                child: widget.child,
              ),
            )
          ],
        ),
      ),
    );
  }
}
