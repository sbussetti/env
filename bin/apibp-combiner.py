#!/usr/bin/python

import os
import re
import sys
from collections import defaultdict


# 1:                '',         # API
# 2 to n-1:         'Group',    # API Group
# Url From File:                # API Group Collection
# n Action From File:           # Action


def dict_print(ddict, depth=1):
    for key, item in sorted(ddict.items()):
        print '%s %s' % ('#' * depth, key)

        if isinstance(item, dict):
            dict_print(item, depth+1)
        else:
            print item


def rec_dict():
    return defaultdict(rec_dict)


def set_rec_dict(ddict, maplist, value):
    get_rec_dict(ddict, maplist[:-1])[maplist[-1]] = value


def get_rec_dict(ddict, maplist):
    return reduce(lambda d, k: d[k], maplist, ddict)


def prep_blueprint_files(root_path, files, user_token):
    blueprint = rec_dict()
    headre = re.compile(r'^#\s(\w+)\s(.*)$')
    for filename in files:
        name_parts = filename.split('-', 2)
        api_name, group_name, action_name = name_parts
        action_name = action_name.rstrip('.txt')

        with open(os.path.join(root_path, filename)) as x:
            contents = x.readlines()

        # assume first line is hash-prefixed header.
        header = contents.pop(0)

        reres = headre.match(header)
        action, url = reres.groups()

        # TODO: dum
        # strip Set-Cookie lines...
        contents = [l for l in contents
                    if 'Set-Cookie:' not in l
                    and 'Vary:' not in l
                    and 'Transfer-Encoding:' not in l]

        contents = re.sub(
            r'\{\{\{\s*user_token\s*\}\}\}',
            user_token,
            u''.join(contents)
        )
        # dummer
        contents = re.sub(
            r'\{\{\{\s*schema__legacy_object_list\s*\}\}\}',
            """
            {
                "title": "Legacy object list",
                "type": "array",
                "items": {
                    "type": "object"
                },
                "minItems": 1
            }
            """,
            u''.join(contents)
        )
        contents = re.sub(
            r'\{\{\{\s*schema__legacy_raw_object\s*\}\}\}',
            """
            {
                "title": "Legacy raw object",
                "type": "object"
            }
            """,
            u''.join(contents)
        )
        contents = re.sub(
            r'\{\{\{\s*schema__basic_payload\s*\}\}\}',
            """
            {
                "title": "Basic Payload Envelope",
                "type": "object",
                "properties": {
                    "control": {
                        "type": ["object", "null"]
                    },
                    "status": {
                        "type": "integer"
                    },
                    "payload": {
                        "type": "array",
                        "items": {
                            "type": "object"
                        },
                        "minItems": 1
                    }
                },
                "required": ["control", "status", "payload"]
            }
            """,
            u''.join(contents)
        )
        url = re.sub(
            r'\{\{\{\s*user_token\s*\}\}\}',
            user_token,
            u''.join(url)
        )

        name_path = [
            'Group %s-%s' % (api_name, group_name),
            '%s Collection [%s]' % (group_name, url),
            '%s [%s]' % (action_name, action)
        ]
        set_rec_dict(blueprint, name_path, contents)
    return blueprint


if __name__ == '__main__':
    try:
        path, utoken = sys.argv[1:3]
    except IndexError:
        raise Exception('path & user token required')
    path = os.path.expanduser(path)
    concat_content = prep_blueprint_files(
        path,
        [f for f in os.listdir(path)
         if os.path.isfile(os.path.join(path, f))],
        utoken)
    dict_print(concat_content)
