# GtkSourceWidget

GtkSourceWidget.jl is a Julia wrapper for the Gtk library GtkSourceView that allows to show source code documents (see https://wiki.gnome.org/Projects/GtkSourceView). The library is only tested with Gtk+3 and version 3 of GtkSourceView. It requires that Gtk.jl (https://github.com/JuliaLang/Gtk.jl) is installed an properly configured.

## Installation

GtkSourceWidget.jl requires that a GtkSourceView is installed and in the library path.

### Linux

On linux GtkSourceView should be installed using the package manager

### OSX

It works when using MacPorts:

1. `port install gtksourceview3 +no_x11 +quartz -x11`

### Windows

This is the most tricky thing. GtkSourceView3 seems to be not be installable via WinRPM. When using 32bit I had success using the binaries from http://www.tarnyko.net/repo/vala/vala0.20.1-glib2.34.3/ together with the official Gtk+3 binaries (version 3.6) from the Gtk website.
