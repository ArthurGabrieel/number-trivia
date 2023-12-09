import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    final val = int.tryParse(str);
    return (val == null || val.isNegative)
        ? Left(InvalidInputFailure())
        : Right(val);
  }
}

class InvalidInputFailure extends Failure {}
