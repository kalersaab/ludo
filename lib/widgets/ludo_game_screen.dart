import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../native_ludo.dart';
import 'ludo_board.dart';
import 'dice_controls.dart';

class LudoGameScreen extends StatefulWidget {
  const LudoGameScreen({super.key});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int diceValue = 1;
  String currentPlayer = 'Red';
  NativeLudoGame? nativeGame;
  final List<Set<int>> movedPieces = [<int>{}, <int>{}, <int>{}, <int>{}];

  int get currentPlayerIndex => <String>['Red', 'Green', 'Blue', 'Yellow']
      .indexOf(currentPlayer);

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
    setState(() {
      diceValue = nativeGame?.rollDice() ?? math.Random().nextInt(6) + 1;
    });
  }

  void moveToken(int piece) {
    if (diceValue != 6 || movedPieces[currentPlayerIndex].contains(piece)) {
      return;
    }

    final moved = nativeGame?.movePiece(currentPlayerIndex, piece) ?? true;
    if (!moved) {
      return;
    }

    setState(() {
      movedPieces[currentPlayerIndex].add(piece);
      nativeGame?.endTurn();
      currentPlayer = <String>['Red', 'Green', 'Blue', 'Yellow'][
        (currentPlayerIndex + 1) % 4
      ];
      diceValue = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Ludo Game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LudoBoard(
                    currentPlayer: currentPlayer,
                    diceValue: diceValue,
                    movedPieces: movedPieces,
                    onTokenTap: moveToken,
                  ),
                  const SizedBox(height: 16),
                  DiceControls(
                    currentPlayer: currentPlayer,
                    diceValue: diceValue,
                    onRollDice: rollDice,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
