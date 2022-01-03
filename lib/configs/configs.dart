import 'package:jasmine/configs/reader_controller_type.dart';
import 'package:jasmine/configs/reader_direction.dart';
import 'package:jasmine/configs/reader_slider_position.dart';
import 'package:jasmine/configs/reader_type.dart';
import 'package:jasmine/configs/versions.dart';

import 'pager_controller_mode.dart';
import 'pager_view_mode.dart';

Future initConfigs() async {
  await initVersion();
  await initPagerControllerMode();
  await initPagerViewMode();
  await initReaderType();
  await initReaderDirection();
  await initReaderControllerType();
  await initReaderSliderPosition();
}
