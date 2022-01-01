import 'package:event/event.dart';
import 'package:jasmine/basic/methods.dart';

const _propertyKey = "pager_controller_mode";
late PagerControllerMode _value;
Event _currentPagerControllerModeEvent = Event();

PagerControllerMode get currentPagerControllerMode => _value;

Event get currentPagerControllerModeEvent => _currentPagerControllerModeEvent;

enum PagerControllerMode {
  stream,
  pager,
}

PagerControllerMode _parse(String string) {
  for (var value in PagerControllerMode.values) {
    if ("$value" == string) {
      return value;
    }
  }
  return PagerControllerMode.pager;
}

Future initPagerControllerMode() async {
  _value = _parse(await methods.loadProperty(_propertyKey));
}
