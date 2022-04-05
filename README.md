# flutter_webgpu
cross-platform call WebGPU API by Dart through dart:ffi. 3D programming in the cross-platform.  Provides WebGPU with Texture Widget on Flutter. 

webgpu in flutter, base on [gfx-rs/wgpu](https://github.com/gfx-rs/wgpu)

in progress...


will be used by [three_dart](https://github.com/wasabia/three_dart)


# Contributing

Pull Request please!


### Development

update webgpu-headers submodule
directory: ./ffi/webgpu-headers

```
git submodule update --init
```


generate header binding
will update code flutter_webgpu/lib/WebGPU_Binding.dart
directory: ./

```
// flutter_webgpu
dart run ffigen --config config.yaml
```


generate the wgpu static library
directory: ./native/wgpu-native

```
make lib-native
```



