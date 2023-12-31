import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Dio dio;

  NumberTriviaRemoteDataSourceImpl({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: 'http://numbersapi.com',
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    );
  }

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await dio.get('/$number');

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await dio.get('/random');

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
