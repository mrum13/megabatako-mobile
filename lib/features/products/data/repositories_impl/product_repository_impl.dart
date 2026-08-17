import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:megabatako/core/connection/network_info.dart';
import 'package:megabatako/core/errors/expentions.dart';
import 'package:megabatako/core/errors/failure.dart';
import 'package:megabatako/features/products/data/data_sources/product_remote_data_source.dart';
import 'package:megabatako/features/products/data/models/store_product_model.dart';
import 'package:megabatako/features/products/domain/entities/product_entity.dart';
import 'package:megabatako/features/products/domain/entities/store_product_entity.dart';
import 'package:megabatako/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final NetworkInfo networkInfo;
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> storeProduct({
    required StoreProductEntity data,
  }) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.storeProductCategory(
          data: StoreProductModel(
            productCategoryId: data.productCategoryId,
            name: data.name,
            price: data.price,
            desc: data.desc,
            thumbnail: data.thumbnail,
            stock: data.stock,
          ),
        );
        return Right(result);
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on TimeoutException {
        return const Left(TimeoutFailure('Timeout. No Response'));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message.toString()));
      } on RequestValidationException catch (e) {
        return Left(NotFoundFailure(e.message.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message.toString()));
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Tidak ada koneksi internet'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductByCategory({
    required int productCategoryId,
  }) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.getProductByCategory(
          productCategoryId: productCategoryId,
        );
        return Right(result);
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on TimeoutException {
        return const Left(TimeoutFailure('Timeout. No Response'));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message.toString()));
      } on RequestValidationException catch (e) {
        return Left(NotFoundFailure(e.message.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message.toString()));
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Tidak ada koneksi internet'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct({required int idProduct}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.deleteProduct(id: idProduct);
        return Right(result);
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on TimeoutException {
        return const Left(TimeoutFailure('Timeout. No Response'));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message.toString()));
      } on RequestValidationException catch (e) {
        return Left(NotFoundFailure(e.message.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message.toString()));
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Tidak ada koneksi internet'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProduct({
    required StoreProductEntity data,
    required int idProduct,
  }) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final result = await remoteDataSource.updateProductCategory(
          data: StoreProductModel(
            productCategoryId: data.productCategoryId,
            name: data.name,
            price: data.price,
            desc: data.desc,
            thumbnail: data.thumbnail,
            stock: data.stock,
          ),
          idProduct: idProduct,
        );
        return Right(result);
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on TimeoutException {
        return const Left(TimeoutFailure('Timeout. No Response'));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message.toString()));
      } on RequestValidationException catch (e) {
        return Left(NotFoundFailure(e.message.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message.toString()));
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message.toString()));
      }
    } else {
      return const Left(ConnectionFailure('Tidak ada koneksi internet'));
    }
  }
}
