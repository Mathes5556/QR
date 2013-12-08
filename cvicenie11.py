class MapBase:

    class Item:
        def __init__(self, key, value):
            self._key = key
            self._value = value
        def __eq__(self, iny):
            return self._key == iny._key
        def __lt__(self, iny):
            return self._key < iny._key

    def __getitem__(self, key):
        raise KeyError

    def __setitem__(self, key, value):
        raise KeyError

    def __len__(self):
        return 0

    def __iter__(self):
        raise KeyError

    def __contains__(self, key):
        try:
            self[key]
        except KeyError:
            return False
        else:
            return True

