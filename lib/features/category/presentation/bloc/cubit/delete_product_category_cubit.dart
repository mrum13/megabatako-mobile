import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/category/domain/usecases/delete_category_use_case.dart';

part 'delete_product_category_state.dart';

class DeleteProductCategoryCubit extends Cubit<DeleteProductCategoryState> {
  final DeleteCategoryUseCase _useCase;

  DeleteProductCategoryCubit(this._useCase)
    : super(DeleteProductCategoryInitial());

  void deleteData({required int idCategory}) async {
    emit(DeleteProductCategoryLoading());

    final result = await _useCase(idCategory: idCategory);

    result.fold(
      (failure) => emit(DeleteProductCategoryFailed(failure.message)),
      (data) => emit(DeleteProductCategorySuccess(data)),
    );
  }
}
