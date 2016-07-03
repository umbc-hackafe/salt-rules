from copy import deepcopy
import socket

def is_listdict(d):
    return isinstance(d, list) and all((isinstance(n, dict) and len(n) == 1 for n in d))

def resolve(hostname):
    return socket.gethostbyname(hostname)

def merge_listdict(a, b):
    "merges b into a"

    a_dict = {}
    b_dict = {}

    for elm in a:
        a_dict.update(elm)

    for elm in b:
        b_dict.update(elm)

    res_dict = merge(a_dict, b_dict)

    return [{k: v} for k, v in res_dict.items()]

def merge(a, b, path=None):
    "merges b into a"
    if path is None: path = []

    if is_listdict(a) and is_listdict(b):
        return merge_listdict(a, b)
    else:
        for key in b:
            if key in a:
                if isinstance(a[key], dict) and isinstance(b[key], dict):
                    merge(a[key], b[key], path + [str(key)])
                elif a[key] == b[key]:
                    pass # same leaf value
                else:
                    a[key] = b[key]
            else:
                a[key] = b[key]
        return a

def static_resolve(host):
    if host == 'localhost':
        return host

    defaults = __salt__['pillar.get']("dns:defaults", {})
    
    for name, network in __salt__['pillar.get']("dns:networks", {}).items():
        network = merge(deepcopy(defaults), network)
        domain = network['options']['domain-name']
        if host.endswith('.' + domain):
            unqualified_host = host[:-len(domain)-1]
            if unqualified_host in network.get('hosts', {}):
                return network['hosts'][unqualified_host].get('ip', host)

    return host
