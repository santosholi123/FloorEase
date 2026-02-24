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

  group('ApiClient.postMultipart', () {
    test('1) postMultipart returns Map on 200 success', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {'message': 'upload ok'},
        ),
      );

      final result = await apiClient.postMultipart(
        '/api/upload',
        body: FormData.fromMap({'file': 'dummy'}),
        requiresAuth: false,
      );

      expect(result['message'], 'upload ok');

      verify(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('2) postMultipart throws ApiFailure on non-2xx response', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
          data: {'message': 'Upload failed'},
        ),
      );

      expect(
        () => apiClient.postMultipart(
          '/api/upload',
          body: FormData.fromMap({'file': 'dummy'}),
          requiresAuth: false,
        ),
        throwsA(isA<ApiFailure>()),
      );

      try {
        await apiClient.postMultipart(
          '/api/upload',
          body: FormData.fromMap({'file': 'dummy'}),
          requiresAuth: false,
        );
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.statusCode, 500);
        expect(err.message, contains('Upload failed'));
      }
    });

    test(
      '3) postMultipart throws ApiFailure 408 on TimeoutException',
      () async {
        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(TimeoutException('Request timeout'));

        try {
          await apiClient.postMultipart(
            '/api/upload',
            body: FormData.fromMap({'file': 'dummy'}),
            requiresAuth: false,
          );
          fail('should throw');
        } catch (e) {
          final err = e as ApiFailure;
          expect(err.statusCode, 408);
          expect(err.message, contains('Request timeout'));
        }
      },
    );

    test('4) postMultipart throws Network error on DioException', () async {
      when(
        () => mockDio.post(
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
        await apiClient.postMultipart(
          '/api/upload',
          body: FormData.fromMap({'file': 'dummy'}),
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
