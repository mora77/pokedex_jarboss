import 'package:json_annotation/json_annotation.dart';
import 'package:prueba_jarboss/features/home/data/models/named_api_resource_dto.dart';

part 'pokemon_stat_dto.g.dart';

@JsonSerializable()
class PokemonStatDto {
  @JsonKey(name: 'base_stat')
  final int baseStat;
  final int effort;
  final NamedApiResourceDto stat;

  const PokemonStatDto({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  factory PokemonStatDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonStatDtoToJson(this);
}
