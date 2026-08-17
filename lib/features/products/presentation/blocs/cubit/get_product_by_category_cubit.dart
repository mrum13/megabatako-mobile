import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/products/domain/entities/product_entity.dart';
import 'package:megabatako/features/products/domain/use_cases/get_product_use_case.dart';

part 'get_product_by_category_state.dart';

class GetProductByCategoryCubit extends Cubit<GetProductByCategoryState> {
  final GetProductByCategoryUseCase _useCase;

  GetProductByCategoryCubit(this._useCase)
    : super(GetProductByCategoryInitial());

  void getData({required int productCategoryId}) async {
    emit(GetProductByCategoryLoading());

    final result = await _useCase(productCategoryId: productCategoryId);

    result.fold(
      (failure) => emit(GetProductByCategoryFailed(failure.message)),
      (data) => emit(GetProductByCategorySuccess(data)),
    );
  }

  void clear() {
    emit(GetProductByCategoryInitial());
  }
}
