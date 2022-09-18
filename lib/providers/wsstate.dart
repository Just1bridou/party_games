import 'package:flutter/foundation.dart';

class WSState with ChangeNotifier {
  String status = "loading";

  void setStatus(String sstatus) {
    status = sstatus;
    notifyListeners();
  }

  String getStatus() {
    return status;
  }
}
