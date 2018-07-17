# Notes

If you run `otool -L libqrencode.4.dylib` it will show you the names and
version numbers of the shared libraries that `libqrencode` uses.

If `libqrencode` is compiled using the default configuration, the library will
expect to find itself in `/usr/local/lib`. Since we're including `libqrencode`
in Voltage, we need to change the path where the library will look for itself.

## rpath

In order to include the `libqrencode.4.dylib` library in Voltage, you have to
use `install_name_tool` to change the location where the library is located to
the `rpath` or runtime search path that Voltage uses during launch:

    install_name_tool -id "@rpath/libqrencode.4.dylib" libqrencode.4.dylib

Now you can include `libqrencode.4.dylib` in the Voltage project as an embedded
binary, which will add a "Copy" build phase in which the binary is copied into
the application.
