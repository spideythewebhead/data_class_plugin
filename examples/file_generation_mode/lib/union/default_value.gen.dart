// AUTO GENERATED - DO NOT MODIFY

// ignore_for_file: library_private_types_in_public_api, unused_element, unused_field

part of 'default_value.dart';

extension $VideoInfo on VideoInfo {
  R when<R>({
    required R Function(_VideoInfoNetwork value) network,
    required R Function(_VideoInfoFile value) file,
  }) {
    if (this is _VideoInfoNetwork) {
      return network(this as _VideoInfoNetwork);
    }
    if (this is _VideoInfoFile) {
      return file(this as _VideoInfoFile);
    }
    throw UnimplementedError('$runtimeType is not generated by this plugin');
  }

  R maybeWhen<R>({
    R Function(_VideoInfoNetwork value)? network,
    R Function(_VideoInfoFile value)? file,
    required R Function() orElse,
  }) {
    if (network != null && this is _VideoInfoNetwork) {
      return network(this as _VideoInfoNetwork);
    }
    if (file != null && this is _VideoInfoFile) {
      return file(this as _VideoInfoFile);
    }
    return orElse();
  }
}

class _VideoInfoNetwork extends VideoInfo {
  _VideoInfoNetwork(
    this.url, {
    this.autoPlay = false,
  }) : super._();

  final String url;

  final bool autoPlay;

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      url,
      autoPlay,
    ]);
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is _VideoInfoNetwork &&
            runtimeType == other.runtimeType &&
            url == other.url &&
            autoPlay == other.autoPlay;
  }

  @override
  String toString() {
    String toStringOutput = '_VideoInfoNetwork{<optimized out>}';
    assert(() {
      toStringOutput = '_VideoInfoNetwork@<$hexIdentity>{url: $url, autoPlay: $autoPlay}';
      return true;
    }());
    return toStringOutput;
  }
}

class _VideoInfoFile extends VideoInfo {
  _VideoInfoFile(
    this.path, {
    this.autoPlay = true,
  }) : super._();

  final String path;

  final bool autoPlay;

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      path,
      autoPlay,
    ]);
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is _VideoInfoFile &&
            runtimeType == other.runtimeType &&
            path == other.path &&
            autoPlay == other.autoPlay;
  }

  @override
  String toString() {
    String toStringOutput = '_VideoInfoFile{<optimized out>}';
    assert(() {
      toStringOutput = '_VideoInfoFile@<$hexIdentity>{path: $path, autoPlay: $autoPlay}';
      return true;
    }());
    return toStringOutput;
  }
}