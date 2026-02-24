import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:batch35_floorease/core/api/api_client.dart';
import 'package:batch35_floorease/core/errors/failures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDio mockDio;
  late ApiClient apiClient;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDio = MockDio();
    apiClient = ApiClient(mockDio);
  });

  group('ApiClient.delete', () {
    test('1) DELETE returns Map on 200 success', () async {
      when(
        () => mockDio.delete(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {'message': 'delete ok'},
        ),
      );

      final result = await apiClient.delete('/api/test', requiresAuth: false);

      expect(result['message'], 'delete ok');

      verify(
        () => mockDio.delete(any(), options: any(named: 'options')),
      ).called(1);
    });

    test('2) DELETE throws ApiFailure on non-2xx response', () async {
      when(
        () => mockDio.delete(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
          data: {'message': 'Forbidden'},
        ),
      );

      expect(
        () => apiClient.delete('/api/test', requiresAuth: false),
        throwsA(isA<ApiFailure>()),
      );

      try {
        await apiClient.delete('/api/test', requiresAuth: false);
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.statusCode, 403);
        expect(err.message, contains('Forbidden'));
      }
    });

    test('3) DELETE throws ApiFailure 408 on TimeoutException', () async {
      when(
        () => mockDio.delete(any(), options: any(named: 'options')),
      ).thenThrow(TimeoutException('Request timeout'));

      try {
        await apiClient.delete('/api/test', requiresAuth: false);
        fail('should throw');
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.statusCode, 408);
        expect(err.message, contains('Request timeout'));
      }
    });
  });
}
