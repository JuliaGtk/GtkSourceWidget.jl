module GtkSourceWidget


export GtkSourceLanguage, GtkSourceLanguageManager, GtkSourceBuffer,
       GtkSourceView, GtkSourceCompletionItem

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
        
auto_indent!(view::GtkSourceView, auto::Bool) = 
  ccall((:gtk_source_view_set_auto_indent,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),view,int32(auto))

### GtkSourceCompletionContext

baremodule GtkSourceCompletionActivation
    const GTK_SOURCE_COMPLETION_ACTIVATION_NONE = 0
    const GTK_SOURCE_COMPLETION_ACTIVATION_INTERACTIVE = 1 << 0
    const GTK_SOURCE_COMPLETION_ACTIVATION_USER_REQUESTED = 1 << 1
end

Gtk.@Gtype GtkSourceCompletionContext libgtksourceview gtk_source_completion_context

function add_proposals(context::GtkSourceCompletionContext, provider::GtkSourceCompletionProvider,
                       proposals::GList, finished::Bool)
  ccall((:gtk_source_completion_context_add_proposals,libgtksourceview),Void,
        (Ptr{GObject},Ptr{GObject}, Ptr{GList},Cint),context, provider, &proposals, finished)                       
end

void                gtk_source_completion_context_get_iter
                                                        (GtkSourceCompletionContext *context,
                                                         GtkTextIter *iter);
GtkSourceCompletionActivation gtk_source_completion_context_get_activation
                                                        (GtkSourceCompletionContext *context);

### GtkSourceCompletionItem

Gtk.@Gtype GtkSourceCompletionItem libgtksourceview gtk_source_completion_item
GtkSourceCompletionItem(label::String, text::String) = GtkSourceCompletionItem(
    ccall((:gtk_source_completion_item_new,libgtksourceview),Ptr{GObject},
          (Ptr{Uint8},Ptr{Uint8},Ptr{Void},Ptr{Uint8}),
           bytestring(label),bytestring(text),C_NULL,C_NULL))



end # module
