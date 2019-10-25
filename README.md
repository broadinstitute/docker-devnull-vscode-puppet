# broadinstitute/docker-devnull-vscode-puppet

## What is devnull-vscode-puppet

This is a multipurpose [Docker][1] image for the **/dev/null** team to use when developing [Puppet][3] modules and configurations.  This image is not meant as a base image to be inherited from.  Instead, it is to be used with something like [VS Code][2] to act as a base [Puppet][3] image to in which to run code while developing and testing.

## How to use this image

Provided in this repository is a `devcontainer.json` file.  Place this file in a `.devcontainer` directory under a repository, workspace, etc. so that [VS Code][2] will recognize it as the configuration for a [Dev Container](https://code.visualstudio.com/docs/remote/containers).  [VS Code][2] should then run and connect to the container every time you open that repository, workspace, etc.

[1]: https://www.docker.com/ "Docker"
[2]: https://code.visualstudio.com/ "VS Code"
[3]: https://puppet.com/ "Puppet"
