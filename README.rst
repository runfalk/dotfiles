Andreas Runfalk's Dotfiles
==========================
This is a collection of dotfiles that I use. They are made to work on Linux. The
dotfiles are split into multiple packages. Some packages may depend on others.
Most of them depend on the bash package.


Requirements
------------
Requires Python 3.7+


Installation
------------
To install a package just execute ``install.py`` in the root directory:

.. code-block::

   $ ./install.py bash git rust

For Neovim to work you need to run ``:PaqInstall`` at first launch.
