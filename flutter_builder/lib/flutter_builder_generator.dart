library flutter_builder;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter_builder_annotation/flutter_builder_annotation.dart';
import 'package:path/path.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';


class ParamGenerator extends GeneratorForAnnotation<Param> {
  final BuilderOptions options;

  ParamGenerator({this.options});

  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if(element is! ClassElement){
      throw InvalidGenerationSourceError('@Param can only be applied on classes.');
    }
    final emitter = DartEmitter();
    // method: printElementInfo
    var displayName = element.displayName;
    StringBuffer sb = StringBuffer('[$displayName]');
    sb.write("element.name=${element.name}");
    sb.write("element.library=${element.library}");
    sb.write("element.documentationComment=${element.documentationComment}");
    sb.write("element.declaration=${element.declaration}");
    sb.write("element.enclosingElement=${element.enclosingElement}");
    sb.write("element.hasDeprecated=${element.hasDeprecated}");
    sb.write("element.hasFactory=${element.hasFactory}");
    sb.write("element.isPrivate=${element.isPrivate}");
    sb.write("element.location=${element.location}");
    sb.write("element.metadata=${element.metadata}");
    sb.write("element.id=${element.id}");
    sb.write("element.librarySource=${element.librarySource}");
    var printElementInfo = sb.toString();
    print('printElementInfo = $printElementInfo');
    // method: printAnnotationInfo
    var name = annotation.peek('name').stringValue;
    var id = annotation.peek('id').intValue;
    StringBuffer sb2 = StringBuffer('[$displayName]');
    sb2.write("annotation.name=${name}");
    sb2.write("annotation.id=${id}");
    String printAnnotationInfo = sb2.toString();
    print('printAnnotationInfo = $printAnnotationInfo');
    // begin build class
    ClassBuilder classBuilder;
    var helper = Class((builder){
      classBuilder= builder;
      // 构造方法
      classBuilder.constructors.add(Constructor((constructorBuilder){
        constructorBuilder.name='_';
      }));
      // 类名
      classBuilder.name='${displayName}Info';
      // 实现接口
      // classBuilder.implements.add(refer(displayName));

      // 添加字段
      classBuilder.fields.add(Field((fieldBuilder){
        fieldBuilder.name = '_${element.name}';
        fieldBuilder.type=refer(displayName);
        fieldBuilder.modifier=FieldModifier.final$;
        fieldBuilder.assignment=Code('${element.name}()');
        fieldBuilder.static = false;
      }));

      // 添加方法
      classBuilder.methods.add(Method((methodBuilder){
        methodBuilder.name='printElementInfo';
        methodBuilder.body=Block.of([
          Code("print('$printElementInfo');"),
        ]);
        methodBuilder.static=true;
      }));
      classBuilder.methods.add(Method((methodBuilder){
        methodBuilder.name='printAnnotationInfo';
        methodBuilder.optionalParameters.add(Parameter((pBuilder){
          pBuilder.type= refer('int');
          pBuilder.name='id';
          pBuilder.defaultTo = Code('0');
        }));

        methodBuilder.body=Block.of([
          Code("print('$printAnnotationInfo');"),
        ]);
        methodBuilder.static=true;

        // ClassElement classElement = element as ClassElement;

      }));
    });

    // 生成代码
    String code = DartFormatter().format('${helper.accept(emitter)}');
    // part of '${basename(buildStep.inputId.path)}';
    return """
        
        import '${element.location.components[0]}';
        
        $code
    """;
  }
}

