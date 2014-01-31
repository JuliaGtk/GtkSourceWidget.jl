module GtkSourceWidget


export GtkSourceLanguage, GtkSourceLanguageManager, GtkSourceBuffer,
       GtkSourceView, GtkSourceCompletionItem,
       GtkSourceStyleSchemeManager, GtkSourceStyleScheme

export scheme, language, show_line_numbers!, auto_indent!, style_scheme, style_scheme!

using Gtk

const GObject = Gtk.GObject

const libgtksourceview = "libgtksourceview-3.0"

### GtkSourceLanguage

Gtk.@Gtype GtkSourceLanguage libgtksourceview gtk_source_language

### GtkSourceLanguageManager

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

### GtkSourceStyleScheme

Gtk.@Gtype GtkSourceStyleScheme libgtksourceview gtk_source_style_scheme

### GtkSourceStyleSchemeManager

Gtk.@Gtype GtkSourceStyleSchemeManager libgtksourceview gtk_source_style_scheme_manager
function GtkSourceStyleSchemeManager(default=true) 
  if default
    GtkSourceStyleSchemeManager(
      ccall((:gtk_source_style_scheme_manager_get_default,libgtksourceview),Ptr{GObject},()))
  else
    GtkSourceStyleSchemeManager(
      ccall((:gtk_source_style_scheme_manager_get_new,libgtksourceview),Ptr{GObject},()))
  end
end

style_scheme(manager::GtkSourceStyleSchemeManager, scheme_id::String) = GtkSourceStyleScheme(
    ccall((:gtk_source_style_scheme_manager_get_scheme,libgtksourceview),Ptr{GObject},
          (Ptr{GObject},Ptr{Uint8}),manager,bytestring(scheme_id)))


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
        
style_scheme!(buffer::GtkSourceBuffer, scheme::GtkSourceStyleScheme) =
  ccall((:gtk_source_buffer_set_style_scheme,libgtksourceview),Void,
        (Ptr{GObject},Ptr{GObject}),buffer,scheme)

### GtkSourceView

Gtk.@Gtype GtkSourceView libgtksourceview gtk_source_view
GtkSourceView(buffer=GtkSourceBuffer()) = GtkSourceView(
    ccall((:gtk_source_view_new_with_buffer,libgtksourceview),Ptr{GObject},(Ptr{GObject},),buffer))
    

show_line_numbers!(view::GtkSourceView, show::Bool) = 
  ccall((:gtk_source_view_set_show_line_numbers,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),view,int32(show))
        
auto_indent!(view::GtkSourceView, auto::Bool) = 
  ccall((:gtk_source_view_set_auto_indent,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),view,int32(auto))

### GtkSourceCompletionContext

baremodule GtkSourceCompletionActivation
    const GTK_SOURCE_COMPLETION_ACTIVATION_NONE = 0
    const GTK_SOURCE_COMPLETION_ACTIVATION_INTERACTIVE = 1
    const GTK_SOURCE_COMPLETION_ACTIVATION_USER_REQUESTED = 2
end

Gtk.@Gtype GtkSourceCompletionContext libgtksourceview gtk_source_completion_context

#function add_proposals(context::GtkSourceCompletionContext, provider::GtkSourceCompletionProvider,
#                       proposals::GList, finished::Bool)
#  ccall((:gtk_source_completion_context_add_proposals,libgtksourceview),Void,
#        (Ptr{GObject},Ptr{GObject}, Ptr{GList},Cint),context, provider, &proposals, finished)                       
#end

#getiter(context::GtkSourceCompletionContext, iter::GtkTextIter) =
#   ccall((:gtk_source_completion_context_get_iter,libgtksourceview),Void,
#        (Ptr{GObject},Ptr{Void}),context, iter)  
        
getactivation(context::GtkSourceCompletionContext) =
   ccall((:gtk_source_completion_context_get_activation,libgtksourceview),Cint,
        (Ptr{GObject},),context)

### GtkSourceCompletionItem

Gtk.@Gtype GtkSourceCompletionItem libgtksourceview gtk_source_completion_item
GtkSourceCompletionItem(label::String, text::String) = GtkSourceCompletionItem(
    ccall((:gtk_source_completion_item_new,libgtksourceview),Ptr{GObject},
          (Ptr{Uint8},Ptr{Uint8},Ptr{Void},Ptr{Uint8}),
           bytestring(label),bytestring(text),C_NULL,C_NULL))


end # module
