import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus_platform_interface.dart';
import 'package:flutter_blue_plus/flutter_blue_plus_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final FlutterBluePlusPlatform initialPlatform = FlutterBluePlusPlatform.instance;

  test('$MethodChannelFlutterBluePlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBluePlus>());
  });

  test('state', () async {
    FlutterBluePlus plugin = FlutterBluePlus.instance;
    BluetoothState state = await plugin.state.last;
    expect(state, BluetoothState.off);
  });
}
