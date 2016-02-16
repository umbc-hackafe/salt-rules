from itertools import izip
from copy import deepcopy
import re

def is_list(obj):
    return isinstance(obj, list)

def is_dict(obj):
    return isinstance(obj, dict)

def is_ip(obj):
    return is_str(obj) and re.match('^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$', obj)

def is_str(obj):
    return isinstance(obj, str)

def is_int(obj):
    return isinstance(obj, int)

def grouped(iterable, n):
    return izip(*[iter(iterable)]*n)

def pairwise(l):
    return grouped(l, 2)

def exclude_keys(dic, *keys):
    return {k: v for k, v in dic.iteritems() if k not in keys}

def copy(dic):
    return deepcopy(dic)
