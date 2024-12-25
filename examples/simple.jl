using GtkSourceWidget, Gtk4

win=GtkWindow("test",400,400)
sv = GtkSourceView()
win[] = sv

buff = sv.buffer
lang = GtkSourceWidget.language(GtkSourceWidget.sourceLanguageManager,"julia1_10")
buff.text = open("simple.jl","r") do f
    read(f,String)
end
GtkSourceWidget.G_.set_language(buff,lang)
