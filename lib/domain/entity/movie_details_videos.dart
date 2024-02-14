import 'package:json_annotation/json_annotation.dart';


part 'movie_details_videos.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieDetailsVideos {
  @JsonKey(name: 'results')
  final List<MovieDetailsVideosResult> results;
  MovieDetailsVideos({required this.results});

  factory MovieDetailsVideos.fromJson(Map<String, dynamic> json) => _$MovieDetailsVideosFromJson(json);

    Map<String, dynamic> toJson() => _$MovieDetailsVideosToJson(this); 
}
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieDetailsVideosResult{
  final String id;
  @JsonKey(name: 'iso_639_1')
  final String iso639;
  @JsonKey(name: 'iso_3166_1')
  final String iso3166;
  final String key;
  final String name;
  final String site;
  final int size;
  final String type;

  MovieDetailsVideosResult({
    required this.id, 
    required this.iso639, 
    required this.iso3166, 
    required this.key, 
    required this.name, 
    required this.site, 
    required this.size, 
    required this.type}); 

    factory MovieDetailsVideosResult.fromJson(Map<String, dynamic> json) => _$MovieDetailsVideosResultFromJson(json);

    Map<String, dynamic> toJson() => _$MovieDetailsVideosResultToJson(this); 
}