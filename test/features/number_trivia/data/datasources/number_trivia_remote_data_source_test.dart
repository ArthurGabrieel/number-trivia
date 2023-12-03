import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = NumberTriviaRemoteDataSourceImpl(dio: mockDio);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                data: fixture('trivia.json'),
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is not 200 (success)',
        () async {
      // arrange
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                data: 'error occurred',
                statusCode: 404,
                requestOptions: RequestOptions(path: ''),
              ));

      // act
      final call = dataSource.getConcreteNumberTrivia;

      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                data: fixture('trivia.json'),
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      // act
      final result = await dataSource.getRandomNumberTrivia();

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is not 200 (success)',
        () async {
      // arrange
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                data: 'error occurred',
                statusCode: 404,
                requestOptions: RequestOptions(path: ''),
              ));

      // act
      final call = dataSource.getRandomNumberTrivia;

      // assert
      expect(
          () => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
