# Installing Blockstack Browser and API with `docker`

Blockstack API and the Blockstack Browser run well in docker. There is a provided CLI to help you build and launch the `docker` images if you are not comfortable with `docker`: `launcher`.
The CLI will pull down the images from our [Quay image repository](https://quay.io/organization/blockstack).

You can download the launcher script from our packaging repo: [download](https://raw.githubusercontent.com/blockstack/packaging/master/browser-core-docker/launcher)

In order to use this script, you must have docker installed and setup on your machine. Our Windows [installer](http://packages.blockstack.com/repositories/windows/) sets up docker for you and uses this script to start Blockstack Browser automatically (the first time it runs, you will need to enter a password).

```bash
# First run the pull command. This will fetch the latest docker images from our image repository.
$ ./launcher pull

# The first time you run ./launcher start, it will create a `$HOME/.blockstack` directory to
# store your Blockstack Core API config and wallet and prompt you for a password to protect those
# Next you can start the Blockstack Core API
$ ./launcher start

# On Linux, this ./launcher start will also install a protocol handler using xdg-mime
# (the protocol handler is installed on Windows by the installer exe and on macOS through
#  the macOS dock application)

# When you are done you can clean up your environment by running
$ ./launcher stop
```

This will start the Blockstack browser and a paired `blockstack-api` daemon.

# Running a different Blockstack Version
By default this script will launch the `latest`-tagged images. To use another version, do:

```bash
$ BLOCKSTACK_TAG=v0.17.1 ./launcher pull
$ BLOCKSTACK_TAG=v0.17.1 ./launcher start
$ ./launcher stop
```

# Storing data elsewhere
By default, this script creates a `$HOME/.blockstack` directory for storing all data. To move that somewhere else, use the `BLOCKSTACK_DATA` environment variable:

```bash
$ ./launcher pull
$ BLOCKSTACK_DATA=/mnt/data/blockstack ./launcher start
$ ./launcher stop
```
