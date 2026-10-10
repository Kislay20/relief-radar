/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

enum NeedType implements _isc.SerializableModel {
  rescue,
  medical,
  water,
  food,
  shelter,
  evacuation,
  other;

  static NeedType fromJson(String name) {
    switch (name) {
      case 'rescue':
        return NeedType.rescue;
      case 'medical':
        return NeedType.medical;
      case 'water':
        return NeedType.water;
      case 'food':
        return NeedType.food;
      case 'shelter':
        return NeedType.shelter;
      case 'evacuation':
        return NeedType.evacuation;
      case 'other':
        return NeedType.other;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "NeedType"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
