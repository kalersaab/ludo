import 'package:flutter/material.dart';

import 'dart:math' as math;

import '../native_ludo.dart';
import 'ludo_board.dart';
import 'dice_controls.dart';

class LudoGameScreen extends StatefulWidget {
  final int playerCount;
  final bool playWithComputer;

  const LudoGameScreen({
    super.key,
    this.playerCount = 4,
    this.playWithComputer = false,
  });

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int diceValue = 1;
  String currentPlayer = 'Red';
  NativeLudoGame? nativeGame;
  bool resolvingRoll = false;
  bool awaitingTokenSelection = false;
  final List<Set<int>> movedPieces = [<int>{}, <int>{}, <int>{}, <int>{}];
  final List<Map<int, int>> piecePositions = List.generate(4, (_) => {});

  int get currentPlayerIndex => _activePlayers.indexOf(currentPlayer);

  List<String> get _activePlayers => widget.playWithComputer
      ? <String>['Red', 'Green']
      : <String>[
          'Red',
          'Green',
          'Blue',
          'Yellow',
        ].take(widget.playerCount).toList();

  bool get _isComputerTurn =>
      widget.playWithComputer && currentPlayer == 'Green';

  int? _firstAvailablePiece() {
    for (int piece = 0; piece < 4; piece++) {
      if (!movedPieces[currentPlayerIndex].contains(piece)) {
        return piece;
      }
    }
    return null;
  }

  static const _mainRoutes = <List<int>>[
    [
      92,
      93,
      94,
      95,
      96,
      82,
      67,
      52,
      37,
      22,
      7,
      8,
      9,
      24,
      39,
      54,
      69,
      84,
      100,
      101,
      102,
      103,
      104,
      105,
      120,
      135,
      134,
      133,
      132,
      131,
      130,
      144,
      159,
      174,
      189,
      204,
      219,
      218,
      217,
      202,
      187,
      172,
      157,
      142,
      126,
      125,
      124,
      123,
      122,
      121,
      106,
      91,
      92,
    ],
    [
      24,
      39,
      54,
      69,
      84,
      100,
      101,
      102,
      103,
      104,
      105,
      120,
      135,
      134,
      133,
      132,
      131,
      130,
      144,
      159,
      174,
      189,
      204,
      219,
      218,
      217,
      202,
      187,
      172,
      157,
      142,
      126,
      125,
      124,
      123,
      122,
      121,
      106,
      91,
      92,
      93,
      94,
      95,
      96,
      82,
      67,
      52,
      37,
      22,
      7,
      8,
      9,
      24,
    ],
    [
      134,
      133,
      132,
      130,
      144,
      159,
      174,
      189,
      204,
      219,
      218,
      217,
      202,
      187,
      172,
      157,
      142,
      126,
      125,
      124,
      123,
      122,
      121,
      106,
      91,
      92,
      93,
      94,
      95,
      96,
      82,
      67,
      52,
      37,
      22,
      7,
      8,
      9,
      24,
      39,
      54,
      69,
      84,
      100,
      101,
      102,
      103,
      104,
      105,
      120,
      119,
      118,
      117,
      116,
      115,
      114,
    ],
    [
      202,
      187,
      172,
      157,
      142,
      126,
      125,
      124,
      123,
      122,
      121,
      106,
      91,
      92,
      93,
      94,
      95,
      96,
      82,
      67,
      52,
      37,
      22,
      7,
      8,
      9,
      24,
      39,
      54,
      69,
      84,
      100,
      101,
      102,
      103,
      104,
      105,
      120,
      135,
      134,
      133,
      132,
      131,
      130,
      144,
      159,
      174,
      189,
      204,
      219,
      218,
      203,
      188,
      173,
      158,
      143,
      128,
    ],
  ];

  static const _routeIndexByPlayer = [0, 1, 3, 2];

  int? _cellAt(int player, int progress) {
    final route = _mainRoutes[_routeIndexByPlayer[player]];
    if (progress < 0 || progress >= route.length) {
      return null;
    }
    return route[progress];
  }

  bool _isCaptureTarget(int player, int progress, int destinationCell) {
    final route = _mainRoutes[_routeIndexByPlayer[player]];
    return progress < route.length &&
        _cellAt(player, progress) == destinationCell;
  }

  @override
  void initState() {
    super.initState();
    nativeGame = NativeLudoGame.tryCreate();
  }

  @override
  void dispose() {
    nativeGame?.dispose();
    super.dispose();
  }

  void rollDice() {
    if (resolvingRoll) {
      return;
    }

    final rolledValue = nativeGame?.rollDice() ?? math.Random().nextInt(6) + 1;

    setState(() {
      resolvingRoll = true;
      awaitingTokenSelection = false;
      diceValue = rolledValue;
    });

    Future<void>.delayed(const Duration(milliseconds: 750), () {
      if (!mounted || !resolvingRoll) {
        return;
      }

      if (rolledValue == 6) {
        setState(() {
          resolvingRoll = false;
          awaitingTokenSelection = true;
        });
        _computerChooseToken();
        return;
      }

      if (movedPieces[currentPlayerIndex].isEmpty) {
        _endTurnAfterRoll();
        return;
      }

      if (movedPieces[currentPlayerIndex].length == 1) {
        _moveTokenAfterRoll(movedPieces[currentPlayerIndex].first, rolledValue);
        return;
      }

      setState(() {
        resolvingRoll = false;
        awaitingTokenSelection = true;
      });
      _computerChooseToken();
    });
  }

  void _computerChooseToken() {
    if (!_isComputerTurn || !awaitingTokenSelection) {
      return;
    }

    final piece = diceValue == 6
        ? (_firstAvailablePiece() ??
              (movedPieces[currentPlayerIndex].isEmpty
                  ? null
                  : movedPieces[currentPlayerIndex].first))
        : (movedPieces[currentPlayerIndex].isEmpty
              ? null
              : movedPieces[currentPlayerIndex].first);
    if (piece != null) {
      moveToken(piece);
    }
  }

  void _endTurnAfterRoll() {
    setState(() {
      resolvingRoll = false;
      awaitingTokenSelection = false;
      nativeGame?.endTurn();
      currentPlayer =
          _activePlayers[(currentPlayerIndex + 1) % _activePlayers.length];
    });

    if (_isComputerTurn) {
      Future<void>.delayed(const Duration(milliseconds: 450), () {
        if (mounted && _isComputerTurn) {
          rollDice();
        }
      });
    }
  }

  void _moveTokenAfterRoll(int piece, int rolledValue) {
    final tokenWasOut = movedPieces[currentPlayerIndex].contains(piece);
    if (!tokenWasOut && rolledValue != 6) {
      return;
    }

    final previousProgress = piecePositions[currentPlayerIndex][piece] ?? 0;
    const finishProgress = 56;
    if (tokenWasOut && previousProgress + rolledValue > finishProgress) {
      if (rolledValue == 6) {
        setState(() {
          resolvingRoll = false;
          awaitingTokenSelection = true;
        });
        return;
      }

      if (movedPieces[currentPlayerIndex].length > 1) {
        setState(() {
          resolvingRoll = false;
          awaitingTokenSelection = true;
        });
        return;
      }

      _endTurnAfterRoll();
      return;
    }

    final moved = nativeGame?.movePiece(currentPlayerIndex, piece) ?? true;
    if (!moved) {
      return;
    }

    setState(() {
      resolvingRoll = false;
      awaitingTokenSelection = false;
      movedPieces[currentPlayerIndex].add(piece);
      final newProgress = tokenWasOut ? previousProgress + rolledValue : 0;
      piecePositions[currentPlayerIndex][piece] = newProgress;
      final destinationCell = _cellAt(currentPlayerIndex, newProgress);

      // Define safe cells:
      // - Starting cells for each player: 92 (Red), 24 (Green), 134 (Blue), 202 (Yellow)
      // - Star cells on the board at safe positions
      const protectedCells = {
        92,  // Red starting cell
        24,  // Green starting cell  
        134, // Blue starting cell
        202, // Yellow starting cell
        // Star safe cells (2 steps before each player's starting position)
        22,  // Star on Red's path (before 24)
        82,  // Star on Green's path (before 92)  
        132, // Star on Blue's path (before 134)
        204, // Star on Yellow's path (before 202)
      };
      if (destinationCell != null &&
          !protectedCells.contains(destinationCell)) {
        for (int opponent = 0; opponent < movedPieces.length; opponent++) {
          if (opponent == currentPlayerIndex) {
            continue;
          }

          final capturedPieces = movedPieces[opponent].where((opponentPiece) {
            final opponentProgress = piecePositions[opponent][opponentPiece];
            return opponentProgress != null &&
                _isCaptureTarget(opponent, opponentProgress, destinationCell);
          }).toList();

          for (final capturedPiece in capturedPieces) {
            movedPieces[opponent].remove(capturedPiece);
            piecePositions[opponent].remove(capturedPiece);
          }
        }
      }
    });

    if (rolledValue != 6) {
      _endTurnAfterRoll();
    }
  }

  void moveToken(int piece) {
    if (resolvingRoll ||
        !awaitingTokenSelection ||
        (diceValue != 6 && !movedPieces[currentPlayerIndex].contains(piece))) {
      return;
    }

    _moveTokenAfterRoll(piece, diceValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Ludo Game',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
                  final board = LudoBoard(
                    currentPlayer: currentPlayer,
                    diceValue: diceValue,
                    movedPieces: movedPieces,
                    piecePositions: piecePositions,
                    playerCount: _activePlayers.length,
                    canSelectTokens: awaitingTokenSelection && !_isComputerTurn,
                    onTokenTap: moveToken,
                  );
                  // Create dice controls for each player position
                  final redDice = DiceControls(
                    currentPlayer: 'Red',
                    diceValue: currentPlayer == 'Red' ? diceValue : 1,
                    enabled:
                        !resolvingRoll &&
                        !awaitingTokenSelection &&
                        !_isComputerTurn &&
                        currentPlayer == 'Red',
                    onRollDice: rollDice,
                  );

                  final greenDice = DiceControls(
                    currentPlayer: 'Green',
                    diceValue: currentPlayer == 'Green' ? diceValue : 1,
                    enabled:
                        !resolvingRoll &&
                        !awaitingTokenSelection &&
                        !_isComputerTurn &&
                        currentPlayer == 'Green',
                    onRollDice: rollDice,
                  );

                  final blueDice = DiceControls(
                    currentPlayer: 'Blue',
                    diceValue: currentPlayer == 'Blue' ? diceValue : 1,
                    enabled:
                        !resolvingRoll &&
                        !awaitingTokenSelection &&
                        !_isComputerTurn &&
                        currentPlayer == 'Blue',
                    onRollDice: rollDice,
                  );

                  final yellowDice = DiceControls(
                    currentPlayer: 'Yellow',
                    diceValue: currentPlayer == 'Yellow' ? diceValue : 1,
                    enabled:
                        !resolvingRoll &&
                        !awaitingTokenSelection &&
                        !_isComputerTurn &&
                        currentPlayer == 'Yellow',
                    onRollDice: rollDice,
                  );

                  return Stack(
                    children: [
                      // Main board in center with minimal padding for dice
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 80,
                          bottom: 80,
                          left: 8,
                          right: 8,
                        ),
                        child: Center(child: board),
                      ),
                      // Only show dice for current player
                      if (currentPlayer == 'Red')
                        Positioned(
                          top: 0,
                          left: 0,
                          child: redDice,
                        ),
                      if (currentPlayer == 'Green')
                        Positioned(
                          top: 0,
                          right: 0,
                          child: greenDice,
                        ),
                      if (currentPlayer == 'Blue')
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: blueDice,
                        ),
                      if (currentPlayer == 'Yellow')
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: yellowDice,
                        ),
                    ],
                  );
                },
              ),
    );
  }
}
