import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  UserEntity(
    this.id,
    this.name,
    this.email,
    this.time
  );

  int id;
  String name;
  String email;
  int time;
  
  factory UserEntity.fromJson(Map<String,dynamic> json) => _$UserEntityFromJson(json);
  Map<String,dynamic> toJson() => _$UserEntityToJson(this);
}