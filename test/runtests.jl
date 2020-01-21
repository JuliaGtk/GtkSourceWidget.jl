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
    
    search_settings = GtkSourceSearchSettings()
    search_context = GtkSourceSearchContext(b, search_settings)
    set_search_text(search_settings, "test")

    it = Gtk.GtkTextIter(b, 1)
    found, its, ite = search_context_forward(search_context, it)
    @test found == true
    @test (its:ite).text[String] == "test"

end


