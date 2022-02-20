import Cocoa
import FlutterMacOS

public class FlutterWebgpuPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_webgpu", binaryMessenger: registrar.messenger)
    let instance = FlutterWebgpuPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // https://medium.com/flutter-community/using-ffi-on-flutter-plugins-to-run-native-rust-code-d64c0f14f9c2
  //  Note: XCode will not bundle the library unless it detects explicit usage within the workspace. Since our Dart code calling it is out of the scope of XCode, we need to write a dummy Swift function that makes some fake usage.
  public func dummyMethodToEnforceBundling() {
    // This will never be executed
    wgpuGetVersion();
  }


}
