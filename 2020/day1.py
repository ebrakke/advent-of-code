puzzle_input = open('day1-input.txt').readlines()
numbered_input = [int(e) for e in puzzle_input if e]

# Basically jst setup two lists that are offset and sum by the index
# If any of the pairs match up to 2020, then return that pair (or triplet in the second part)
def rotate(l, n):
    return l[-n:] + l[:-n]

def solve_part_one(inp):
    found_sum = (0, 0, 0)
    for offset in range(1, len(inp)):
        sums = [(i, j, i + j) for i in inp for j in rotate(inp, offset) if i+j == 2020]
        if len(sums) > 0:
            found_sum = sums[0]
            break

    return found_sum[0] * found_sum[1]
    
def solve_part_two(inp):
    found_sum = (0, 0, 0, 0)
    for offset in range(1, len(inp)):
        rotation_one = rotate(inp, offset)
        rotation_two = rotate(inp, offset + 1)
        sums = [(i, j, k, i + j) for i in inp for j in rotation_one for k in rotation_two if i+j+k == 2020]
        if len(sums) > 0:
            found_sum = sums[0]
            break

    return found_sum[0] * found_sum[1] * found_sum[2]

print (solve_part_one(numbered_input))
print(solve_part_two(numbered_input))
