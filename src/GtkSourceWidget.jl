module GtkSourceWidget


export GtkSourceLanguage, GtkSourceLanguageManager, GtkSourceBuffer,
       GtkSourceView

using Gtk

const GObject = Gtk.GObject

const libgtksourceview = "libgtksourceview-3.0"

Gtk.@Gtype GtkSourceLanguage libgtksourceview gtk_source_language

Gtk.@Gtype GtkSourceLanguageManager libgtksourceview gtk_source_language_manager
function GtkSourceLanguageManager(default=true) 
  if default
    GtkSourceLanguageManager(
      ccall((:gtk_source_language_manager_get_default,libgtksourceview),Ptr{GObject},()))
  else
    GtkSourceLanguageManager(
      ccall((:gtk_source_language_manager_new,libgtksourceview),Ptr{GObject},()))
  end
end

language(manager::GtkSourceLanguageManager, id::String) = GtkSourceLanguage(
    ccall((:gtk_source_language_manager_get_language,libgtksourceview),Ptr{GObject},
          (Ptr{GObject},Ptr{Uint8}),manager,bytestring(id)))

### GtkSourceBuffer

Gtk.@Gtype GtkSourceBuffer libgtksourceview gtk_source_buffer
GtkSourceBuffer() = GtkSourceBuffer(
     ccall((:gtk_source_buffer_new,libgtksourceview),Ptr{GObject}, (Ptr{Void},), C_NULL) )
     
GtkSourceBuffer(lang::GtkSourceLanguage) = GtkSourceBuffer(
     ccall((:gtk_source_buffer_new_with_language,libgtksourceview),Ptr{GObject}, 
           (Ptr{GObject},), lang) ) 

highlight_syntax(buffer::GtkSourceBuffer, highlight::Bool) = 
  ccall((:gtk_source_buffer_set_highlight_syntax,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),view,int32(highlight))

### GtkSourceView

Gtk.@Gtype GtkSourceView libgtksourceview gtk_source_view
GtkSourceView(buffer=GtkSourceBuffer()) = GtkSourceView(
    ccall((:gtk_source_view_new_with_buffer,libgtksourceview),Ptr{GObject},(Ptr{GObject},),buffer))
    

show_line_numbers!(view::GtkSourceView, show::Bool) = 
  ccall((:gtk_source_view_set_show_line_numbers,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),view,int32(show))

end # module
