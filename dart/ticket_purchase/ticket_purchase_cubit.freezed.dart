// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ticket_purchase_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TicketPurchaseStateTearOff {
  const _$TicketPurchaseStateTearOff();

  _TicketPurchaseState call(
      {required List<int> ticketsPurchased,
      required int selectedTicketCategoryIndex,
      required List<EventTickets$Query$TicketCategories> ticketCategories,
      required double sumOfPurchase,
      required bool maxTicketReached}) {
    return _TicketPurchaseState(
      ticketsPurchased: ticketsPurchased,
      selectedTicketCategoryIndex: selectedTicketCategoryIndex,
      ticketCategories: ticketCategories,
      sumOfPurchase: sumOfPurchase,
      maxTicketReached: maxTicketReached,
    );
  }
}

/// @nodoc
const $TicketPurchaseState = _$TicketPurchaseStateTearOff();

/// @nodoc
mixin _$TicketPurchaseState {
  List<int> get ticketsPurchased => throw _privateConstructorUsedError;
  int get selectedTicketCategoryIndex => throw _privateConstructorUsedError;
  List<EventTickets$Query$TicketCategories> get ticketCategories =>
      throw _privateConstructorUsedError;
  double get sumOfPurchase => throw _privateConstructorUsedError;
  bool get maxTicketReached => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketPurchaseStateCopyWith<TicketPurchaseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketPurchaseStateCopyWith<$Res> {
  factory $TicketPurchaseStateCopyWith(
          TicketPurchaseState value, $Res Function(TicketPurchaseState) then) =
      _$TicketPurchaseStateCopyWithImpl<$Res>;
  $Res call(
      {List<int> ticketsPurchased,
      int selectedTicketCategoryIndex,
      List<EventTickets$Query$TicketCategories> ticketCategories,
      double sumOfPurchase,
      bool maxTicketReached});
}

/// @nodoc
class _$TicketPurchaseStateCopyWithImpl<$Res>
    implements $TicketPurchaseStateCopyWith<$Res> {
  _$TicketPurchaseStateCopyWithImpl(this._value, this._then);

  final TicketPurchaseState _value;
  // ignore: unused_field
  final $Res Function(TicketPurchaseState) _then;

  @override
  $Res call({
    Object? ticketsPurchased = freezed,
    Object? selectedTicketCategoryIndex = freezed,
    Object? ticketCategories = freezed,
    Object? sumOfPurchase = freezed,
    Object? maxTicketReached = freezed,
  }) {
    return _then(_value.copyWith(
      ticketsPurchased: ticketsPurchased == freezed
          ? _value.ticketsPurchased
          : ticketsPurchased // ignore: cast_nullable_to_non_nullable
              as List<int>,
      selectedTicketCategoryIndex: selectedTicketCategoryIndex == freezed
          ? _value.selectedTicketCategoryIndex
          : selectedTicketCategoryIndex // ignore: cast_nullable_to_non_nullable
              as int,
      ticketCategories: ticketCategories == freezed
          ? _value.ticketCategories
          : ticketCategories // ignore: cast_nullable_to_non_nullable
              as List<EventTickets$Query$TicketCategories>,
      sumOfPurchase: sumOfPurchase == freezed
          ? _value.sumOfPurchase
          : sumOfPurchase // ignore: cast_nullable_to_non_nullable
              as double,
      maxTicketReached: maxTicketReached == freezed
          ? _value.maxTicketReached
          : maxTicketReached // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$TicketPurchaseStateCopyWith<$Res>
    implements $TicketPurchaseStateCopyWith<$Res> {
  factory _$TicketPurchaseStateCopyWith(_TicketPurchaseState value,
          $Res Function(_TicketPurchaseState) then) =
      __$TicketPurchaseStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<int> ticketsPurchased,
      int selectedTicketCategoryIndex,
      List<EventTickets$Query$TicketCategories> ticketCategories,
      double sumOfPurchase,
      bool maxTicketReached});
}

/// @nodoc
class __$TicketPurchaseStateCopyWithImpl<$Res>
    extends _$TicketPurchaseStateCopyWithImpl<$Res>
    implements _$TicketPurchaseStateCopyWith<$Res> {
  __$TicketPurchaseStateCopyWithImpl(
      _TicketPurchaseState _value, $Res Function(_TicketPurchaseState) _then)
      : super(_value, (v) => _then(v as _TicketPurchaseState));

  @override
  _TicketPurchaseState get _value => super._value as _TicketPurchaseState;

  @override
  $Res call({
    Object? ticketsPurchased = freezed,
    Object? selectedTicketCategoryIndex = freezed,
    Object? ticketCategories = freezed,
    Object? sumOfPurchase = freezed,
    Object? maxTicketReached = freezed,
  }) {
    return _then(_TicketPurchaseState(
      ticketsPurchased: ticketsPurchased == freezed
          ? _value.ticketsPurchased
          : ticketsPurchased // ignore: cast_nullable_to_non_nullable
              as List<int>,
      selectedTicketCategoryIndex: selectedTicketCategoryIndex == freezed
          ? _value.selectedTicketCategoryIndex
          : selectedTicketCategoryIndex // ignore: cast_nullable_to_non_nullable
              as int,
      ticketCategories: ticketCategories == freezed
          ? _value.ticketCategories
          : ticketCategories // ignore: cast_nullable_to_non_nullable
              as List<EventTickets$Query$TicketCategories>,
      sumOfPurchase: sumOfPurchase == freezed
          ? _value.sumOfPurchase
          : sumOfPurchase // ignore: cast_nullable_to_non_nullable
              as double,
      maxTicketReached: maxTicketReached == freezed
          ? _value.maxTicketReached
          : maxTicketReached // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_TicketPurchaseState implements _TicketPurchaseState {
  const _$_TicketPurchaseState(
      {required this.ticketsPurchased,
      required this.selectedTicketCategoryIndex,
      required this.ticketCategories,
      required this.sumOfPurchase,
      required this.maxTicketReached});

  @override
  final List<int> ticketsPurchased;
  @override
  final int selectedTicketCategoryIndex;
  @override
  final List<EventTickets$Query$TicketCategories> ticketCategories;
  @override
  final double sumOfPurchase;
  @override
  final bool maxTicketReached;

  @override
  String toString() {
    return 'TicketPurchaseState(ticketsPurchased: $ticketsPurchased, selectedTicketCategoryIndex: $selectedTicketCategoryIndex, ticketCategories: $ticketCategories, sumOfPurchase: $sumOfPurchase, maxTicketReached: $maxTicketReached)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TicketPurchaseState &&
            const DeepCollectionEquality()
                .equals(other.ticketsPurchased, ticketsPurchased) &&
            const DeepCollectionEquality().equals(
                other.selectedTicketCategoryIndex,
                selectedTicketCategoryIndex) &&
            const DeepCollectionEquality()
                .equals(other.ticketCategories, ticketCategories) &&
            const DeepCollectionEquality()
                .equals(other.sumOfPurchase, sumOfPurchase) &&
            const DeepCollectionEquality()
                .equals(other.maxTicketReached, maxTicketReached));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(ticketsPurchased),
      const DeepCollectionEquality().hash(selectedTicketCategoryIndex),
      const DeepCollectionEquality().hash(ticketCategories),
      const DeepCollectionEquality().hash(sumOfPurchase),
      const DeepCollectionEquality().hash(maxTicketReached));

  @JsonKey(ignore: true)
  @override
  _$TicketPurchaseStateCopyWith<_TicketPurchaseState> get copyWith =>
      __$TicketPurchaseStateCopyWithImpl<_TicketPurchaseState>(
          this, _$identity);
}

abstract class _TicketPurchaseState implements TicketPurchaseState {
  const factory _TicketPurchaseState(
      {required List<int> ticketsPurchased,
      required int selectedTicketCategoryIndex,
      required List<EventTickets$Query$TicketCategories> ticketCategories,
      required double sumOfPurchase,
      required bool maxTicketReached}) = _$_TicketPurchaseState;

  @override
  List<int> get ticketsPurchased;
  @override
  int get selectedTicketCategoryIndex;
  @override
  List<EventTickets$Query$TicketCategories> get ticketCategories;
  @override
  double get sumOfPurchase;
  @override
  bool get maxTicketReached;
  @override
  @JsonKey(ignore: true)
  _$TicketPurchaseStateCopyWith<_TicketPurchaseState> get copyWith =>
      throw _privateConstructorUsedError;
}
