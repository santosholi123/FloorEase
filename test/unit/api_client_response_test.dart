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

  group('ApiClient Response Handling', () {
    test('1) throws ApiFailure when statusCode is null', () async {
      when(() => mockDio.get(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: null,
          data: {'message': 'Unknown error'},
        ),
      );

      expect(
        () => apiClient.get('/api/test', requiresAuth: false),
        throwsA(isA<ApiFailure>()),
      );
    });

    test(
      '2) uses fallback message when no message or error key present',
      () async {
        when(
          () => mockDio.get(any(), options: any(named: 'options')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {},
          ),
        );

        try {
          await apiClient.get('/api/test', requiresAuth: false);
        } catch (e) {
          final err = e as ApiFailure;
          expect(err.message, contains('Request failed with status code 400'));
        }
      },
    );

    test('3) extracts error from "error" key if message not present', () async {
      when(() => mockDio.get(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'error': 'Invalid input'},
        ),
      );

      try {
        await apiClient.get('/api/test', requiresAuth: false);
      } catch (e) {
        final err = e as ApiFailure;
        expect(err.message, contains('Invalid input'));
      }
    });
  });
}
