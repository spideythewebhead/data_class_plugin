import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';

abstract class CodeWriter {
  factory CodeWriter.stringBuffer() = _StringBufferCodeWriter;
  factory CodeWriter.dartEditBuilder(DartEditBuilder builder) = _DartEditBuilderCodeWriter;

  String get content;

  void write(String string);
  void writeln([String string]);
}

class _StringBufferCodeWriter implements CodeWriter {
  final StringBuffer _buffer = StringBuffer();

  @override
  void write(String string) => _buffer.write(string);

  @override
  void writeln([String string = '']) => _buffer.writeln(string);

  @override
  String get content => _buffer.toString();
}

class _DartEditBuilderCodeWriter implements CodeWriter {
  _DartEditBuilderCodeWriter(this._builder);

  final DartEditBuilder _builder;

  @override
  void write(String string) => _builder.write(string);

  @override
  void writeln([String string = '']) => _builder.writeln(string);

  @override
  String get content => _builder.toString();
}
