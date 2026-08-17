import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megabatako/features/category/domain/entities/category_entity.dart';
import 'package:megabatako/features/category/domain/usecases/get_category_use_case.dart';

part 'get_product_category_state.dart';

class GetProductCategoryCubit extends Cubit<GetProductCategoryState> {
  final GetCategoryUseCase _useCase;

  GetProductCategoryCubit(this._useCase) : super(GetProductCategoryInitial());

  void getData() async {
    emit(GetProductCategoryLoading());

    final result = await _useCase();

    result.fold(
      (failure) => emit(GetProductCategoryFailed(failure.message)),
      (data) => emit(GetProductCategorySuccess(data)),
    );
  }
}
