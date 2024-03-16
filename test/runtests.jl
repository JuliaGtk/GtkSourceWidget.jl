using GtkSourceWidget, Test
using Gtk4

@testset "GtkSourceView" begin

    w = GtkWindow()
    b = GtkSourceBuffer()
    b.text = "test"
    v = GtkSourceView(b)
    push!(w,v)
    @test b.text == "test"
    
    search_settings = GtkSourceSearchSettings()
    search_context = GtkSourceSearchContext(b, search_settings)
    set_search_text(search_settings, "test")

    it = Gtk4._GtkTextIter(b, 1)
    found, its, ite = search_context_forward(search_context, it)
    @test found == true
    @test (its:ite).text == "test"

    search_context_replace(search_context, its, ite, "it worked!")
    set_search_text(search_settings, "it worked!")

    it = Gtk4._GtkTextIter(b, 1)
    found, its, ite = search_context_forward(search_context, it)
    @test found == true
    @test (its:ite).text == "it worked!"

    mark = create_mark(b, it)
    scroll_to(v, mark, 0, true, 0.5, 0.5)

end


