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

  group('ApiClient.put', () {
    test('1) PUT returns Map on 200 success', () async {
      when(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {'message': 'put ok'},
        ),
      );

      final result = await apiClient.put(
        '/api/test',
        body: {'name': 'test'},
        requiresAuth: false,
      );

      expect(result['message'], 'put ok');

      verify(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('2) PUT throws ApiFailure on non-2xx response', () async {
      when(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'message': 'Bad request'},
        ),
      );

      expect(
        () => apiClient.put(
          '/api/test',
          body: {'name': 'test'},
          requiresAuth: false,
        ),
        throwsA(isA<ApiFailure>()),
      );

      try {
        await apiClient.put(
          '/api/test',
          body: {'name': 'test'},
          requiresAuth: false,
        );
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.statusCode, 400);
        expect(err.message, contains('Bad request'));
      }
    });

    test('3) PUT throws ApiFailure 408 on TimeoutException', () async {
      when(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(TimeoutException('Request timeout'));

      try {
        await apiClient.put(
          '/api/test',
          body: {'name': 'test'},
          requiresAuth: false,
        );
        fail('should throw');
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.statusCode, 408);
        expect(err.message, contains('Request timeout'));
      }
    });

    test('4) PUT throws ApiFailure Network error on DioException', () async {
      when(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
          message: 'Connection failed',
        ),
      );

      try {
        await apiClient.put(
          '/api/test',
          body: {'name': 'test'},
          requiresAuth: false,
        );
        fail('should throw');
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.message, contains('Network error'));
      }
    });
  });
}
