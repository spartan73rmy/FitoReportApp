// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etapaFenologica.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EtapaFenologicaAdapter extends TypeAdapter<EtapaFenologica> {
  @override
  final int typeId = 0;

  @override
  EtapaFenologica read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EtapaFenologica(
      id: fields[0] as int?,
      serverId: fields[1] as int?,
      nombre: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EtapaFenologica obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serverId)
      ..writeByte(2)
      ..write(obj.nombre);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EtapaFenologicaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
