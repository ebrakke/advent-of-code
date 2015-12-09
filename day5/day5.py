import re
regex = re.compile(r'(.)\1')
def is_nice_name(name):
	has_enough_vowls = len([x for x in name if x in 'aeiou']) > 2
	has_double_letters = False
	for i, l in enumerate(name):
		if i == len(name) - 1: break
		if l == name[i + 1]:
			has_double_letters = True
	has_forbidden_words = len([x for x in ['ab', 'cd', 'pq', 'xy'] if x in name]) > 0
	return has_enough_vowls and has_double_letters and not has_forbidden_words

def new_is_nice_name(name):
	has_repeat_with_other_letter = False
	has_distinct_reps = False
	for i, l in enumerate(name):
		if i == len(name) - 2: break
		if l == name[i+2] and l != name[i+1]:
			has_repeat_with_other_letter = True
		if l + name[i+1] in name[i+2:]:
			has_distinct_reps = True
	return has_distinct_reps and has_repeat_with_other_letter

with open('input.txt') as f:
	f = f.readlines()
	nice_count = 0
	for name in f:
		if new_is_nice_name(name):
			nice_count += 1
	print nice_count



