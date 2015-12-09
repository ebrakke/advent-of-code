grid = [[0 for x in range(1000)] for y in range(1000)]

def parse_instruction(instr):
	s = instr.split(' ')
	if len(s) == 4:
		start = map(int, s[1].split(','))
		end = map(int, s[3].split(','))
		return ('t', start, end)
	start = map(int, s[2].split(','))
	end = map(int, s[4].split(','))
	i = 'o' if s[1] == 'on' else 'f'
	return (i, start, end)

def change_light(i, x, y):
	if i == 't':
		grid[x][y] = (grid[x][y] + 1) % 2
	if i == 'o':
		grid[x][y] = 1
	if i == 'f':
		grid[x][y] = 0

def new_change_light(i, x, y):
	if i == 't':
		grid[x][y] += 2
	if i == 'o':
		grid[x][y] += 1
	if i == 'f':
		grid[x][y] = max(0, grid[x][y] - 1)

def do_instruction(parsed_instr):
	i = parsed_instr[0]
	sx,sy = parsed_instr[1]
	ex,ey = parsed_instr[2]

	for x in range(sx, ex + 1):
		for y in range(sy, ey + 1):
			new_change_light(i, x, y)


def sum_grid():
	return sum(map(sum, [x for x in grid]))

with open('input.txt') as f:
	instr = f.readlines()
	count = 0
	for i in instr:
		print count
		parsed_instr = parse_instruction(i)
		do_instruction(parsed_instr)
		count += 1
	print sum_grid()

