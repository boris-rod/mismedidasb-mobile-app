import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/home/home_page.dart';
import 'package:mismedidasb/ui/login/login_page.dart';
import 'package:mismedidasb/ui/splash/splash_bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends StateWithBloC<SplashPage, SplashBloC> {
  void initState() {
    super.initState();

    bloc.navigateResult.listen((result) {
      NavigationUtils.pushReplacement(
          context, (result ?? true) ? LoginPage() : HomePage());
    });
    bloc.shouldNavigateToLogin();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: R.color.primary_color,
        child: Center(
          child: Image.asset(
            R.image.logo,
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
