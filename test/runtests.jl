using GtkSourceWidget, Test
using Gtk

@testset "GtkSourceView" begin

    w = GtkWindow()
    b = GtkSourceBuffer()
    b.text[String] = "test"
    v = GtkSourceView(b)
    push!(w,v)
    showall(w)
    @test b.text[String] == "test"

end