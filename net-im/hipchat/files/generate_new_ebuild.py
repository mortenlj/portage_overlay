#!/usr/bin/env python
# -*- coding: utf-8
import subprocess

import urllib2
import urlparse
import posixpath
import shutil
import re
import os

from distutils.version import StrictVersion

DOWNLOAD_URL = 'http://downloads.hipchat.com/linux/arch/hipchat-x86_64.tar.xz'
VERSION_PATTERN = re.compile(r"hipchat-([0-9.]+[0-9]).*")
FILES_DIR = os.path.dirname(os.path.realpath(__file__))
EBUILD_DIR = os.path.dirname(FILES_DIR)
EBUILD_NAME_TEMPLATE = "hipchat-%s.ebuild"
EBUILD_TEMPLATE_FILENAME = "hipchat.ebuild"


class RedirectHandler(urllib2.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        raise urllib2.HTTPError(newurl, code, msg, headers, fp)


class InvalidResponse(Exception):
    def __init__(self, headers):
        self.headers = headers

    def __str__(self):
        return str(self.headers)


def get_actual_download():
    request = urllib2.Request(DOWNLOAD_URL)
    request.get_method = lambda: 'HEAD'
    opener = urllib2.build_opener(RedirectHandler())
    try:
        response = opener.open(request)
        raise InvalidResponse(response.info())
    except urllib2.HTTPError as e:
        return e.geturl()


def get_download_filename():
    url = get_actual_download()
    parsed = urlparse.urlparse(url)
    return posixpath.basename(parsed.path)


def get_version(filename):
    m = VERSION_PATTERN.match(filename)
    if m:
        return m.group(1)


def get_latest_on_disk():
    latest = StrictVersion("0.0")
    for filename in os.listdir(EBUILD_DIR):
        if filename.endswith(".ebuild"):
            current = StrictVersion(get_version(filename))
            if current > latest:
                latest = current
    return latest


def create_new(version):
    src = os.path.join(FILES_DIR, EBUILD_TEMPLATE_FILENAME)
    newname = EBUILD_NAME_TEMPLATE % str(version)
    dest = os.path.join(EBUILD_DIR, newname)
    shutil.copy(src, dest)
    print "Created new ebuild: %s" % dest
    subprocess.call(["ebuild", dest, "digest"])


def main():
    download_version = StrictVersion(get_version(get_download_filename()))
    latest = get_latest_on_disk()
    if latest < download_version:
        create_new(download_version)

if __name__ == "__main__":
    main()
