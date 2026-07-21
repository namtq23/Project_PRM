// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_details_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TourDetailsViewModel)
final tourDetailsViewModelProvider = TourDetailsViewModelFamily._();

final class TourDetailsViewModelProvider
    extends $AsyncNotifierProvider<TourDetailsViewModel, TourDetailsState> {
  TourDetailsViewModelProvider._({
    required TourDetailsViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'tourDetailsViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tourDetailsViewModelHash();

  @override
  String toString() {
    return r'tourDetailsViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TourDetailsViewModel create() => TourDetailsViewModel();

  @override
  bool operator ==(Object other) {
    return other is TourDetailsViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tourDetailsViewModelHash() =>
    r'3d938043836c8ea7283e1e92157f7cf359ad7550';

final class TourDetailsViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          TourDetailsViewModel,
          AsyncValue<TourDetailsState>,
          TourDetailsState,
          FutureOr<TourDetailsState>,
          int
        > {
  TourDetailsViewModelFamily._()
    : super(
        retry: null,
        name: r'tourDetailsViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TourDetailsViewModelProvider call(int tourId) =>
      TourDetailsViewModelProvider._(argument: tourId, from: this);

  @override
  String toString() => r'tourDetailsViewModelProvider';
}

abstract class _$TourDetailsViewModel extends $AsyncNotifier<TourDetailsState> {
  late final _$args = ref.$arg as int;
  int get tourId => _$args;

  FutureOr<TourDetailsState> build(int tourId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<TourDetailsState>, TourDetailsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TourDetailsState>, TourDetailsState>,
              AsyncValue<TourDetailsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
