import 'package:equatable/equatable.dart';
import 'package:prueba_jarboss/features/home/domain/entities/named_api_resource.dart';

class PokemonType extends Equatable {
  final int slot;
  final NamedApiResource type;

  const PokemonType({
    required this.slot,
    required this.type,
  });

  PokemonType copyWith({
    int? slot,
    NamedApiResource? type,
  }) {
    return PokemonType(
      slot: slot ?? this.slot,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [slot, type];
}
