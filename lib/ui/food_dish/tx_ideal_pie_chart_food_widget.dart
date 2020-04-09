import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXIdealPieChartFoodWidget extends StatelessWidget{
  final DailyActivityFoodModel model;

  const TXIdealPieChartFoodWidget({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SubscriberSeries, String>> series = [];
    List<charts.Series<SubscriberSeries, String>> series1 = [];

    final List<SubscriberSeries> data = [
      SubscriberSeries(
        nutritionKey: "1",
        partialValue: 2,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[100]),
      ),
      SubscriberSeries(
        nutritionKey: "2",
        partialValue: 4,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[200]),
      ),
      SubscriberSeries(
        nutritionKey: "3",
        partialValue: 4,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[700]),
      ),
    ];
    final List<SubscriberSeries> data1 = [
      SubscriberSeries(
        nutritionKey: "1",
        partialValue: 3,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[100]),
      ),
      SubscriberSeries(
        nutritionKey: "2",
        partialValue: 2,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[200]),
      ),
      SubscriberSeries(
        nutritionKey: "3",
        partialValue: 5,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[700]),
      ),
    ];

    series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          displayName: "Pie",
          domainFn: (SubscriberSeries series, _) => series.nutritionKey,
          measureFn: (SubscriberSeries series, _) => series.partialValue,
          colorFn: (SubscriberSeries series, _) => series.barColor)
    ];

    series1 = [
      charts.Series(
          id: "Subscribers",
          data: data1,
          displayName: "Pie",
          domainFn: (SubscriberSeries series, _) => series.nutritionKey,
          measureFn: (SubscriberSeries series, _) => series.partialValue,
          colorFn: (SubscriberSeries series, _) => series.barColor)
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TXTextWidget(
          text: "Ideal",
          size: 10,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        Container(
          height: 55,
          width: 55,
          child: Stack(
            children: <Widget>[
              charts.PieChart(
                model.id == 5 ? series1 : series,
                layoutConfig: LayoutConfig(
                    topMarginSpec:
                    MarginSpec.fixedPixel(0),
                    leftMarginSpec:
                    MarginSpec.fixedPixel(0),
                    rightMarginSpec:
                    MarginSpec.fixedPixel(0),
                    bottomMarginSpec:
                    MarginSpec.fixedPixel(0)),
                animate: true,
              ),
              Positioned(
                top: model.id == 5 ? 23 : 20,
                left: 6,
                child: TXTextWidget(
                  text: model.id == 5 ? "50%" : "40%",
                  color: Colors.white,
                  size: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned(
                top: model.id == 5 ? 15 : 10,
                right: model.id == 5 ? 7 : 8,
                child: TXTextWidget(
                  text: model.id == 5 ? "30%" : "20%",
                  color: Colors.white,
                  size: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned(
                right: model.id == 5 ? 8 : 9,
                bottom: model.id == 5 ? 7 : 12,
                child: TXTextWidget(
                  text: model.id == 5 ? "20%" : "40%",
                  color: Colors.white,
                  size: 9,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

}

class SubscriberSeries {
  final String nutritionKey;
  final int partialValue;
  final charts.Color barColor;

  SubscriberSeries(
      {@required this.nutritionKey,
        @required this.partialValue,
        @required this.barColor});
}