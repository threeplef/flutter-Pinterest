import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/model/photo.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default([]) List<Photo> photos,
    @Default(false) bool isLoading,
  }) = _MainState;
}