import 'package:flutter/foundation.dart';

class RouterStateNotifier extends ChangeNotifier {
  String _currentPath = '/';

  String get currentPath => _currentPath;

  void updatePath(String path) {
    if (_currentPath != path) {
      _currentPath = path;
      notifyListeners(); // 🔔 avisa a los widgets que escuchan
    }
  }
}
