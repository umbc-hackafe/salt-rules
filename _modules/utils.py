from itertools import izip
from copy import deepcopy
import re

def dict_to_dictlist(d):
    return [{k: v} for k, v in d.items()]

def dictlist_to_dict(l):
    res = {}
    for d in l:
        if len(d) != 1:
            raise ValueError("Not a dictlist!")
        for k, v in d.items():
            res[k] = v
    return res

NET_PARAMS = ['name', 'bridge', 'gw', 'ip', 'type', 'ip6', 'hwaddr', 'tag']
KEEP_ANYWAY = ['name']

def filter_netparams(param_dictlist):
    return [{k: v} for d in param_dictlist for k, v in d.items() if k not in NET_PARAMS or k in KEEP_ANYWAY]

def mknet(name='eth0', bridge='vmbr0', gw=None, ip=None, type='veth', **kwargs):
    defaults = dictlist_to_dict(__salt__['pillar.get']('cloud:defaults', []))
    print(defaults)

    if ip and '/' not in ip:
        ip += '/24'

    if gw:
        kwargs['gw'] = gw

    if ip:
        kwargs['ip'] = ip

    kwargs.update({
        'name': name,
        'bridge': bridge,
        'type': type
    })

    defaults.update(kwargs)

    return ','.join(['='.join((k,str(v))) for k, v in defaults.items() if k in NET_PARAMS])

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
