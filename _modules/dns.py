from copy import deepcopy

def merge(a, b, path=None):
    "merges b into a"
    if path is None: path = []
    for key in b:
        if key in a:
            if isinstance(a[key], dict) and isinstance(b[key], dict):
                merge(a[key], b[key], path + [str(key)])
            elif a[key] == b[key]:
                pass # same leaf value
            else:
                raise Exception('Conflict at %s' % '.'.join(path + [str(key)]))
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
            if unqualified_host in network['hosts']:
                return network['hosts'][unqualified_host].get('ip', host)

    return host
