# flutter_builder_demo

演示flutter注解生成代码的使用方法.

## 开始

- 注解处理器：
source_gen负责编译时解析注解；

- 代码生成器：
code_builder负责生成代码；

- 操作步骤：
1. 编写注解类；
2. 编写GeneratorForAnnotation<Annotation>；-->code_builder负责生成代码；
除了`code_builder`，还可以通过`字符串拼接`、`mustach`预置模板来生成代码，代码即字符串；
3. 创建`build.yaml`，注册builder；
```yaml
# website: https://pub.dartlang.org/packages/build_config
targets:
  $default:
    builders:
      code_gen_explore|flutter_builder:
        enabled: true   # 当前builder是否生效
        options: { 'write': true }     # 这里指定的参数可以在GeneratorForAnnotation<Annotation>
        generate_for:    # 决定针对那些文件/文件夹做扫描，或者排除哪些文件
        - lib/test/*
#        exclude: ['**.g.dart']   # 排除特定类型扫描
#        include: ['*.dart']      # 指定特定类型扫描
      source_gen|combining_builder:
        enabled: true

builders:
  flutter_builder:
    target: ":flutter_builder" #目标库
    import: 'package:flutter_builder/flutter_builder.dart'  #builder文件
    builder_factories: ['nativeCallBuilder']
    build_extensions: {'.dart': ['.test.g.dart']}
    auto_apply: dependents #将此Builder应用于包，直接依赖于公开构建起的包，也可以是[all_packages|root_package|dependents]
    build_to: source #输出到注解的目标类的代码同目录中，或者输出转到隐藏的构建缓存，不会发布(cache)[source|cache]
    applies_builders: ["source_gen|combining_builder"] #指定是否可以延迟运行构建器
```
3. 使用注解；
4. 命令行运行生成代码：
```bash
# flutter project
flutter packages pub run build_runner build [--delete-conflicting-outputs]
# dart propject
pub run build_runner build [--delete-conflicting-outputs]

# FYI: clean command
flutter packages pub run build_runner clean
```

## 参考资料
- [详解Dart中如何通过注解生成代码](https://zhuanlan.zhihu.com/p/166636402)
- [flutter 使用source_gen和code_builder编译时生成代码](https://www.jianshu.com/p/19df99a86aef)