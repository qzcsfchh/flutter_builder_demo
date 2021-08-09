library flutter_builder_demo;

import 'package:flutter_builder_annotation/flutter_builder_annotation.dart';




/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}


@Param(name: "test",id: 1)
class TestModule{

}

