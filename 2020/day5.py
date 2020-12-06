seats = open('day5.txt').readlines()
# seats = ['BFFFBBFRRR', 'FFFBBBFRRR', 'BBFFBBFRLL']

def parse_seat_code(code):
    row = ''.join(['0' if l == 'F' else '1' for l in code[:7]])
    seat = ''.join(['0' if l == 'L' else '1' for l in code[7:]])
    return (int(row, 2), int(seat, 2))

def solve_1():
    rows = [parse_seat_code(s.strip()) for s in seats]
    codes = [(r * 8) + c for r,c in rows]
    return max(codes)

def solve_2():
    rows = [parse_seat_code(s.strip()) for s in seats]
    codes = sorted([r * 8 + c for r,c in rows])
    gap = (0,0)
    for i, r in enumerate(codes):
        if i != len(codes):
            if codes[i+1] - r != 1:
                gap = (r, codes[i+1])
                break
    if gap != (0,0):
        return gap[0] + 1
    return 0

print(solve_1())
print(solve_2())
