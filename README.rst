Dots
====

This is **dots**, a minimalistic approach to backup and restore of my daily
driver. Its primary purpose is to restore secrets from an encrypted git bundle
and perform a handful of tasks (as scripts) such as installing packages and
configuring the system and tools.

It is assumed that the following directory structure exists::

  ./git/dots           # The 'dots' git repository
  ./secrets            # Repository containing sensitive data
  ./secrets.bundle.age # Encrypted backup of the "secrets" repository

This structure should reside on a physical medium that is as secure as
practically possible.

Usage
-----

A ``Makefile`` provides an overview of available tasks. To get started::

   cd ~/git
   git clone https://github.com/safl/dots.git
   cd dots
   make

This will display common tasks. For more details, check the contents of the
``Makefile``.

Usage: setup
------------

While the ``Makefile`` is helpful, ``make`` may not be available on a fresh
system. Assuming **dots** and the **secrets backup** are available at some mount
point with the layout shown above, run::

   cd ./git/dots
   ./setup.sh

This will decrypt the **secrets backup** and run the various tasks. You may need
to log out and back in to apply changes made to the environment.

Usage: Creating a backup
------------------------

The **dots** repository contains non-sensitive content. To back up this content,
add or update dotfiles under::

   ./git/dots/dotfiles/<tool>

And update or add scripts in ``tasks/`` as needed. Then commit and push to
your preferred Git remote. That is all it takes to back up and store your
non-sensitive configuration.

To back up sensitive data, copy the relevant content into the ``secrets``
repository and run::

   make backup

This will create the file ``./secrets.bundle.age``.

Tasks
-----

Tasks are Bash scripts located in ``tasks/*.sh``. They can be executed directly,
or via ``./setup.sh`` or ``make setup``.

The ``setup.sh`` script runs tasks in order, using ``sudo`` when needed. This is
indicated by including ``sudo`` in the script filename.
