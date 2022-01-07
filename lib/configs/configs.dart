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
  initLogin();
}
