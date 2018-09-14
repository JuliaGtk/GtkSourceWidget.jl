using GtkSourceWidget, Test
using Gtk

w = GtkWindow()
b = GtkSourceBuffer()
v = GtkSourceView(b)
push!(w,v)
showall(w)