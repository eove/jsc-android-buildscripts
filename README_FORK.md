# JSC build scripts for Android

This is a fork providing more eove tuning.

## Patches

JSC can be tuned using patches.

Patches are located in `patches` directory.

To use a patch, you have to edit `scripts/patch.sh` and add it under `# Eove patches` section for instance.

## How to build JSC

Use the dockerfile we provide with the fork:

```
docker build . -t jsc
```

Then export build artifact on your host:

```
docker run --rm -v /home/michael/Downloads:/out jsc cp dist.tar.gz /out
```

Change user rights on this file:

```
sudo chown -v michael:michael ~/Downloads/dist.tar.gz
```

Please adapt your host destination directory (`/home/michael/Downloads` in the example).

## How to use a custom JSC in a React Native app

Extract the build archive:

```
tar xfz ~/Downloads/dist.tar.gz
```

Then edit any app root `build.gradle` (`eo150-app/android/build.gradle` for instance).

Set JSC location like:

```groovy
        maven {
            // Android JSC is installed from npm
            // url("$rootDir/../node_modules/jsc-android/dist")

            // Local JSC build
            url("/home/michael/Downloads/dist")
        }
```