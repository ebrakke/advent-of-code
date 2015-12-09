def get_surface_area_and_slack(s):
	l, w, h = s.split('x')
	l, w, h = int(l), int(w), int(h)
	lw = l*w
	wh = w*h
	lh = l*h
	return 2 * (lw + wh + lh) + min(lw, wh, lh)

def get_present_bow_length(s):
	l, w, h = s.split('x')
	l, w, h = int(l), int(w), int(h)
	volume = l*w*h
	min_sides = min([(l,w), (w,h), (l,h)], key=lambda x: x[0] + x[1])
	return 2*min_sides[0] + 2*min_sides[1] + volume

def get_total_for_all(i):
	total_sa = 0
	rows = i.split('\n')
	rows = map(get_surface_area_and_slack, rows)
	return sum(rows)

def get_toal_bow_length(i):
	toal_ribbion_length = 0
	rows = i.split('\n')
	rows = map(get_present_bow_length, rows)
	return sum(rows)
	
with open('input.txt') as f:
	f = f.read()
	print get_total_for_all(f)
	print get_toal_bow_length(f)