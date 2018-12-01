
from tensorflow import keras
import tensorflow as tf
import numpy as np

winning_combo = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
board_state = [0,0,0,0,0,0,0,0,0]
normal_board_state = ['•','•','•','•','•','•','•','•','•']

model = keras.Sequential()

input_layer = keras.layers.Dense(9, input_shape=[9], activation='tanh')
model.add(input_layer)

output_layer = keras.layers.Dense(1, activation='sigmoid')
model.add(output_layer)
model.load_weights('ttt.h5')


game_in_session = False

def play():
	global game_in_session
	game_in_session = True
	# get_user_input()
	AI()

def show_board_state():
	print(normal_board_state[0],normal_board_state[1],normal_board_state[2])
	print(normal_board_state[3],normal_board_state[4],normal_board_state[5])
	print(normal_board_state[6],normal_board_state[7],normal_board_state[8])

def AI():

	probAI = []

	for i in range(len(board_state)):
		if board_state[i] == 0:
			custom_state = board_state
			custom_state[i] = -1
			state = np.array([custom_state])
			res = float(model.predict(state))
			probAI.append(res)
			custom_state[i] = 0
		else:
			probAI.append(0)



	highestProb = -1
	hprob = 0

	for i in range(len(probAI)):
		if probAI[i] > hprob:
			highestProb = i
			hprob = probAI[i]

	board_state[highestProb] = -1
	normal_board_state[highestProb] = 'O'
	show_board_state()
	check_winner()

	if game_in_session:
		get_user_input()

def get_user_input():
	user_input = int(input('Play: '))
	if board_state[user_input - 1] == 0:
		board_state[user_input - 1] = 1
		normal_board_state[user_input - 1] = 'X'
	else:
		get_user_input()

	check_winner()

	if game_in_session:
		AI()

def check_winner():
	global game_in_session


	for combo in winning_combo:
		x = combo[0]
		y = combo[1]
		z = combo[2]

		if board_state[x] == board_state[y] and board_state[x] == board_state[z] and board_state[x] != 0:
			if board_state[x] == 1:
				print('You Win!')
				with open('Dataset/winning_combo.txt', 'a') as winning_c:
					winning_c.write('[' + ",".join(map(str, board_state)) +']\n')
				with open('Dataset/winners.txt', 'a') as win:
					win.write('[0]\n')

				print(board_state, 0)
				game_in_session = False
				break
			else:
				print('AI Wins!')
				with open('Dataset/winning_combo.txt', 'a') as winning_c:
					winning_c.write('[' + ",".join(map(str, board_state)) +']\n')
				with open('Dataset/winners.txt', 'a') as win:
					win.write('[1]\n')
				print(board_state, 1)
				game_in_session = False
				break
	print('')

play()
