grid = dict()
north = '^'
south = 'v'
east = '>'
west = '<'
pos_santa = (0,0)
pos_robo_santa = (0,0)

def move_santa(direction, pos):
	if direction == north:
		pos = (pos[0], pos[1] - 1)
	if direction == south:
		pos = (pos[0], pos[1] + 1)
	if direction == east:
		pos = (pos[0] + 1, pos[1])
	if direction == west:
		pos = (pos[0] - 1, pos[1])
	grid.setdefault(pos, 0)
	grid[pos] = grid[pos] + 1
	return pos


with open('input.txt') as f:
	grid[pos_santa] = 1
	for i,d in enumerate(f.read()):
		if i % 2 == 1:
			pos_robo_santa = move_santa(d, pos_robo_santa)
		else:
			pos_santa = move_santa(d, pos_santa)
	print len(grid)

