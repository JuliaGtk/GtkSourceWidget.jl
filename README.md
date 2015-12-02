# GtkSourceWidget

GtkSourceWidget.jl is a Julia wrapper for the Gtk library GtkSourceView that allows to show source code documents (see https://wiki.gnome.org/Projects/GtkSourceView). The library is only tested with Gtk+3 and version 3 of GtkSourceView. It requires that Gtk.jl (https://github.com/JuliaLang/Gtk.jl) is installed an properly configured.

## Installation

GtkSourceWidget.jl requires that a GtkSourceView is installed and in the library path. 

### Linux

?

### OSX
Use Julia's Homebrew to install the library:

  using Homebrew
  Homebrew.add("gtksourceview3")

### Windows

64-bits binaries are provided.
