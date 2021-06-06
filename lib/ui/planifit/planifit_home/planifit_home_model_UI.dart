import 'package:mismedidasb/enums.dart';

class PlanifitHomeModelUI{
  int selectedTab;
  WatchConnectedStatus connectedStatus;
  bool bleSupported;
  bool bleEnabled;

  PlanifitHomeModelUI({this.selectedTab, this.connectedStatus, this.bleSupported, this.bleEnabled});
}