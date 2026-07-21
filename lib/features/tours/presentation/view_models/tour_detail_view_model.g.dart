// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TourDetailViewModel)
final tourDetailViewModelProvider = TourDetailViewModelFamily._();

final class TourDetailViewModelProvider
    extends $AsyncNotifierProvider<TourDetailViewModel, Tour?> {
  TourDetailViewModelProvider._({
    required TourDetailViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'tourDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tourDetailViewModelHash();

  @override
  String toString() {
    return r'tourDetailViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TourDetailViewModel create() => TourDetailViewModel();

  @override
  bool operator ==(Object other) {
    return other is TourDetailViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tourDetailViewModelHash() =>
    r'71d1537f191f8ecfe1ea34ad84efe67ecad92e03';

final class TourDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          TourDetailViewModel,
          AsyncValue<Tour?>,
          Tour?,
          FutureOr<Tour?>,
          int
        > {
  TourDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'tourDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TourDetailViewModelProvider call(int tourId) =>
      TourDetailViewModelProvider._(argument: tourId, from: this);

  @override
  String toString() => r'tourDetailViewModelProvider';
}

abstract class _$TourDetailViewModel extends $AsyncNotifier<Tour?> {
  late final _$args = ref.$arg as int;
  int get tourId => _$args;

  FutureOr<Tour?> build(int tourId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Tour?>, Tour?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Tour?>, Tour?>,
              AsyncValue<Tour?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
