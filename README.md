Packaging Scripts
=================

This repository contains the necessary scripts and tools to create signed Linux package repositories.  Currently, they support creating Debian/Ubuntu repositories from Python source packages.

To use these scripts, you will need [fpm](https://github.com/jordansissel/fpm) and a GPG key.

Example
-------

This will create a Debian/Ubuntu repository signed with GPG key ID DB858875:

```
    $ make GPGKEYID=DB858875
```

The repository will be built under `./build/repositories/debian`.
