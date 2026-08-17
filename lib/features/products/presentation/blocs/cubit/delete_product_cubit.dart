import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/products/domain/use_cases/delete_product_use.dart';

part 'delete_product_state.dart';

class DeleteProductCubit extends Cubit<DeleteProductState> {
  final DeleteProductUseCase _useCase;

  DeleteProductCubit(this._useCase) : super(DeleteProductInitial());

  void deleteData({required int idProduct}) async {
    emit(DeleteProductLoading());

    final result = await _useCase(idProduct: idProduct);

    result.fold(
      (failure) => emit(DeleteProductFailed(failure.message)),
      (data) => emit(DeleteProductSuccess(data)),
    );
  }
}
