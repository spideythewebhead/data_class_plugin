abstract class CodeWriter {
  factory CodeWriter.stringBuffer() = _StringBufferCodeWriter;

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
