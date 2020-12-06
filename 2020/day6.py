from collections import Counter

groups = open('day6.txt').read().split('\n\n')
parsed_groups = [[a for a in g.split('\n') if a != ''] for g in groups]

def get_group_count(group):
    answers = [a for ans in group for a in ans]
    counts = Counter(answers)
    return len(counts)

def get_consensus_count(group):
    answers = [a for ans in group for a in ans]
    counts = Counter(answers)
    consensus = [c for c in counts if counts[c] == len(group)]
    return len(consensus)

def solve_1():
    return sum([get_group_count(g) for g in parsed_groups])

def solve_2():
    return sum([get_consensus_count(g) for g in parsed_groups])

print(solve_1())
print(solve_2())

