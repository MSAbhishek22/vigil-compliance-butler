/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

library protocol;

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;

// Model exports  
export 'requirement.dart';
export 'source_document.dart';
export 'vigil_job.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    return _i2.Protocol().deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    return _i2.Protocol().getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    return _i2.Protocol().deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    return _i2.Protocol().getTableForType(t);
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() => 
      _i2.Protocol.targetTableDefinitions;

  @override
  String getModuleName() => 'vigil';
}
