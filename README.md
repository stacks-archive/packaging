Blockstack Toolbox
==================================

The Blockstack Docker Toolbox installs everything you need to get started with
Blockstack, using Docker on Windows. It includes the Docker client, Compose,
Machine, Kitematic, and VirtualBox.

## Installation and documentation

For running on Windows, you must enable VT-X (hardware virtualization support). This can be enabled by running the Windows Powershell as Administrator and executing the command:

```
Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All
```

You may also need to run

```
bcdedit /set hypervisorlaunchtype auto
```

You can see this Microsoft article for more information on VT-X (https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v).

## Building the Blockstack Docker Toolbox

Toolbox installers are built using Docker, so you'll need a Docker host set up. For example, using [Docker Machine](https://github.com/docker/machine):

```
$ docker-machine create -d virtualbox toolbox
$ eval "$(docker-machine env toolbox)"
```

Then, to build the Toolbox for both platforms:

```
make
```

Build for a specific platform:

```
make osx
```

or

```
make windows
```

The resulting installers will be in the `dist` directory.

## Frequently Asked Questions

**Do I have to install VirtualBox?**

No, you can deselect VirtualBox during installation. It is bundled in case you want to have a working environment for free.
