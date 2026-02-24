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
    // Needed because Options is used as a named argument in dio.post(...)
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDio = MockDio();
    apiClient = ApiClient(mockDio);
  });

  Response<dynamic> _successResponse(Map<String, dynamic> data) {
    return Response<dynamic>(
      requestOptions: RequestOptions(path: '/test'),
      statusCode: 200,
      data: data,
    );
  }

  Response<dynamic> _errorResponse(int code, Map<String, dynamic> data) {
    return Response<dynamic>(
      requestOptions: RequestOptions(path: '/test'),
      statusCode: code,
      data: data,
    );
  }

  group('ApiClient.post', () {
    test('1) returns Map on 200 success', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => _successResponse({'message': 'ok'}));

      final result = await apiClient.post(
        '/api/auth/login',
        body: {'email': 'a@gmail.com', 'password': '123456'},
        requiresAuth: false,
      );

      expect(result['message'], 'ok');

      verify(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('2) sends Content-Type + custom headers', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => _successResponse({'message': 'ok'}));

      await apiClient.post(
        '/secure',
        body: {'a': 1},
        headers: {'Authorization': 'Bearer token'},
        requiresAuth: false,
      );

      final captured =
          verify(
                () => mockDio.post(
                  any(),
                  data: any(named: 'data'),
                  options: captureAny(named: 'options'),
                ),
              ).captured.single
              as Options;

      expect(captured.headers?['Content-Type'], 'application/json');
      expect(captured.headers?['Authorization'], 'Bearer token');
    });

    test('3) throws ApiFailure with statusCode + message on non-2xx', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _errorResponse(409, {'message': 'Email already exists'}),
      );

      expect(
        () => apiClient.post(
          '/api/auth/register',
          body: {'x': 1},
          requiresAuth: false,
        ),
        throwsA(isA<ApiFailure>()),
      );

      try {
        await apiClient.post(
          '/api/auth/register',
          body: {'x': 1},
          requiresAuth: false,
        );
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.statusCode, 409);
        expect(err.message, contains('Email already exists'));
      }
    });

    test('4) throws ApiFailure 408 on TimeoutException', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(TimeoutException('Request timeout'));

      try {
        await apiClient.post('/any', body: {'x': 1}, requiresAuth: false);
        fail('should throw');
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.statusCode, 408);
        expect(err.message, contains('Request timeout'));
      }
    });

    test('5) throws ApiFailure Network error on DioException', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/any'),
          type: DioExceptionType.connectionError,
          message: 'Connection failed',
        ),
      );

      try {
        await apiClient.post('/any', body: {'x': 1}, requiresAuth: false);
        fail('should throw');
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.message, 'Network error: Connection failed');
      }
    });
  });
}
