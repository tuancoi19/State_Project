import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data with ChangeNotifier {
  int toTal = 0;
  int vipToTal = 0;
  double toTalInCome = 0;

  Data({toTal, vipToTal, toTalIncome});

  void loadData() async {
    final daTa = await SharedPreferences.getInstance();
    toTal = daTa.getInt('total') ?? 0;
    vipToTal = daTa.getInt('viptotal') ?? 0;
    toTalInCome = daTa.getDouble('totalincome') ?? 0;
    notifyListeners();
  }
}

class Bill with ChangeNotifier {
  double aMount = 0;
  String checkNull = '';
  bool isCheck = false;
  double bill = 0;
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  Bill({aMount, checkNull, isCheck, bill, name, number, nodeOne, nodeTwo});

  set check(bool value) {
    isCheck = value;
    notifyListeners();
  }

  void calCuLaTing() {
    if (isCheck == true) {
      bill = 20000 * aMount * 90 / 100;
    } else {
      bill = 20000 * aMount;
    }
    notifyListeners();
  }

  void conTiNue() async {
    if (bill != 0) {
      final daTa = await SharedPreferences.getInstance();
      int toTal = (daTa.getInt('total') ?? 0) + 1;
      daTa.setInt('total', toTal);
      if (isCheck == true) {
        int vipToTal = (daTa.getInt('viptotal') ?? 0) + 1;
        daTa.setInt('viptotal', vipToTal);
      }
      double toTalInCome = (daTa.getDouble('totalincome') ?? 0) + bill;
      daTa.setDouble('totalincome', toTalInCome);
      name.clear();
      number.clear();
      isCheck = false;
      bill = 0;
      checkNull = '';
      notifyListeners();
    }
  }
}
