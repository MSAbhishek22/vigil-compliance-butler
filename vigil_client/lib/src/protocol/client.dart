/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'protocol.dart' as _i3;

/// DocumentEndpoint - The main API endpoint for Vigil
class EndpointDocument extends _i1.EndpointRef {
  EndpointDocument(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'document';

  /// Process a document URL
  _i2.Future<_i3.SourceDocument> processDocument(String url) async {
    final result = await caller.callServerEndpoint<Map<String, dynamic>>(
      'document',
      'processDocument',
      {'url': url},
    );
    return _i3.SourceDocument.fromJson(result, _i3.Protocol());
  }

  /// Get requirements for a document
  _i2.Future<List<_i3.Requirement>> getRequirements(int sourceDocumentId) async {
    final result = await caller.callServerEndpoint<List<Map<String, dynamic>>>(
      'document',
      'getRequirements',
      {'sourceDocumentId': sourceDocumentId},
    );
    return (result).map((e) => _i3.Requirement.fromJson(e, _i3.Protocol())).toList();
  }

  /// Complete a requirement
  _i2.Future<_i3.Requirement> completeRequirement(int requirementId, String? proofUrl) async {
    final result = await caller.callServerEndpoint<Map<String, dynamic>>(
      'document',
      'completeRequirement',
      {'requirementId': requirementId, 'proofUrl': proofUrl},
    );
    return _i3.Requirement.fromJson(result, _i3.Protocol());
  }

  /// Get the "Vigilance Score" - percentage of requirements completed
  _i2.Future<Map<String, dynamic>> getVigilanceScore() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'document',
        'getVigilanceScore',
        {},
      );

  /// Get all active source documents
  _i2.Future<List<_i3.SourceDocument>> getActiveDocuments() async {
    final result = await caller.callServerEndpoint<List<Map<String, dynamic>>>(
      'document',
      'getActiveDocuments',
      {},
    );
    return (result).map((e) => _i3.SourceDocument.fromJson(e, _i3.Protocol())).toList();
  }

  /// Get upcoming deadlines
  _i2.Future<List<Map<String, dynamic>>> getUpcomingDeadlines({int? limit}) =>
      caller.callServerEndpoint<List<Map<String, dynamic>>>(
        'document',
        'getUpcomingDeadlines',
        {'limit': limit},
      );

  /// Health check endpoint
  _i2.Future<String> ping() => caller.callServerEndpoint<String>(
        'document',
        'ping',
        {},
    );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
  }) : super(
          host,
          _i3.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
        ) {
    // Cast this to dynamic to bypass mismatched type if Serverpod version differs
    document = EndpointDocument(this as dynamic);
  }

  late final EndpointDocument document;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {'document': document};

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
