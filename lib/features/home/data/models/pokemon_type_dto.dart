import 'package:json_annotation/json_annotation.dart';
import 'package:prueba_jarboss/features/home/data/models/named_api_resource_dto.dart';

part 'pokemon_type_dto.g.dart';

@JsonSerializable()
class PokemonTypeDto {
  final int slot;
  final NamedApiResourceDto type;

  const PokemonTypeDto({
    required this.slot,
    required this.type,
  });

  factory PokemonTypeDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonTypeDtoToJson(this);
}
