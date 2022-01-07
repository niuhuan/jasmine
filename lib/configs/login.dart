import 'package:event/event.dart';
import 'package:jasmine/basic/methods.dart';

enum LoginStatus {
  notSet,
  logging,
  loginField,
  loginSuccess,
}

late SelfInfo _selfInfo;
LoginStatus _status = LoginStatus.notSet;
final Event _event = Event();

SelfInfo get selfInfo => _selfInfo;

Event get loginEvent => _event;

LoginStatus get loginStatus => _status;

set _loginState(LoginStatus value) {
  _status = value;
  _event.broadcast();
}

Future initLogin() async {
  try {
    _loginState = LoginStatus.logging;
    final preLogin = await methods.preLogin();
    if (!preLogin.preSet) {
      _loginState = LoginStatus.notSet;
    } else if (preLogin.preLogin) {
      _selfInfo = preLogin.selfInfo!;
      _loginState = LoginStatus.loginSuccess;
    } else {
      _loginState = LoginStatus.loginField;
    }
  } catch (e, st) {
    print("$e\n$st");
    _loginState = LoginStatus.loginField;
  }
}
