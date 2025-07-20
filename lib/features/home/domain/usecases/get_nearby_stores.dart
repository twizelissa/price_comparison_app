import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/store.dart';
import '../repositories/home_repository.dart';

class GetNearbyStores implements UseCase<List<Store>, GetNearbyStoresParams> {
  final HomeRepository repository;

  GetNearbyStores(this.repository);

  @override
  Future<Either<Failure, List<Store>>> call(GetNearbyStoresParams params) async {
    return await repository.getNearbyStores(
      latitude: params.latitude,
      longitude: params.longitude,
      radiusInKm: params.radiusInKm,
      limit: params.limit,
    );
  }
}

class GetNearbyStoresParams extends Equatable {
  final double latitude;
  final double longitude;
  final double radiusInKm;
  final int limit;

  const GetNearbyStoresParams({
    required this.latitude,
    required this.longitude,
    this.radiusInKm = 10.0,
    this.limit = 20,
  });

  @override
  List<Object> get props => [latitude, longitude, radiusInKm, limit];
}