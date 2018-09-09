# Gtk Inspector Prototype

![Screenshot](data/screenshot.png?raw=true)

## Building

You'll need the following dependencies to build:
* libgtk-3-dev
* meson
* valac

Run `meson build` to configure the build environment and then change to the build directory and run `ninja` to build

    meson build --prefix=/usr 
    cd build
    ninja

execute with `./inspector`

    ./inspector
