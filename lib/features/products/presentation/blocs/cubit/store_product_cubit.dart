import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/products/domain/entities/store_product_entity.dart';
import 'package:megabatako/features/products/domain/use_cases/store_product_use_case.dart';

part 'store_product_state.dart';

class StoreProductCubit extends Cubit<StoreProductState> {
  final StoreProductUseCase _useCase;
  StoreProductCubit(this._useCase) : super(StoreProductInitial());

  void storeData({required StoreProductEntity data}) async {
    emit(StoreProductLoading());

    final result = await _useCase(data: data);

    result.fold(
      (failure) => emit(StoreProductFailed(failure.message)),
      (data) => emit(StoreProductSuccess(data)),
    );
  }
}
