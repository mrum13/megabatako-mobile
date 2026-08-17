import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/products/domain/entities/store_product_entity.dart';
import 'package:megabatako/features/products/domain/use_cases/update_product_use_case.dart';

part 'update_product_state.dart';

class UpdateProductCubit extends Cubit<UpdateProductState> {
  final UpdateProductUseCase _useCase;

  UpdateProductCubit(this._useCase) : super(UpdateProductInitial());

    void updateData({required StoreProductEntity data, required int idProduct}) async {
    emit(UpdateProductLoading());

    final result = await _useCase(data: data, idProduct: idProduct);

    result.fold(
      (failure) => emit(UpdateProductFailed(failure.message)),
      (data) => emit(UpdateProductSuccess(data)),
    );
  }
}
