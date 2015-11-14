import time
import requests
import threading

class Sign:
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.messages = []

    def clear(self):
        # Should probably implement this on the other side
        requests.post("http://{}:{}/clear".format(self.host, self.port))
        self.messages = []

    def new_message(self, *args, **kwargs):
        msg = Message(*args, sign=self, **kwargs)
        msg.add()
        self.messages.append(msg)
        return msg

    def remove_message(self, name):
        i = -1
        for i, message in enumerate(self.messages):
            if message.name == name:
                message.remove()
                break
        else:
            i = -1

        if i != -1:
            del self.messages[i]
        self.new_message('', name=name).remove()

class Message:
    def __init__(self, message, name=None, effects=[], priority=5,
                 lifetime=None, expiration=None, sign=None):
        self.message = message
        self.effects = effects
        self.priority = priority
        self.lifetime = lifetime
        self.expiration = expiration
        self.name = name
        self.sign = sign

    def update(self, local=False, **kwargs):
        valid = {k: v for k, v in kwargs.items() if v != None and k in (
            "message", "effects", "priority", "lifetime", "expiration"
        )}

        self.__dict__.update(valid)

        if not local:
            self.add()

        return self

    def get_expiration(self):
        if self.lifetime:
            return time.time() + self.lifetime
        elif self.expiration:
            return self.expiration
        else:
            return 2147483647 # meh

    def add(self):
        threading.Thread(target=self._add_request).start()

    def remove(self):
        threading.Thread(target=self._remove_request).start()

    def _add_request(self):
        data = {
            "text": self.message,
            "effects": ",".join(self.effects).lower(),
            "priority": self.priority,
            "expiration": self.get_expiration()
        }

        if self.name:
            data["name"] = self.name

        r = requests.post("http://{}:{}/add_message".format(self.sign.host, self.sign.port), data=data)

        r.raise_for_status()

        self.name = r.text

    def _remove_request(self):
        if self.name:
            r = requests.post("http://{}:{}/remove_message/{}".format(
                self.sign.host, self.sign.port, self.name))
