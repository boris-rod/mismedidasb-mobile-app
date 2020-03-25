import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/habit/habit_model.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/habit/habit_bloc.dart';

class HabitPage extends StatefulWidget {
  final HealthConceptModel conceptModel;

  const HabitPage({Key key, this.conceptModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HabitState();
}

class _HabitState extends StateWithBloC<HabitPage, HabitBloC> {
  @override
  void initState() {
    super.initState();
    bloc.loadData(widget.conceptModel.id);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          title: widget.conceptModel.title ?? "Hábitos Saludables",
          body: TXBackgroundWidget(
            iconRes: R.image.habits_home,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20),
                    child: TXTextWidget(
                      text: R.string.healthHabits,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<HabitModel>>(
                      stream: bloc.habitsResult,
                      initialData: [],
                      builder: (context, snapshot) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 30),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            final habit = snapshot.data[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TXTextWidget(
                                  textAlign: TextAlign.justify,
                                  text: habit.title,
                                  color: R.color.primary_color,
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, subIndex) {
                                    final subTitle = habit.subtitle[subIndex];
                                    return Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: TXTextWidget(
                                        text: "- $subTitle",
                                        textAlign: TextAlign.justify,
                                        color: R.color.accent_color,
                                      ),
                                    );
                                  },
                                  itemCount: habit.subtitle.length,
                                ),
                                SizedBox(height: 10,)
                              ],
                            );
                          },
                          itemCount: snapshot.data.length,
                        );
                      },
                    ),
                  ),
                  TXTextWidget(
                    textAlign: TextAlign.center,
                    text: R.string.appClinicalWarningForAdvice,
                    size: 10,
                    color: R.color.accent_color,
                  ),
                ],
              ),
            ),
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }
}
