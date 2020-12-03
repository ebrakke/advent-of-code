from functools import reduce
from operator import mul

puzzle_map = open('day3_test_input.txt').readlines()

PATTERN_LENGTH = len(puzzle_map[0])

def get_trees_hit(movement):
    trees_hit = 0
    x, y = (0, 0)
    for row in puzzle_map:
        if y > len(puzzle_map):
            break
        if puzzle_map[y][x] == "#":
            trees_hit = trees_hit + 1
        x = (x + movement[0]) % (PATTERN_LENGTH - 1)
        y = (y + movement[1])
    return trees_hit

def solve_2():
    movements = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    trees_hit = [get_trees_hit(m) for m in movements]
    return reduce(mul, trees_hit)

print(get_trees_hit((3, 1)))
print(solve_2())

