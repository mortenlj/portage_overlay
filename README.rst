Epcylons Portage Overlay
========================

Packages and apps I use that don't have official ebuilds. Some are updated regulary,
some are hardly updated at all.

Installation
------------

1. Emerge layman: ``emerge -v layman`` and follow instructions for installation
2. Download the file ``epcylon-overlay.xml`` from this repo and place in ``/etc/layman/overlays``
3. Enable the overlay: ``layman -a epcylon``
4. Update layman repos: ``layman -S`` (You probably want to add this to cron)
