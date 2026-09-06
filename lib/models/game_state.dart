import 'ludo_rules.dart';

/// Represents the position of a token
enum TokenLocation {
  home, // In the starting area
  onBoard, // On the main path or home lane
  finished, // Reached the final position
}

/// Represents a single token's state
class TokenState {
  final int player;
  final int tokenId;
  int progress; // 0 = first cell after entering, finishPosition = home
  TokenLocation location;

  TokenState({
    required this.player,
    required this.tokenId,
    this.progress = 0,
    this.location = TokenLocation.home,
  });

  TokenState copyWith({
    int? progress,
    TokenLocation? location,
  }) {
    return TokenState(
      player: player,
      tokenId: tokenId,
      progress: progress ?? this.progress,
      location: location ?? this.location,
    );
  }
}

/// Manages the complete game state
class LudoGameState {
  final LudoRules rules;
  final List<List<TokenState>> tokens;
  int currentPlayer;
  int? lastDiceValue;
  int consecutiveSixes;
  int? winner;
  bool gameOver;

  LudoGameState({
    required this.rules,
    this.currentPlayer = 0,
    this.lastDiceValue,
    this.consecutiveSixes = 0,
    this.winner,
    this.gameOver = false,
  }) : tokens = List.generate(
          4,
          (player) => List.generate(
            rules.tokensPerPlayer,
            (tokenId) => TokenState(
              player: player,
              tokenId: tokenId,
            ),
          ),
        );

  /// Get all tokens for a specific player
  List<TokenState> getPlayerTokens(int player) => tokens[player];

  /// Get a specific token
  TokenState getToken(int player, int tokenId) => tokens[player][tokenId];

  /// Get tokens that are on the board (not in home or finished)
  List<TokenState> getTokensOnBoard(int player) {
    return tokens[player]
        .where((token) => token.location == TokenLocation.onBoard)
        .toList();
  }

  /// Get tokens still in home
  List<TokenState> getTokensInHome(int player) {
    return tokens[player]
        .where((token) => token.location == TokenLocation.home)
        .toList();
  }

  /// Get finished tokens
  List<TokenState> getFinishedTokens(int player) {
    return tokens[player]
        .where((token) => token.location == TokenLocation.finished)
        .toList();
  }

  /// Check if a player can enter a token from home
  bool canEnterToken(int player, int diceValue) {
    if (!rules.canEnterBoard(diceValue)) return false;
    return getTokensInHome(player).isNotEmpty;
  }

  /// Check if a token can move with the current dice value
  bool canMoveToken(int player, int tokenId, int diceValue) {
    if (diceValue < 1 || diceValue > rules.diceSides) return false;

    final token = getToken(player, tokenId);

    // Token in home can only move if dice allows entry
    if (token.location == TokenLocation.home) {
      return rules.canEnterBoard(diceValue);
    }

    // Token already finished cannot move
    if (token.location == TokenLocation.finished) {
      return false;
    }

    // Check if move would exceed finish position
    final newProgress = token.progress + diceValue;
    if (rules.mustLandExactly) {
      return newProgress <= rules.finishPosition;
    } else {
      return newProgress <= rules.finishPosition;
    }
  }

  /// Get all movable tokens for the current player
  List<int> getMovableTokens(int player, int diceValue) {
    final movable = <int>[];

    for (var i = 0; i < rules.tokensPerPlayer; i++) {
      if (canMoveToken(player, i, diceValue)) {
        movable.add(i);
      }
    }

    return movable;
  }

  /// Check if a player has any valid moves
  bool hasValidMoves(int player, int diceValue) {
    return getMovableTokens(player, diceValue).isNotEmpty;
  }

  /// Calculate destination cell for a token after moving
  int? calculateDestinationCell(int player, int tokenId, int diceValue) {
    final token = getToken(player, tokenId);

    if (token.location == TokenLocation.home) {
      if (!rules.canEnterBoard(diceValue)) return null;
      return 0; // First position after entering
    }

    if (token.location == TokenLocation.finished) {
      return null;
    }

    final newProgress = token.progress + diceValue;
    if (newProgress > rules.finishPosition) {
      if (rules.mustLandExactly) return null;
      return rules.finishPosition;
    }

    return newProgress;
  }

  /// Move a token and update game state
  MoveResult moveToken(int player, int tokenId, int diceValue) {
    if (!canMoveToken(player, tokenId, diceValue)) {
      return MoveResult.illegal;
    }

    final token = getToken(player, tokenId);
    final capturedTokens = <TokenState>[];

    // Handle token entering from home
    if (token.location == TokenLocation.home) {
      token.location = TokenLocation.onBoard;
      token.progress = 0;
    } else {
      // Move token on board
      final newProgress = token.progress + diceValue;

      if (newProgress >= rules.finishPosition) {
        token.progress = rules.finishPosition;
        token.location = TokenLocation.finished;

        // Check if player won
        if (checkPlayerWon(player)) {
          winner = player;
          gameOver = true;
          return MoveResult.won;
        }

        return MoveResult.finished;
      } else {
        token.progress = newProgress;

        // Check for captures
        if (rules.captureEnabled) {
          capturedTokens.addAll(_checkCaptures(player, token));
        }
      }
    }

    if (capturedTokens.isNotEmpty) {
      return MoveResult.captured;
    }

    return MoveResult.normal;
  }

  /// Check if any opponent tokens are captured at the given position
  List<TokenState> _checkCaptures(int player, TokenState movingToken) {
    final captured = <TokenState>[];
    final destinationCell = movingToken.progress;

    // Check if destination is a safe cell
    if (_isProgressOnSafeCell(player, destinationCell)) {
      return captured;
    }

    // Check all opponent tokens
    for (var opponentPlayer = 0; opponentPlayer < rules.playerCount; opponentPlayer++) {
      if (opponentPlayer == player) continue;

      for (var opponentToken in getTokensOnBoard(opponentPlayer)) {
        // Check if opponent token is at the same cell
        if (_areTokensOnSameCell(player, movingToken.progress, opponentPlayer, opponentToken.progress)) {
          // Capture the token - send it back home
          opponentToken.location = TokenLocation.home;
          opponentToken.progress = 0;
          captured.add(opponentToken);
        }
      }
    }

    return captured;
  }

  /// Check if two tokens are on the same cell (considering different player paths)
  bool _areTokensOnSameCell(int player1, int progress1, int player2, int progress2) {
    // This is simplified - you'd need proper path mapping
    // For now, assume same progress means same cell if both are on main path
    if (progress1 > rules.mainPathSteps || progress2 > rules.mainPathSteps) {
      return false; // One or both are in home lane
    }
    return progress1 == progress2;
  }

  /// Check if a progress position corresponds to a safe cell
  bool _isProgressOnSafeCell(int player, int progress) {
    // This needs proper mapping between progress and actual cell numbers
    // For now, safe cells are at specific progress points
    final safeCellProgresses = {0, 8, 13, 21, 26, 34, 39, 47};
    return safeCellProgresses.contains(progress);
  }

  /// Check if a player has won (all tokens finished)
  bool checkPlayerWon(int player) {
    return getFinishedTokens(player).length == rules.tokensPerPlayer;
  }

  /// Handle end of turn logic
  void endTurn(int diceValue) {
    // Check if player gets extra turn
    if (rules.grantsExtraTurn(diceValue)) {
      consecutiveSixes++;

      // Check if max consecutive sixes reached
      if (consecutiveSixes >= rules.maxConsecutiveSixes) {
        _switchPlayer();
        consecutiveSixes = 0;
      }
      // Otherwise, same player goes again
    } else {
      _switchPlayer();
      consecutiveSixes = 0;
    }

    lastDiceValue = null;
  }

  /// Switch to the next player
  void _switchPlayer() {
    currentPlayer = (currentPlayer + 1) % rules.playerCount;
  }

  /// Reset the game
  void reset() {
    currentPlayer = 0;
    lastDiceValue = null;
    consecutiveSixes = 0;
    winner = null;
    gameOver = false;

    for (var playerTokens in tokens) {
      for (var token in playerTokens) {
        token.location = TokenLocation.home;
        token.progress = 0;
      }
    }
  }
}

/// Result of a token move
enum MoveResult {
  normal, // Normal move
  captured, // Captured opponent token(s)
  finished, // Token reached finish
  won, // Player won the game
  illegal, // Illegal move
}
