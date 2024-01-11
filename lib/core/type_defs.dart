import 'package:fpdart/fpdart.dart';
import 'package:x_clone/core/failure.dart';

typedef FutureEither<T> = Future<Either<FailureClass, T>>;
typedef FutureVoid = FutureEither<void>;
