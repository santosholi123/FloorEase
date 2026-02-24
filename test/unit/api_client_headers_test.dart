import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:batch35_floorease/core/api/api_client.dart';

class MockDio extends Mock implements Dio {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

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

  group('ApiClient Headers', () {
    test('1) requiresAuth false does not add Authorization header', () async {
      when(
        () => mockDio.get(any(), options: captureAny(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {'message': 'ok'},
        ),
      );

      await apiClient.get('/api/test', requiresAuth: false);

      final captured =
          verify(
                () => mockDio.get(any(), options: captureAny(named: 'options')),
              ).captured.single
              as Options;

      expect(captured.headers?['Authorization'], isNull);
    });

    test('2) default Content-Type header is application/json', () async {
      when(
        () => mockDio.get(any(), options: captureAny(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {'message': 'ok'},
        ),
      );

      await apiClient.get('/api/test', requiresAuth: false);

      final captured =
          verify(
                () => mockDio.get(any(), options: captureAny(named: 'options')),
              ).captured.single
              as Options;

      expect(captured.headers?['Content-Type'], 'application/json');
    });

    test('3) multiple custom headers are merged correctly', () async {
      when(
        () => mockDio.get(any(), options: captureAny(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {'message': 'ok'},
        ),
      );

      await apiClient.get(
        '/api/test',
        requiresAuth: false,
        headers: {'X-Test': '123', 'Another-Header': 'abc'},
      );

      final captured =
          verify(
                () => mockDio.get(any(), options: captureAny(named: 'options')),
              ).captured.single
              as Options;

      expect(captured.headers?['X-Test'], '123');
      expect(captured.headers?['Another-Header'], 'abc');
    });

    test('4) custom headers override default headers', () async {
      when(
        () => mockDio.get(any(), options: captureAny(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {'message': 'ok'},
        ),
      );

      await apiClient.get(
        '/api/test',
        requiresAuth: false,
        headers: {'Content-Type': 'custom/type'},
      );

      final captured =
          verify(
                () => mockDio.get(any(), options: captureAny(named: 'options')),
              ).captured.single
              as Options;

      expect(captured.headers?['Content-Type'], 'custom/type');
    });
  });
}
