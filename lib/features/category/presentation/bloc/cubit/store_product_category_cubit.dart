import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/category/domain/usecases/store_category_use_case.dart';

part 'store_product_category_state.dart';

class StoreProductCategoryCubit extends Cubit<StoreProductCategoryState> {
  final StoreProductCategoryUseCase _useCase;

  StoreProductCategoryCubit(this._useCase) : super(StoreProductCategoryInitial());

  void storeData({required String name}) async {
    emit(StoreProductCategoryLoading());

    final result = await _useCase(name: name);

    result.fold(
      (failure) => emit(StoreProductCategoryFailed(failure.message)),
      (data) => emit(StoreProductCategorySuccess(data)),
    );
  }
}
