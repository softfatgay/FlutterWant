// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountMGModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountMGModel _$AccountMGModelFromJson(Map<String, dynamic> json) {
  return AccountMGModel()
    ..aliasEnableOps =
        (json['aliasEnableOps'] as List)?.map((e) => e as num)?.toList()
    ..alias = (json['alias'] as List)
        ?.map((e) =>
            e == null ? null : AliasItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AccountMGModelToJson(AccountMGModel instance) =>
    <String, dynamic>{
      'aliasEnableOps': instance.aliasEnableOps,
      'alias': instance.alias,
    };

AliasItem _$AliasItemFromJson(Map<String, dynamic> json) {
  return AliasItem()
    ..aliasType = json['aliasType'] as num
    ..frontGroupType = json['frontGroupType'] as num
    ..mobile = json['mobile'] as String
    ..alias = json['alias'] as String;
}

Map<String, dynamic> _$AliasItemToJson(AliasItem instance) => <String, dynamic>{
      'aliasType': instance.aliasType,
      'frontGroupType': instance.frontGroupType,
      'mobile': instance.mobile,
      'alias': instance.alias,
    };
