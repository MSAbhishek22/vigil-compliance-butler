/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'requirement.dart' as _i2;
import 'source_document.dart' as _i3;
import 'vigil_job.dart' as _i4;

export 'requirement.dart';
export 'source_document.dart';
export 'vigil_job.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Requirement) {
      return _i2.Requirement.fromJson(data, this) as T;
    }
    if (t == _i3.SourceDocument) {
      return _i3.SourceDocument.fromJson(data, this) as T;
    }
    if (t == _i4.VigilJob) {
      return _i4.VigilJob.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.Requirement?>()) {
      return (data != null ? _i2.Requirement.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i3.SourceDocument?>()) {
      return (data != null ? _i3.SourceDocument.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i4.VigilJob?>()) {
      return (data != null ? _i4.VigilJob.fromJson(data, this) : null) as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    if (data is _i2.Requirement) {
      return 'Requirement';
    }
    if (data is _i3.SourceDocument) {
      return 'SourceDocument';
    }
    if (data is _i4.VigilJob) {
      return 'VigilJob';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'Requirement') {
      return deserialize<_i2.Requirement>(data['data']);
    }
    if (data['className'] == 'SourceDocument') {
      return deserialize<_i3.SourceDocument>(data['data']);
    }
    if (data['className'] == 'VigilJob') {
      return deserialize<_i4.VigilJob>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
