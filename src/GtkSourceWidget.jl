module GtkSourceWidget


export GtkSourceLanguage, GtkSourceLanguageManager, GtkSourceBuffer,
       GtkSourceView, GtkSourceCompletionItem,
       GtkSourceStyleSchemeManager, GtkSourceStyleScheme

export @GtkSourceLanguage, @GtkSourceLanguageManager, @GtkSourceBuffer,
       @GtkSourceView, @GtkSourceCompletionItem,
       @GtkSourceStyleSchemeManager, @GtkSourceStyleScheme


export scheme, language, show_line_numbers!, auto_indent!, style_scheme, style_scheme!,
       max_undo_levels, max_undo_levels!, undo!, redo!, canundo, canredo, undomanager,
       highlight_current_line!, highlight_matching_brackets

using Gtk

import ..Gtk: suffix

const GObject = Gtk.GObject

if Gtk.gtk_version == 3
    if OS_NAME == :Windows
        const libgtksourceview = "libgtksourceview-3.0-0"
	else
        const libgtksourceview = "libgtksourceview-3.0"
    end
else
    error("Unsupported Gtk version $gtk_version")
end

### GtkSourceLanguage

Gtk.@Gtype GtkSourceLanguage libgtksourceview gtk_source_language

### GtkSourceLanguageManager

Gtk.@Gtype GtkSourceLanguageManager libgtksourceview gtk_source_language_manager
function GtkSourceLanguageManagerLeaf(default=true) 
  if default
    GtkSourceLanguageManagerLeaf(
      ccall((:gtk_source_language_manager_get_default,libgtksourceview),Ptr{GObject},()))
  else
    GtkSourceLanguageManagerLeaf(
      ccall((:gtk_source_language_manager_new,libgtksourceview),Ptr{GObject},()))
  end
end

language(manager::GtkSourceLanguageManager, id::String) = @GtkSourceLanguage(
    ccall((:gtk_source_language_manager_get_language,libgtksourceview),Ptr{GObject},
          (Ptr{GObject},Ptr{Uint8}),manager,bytestring(id)))

### GtkSourceStyleScheme

Gtk.@Gtype GtkSourceStyleScheme libgtksourceview gtk_source_style_scheme

### GtkSourceStyleSchemeManager

Gtk.@Gtype GtkSourceStyleSchemeManager libgtksourceview gtk_source_style_scheme_manager
function GtkSourceStyleSchemeManagerLeaf(default=true) 
  if default
    GtkSourceStyleSchemeManagerLeaf(
      ccall((:gtk_source_style_scheme_manager_get_default,libgtksourceview),Ptr{GObject},()))
  else
    GtkSourceStyleSchemeManagerLeaf(
      ccall((:gtk_source_style_scheme_manager_get_new,libgtksourceview),Ptr{GObject},()))
  end
end

style_scheme(manager::GtkSourceStyleSchemeManager, scheme_id::String) = @GtkSourceStyleScheme(
    ccall((:gtk_source_style_scheme_manager_get_scheme,libgtksourceview),Ptr{GObject},
          (Ptr{GObject},Ptr{Uint8}),manager,bytestring(scheme_id)))

### GtkSourceUndoManager

### This is a hack!!!
type GtkSourceUndoManagerI
  handle::Ptr{Void}
end

undo!(manager::GtkSourceUndoManagerI) =
  ccall((:gtk_source_undo_manager_undo,libgtksourceview),Void,
        (Ptr{Void},),manager.handle)
        
redo!(manager::GtkSourceUndoManagerI) =
  ccall((:gtk_source_undo_manager_redo,libgtksourceview),Void,
        (Ptr{Void},),manager.handle)
        
canundo(manager::GtkSourceUndoManagerI) = bool(
  ccall((:gtk_source_undo_manager_can_undo,libgtksourceview),Cint,
        (Ptr{Void},),manager.handle))
        
canredo(manager::GtkSourceUndoManagerI) = bool(
  ccall((:gtk_source_undo_manager_can_redo,libgtksourceview),Cint,
        (Ptr{Void},),manager.handle))

### GtkSourceBuffer

Gtk.@Gtype GtkSourceBuffer libgtksourceview gtk_source_buffer
GtkSourceBufferLeaf() = GtkSourceBufferLeaf(
     ccall((:gtk_source_buffer_new,libgtksourceview),Ptr{GObject}, (Ptr{Void},), C_NULL) )
     
GtkSourceBufferLeaf(lang::GtkSourceLanguage) = GtkSourceBufferLeaf(
     ccall((:gtk_source_buffer_new_with_language,libgtksourceview),Ptr{GObject}, 
           (Ptr{GObject},), lang) ) 

highlight_syntax(buffer::GtkSourceBuffer, highlight::Bool) = 
  ccall((:gtk_source_buffer_set_highlight_syntax,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),buffer,int32(highlight))
        
highlight_matching_brackets(buffer::GtkSourceBuffer, highlight::Bool) = 
  ccall((:gtk_source_buffer_set_highlight_matching_brackets,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),buffer,int32(highlight))
        
style_scheme!(buffer::GtkSourceBuffer, scheme::GtkSourceStyleScheme) =
  ccall((:gtk_source_buffer_set_style_scheme,libgtksourceview),Void,
        (Ptr{GObject},Ptr{GObject}),buffer,scheme)

max_undo_levels(buffer::GtkSourceBuffer) =
  ccall((:gtk_source_buffer_get_max_undo_levels,libgtksourceview),Cint,
        (Ptr{GObject},),buffer)
        
max_undo_levels!(buffer::GtkSourceBuffer, levels::Integer) =
  ccall((:gtk_source_buffer_set_max_undo_levels,libgtksourceview),Void,
        (Ptr{GObject},Cint),buffer,levels)
        
undo!(buffer::GtkSourceBuffer) =
  ccall((:gtk_source_buffer_undo,libgtksourceview),Void,
        (Ptr{GObject},),buffer)
        
redo!(buffer::GtkSourceBuffer) =
  ccall((:gtk_source_buffer_redo,libgtksourceview),Void,
        (Ptr{GObject},),buffer)
        
canundo(buffer::GtkSourceBuffer) = bool(
  ccall((:gtk_source_buffer_can_undo,libgtksourceview),Cint,
        (Ptr{GObject},),buffer))
        
canredo(buffer::GtkSourceBuffer) = bool(
  ccall((:gtk_source_buffer_can_redo,libgtksourceview),Cint,
        (Ptr{GObject},),buffer))
        
undomanager(buffer::GtkSourceBuffer) = GtkSourceUndoManagerI(
  ccall((:gtk_source_buffer_get_undo_manager,libgtksourceview),Ptr{Void},
        (Ptr{GObject},),buffer))

### GtkSourceView

Gtk.@Gtype GtkSourceView libgtksourceview gtk_source_view
GtkSourceViewLeaf(buffer=@GtkSourceBuffer()) = @GtkSourceView(
    ccall((:gtk_source_view_new_with_buffer,libgtksourceview),Ptr{GObject},(Ptr{GObject},),buffer))
    

show_line_numbers!(view::GtkSourceView, show::Bool) = 
  ccall((:gtk_source_view_set_show_line_numbers,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),view,int32(show))
        
auto_indent!(view::GtkSourceView, auto::Bool) = 
  ccall((:gtk_source_view_set_auto_indent,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),view,int32(auto))
        
highlight_current_line!(view::GtkSourceView, hl::Bool) = 
  ccall((:gtk_source_view_set_highlight_current_line,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),view,int32(hl))

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
GtkSourceCompletionItemLeaf(label::String, text::String) = GtkSourceCompletionItemLeaf(
    ccall((:gtk_source_completion_item_new,libgtksourceview),Ptr{GObject},
          (Ptr{Uint8},Ptr{Uint8},Ptr{Void},Ptr{Uint8}),
           bytestring(label),bytestring(text),C_NULL,C_NULL))


end # module
