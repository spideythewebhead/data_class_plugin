class FileNotFoundException implements Exception {
  const FileNotFoundException([this.message]);

  final String? message;

  @override
  String toString() {
    return message ?? super.toString();
  }
}
