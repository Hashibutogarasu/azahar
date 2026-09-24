import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_session_metadata.freezed.dart';

@freezed
abstract class MediaSessionMetadata with _$MediaSessionMetadata {
  const factory MediaSessionMetadata({required String title, String? artworkPath}) =
      _MediaSessionMetadata;
}
