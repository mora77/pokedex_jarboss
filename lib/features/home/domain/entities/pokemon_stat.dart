import 'package:equatable/equatable.dart';
import 'package:prueba_jarboss/features/home/domain/entities/named_api_resource.dart';

class PokemonStat extends Equatable {
  final int baseStat;
  final int effort;
  final NamedApiResource stat;

  const PokemonStat({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  PokemonStat copyWith({
    int? baseStat,
    int? effort,
    NamedApiResource? stat,
  }) {
    return PokemonStat(
      baseStat: baseStat ?? this.baseStat,
      effort: effort ?? this.effort,
      stat: stat ?? this.stat,
    );
  }

  @override
  List<Object?> get props => [baseStat, effort, stat];
}
