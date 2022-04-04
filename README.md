# flutter_webgpu

webgpu in flutter, base on [gfx-rs/wgpu](https://github.com/gfx-rs/wgpu)

in progress...




## Run

### update webgpu-headers submodule
ffi/webgpu-headers directory:

```
git submodule update --init
```

### generate header binding

will update code flutter_webgpu/lib/WebGPU_Binding.dart

```
// flutter_webgpu
dart run ffigen --config config.yaml
```


### generate the wgpu static library

flutter_webgpu/native/wgpu-native

```
make lib-native
```



