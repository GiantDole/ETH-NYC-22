// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ticket_purchase_bottom_sheet_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TicketPurchaseBottomSheetStateTearOff {
  const _$TicketPurchaseBottomSheetStateTearOff();

  _TicketPurchaseBottomSheetState call(
      {required PanelController panelController, required bool panelListener}) {
    return _TicketPurchaseBottomSheetState(
      panelController: panelController,
      panelListener: panelListener,
    );
  }
}

/// @nodoc
const $TicketPurchaseBottomSheetState =
    _$TicketPurchaseBottomSheetStateTearOff();

/// @nodoc
mixin _$TicketPurchaseBottomSheetState {
  PanelController get panelController => throw _privateConstructorUsedError;
  bool get panelListener => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketPurchaseBottomSheetStateCopyWith<TicketPurchaseBottomSheetState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketPurchaseBottomSheetStateCopyWith<$Res> {
  factory $TicketPurchaseBottomSheetStateCopyWith(
          TicketPurchaseBottomSheetState value,
          $Res Function(TicketPurchaseBottomSheetState) then) =
      _$TicketPurchaseBottomSheetStateCopyWithImpl<$Res>;
  $Res call({PanelController panelController, bool panelListener});
}

/// @nodoc
class _$TicketPurchaseBottomSheetStateCopyWithImpl<$Res>
    implements $TicketPurchaseBottomSheetStateCopyWith<$Res> {
  _$TicketPurchaseBottomSheetStateCopyWithImpl(this._value, this._then);

  final TicketPurchaseBottomSheetState _value;
  // ignore: unused_field
  final $Res Function(TicketPurchaseBottomSheetState) _then;

  @override
  $Res call({
    Object? panelController = freezed,
    Object? panelListener = freezed,
  }) {
    return _then(_value.copyWith(
      panelController: panelController == freezed
          ? _value.panelController
          : panelController // ignore: cast_nullable_to_non_nullable
              as PanelController,
      panelListener: panelListener == freezed
          ? _value.panelListener
          : panelListener // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$TicketPurchaseBottomSheetStateCopyWith<$Res>
    implements $TicketPurchaseBottomSheetStateCopyWith<$Res> {
  factory _$TicketPurchaseBottomSheetStateCopyWith(
          _TicketPurchaseBottomSheetState value,
          $Res Function(_TicketPurchaseBottomSheetState) then) =
      __$TicketPurchaseBottomSheetStateCopyWithImpl<$Res>;
  @override
  $Res call({PanelController panelController, bool panelListener});
}

/// @nodoc
class __$TicketPurchaseBottomSheetStateCopyWithImpl<$Res>
    extends _$TicketPurchaseBottomSheetStateCopyWithImpl<$Res>
    implements _$TicketPurchaseBottomSheetStateCopyWith<$Res> {
  __$TicketPurchaseBottomSheetStateCopyWithImpl(
      _TicketPurchaseBottomSheetState _value,
      $Res Function(_TicketPurchaseBottomSheetState) _then)
      : super(_value, (v) => _then(v as _TicketPurchaseBottomSheetState));

  @override
  _TicketPurchaseBottomSheetState get _value =>
      super._value as _TicketPurchaseBottomSheetState;

  @override
  $Res call({
    Object? panelController = freezed,
    Object? panelListener = freezed,
  }) {
    return _then(_TicketPurchaseBottomSheetState(
      panelController: panelController == freezed
          ? _value.panelController
          : panelController // ignore: cast_nullable_to_non_nullable
              as PanelController,
      panelListener: panelListener == freezed
          ? _value.panelListener
          : panelListener // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_TicketPurchaseBottomSheetState
    implements _TicketPurchaseBottomSheetState {
  const _$_TicketPurchaseBottomSheetState(
      {required this.panelController, required this.panelListener});

  @override
  final PanelController panelController;
  @override
  final bool panelListener;

  @override
  String toString() {
    return 'TicketPurchaseBottomSheetState(panelController: $panelController, panelListener: $panelListener)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TicketPurchaseBottomSheetState &&
            const DeepCollectionEquality()
                .equals(other.panelController, panelController) &&
            const DeepCollectionEquality()
                .equals(other.panelListener, panelListener));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(panelController),
      const DeepCollectionEquality().hash(panelListener));

  @JsonKey(ignore: true)
  @override
  _$TicketPurchaseBottomSheetStateCopyWith<_TicketPurchaseBottomSheetState>
      get copyWith => __$TicketPurchaseBottomSheetStateCopyWithImpl<
          _TicketPurchaseBottomSheetState>(this, _$identity);
}

abstract class _TicketPurchaseBottomSheetState
    implements TicketPurchaseBottomSheetState {
  const factory _TicketPurchaseBottomSheetState(
      {required PanelController panelController,
      required bool panelListener}) = _$_TicketPurchaseBottomSheetState;

  @override
  PanelController get panelController;
  @override
  bool get panelListener;
  @override
  @JsonKey(ignore: true)
  _$TicketPurchaseBottomSheetStateCopyWith<_TicketPurchaseBottomSheetState>
      get copyWith => throw _privateConstructorUsedError;
}
