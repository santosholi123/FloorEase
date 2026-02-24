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

  group('ApiClient.get', () {
    test('1) GET returns Map on 200 success', () async {
      when(() => mockDio.get(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {'message': 'get ok'},
        ),
      );

      final result = await apiClient.get('/api/test', requiresAuth: false);

      expect(result['message'], 'get ok');

      verify(
        () => mockDio.get(any(), options: any(named: 'options')),
      ).called(1);
    });

    test('2) GET throws ApiFailure on non-2xx response', () async {
      when(() => mockDio.get(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
          data: {'message': 'Not found'},
        ),
      );

      expect(
        () => apiClient.get('/api/test', requiresAuth: false),
        throwsA(isA<ApiFailure>()),
      );

      try {
        await apiClient.get('/api/test', requiresAuth: false);
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.statusCode, 404);
        expect(err.message, contains('Not found'));
      }
    });

    test('3) GET throws ApiFailure 408 on TimeoutException', () async {
      when(
        () => mockDio.get(any(), options: any(named: 'options')),
      ).thenThrow(TimeoutException('Request timeout'));

      try {
        await apiClient.get('/api/test', requiresAuth: false);
        fail('should throw');
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.statusCode, 408);
        expect(err.message, contains('Request timeout'));
      }
    });

    test('4) GET throws ApiFailure Network error on DioException', () async {
      when(() => mockDio.get(any(), options: any(named: 'options'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
          message: 'Connection failed',
        ),
      );

      try {
        await apiClient.get('/api/test', requiresAuth: false);
        fail('should throw');
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.message, contains('Network error'));
      }
    });
  });
}
