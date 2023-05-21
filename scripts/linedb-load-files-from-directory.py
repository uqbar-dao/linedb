#  linedb-load-files-from-directory.py
#    Load files from given directory into %linedb
#    running on ship with given +code at given URL.

import json
import os
import sys

import argparse
import base64
import requests

from urllib.parse import urljoin

def get_cookie(
        url_base="http://localhost",
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
        ship="nec",
        url_base="http://localhost",
):
    url = urljoin(url_base, "/~/channel/linedb-load-files-from-directory")
    headers = {
        "content-type": "application/json",
        "cookie": cookie,
    }
    data = [{
        "id": 1,
        "action": "poke",
        "ship": ship,
        "app": "linedb",
        "mark": "linedb-action",
        "json": poke_json,
    }]
    response = requests.put(url, headers=headers, data=json.dumps(data))
    return response

def read_files_in_directory(directory):
    file_contents = {}

    def read_file(file_path):
        try:
            with open(file_path, "r", encoding="utf-8") as file:
                lines = file.readlines()
                return [line.rstrip() for line in lines]
        except UnicodeDecodeError:
            with open(file_path, "rb") as file:
                binary_data = file.read()
                encoded_data = base64.b64encode(binary_data).decode('utf-8')
                print(f"encoding binary file to b64: {file_path}")
                return encoded_data

    def make_path_key(path):
        #  use .lower() to avoid, e.g., "/README/md" from crashing path parsing
        hoon_notation_path = "/".join(path[len(directory):].split(".")).lower()
        if hoon_notation_path[0] == "/":
          return f"{hoon_notation_path}"
        return f"/{hoon_notation_path}"

    def recurse_directory(current_directory):
        for entry in os.listdir(current_directory):
            full_path = os.path.join(current_directory, entry)
            if entry[0] == ".":
                continue
            if os.path.isfile(full_path):
                file_contents[make_path_key(full_path)] = read_file(full_path)
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
            const="http://localhost",
            default="http://localhost",
    )
    parser.add_argument(
            "--ship",
            help=".",
            nargs="?",
            const="nec",
            default="nec",
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
    response = send_poke(cookie, poke_json, ship=args.ship, url_base=args.url_base)
    print(response)
