#!/usr/bin/env python
# -*- coding: utf-8

import urllib2
import re
import os
import subprocess

from xml.etree import cElementTree as ET

from distutils.version import LooseVersion

UPDATES_URL = 'http://www.jetbrains.com/updates/updates.xml'
VERSION_PATTERN = re.compile(r"idea-([0-9.]+[0-9]).*")
FILES_DIR = os.path.dirname(os.path.realpath(__file__))
EBUILD_DIR = os.path.dirname(FILES_DIR)
EBUILD_NAME_TEMPLATE = "idea-%s.ebuild"
EBUILD_TEMPLATE_FILENAME = "idea.ebuild"


def get_latest_update():
    uobj = urllib2.urlopen(UPDATES_URL)
    try:
        data = uobj.read()
        root = ET.fromstring(data)
        release_channels = root.findall("./product/channel[@status='release']")
        def key(el):
            return int(el.get("majorVersion"))
        release_channels.sort(key=key)
        latest_channel = release_channels[-1]
        build = latest_channel.find("build")
        return build.get("number"), LooseVersion(build.get("version"))
    finally:
        uobj.close()


def get_version(filename):
    m = VERSION_PATTERN.match(filename)
    if m:
        return LooseVersion(m.group(1))


def get_latest_on_disk():
    latest = LooseVersion("0.0")
    for filename in os.listdir(EBUILD_DIR):
        if filename.endswith(".ebuild"):
            current = get_version(filename)
            if current > latest:
                latest = current
    return latest


def create_new(version, build_number):
    src = os.path.join(FILES_DIR, EBUILD_TEMPLATE_FILENAME)
    new_name = EBUILD_NAME_TEMPLATE % str(version)
    dest = os.path.join(EBUILD_DIR, new_name)
    with open(src) as fobj:
        template = fobj.read()
    with open(dest, "w") as fobj:
        ebuild = template % (build_number, version.version[0])
        fobj.write(ebuild)
    print "Created new ebuild: %s" % dest
    subprocess.call(["ebuild", dest, "digest"])


def main():
    build_number, download_version = get_latest_update()
    latest = get_latest_on_disk()
    if latest < download_version:
        create_new(download_version, build_number)

if __name__ == "__main__":
    main()
