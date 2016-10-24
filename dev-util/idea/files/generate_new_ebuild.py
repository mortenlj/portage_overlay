#!/usr/bin/env python
# -*- coding: utf-8
import tarfile

import urllib2
import re
import os
import portage
import subprocess

from xml.etree import cElementTree as ET

from distutils.version import LooseVersion

UPDATES_URL = 'http://www.jetbrains.com/updates/updates.xml'
VERSION_PATTERN = re.compile(r"idea-([0-9.]+[0-9]).*")
FILES_DIR = os.path.dirname(os.path.realpath(__file__))
EBUILD_DIR = os.path.dirname(FILES_DIR)
EBUILD_NAME_TEMPLATE = "idea-%s.ebuild"
EBUILD_TEMPLATE_FILENAME = "idea.ebuild"
DIST_FILENAME_TEMPLATE = "ideaIU-%s.tar.gz"
BNUM_PATTERN = re.compile(r"idea-IU-(\d+\.\d+\.\d+)")


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


def write_ebuild(dest, template, version, build_number):
    with open(dest, "w") as fobj:
        ebuild = template % (build_number, version.version[0])
        fobj.write(ebuild)


def get_actual_build_number(version):
    fpath = os.path.join(portage.settings["DISTDIR"], DIST_FILENAME_TEMPLATE % version)
    with tarfile.open(fpath) as archive:
        for member in archive.getmembers():
            n = member.name
            while os.path.sep in n:
                n = os.path.dirname(n)
            m = BNUM_PATTERN.search(n)
            if m:
                return m.group(1)


def create_new(version, build_number):
    src = os.path.join(FILES_DIR, EBUILD_TEMPLATE_FILENAME)
    new_name = EBUILD_NAME_TEMPLATE % str(version)
    dest = os.path.join(EBUILD_DIR, new_name)
    with open(src) as fobj:
        template = fobj.read()
    try:
        write_ebuild(dest, template, version, build_number)
        subprocess.check_call(["ebuild", dest, "digest"])
        actual_build_number = get_actual_build_number(version)
        write_ebuild(dest, template, version, actual_build_number)
    except (subprocess.CalledProcessError, IOError) as e:
        print "Error creating new ebuild: %s" % str(e)
        if os.path.exists(dest):
            os.unlink(dest)
    else:
        print "Created new ebuild: %s" % dest
        subprocess.call(["ebuild", dest, "digest"])


def main():
    build_number, download_version = get_latest_update()
    latest = get_latest_on_disk()
    if latest < download_version:
        create_new(download_version, build_number)

if __name__ == "__main__":
    main()
