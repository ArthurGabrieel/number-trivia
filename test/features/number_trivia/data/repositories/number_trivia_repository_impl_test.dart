import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  const tNumber = 1;
  const tNumberTriviaModel =
      NumberTriviaModel(text: 'Test text', number: tNumber);
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) => Future.value(true));
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future<void>.value());
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) => Future.value(false));
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    test('should check if the device is online', () {
      //arrange
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) => Future.value(true));
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) => Future.value(tNumberTriviaModel));
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) => Future.value());

      //act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) => Future.value(true));
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future<void>.value());
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((_) => Future.value(true));
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenAnswer((_) => Future.value(tNumberTriviaModel));

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(() => mockLocalDataSource.cacheNumberTrivia(
              tNumberTriviaModel)); // Verify the interaction with localDataSource
          expect(result, const Right(tNumberTrivia));
        },
      );

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) => Future.value(tNumberTriviaModel));
        //act
        await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // Arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) => Future.value(tNumberTriviaModel));

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, const Right(tNumberTrivia));
        },
      );

      test(
        'should return CacheFailure cached data when the cached data is not present',
        () async {
          //arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    test('should check if the device is online', () {
      //arrange
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) => Future.value(true));
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) => Future.value(tNumberTriviaModel));
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) => Future.value());

      //act
      repository.getRandomNumberTrivia();
      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) => Future.value(true));
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future<void>.value());
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((_) => Future.value(true));
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) => Future.value(tNumberTriviaModel));

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verify(() => mockLocalDataSource.cacheNumberTrivia(
              tNumberTriviaModel)); // Verify the interaction with localDataSource
          expect(result, const Right(tNumberTrivia));
        },
      );

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) => Future.value(tNumberTriviaModel));
        //act
        await repository.getRandomNumberTrivia();
        //assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // Arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) => Future.value(tNumberTriviaModel));

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, const Right(tNumberTrivia));
        },
      );

      test(
        'should return CacheFailure cached data when the cached data is not present',
        () async {
          //arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          //act
          final result = await repository.getRandomNumberTrivia();

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
