using GtkSourceWidget, Test
using Gtk

v = GtkSourceView(b)
push!(w,v)
showall(w)