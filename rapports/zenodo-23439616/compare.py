"""Compare nombre à nombre deux fichiers JSON (référence, obtenu).
Usage : python3 -I compare.py REF.json NEW.json
Sortie : champs numériques comparés, écart relatif max |a-b|/|a| (|a-b| si a=0),
et les différences non numériques ou de structure."""
import json, sys

def walk(a, b, path, st):
    if isinstance(a, bool) or isinstance(b, bool) or a is None or b is None:
        if a != b: st['autres'].append((path, a, b))
    elif isinstance(a, (int, float)) and isinstance(b, (int, float)):
        st['n'] += 1
        d = abs(a - b)
        e = d / abs(a) if a != 0 else d
        st['max'] = max(st['max'], e)
    elif isinstance(a, dict) and isinstance(b, dict):
        for k in sorted(set(a) | set(b)):
            if k not in a or k not in b:
                st['autres'].append((path + '/' + k, 'absent' if k not in a else '...', 'absent' if k not in b else '...'))
            else:
                walk(a[k], b[k], path + '/' + k, st)
    elif isinstance(a, list) and isinstance(b, list):
        if len(a) != len(b): st['autres'].append((path, 'len %d' % len(a), 'len %d' % len(b)))
        for i, (x, y) in enumerate(zip(a, b)): walk(x, y, '%s[%d]' % (path, i), st)
    elif a != b:
        st['autres'].append((path, a if not isinstance(a, (dict, list)) else 'type', b if not isinstance(b, (dict, list)) else 'type'))

st = {'n': 0, 'max': 0.0, 'autres': []}
walk(json.load(open(sys.argv[1])), json.load(open(sys.argv[2])), '', st)
print('champs numériques comparés: %d' % st['n'])
print('écart relatif max: %r' % st['max'])
print('autres différences: %d' % len(st['autres']))
for p, a, b in st['autres'][:20]: print('  %s: %r -> %r' % (p, a, b))
