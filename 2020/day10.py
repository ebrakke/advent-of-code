import collections
import itertools
from functools import reduce

adapters = sorted([int(a) for a in open('day10.txt').readlines()])

def solve_1(adapters):
    diffs = [adapters[0]] + [adapters[i + 1] - adapters[i] for i in range(len(adapters) - 1)] + [3]
    counts = collections.Counter(diffs)
    return counts[1] * counts[3]

def get_next_numbers(num, rest):
    return [r for r in rest if r - num <= 3]

def build_decisions(start, rest):
    next_nums = get_next_numbers(start, rest)
    if len(next_nums) == len(rest):
        return [start, next_nums]
    if len(next_nums) == 1:
        return [start] + build_decisions(next_nums[0], rest[1:])
    new_start = len(next_nums)
    return [start, next_nums] + build_decisions(rest[new_start], rest[new_start+1:])

def solve_2(adapters):
    decisions = build_decisions(0, adapters[:-1]) + [adapters[-1]]
    nums = []
    for i, d in enumerate(decisions):
        if type(d) == list:
            before, after = decisions[i-1], decisions[i+1]
            combos = [c for i in range(1, len(d) + 1) for c in itertools.combinations(d, i) if c[0] - before <= 3 and after - c[-1] <= 3]
            nums = nums + [len(combos)]
    return reduce(lambda x,y: x * y, nums) 


print(solve_1(adapters))
print(solve_2(adapters))

