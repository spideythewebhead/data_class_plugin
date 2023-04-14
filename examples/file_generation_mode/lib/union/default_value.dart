import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'default_value.gen.dart';

@Union()
sealed class VideoInfo {
  const VideoInfo._();

  factory VideoInfo.network(
    String url, {
    // if no value is p rovided for autoPlay then default is false
    @DefaultValue(false) bool autoPlay,
  }) = _VideoInfoNetwork;

  factory VideoInfo.file(
    String path, {
    // if you want to provide type safety to the passed argument
    // you can specify the type on the annotation
    @DefaultValue<bool>(true) bool autoPlay,
  }) = _VideoInfoFile;
}

void main(List<String> args) {
  final VideoInfo networkVideoInfo = VideoInfo.network('https://asdf.com/vid.mp4');
  final VideoInfo fileVideoInfo = VideoInfo.file('file:///vid.mp4');

  prettyPrint('network video info', networkVideoInfo);
  prettyPrint('file video info', fileVideoInfo);
}
