#  linedb-load-files-from-directory.py
#    Load files from given directory into %linedb
#    running on ship with given +code at given URL.

import json
import os
import sys

import argparse
import requests

from urllib.parse import urljoin

def get_cookie(
        url_base="http://localhost:8080",
        password="ropnys-batwyd-nossyt-mapwet",  #  ~nec
):
    url = urljoin(url_base, "/~/login")
    data = {"password": password}
    response = requests.post(url, data=data)

    for header in response.headers.items():
        if header[0].lower() == "set-cookie":
            cookie = header[1].split(";")[0]
            return cookie

def send_poke(
        cookie,
        poke_json,
        url_base="http://localhost:8080",
):
    url = urljoin(url_base, "/~/channel/linedb-load-files-from-directory")
    headers = {
        "content-type": "application/json",
        "cookie": cookie,
    }
    data = [{
        "id": 1,
        "action": "poke",
        "ship": "nec",
        "app": "linedb",
        "mark": "linedb-action",
        "json": poke_json,
    }]
    response = requests.put(url, headers=headers, data=json.dumps(data))
    return response

def read_files_in_directory(directory):
    file_contents = {}

    def read_file(file_path):
        with open(file_path, 'r') as file:
            lines = file.readlines()
            return [line.strip() for line in lines]

    def make_path_key(path):
        hoon_notation_path = "/".join(path.split("."))
        return f"/{hoon_notation_path}"

    def recurse_directory(current_directory):
        for entry in os.listdir(current_directory):
            full_path = os.path.join(current_directory, entry)
            if os.path.isfile(full_path):
                file_contents[make_path_key(entry)] = read_file(full_path)
            elif os.path.isdir(full_path):
                recurse_directory(full_path)

    recurse_directory(directory)
    return file_contents

def parse_arguments():
    parser = argparse.ArgumentParser(
            description="Load files from given directory into %linedb running on ship with given +code at given URL."
    )
    parser.add_argument("repo_name", help="Name of the linedb repo to write files to.")
    parser.add_argument("branch_name", help="Name of the linedb branch to write files to.")
    parser.add_argument("directory", help="Path to the Unix directory to read from.")
    parser.add_argument(
            "--url_base",
            help=".",
            nargs="?",
            const="http://localhost:8080",
            default="http://localhost:8080",
    )
    parser.add_argument(
            "--password",
            help=".",
            nargs="?",
            const="ropnys-batwyd-nossyt-mapwet",
            default="ropnys-batwyd-nossyt-mapwet",
    )
    return parser.parse_args()

if __name__ == '__main__':
    args = parse_arguments()

    files_in_directory = read_files_in_directory(args.directory)
    poke_json = {
        "commit": {
            "repo": args.repo_name,
            "branch": args.branch_name,
            "snap": files_in_directory,
        }
    }

    cookie = get_cookie(url_base=args.url_base, password=args.password)
    response = send_poke(cookie, poke_json, url_base=args.url_base)
