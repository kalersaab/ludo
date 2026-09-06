/// Configuration for Ludo game rules.
/// This allows different rule variants to be implemented.
class LudoRules {
  /// Number of players (2-4)
  final int playerCount;

  /// Number of tokens per player (typically 4)
  final int tokensPerPlayer;

  /// Number of sides on the dice (typically 6)
  final int diceSides;

  /// Dice value required to enter the board from home
  final int entryDiceValue;

  /// Total steps in the main path (not including home lane)
  final int mainPathSteps;

  /// Length of the home lane (final straight path)
  final int homeLaneLength;

  /// Whether rolling a 6 grants an extra turn
  final bool sixGrantsExtraTurn;

  /// Maximum consecutive sixes allowed before forfeiting turn
  final int maxConsecutiveSixes;

  /// Whether landing on an opponent token captures it
  final bool captureEnabled;

  /// Cell numbers that are safe (tokens cannot be captured)
  final Set<int> safeCells;

  /// Whether tokens stack on the same cell
  final bool allowStacking;

  /// Whether a token must land exactly on the finish position
  final bool mustLandExactly;

  const LudoRules({
    this.playerCount = 2,
    this.tokensPerPlayer = 4,
    this.diceSides = 6,
    this.entryDiceValue = 6,
    this.mainPathSteps = 51,
    this.homeLaneLength = 6,
    this.sixGrantsExtraTurn = true,
    this.maxConsecutiveSixes = 3,
    this.captureEnabled = true,
    this.safeCells = const {
      92, // Red starting cell
      24, // Green starting cell
      134, // Blue starting cell
      202, // Yellow starting cell
      22, // Star safe cell
      82, // Star safe cell
      132, // Star safe cell
      204, // Star safe cell
    },
    this.allowStacking = true,
    this.mustLandExactly = true,
  });

  /// Standard Ludo rules (Classic variant)
  const LudoRules.standard({
    int playerCount = 4,
  }) : this(
          playerCount: playerCount,
          tokensPerPlayer: 4,
          diceSides: 6,
          entryDiceValue: 6,
          mainPathSteps: 51,
          homeLaneLength: 6,
          sixGrantsExtraTurn: true,
          maxConsecutiveSixes: 3,
          captureEnabled: true,
          safeCells: const {
            92, 24, 134, 202, // Starting cells
            22, 82, 132, 204, // Star cells
          },
          allowStacking: true,
          mustLandExactly: true,
        );

  /// Quick game variant (shorter game)
  const LudoRules.quick({
    int playerCount = 2,
  }) : this(
          playerCount: playerCount,
          tokensPerPlayer: 2,
          diceSides: 6,
          entryDiceValue: 6,
          mainPathSteps: 51,
          homeLaneLength: 6,
          sixGrantsExtraTurn: true,
          maxConsecutiveSixes: 3,
          captureEnabled: true,
          safeCells: const {92, 24, 134, 202, 22, 82, 132, 204},
          allowStacking: true,
          mustLandExactly: false,
        );

  /// Total path length including home lane
  int get totalPathLength => mainPathSteps + homeLaneLength;

  /// Check if a dice value allows token entry
  bool canEnterBoard(int diceValue) => diceValue == entryDiceValue;

  /// Check if a dice value grants an extra turn
  bool grantsExtraTurn(int diceValue) =>
      sixGrantsExtraTurn && diceValue == diceSides;

  /// Check if a cell is a safe cell
  bool isSafeCell(int cellNumber) => safeCells.contains(cellNumber);

  /// Calculate the finish position index
  int get finishPosition => totalPathLength - 1;
}
