import 'package:jasmine/configs/reader_direction.dart';
import 'package:jasmine/configs/reader_type.dart';

import 'pager_controller_mode.dart';
import 'pager_view_mode.dart';

Future initConfigs() async {
  await initPagerControllerMode();
  await initPagerViewMode();
  await initReaderType();
  await initReaderDirection();
}
