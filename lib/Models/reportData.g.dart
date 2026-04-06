// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportDataAdapter extends TypeAdapter<ReportData> {
  @override
  final int typeId = 4;

  @override
  ReportData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportData(
      id: fields[0] as int?,
      serverId: fields[1] as int?,
      lugar: fields[2] as String?,
      productor: fields[3] as String?,
      latitude: fields[4] as double,
      longitud: fields[5] as double,
      ubicacion: fields[6] as String?,
      predio: fields[7] as String?,
      cultivo: fields[8] as String?,
      observaciones: fields[9] as String?,
      litros: fields[10] as int,
      created: fields[11] as DateTime,
      imagesHash: (fields[12] as List).cast<String>(),
      enfermedadJson: (fields[13] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      productoJson: (fields[14] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      plagaJson: (fields[15] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      etapaFenologicaJson: (fields[16] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, ReportData obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serverId)
      ..writeByte(2)
      ..write(obj.lugar)
      ..writeByte(3)
      ..write(obj.productor)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitud)
      ..writeByte(6)
      ..write(obj.ubicacion)
      ..writeByte(7)
      ..write(obj.predio)
      ..writeByte(8)
      ..write(obj.cultivo)
      ..writeByte(9)
      ..write(obj.observaciones)
      ..writeByte(10)
      ..write(obj.litros)
      ..writeByte(11)
      ..write(obj.created)
      ..writeByte(12)
      ..write(obj.imagesHash)
      ..writeByte(13)
      ..write(obj.enfermedadJson)
      ..writeByte(14)
      ..write(obj.productoJson)
      ..writeByte(15)
      ..write(obj.plagaJson)
      ..writeByte(16)
      ..write(obj.etapaFenologicaJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
