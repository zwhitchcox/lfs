## Getting Started

Switch to the root user:
```
sudo su
```

Load the environment variables:
```
source env.sh
```

Create the LFS user:

```
bash misc/lfs-user.sh
```

Run all the stages:

```
bash run.sh
```

This will create a copy of each disk image before moving on to the next stage.

Run an individual stage:

```
```
bash run.sh $NUM_STAGE
```

Replace $NUM_STAGE with the stage number, where stage 1 is disk, stage 2 is add-sources, and so on.

## Stages

The stages in order are:

    disk: Sets up the disk image for LFS.
    add-sources: Downloads the source packages for the build process.
    create-dirs: Creates the directory structure for LFS.
    binutils: Installs the binutils package.
    gcc: Installs the GCC compiler package.
    linux: Installs the Linux kernel.
