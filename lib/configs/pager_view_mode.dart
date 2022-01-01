import 'package:event/event.dart';
import 'package:jasmine/basic/methods.dart';

const _propertyKey = "pager_view_mode";
late PagerViewMode _value;
Event _currentPagerViewModeEvent = Event();

PagerViewMode get currentPagerViewMode => _value;

Event get currentPagerViewModeEvent => _currentPagerViewModeEvent;

enum PagerViewMode {
  cover,
  info,
}

PagerViewMode _parse(String string) {
  for (var value in PagerViewMode.values) {
    if ("$value" == string) {
      return value;
    }
  }
  return PagerViewMode.cover;
}

Future initPagerViewMode() async {
  _value = _parse(await methods.loadProperty(_propertyKey));
}
