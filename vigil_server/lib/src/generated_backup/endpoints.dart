/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/document_endpoint.dart' as _i2;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'document': _i2.DocumentEndpoint()..initialize(server, 'document', null),
    };
    
    connectors['document'] = _i1.EndpointConnector(
      name: 'document',
      endpoint: endpoints['document']!,
      methodConnectors: {
        'getVigilanceScore': _i1.MethodConnector(
          name: 'getVigilanceScore',
          params: {},
          call: (session, params) async {
            return (endpoints['document'] as _i2.DocumentEndpoint).getVigilanceScore(session);
          },
        ),
        'getActiveDocuments': _i1.MethodConnector(
          name: 'getActiveDocuments',
          params: {},
          call: (session, params) async {
            return (endpoints['document'] as _i2.DocumentEndpoint).getActiveDocuments(session);
          },
        ),
        'getUpcomingDeadlines': _i1.MethodConnector(
          name: 'getUpcomingDeadlines',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (session, params) async {
            return (endpoints['document'] as _i2.DocumentEndpoint).getUpcomingDeadlines(
              session,
              limit: params['limit'] ?? 5,
            );
          },
        ),
        'ping': _i1.MethodConnector(
          name: 'ping',
          params: {},
          call: (session, params) async {
            return (endpoints['document'] as _i2.DocumentEndpoint).ping(session);
          },
        ),
      },
    );
  }
}
