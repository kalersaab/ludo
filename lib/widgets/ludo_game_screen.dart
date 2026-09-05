import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'ludo_board.dart';
import 'dice_controls.dart';

class LudoGameScreen extends StatefulWidget {
  const LudoGameScreen({super.key});

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> {
  int diceValue = 6;
  String currentPlayer = 'Red';

  void rollDice() {
    setState(() {
      diceValue = math.Random().nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Ludo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ludo Board
                const LudoBoard(),
                const SizedBox(height: 20),
                // Dice Controls
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
    );
  }
}
