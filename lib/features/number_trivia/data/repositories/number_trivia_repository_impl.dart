import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        await localDataSource.cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    }

    try {
      final localTrivia = await localDataSource.getLastNumberTrivia();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async =>
      await _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async =>
      await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
}
