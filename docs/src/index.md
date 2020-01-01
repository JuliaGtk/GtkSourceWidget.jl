# GtkSourceWidget.jl

GtkSourceWidget.jl is a Julia wrapper for the Gtk library GtkSourceView that allows showing source code documents (see [https://wiki.gnome.org/Projects/GtkSourceView](https://wiki.gnome.org/Projects/GtkSourceView) ).

Some methods are not yet documented, and others are not implemented. Browsing the source file is recommended.

## Index

```@index
Pages = ["index.md"]
```

## Basic usage

```julia
using Gtk, GtkSourceWidget

w = GtkWindow()
b = GtkSourceBuffer()
b.text[String] = "test"
v = GtkSourceView(b)
push!(w,v)
showall(w)
```

## Types

```julia
GtkSourceBuffer
GtkSourceView
GtkSourceLanguage
GtkSourceLanguageManager
GtkSourceStyle
GtkSourceStyleScheme
GtkSourceStyleSchemeManager
GtkSourceSearchSettings
GtkSourceSearchContext
GtkSourceMap
```

## Public Interface

```@autodocs
Modules = [GtkSourceWidget]
Private = false
```

## Internals

```@autodocs
Modules = [GtkSourceWidget]
Public = true
```