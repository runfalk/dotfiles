Andreas Runfalk's dotfiles
==========================
This is a collection of dotfiles that I use. They are made to work on both Linux and macOS where it makes sense. The dotfiles are split into multiple packages. Some packages may depend on others. Most of them depend on the bash package.


Requirements
------------
All scripts assume bash is available, and some require Python to function.

On macOS `Homebrew <https://brew.sh/>`_ is highly recommended.


Installation
------------
To install a package just execute ``dotfile`` in the root directory:

.. code-block::

   $ ./dotfile bash python twitch


Highlights
----------
**python**
  A collection of tools for dealing with Python development:
  
  ``venv`` is a wrapper around `virtualenv <https://virtualenv.pypa.io/en/stable/>`_. It allows the user to select one or multiple Python versions from a curses menu when creating the environment. To activate a virtualenv, just type ``a`` anywhere in the directory a virtualenv belongs to. If there are multiple python versions, a curses menu is presented. Environments are also patched to include a top level ``node_modules/.bin/`` folder in the ``PATH``.
  
  ``rtdoffline`` is a tool to download documentation directly from `Read the Docs <https://readthedocs.org/>`_. Note that some projects don't have the same name on RtD as on PyPI. Usage: ``rtdoffline [-f pdf|htmlzip|epub] [-v latest|<version>] name..``

**twitch**
  A CLI Twitch stream menu for `streamlink <https://streamlink.github.io/>`_. It looks at the Twitch users specified in ``~/.config/twitch-bookmarks`` and returns a curses menu where a streamer that is online can be selected.
