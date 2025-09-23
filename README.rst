Dots
====

Currently pursuing a richly simplified daily-driver where customizations are
minimal. This means relying on tools with sane defaults or requiring only minor
setup and configuration.

The main purpose here is setting up secrets from an encrypted bundle, along with
a couple of minor settings for Git and my editor.

Usage
-----

A self-documenting Makefile drives everything. To get started::

    git clone https://github.com/safl/dots.git
    cd dots
    make

The common use-case is to recover dotfiles from the ``dots`` repository and
restore secrets from an ``age``-encrypted Git bundle::

    cd dots
    make install-packages
    make install-git
    make install-rust
    make install-helix
    make decrypt
    make install-ssh


To create a new encrypted bundle::

    make encrypt

That’s all there is to it.
