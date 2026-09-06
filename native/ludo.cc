#include "ludo.h"

#include <algorithm>
#include <random>

namespace {

std::mt19937& random_engine() {
	static std::mt19937 engine(std::random_device{}());
	return engine;
}

bool valid_player(int player) {
	return player >= 0 && player < LUDO_PLAYER_COUNT;
}

bool valid_piece(int piece) {
	return piece >= 0 && piece < LUDO_PIECES_PER_PLAYER;
}

bool player_has_won(const LudoGameState* game, int player) {
	for (int piece = 0; piece < LUDO_PIECES_PER_PLAYER; ++piece) {
		if (game->positions[player][piece] != LUDO_FINISH) {
			return false;
		}
	}
	return true;
}

}  // namespace

LudoGameState* ludo_create() {
	LudoGameState* game = new LudoGameState;
	ludo_init(game);
	return game;
}

void ludo_destroy(LudoGameState* game) {
	delete game;
}

void ludo_seed(unsigned int seed) {
	random_engine().seed(seed);
}

void ludo_init(LudoGameState* game) {
	if (game == nullptr) {
		return;
	}

	game->current_player = 0;
	game->dice_value = 0;
	game->winner = -1;
	game->game_over = 0;

	for (int player = 0; player < LUDO_PLAYER_COUNT; ++player) {
		for (int piece = 0; piece < LUDO_PIECES_PER_PLAYER; ++piece) {
			game->positions[player][piece] = LUDO_HOME;
		}
	}
}

int ludo_roll_dice(LudoGameState* game) {
	if (game == nullptr || game->game_over != 0) {
		return 0;
	}

	std::uniform_int_distribution<int> distribution(1, 6);
	game->dice_value = distribution(random_engine());
	return game->dice_value;
}

int ludo_can_move(const LudoGameState* game, int player, int piece) {
	if (game == nullptr || game->game_over != 0 ||
			player != game->current_player || !valid_player(player) ||
			!valid_piece(piece) || game->dice_value < 1 || game->dice_value > 6) {
		return 0;
	}

	const int position = game->positions[player][piece];
	if (position == LUDO_HOME) {
		return game->dice_value == 6 ? 1 : 0;
	}
	if (position == LUDO_FINISH) {
		return 0;
	}

	return position + game->dice_value <= LUDO_FINISH ? 1 : 0;
}

int ludo_move_piece(LudoGameState* game, int player, int piece) {
	if (!ludo_can_move(game, player, piece)) {
		return 0;
	}

	int& position = game->positions[player][piece];
	if (position == LUDO_HOME) {
		position = 0;
	} else {
		position = std::min(position + game->dice_value, static_cast<int>(LUDO_FINISH));
	}

	if (player_has_won(game, player)) {
		game->winner = player;
		game->game_over = 1;
	}
	return 1;
}

void ludo_end_turn(LudoGameState* game) {
	if (game == nullptr || game->game_over != 0) {
		return;
	}

	game->current_player = (game->current_player + 1) % LUDO_PLAYER_COUNT;
	game->dice_value = 0;
}
