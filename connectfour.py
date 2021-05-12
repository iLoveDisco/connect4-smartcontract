#! /usr/bin/env python3
from itertools import groupby, chain

NONE = '.'
RED = 'R'
YELLOW = 'Y'

class Game:
	def __init__ (self, cols = 7, rows = 6):
		"""Create a new game."""
		self.cols = cols
		self.rows = rows
		self.board = [[NONE] * rows for _ in range(cols)]
		self.whosTurn = YELLOW

	def insert (self, column, color):
		"""Insert the color in the given column."""
		c = self.board[column]
		if c[0] != NONE:
			raise Exception('Column is full')

		i = -1
		while c[i] != NONE:
			i -= 1
		c[i] = color

		return self.printBoard()

	def printBoard (self):
		output = '  '.join(map(str, range(self.cols))) + '\n'
		for y in range(self.rows):
			output = output + '  '.join(str(self.board[x][y]) for x in range(self.cols))
			output = output + '\n'
		output = output + '\n'
		return output