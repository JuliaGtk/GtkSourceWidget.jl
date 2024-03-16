using GtkSourceWidget, Gtk4

win=GtkWindow("test",400,400)
sv = GtkSourceView()
win[] = sv

buff = sv.buffer
langman = GtkSourceLanguageManager()
lang = GtkSourceWidget.language(langman,"julia")
buff.text = open("simple.jl","r") do f
    read(f,String)
end
GtkSourceWidget.G_.set_language(buff,lang)
