#import "FlutterWebgpuPlugin.h"
#if __has_include(<flutter_webgpu/flutter_webgpu-Swift.h>)
#import <flutter_webgpu/flutter_webgpu-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_webgpu-Swift.h"
#endif

@implementation FlutterWebgpuPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterWebgpuPlugin registerWithRegistrar:registrar];
}
@end
