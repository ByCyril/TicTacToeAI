

from keras.preprocessing import sequence
from keras.models import Sequential
from keras.layers.core import Dense, Activation
from keras.layers.embeddings import Embedding
from keras.layers.recurrent import GRU
import numpy as np
import coremltools

winning_combo = []
winners = []

items_to_skip = []

with open('Dataset/winning_combo.txt', 'r') as fh:
	i = 0
	for line in fh:
		l = line[1:len(line) - 2]
		arr = [int(s) for s in l.split(',')]
		if arr not in winning_combo:
			winning_combo.append(arr)
		else:
			items_to_skip.append(i)
		i += 1

with open('Dataset/winners.txt', 'r') as fh:
	i = 0
	for line in fh:
		if i not in items_to_skip:
			l = int(line[1])
			winners.append([l])
		i += 1

print(len(winning_combo), len(winners))



winning_combo = np.array(winning_combo)
winners = np.array(winners)

model = Sequential()

input_layer = Dense(9, input_shape=[9], activation='tanh')
model.add(input_layer)

output_layer = Dense(1, activation='sigmoid')
model.add(output_layer)

model.compile(optimizer='rmsprop',loss='binary_crossentropy')


model.fit(winning_combo, winners,epochs=50,steps_per_epoch=50)

model.save('TicTacToeAI.h5')

coreml_model = coremltools.converters.keras.convert(
    model, input_names=['board_state'], output_names=['winning_probability'])
coreml_model.save('TicTacToeAI.mlmodel')



















