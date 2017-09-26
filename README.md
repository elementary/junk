## Building, Testing, and Installation

You'll need the following dependencies:

 - meson
 - gettext
 - libgtk-3-dev
 - valac

Run `meson build` to configure the build environment. Change to the build directory and run `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`, then execute with `io.elementary.sideload`

    sudo ninja install
    io.elementary.sideload
