[![pub package](https://img.shields.io/pub/v/flutter_blue_plus.svg)](https://pub.dartlang.org/packages/flutter_blue_plus)

<br>
<p align="center">
<img alt="FlutterBlue" src="https://github.com/boskokg/flutter_blue_plus/blob/master/site/flutterblue.png?raw=true" />
</p>
<br><br>

## Introduction

FlutterBluePlus is a bluetooth plugin for [Flutter](https://flutter.dev), a new app SDK to help developers build modern multi-platform apps. Note: this plugin is continuous work from FlutterBlue since maintaince stoped.

## Alpha version

**This package must be tested on a real device.**

## Cross-Platform Bluetooth LE
FlutterBluePlus aims to offer the most from both platforms (iOS and Android).

<b>note from ohdonpiano</b>
I'm going to first re-introduce macOS support and then add windows 10+ support.
I'll be testing with real peripheral hardware (some smart locks).

Using the FlutterBluePlus instance, you can scan for and connect to nearby devices ([BluetoothDevice](#bluetoothdevice-api)).
Once connected to a device, the BluetoothDevice object can discover services ([BluetoothService](lib/src/bluetooth_service.dart)), characteristics ([BluetoothCharacteristic](lib/src/bluetooth_characteristic.dart)), and descriptors ([BluetoothDescriptor](lib/src/bluetooth_descriptor.dart)).
The BluetoothDevice object is then used to directly interact with characteristics and descriptors.

### How it works on Windows
Using SimpleBLE shared library, compiled and then used in native plugin code

### How to compile SimpleBLE 
A compiled version of SimpleBLE is already present in the plugin, in case it's needed here are the
steps to build from sources:
1. download sources, cd SimpleBLE/simpleble
2. build:  cmake -B build_simpleble -DBUILD_SHARED_LIBS=TRUE
3. cmake --build build_simpleble -j7 --config=Release
4. install: cmake --install build_simpleble --prefix path/to/windows/plugin/folder

## Usage
### Obtain an instance
```dart
FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
```

### Scan for devices
```dart
// Start scanning
flutterBlue.startScan(timeout: Duration(seconds: 4));

// Listen to scan results
var subscription = flutterBlue.scanResults.listen((results) {
    // do something with scan results
    for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
    }
});

// Stop scanning
flutterBlue.stopScan();
```

### Connect to a device
```dart
// Connect to the device
await device.connect();

// Disconnect from device
device.disconnect();
```

### Discover services
```dart
List<BluetoothService> services = await device.discoverServices();
services.forEach((service) {
    // do something with service
});
```

### Read and write characteristics
```dart
// Reads all characteristics
var characteristics = service.characteristics;
for(BluetoothCharacteristic c in characteristics) {
    List<int> value = await c.read();
    print(value);
}

// Writes to a characteristic
await c.write([0x12, 0x34])
```

### Read and write descriptors
```dart
// Reads all descriptors
var descriptors = characteristic.descriptors;
for(BluetoothDescriptor d in descriptors) {
    List<int> value = await d.read();
    print(value);
}

// Writes to a descriptor
await d.write([0x12, 0x34])
```

### Set notifications and listen to changes
```dart
await characteristic.setNotifyValue(true);
characteristic.value.listen((value) {
    // do something with new value
});
```

### Read the MTU and request larger size
```dart
final mtu = await device.mtu.first;
await device.requestMtu(512);
```
Note that iOS will not allow requests of MTU size, and will always try to negotiate the highest possible MTU (iOS supports up to MTU size 185)

## Getting Started
### Change the minSdkVersion for Android

flutter_blue_plus is compatible only from version 19 of Android SDK so you should change this in **android/app/build.gradle**:
```dart
Android {
  defaultConfig {
     minSdkVersion: 19
```
### Add permissions for Bluetooth
We need to add the permission to use Bluetooth and access location:

#### **Android**
In the **android/app/src/main/AndroidManifest.xml** let’s add:

```xml 
	 <uses-permission android:name="android.permission.BLUETOOTH" />  
	 <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />  
	 <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>  
 <application
```
#### **IOS**
In the **ios/Runner/Info.plist** let’s add:

```dart 
	<dict>  
	    <key>NSBluetoothAlwaysUsageDescription</key>  
	    <string>Need BLE permission</string>  
	    <key>NSBluetoothPeripheralUsageDescription</key>  
	    <string>Need BLE permission</string>  
	    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>  
	    <string>Need Location permission</string>  
	    <key>NSLocationAlwaysUsageDescription</key>  
	    <string>Need Location permission</string>  
	    <key>NSLocationWhenInUseUsageDescription</key>  
	    <string>Need Location permission</string>
```

For location permissions on iOS see more at: [https://developer.apple.com/documentation/corelocation/requesting_authorization_for_location_services](https://developer.apple.com/documentation/corelocation/requesting_authorization_for_location_services)


## Reference
### FlutterBlue API
|             |      Android       |        iOS         |       MacOS        | Windows 11 |                    Description                     |
|:------------|:------------------:|:------------------:|:------------------:|:----------:|:--------------------------------------------------:|
| scan        | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |  Starts a scan for Bluetooth Low Energy devices.   |
| state       | :white_check_mark: | :white_check_mark: | :white_check_mark: |            | Stream of state changes for the Bluetooth Adapter. |
| isAvailable | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |   Checks whether the device supports Bluetooth.    |
| isOn        | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |  Checks if Bluetooth functionality is turned on.   |

### BluetoothDevice API
|                  |      Android       |        iOS         |       MacOS        | Windows 11 |                                            Description                                            |
|:-----------------|:------------------:|:------------------:|:------------------:|:----------:|:-------------------------------------------------------------------------------------------------:|
| connect          | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |                              Establishes a connection to the device.                              |
| disconnect       | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |                      Cancels an active or pending connection to the device.                       |
| discoverServices | :white_check_mark: | :white_check_mark: | :white_check_mark: |            | Discovers services offered by the remote device as well as their characteristics and descriptors. |
| services         | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |             Gets a list of services. Requires that discoverServices() has completed.              |
| state            | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |                         Stream of state changes for the Bluetooth Device.                         |
| mtu              | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |                                    Stream of mtu size changes.                                    |
| requestMtu       | :white_check_mark: |                    |                    |            |                             Request to change the MTU for the device.                             |
| readRssi         | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |                                Read RSSI from a connected device.                                 |

### BluetoothCharacteristic API
|                |      Android       |        iOS         |       MacOS        | Windows 11 |                       Description                        |
|:---------------|:------------------:|:------------------:|:------------------:|:----------:|:--------------------------------------------------------:|
| read           | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |        Retrieves the value of the characteristic.        |
| write          | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |         Writes the value of the characteristic.          |
| setNotifyValue | :white_check_mark: | :white_check_mark: | :white_check_mark: |            | Sets notifications or indications on the characteristic. |
| value          | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |      Stream of characteristic's value when changed.      |

### BluetoothDescriptor API
|       |      Android       |        iOS         |       MacOS        | Windows 11 |              Description               |
|:------|:------------------:|:------------------:|:------------------:|:----------:|:--------------------------------------:|
| read  | :white_check_mark: | :white_check_mark: | :white_check_mark: |            | Retrieves the value of the descriptor. |
| write | :white_check_mark: | :white_check_mark: | :white_check_mark: |            |  Writes the value of the descriptor.   |

## Troubleshooting
### When I scan using a service UUID filter, it doesn't find any devices.
Make sure the device is advertising which service UUID's it supports.  This is found in the advertisement
packet as **UUID 16 bit complete list** or **UUID 128 bit complete list**.
