import 'package:flutter/material.dart';

class DiceControls extends StatelessWidget {
  final String currentPlayer;
  final int diceValue;
  final VoidCallback onRollDice;

  const DiceControls({
    super.key,
    required this.currentPlayer,
    required this.diceValue,
    required this.onRollDice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Current: $currentPlayer',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton.icon(
            onPressed: onRollDice,
            icon: const Icon(Icons.casino),
            label: Text('$diceValue'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
