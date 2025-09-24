Dots
====

A minimal setup for my daily driver. The main purpose is restoring secrets from
an encrypted bundle, along with a handful of tasks to install packages and
configuration.

Usage
-----

A self-documenting ``Makefile`` drives everything. To get started::

   git clone https://github.com/safl/dots.git
   cd dots
   make

The common use case is recovering dotfiles from the ``dots`` repository and
restoring secrets from an ``age``-encrypted git bundle::

   make setup

To create a new encrypted bundle::

   make encrypt

That’s all there is to it.

Tasks
-----

Tasks are Bash scripts located in ``tasks/*.sh``. They can be run directly, or
via ``./setup.sh`` / ``make setup``.

The ``setup.sh`` script runs tasks in order, using ``sudo`` when required. This
is indicated by the naming convention of including ``sudo`` in the script
filename.
