import 'package:jasmine/configs/android_display_mode.dart';
import 'package:jasmine/configs/android_version.dart';
import 'package:jasmine/configs/pager_column_number.dart';
import 'package:jasmine/configs/pager_cover_rate.dart';

import 'auto_clean.dart';
import 'network_api_host.dart';
import 'network_cdn_host.dart';
import 'reader_controller_type.dart';
import 'reader_direction.dart';
import 'reader_slider_position.dart';
import 'reader_type.dart';
import 'versions.dart';
import 'login.dart';
import 'pager_controller_mode.dart';
import 'pager_view_mode.dart';

Future initConfigs() async {
  await initAndroidVersion();
  await initAndroidDisplayMode();
  await initVersion();
  autoCheckNewVersion();
  await initApiHost();
  await initCdnHost();
  await initPagerControllerMode();
  await initPagerViewMode();
  await initReaderType();
  await initReaderDirection();
  await initReaderControllerType();
  await initReaderSliderPosition();
  await initPagerColumnCount();
  await initPagerCoverRate();
  await initAutoClean();
  initLogin();
}
