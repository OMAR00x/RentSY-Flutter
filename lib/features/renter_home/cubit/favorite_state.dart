import 'package:freezed_annotation/freezed_annotation.dart'; // ✨ استيراد freezed_annotation
import 'package:saved/core/domain/models/apartment_model.dart';

part 'favorite_state.freezed.dart'; // ✨ هذا السطر مهم جداً
      // ✨ هذا السطر مهم إذا كنت بدك serializable، لو لا ممكن تستغنى عنه

@freezed
abstract class FavoriteState with _$FavoriteState {
  const factory FavoriteState.initial() = FavoriteInitial;
  const factory FavoriteState.loading() = FavoriteLoading;
  const factory FavoriteState.loaded(List<ApartmentModel> apartments) = FavoriteLoaded;
  const factory FavoriteState.empty() = FavoriteEmpty;
  const factory FavoriteState.error(String message) = FavoriteError;
}
