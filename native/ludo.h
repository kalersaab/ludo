#ifndef LUDO_H
#define LUDO_H

#ifdef __cplusplus
extern "C" {
#endif

enum {
	LUDO_PLAYER_COUNT = 4,
	LUDO_PIECES_PER_PLAYER = 4,
	LUDO_HOME = -1,
	LUDO_FINISH = 57,
};

typedef struct {
	int current_player;
	int dice_value;
	int positions[LUDO_PLAYER_COUNT][LUDO_PIECES_PER_PLAYER];
	int winner;
	int game_over;
} LudoGameState;

LudoGameState* ludo_create();
void ludo_destroy(LudoGameState* game);
void ludo_seed(unsigned int seed);
void ludo_init(LudoGameState* game);
int ludo_roll_dice(LudoGameState* game);
int ludo_can_move(const LudoGameState* game, int player, int piece);
int ludo_move_piece(LudoGameState* game, int player, int piece);
void ludo_end_turn(LudoGameState* game);

#ifdef __cplusplus
}
#endif

#endif
