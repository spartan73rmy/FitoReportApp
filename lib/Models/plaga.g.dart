// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plaga.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlagaAdapter extends TypeAdapter<Plaga> {
  @override
  final int typeId = 1;

  @override
  Plaga read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Plaga(
      id: fields[0] as int?,
      serverId: fields[1] as int?,
      nombre: fields[2] as String?,
      selected: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Plaga obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serverId)
      ..writeByte(2)
      ..write(obj.nombre)
      ..writeByte(3)
      ..write(obj.selected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlagaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
