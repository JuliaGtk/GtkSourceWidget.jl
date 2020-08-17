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

    search_context_replace(search_context, its, ite, "it worked!")
    set_search_text(search_settings, "it worked!")

    it = Gtk.GtkTextIter(b, 1)
    found, its, ite = search_context_forward(search_context, it)
    @test found == true
    @test (its:ite).text[String] == "it worked!"

    mark = create_mark(b, it)
    scroll_to(v, mark, 0, true, 0.5, 0.5)

end


