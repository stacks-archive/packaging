# Installing Blockstack Browser and API with `docker`

Blockstack API and the Blockstack Browser run well in docker. There is a provided CLI to help you build and launch the `docker` images if you are not comfortable with `docker`: `launcher`.
The CLI will pull down the images from our [Quay image repository](https://quay.io/organization/blockstack).

You can download the launcher script from our packaging repo: [download](https://raw.githubusercontent.com/blockstack/packaging/master/browser-core-docker/launcher)

```bash
# First run the pull command. This will fetch the latest docker images from our image repository.
$ ./launcher pull

# The first time you run ./launcher start, it will create a `$HOME/.blockstack` directory to
# store your Blockstack Core API config and wallet and prompt you for a password to protect those
# Next you can start the Blockstack Core API
$ ./launcher start

# When you are done you can clean up your environment by running
$ ./launcher stop
```

This will start the Blockstack browser and a paired `blockstack-api` daemon.
