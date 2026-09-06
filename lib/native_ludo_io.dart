import 'dart:ffi';
import 'dart:io';

typedef _CreateNative = Pointer<Void> Function();
typedef _CreateDart = Pointer<Void> Function();
typedef _DestroyNative = Void Function(Pointer<Void>);
typedef _DestroyDart = void Function(Pointer<Void>);
typedef _RollNative = Int32 Function(Pointer<Void>);
typedef _RollDart = int Function(Pointer<Void>);
typedef _MoveNative = Int32 Function(Pointer<Void>, Int32, Int32);
typedef _MoveDart = int Function(Pointer<Void>, int, int);
typedef _EndTurnNative = Void Function(Pointer<Void>);
typedef _EndTurnDart = void Function(Pointer<Void>);

class NativeLudoGame {
  final Pointer<Void> _handle;
  final _RollDart _roll;
  final _MoveDart _move;
  final _EndTurnDart _endTurn;
  final _DestroyDart _destroy;

  NativeLudoGame._(
    this._handle,
    this._roll,
    this._move,
    this._endTurn,
    this._destroy,
  );

  static NativeLudoGame? tryCreate() {
    if (!Platform.isMacOS) {
      return null;
    }

    try {
      final library = DynamicLibrary.process();
      final create = library.lookupFunction<_CreateNative, _CreateDart>(
        'ludo_create',
      );
      final handle = create();
      if (handle == nullptr) {
        return null;
      }

      return NativeLudoGame._(
        handle,
        library.lookupFunction<_RollNative, _RollDart>('ludo_roll_dice'),
        library.lookupFunction<_MoveNative, _MoveDart>('ludo_move_piece'),
        library.lookupFunction<_EndTurnNative, _EndTurnDart>('ludo_end_turn'),
        library.lookupFunction<_DestroyNative, _DestroyDart>('ludo_destroy'),
      );
    } on Object {
      return null;
    }
  }

  int rollDice() => _roll(_handle);

  bool movePiece(int player, int piece) => _move(_handle, player, piece) != 0;

  void endTurn() => _endTurn(_handle);

  void dispose() {
    _destroy(_handle);
  }
}