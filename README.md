# flutter_webgpu

webgpu in flutter, base on [gfx-rs/wgpu](https://github.com/gfx-rs/wgpu)

in progress...




### Develop

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



