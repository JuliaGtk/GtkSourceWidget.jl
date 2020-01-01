module GtkSourceWidget

using Gtk, GtkSourceView_jll

export GtkSourceLanguage, GtkSourceLanguageManager, GtkSourceBuffer,
       GtkSourceView, GtkSourceCompletionItem,
       GtkSourceStyleSchemeManager, GtkSourceStyleScheme, GtkSourceMap,
       GtkSourceSearchContext, GtkSourceSearchSettings

export scheme, language, show_line_numbers!, auto_indent!, style_scheme, style_scheme!,
       max_undo_levels, max_undo_levels!, undo!, redo!, canundo, canredo, undomanager,
       highlight_current_line!, highlight_matching_brackets, source_view_get_gutter,
       reset_undomanager, set_view, get_view, style_scheme_chooser, style_scheme_chooser_button,
       set_search_text, get_search_text, search_context_forward, highlight, search_context_replace

import ..Gtk: suffix, GObject, GtkTextIter

const MutableGtkTextIter = Gtk.GLib.MutableTypes.Mutable{GtkTextIter}

mutable(it::GtkTextIter) = Gtk.GLib.MutableTypes.mutable(it)

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

get_search_path(manager::GtkSourceLanguageManager) = ccall((:gtk_source_language_manager_get_search_path,libgtksourceview),Ptr{Ptr{UInt8}},
    (Ptr{GObject},),manager)

"""
    set_search_path(manager::GtkSourceLanguageManager, dir)

Implements `gtk_source_language_manager_set_search_path`.

Example : 
    `GtkSourceWidget.set_search_path(sourceStyleManager, Any[path, C_NULL])`
"""
set_search_path(manager::GtkSourceLanguageManager, dir)  = ccall((:gtk_source_language_manager_set_search_path,libgtksourceview),Nothing,
    (Ptr{GObject}, Ptr{Ptr{UInt8}}),manager, dir)


"""
    language(manager::GtkSourceLanguageManager, id::String)

Implements `gtk_source_language_manager_get_language`.
"""
language(manager::GtkSourceLanguageManager, id::String) = GtkSourceLanguage(
    ccall((:gtk_source_language_manager_get_language,libgtksourceview),Ptr{GObject},
          (Ptr{GObject},Ptr{UInt8}),manager,string(id)))
          
### GtkSourceStyle
          
Gtk.@Gtype GtkSourceStyle libgtksourceview gtk_source_style

### GtkSourceStyleScheme

Gtk.@Gtype GtkSourceStyleScheme libgtksourceview gtk_source_style_scheme

"""
    style(scheme::GtkSourceStyleScheme, style_id::String)

Implements `gtk_source_style_scheme_get_style`.
"""
style(scheme::GtkSourceStyleScheme, style_id::String)  = GtkSourceStyle(
    ccall((:gtk_source_style_scheme_get_style,libgtksourceview),Ptr{GObject},
    (Ptr{GObject}, Ptr{UInt8}), scheme, string(style_id)))

### GtkSourceStyleSchemeManager

Gtk.@Gtype GtkSourceStyleSchemeManager libgtksourceview gtk_source_style_scheme_manager
function GtkSourceStyleSchemeManagerLeaf(default=true)
  if default
    GtkSourceStyleSchemeManagerLeaf(
      ccall((:gtk_source_style_scheme_manager_get_default, libgtksourceview), Ptr{GObject},()))
  else
    GtkSourceStyleSchemeManagerLeaf(
      ccall((:gtk_source_style_scheme_manager_get_new, libgtksourceview), Ptr{GObject},()))
  end
end

"""
    style_scheme(manager::GtkSourceStyleSchemeManager, scheme_id::String)

Implements `gtk_source_style_scheme_manager_get_scheme`.
"""
style_scheme(manager::GtkSourceStyleSchemeManager, scheme_id::String) = GtkSourceStyleScheme(
    ccall((:gtk_source_style_scheme_manager_get_scheme,libgtksourceview),Ptr{GObject},
          (Ptr{GObject},Ptr{UInt8}),manager,string(scheme_id)))

"""
    set_search_path(manager::GtkSourceStyleSchemeManager, dir)

Implements `gtk_source_style_scheme_manager_set_search_path`.
"""
set_search_path(manager::GtkSourceStyleSchemeManager, dir)  = ccall((:gtk_source_style_scheme_manager_set_search_path,libgtksourceview),Nothing,
    (Ptr{GObject}, Ptr{Ptr{UInt8}}),manager, dir)

### GtkSourceUndoManager

### This is a hack!!!
struct GtkSourceUndoManagerI end

undo!(manager::GtkSourceUndoManagerI) =
  ccall((:gtk_source_undo_manager_undo,libgtksourceview),Nothing,
        (Ptr{Nothing},),manager.handle)

redo!(manager::GtkSourceUndoManagerI) =
  ccall((:gtk_source_undo_manager_redo,libgtksourceview),Nothing,
        (Ptr{Nothing},),manager.handle)

canundo(manager::GtkSourceUndoManagerI) = Bool(
  ccall((:gtk_source_undo_manager_can_undo,libgtksourceview),Cint,
        (Ptr{Nothing},),manager.handle))

canredo(manager::GtkSourceUndoManagerI) = Bool(
  ccall((:gtk_source_undo_manager_can_redo,libgtksourceview),Cint,
        (Ptr{Nothing},),manager.handle))

### GtkSourceBuffer

Gtk.@Gtype GtkSourceBuffer libgtksourceview gtk_source_buffer
GtkSourceBufferLeaf() = GtkSourceBufferLeaf(
     ccall((:gtk_source_buffer_new,libgtksourceview),Ptr{GObject}, (Ptr{Nothing},), C_NULL) )

"""
    GtkSourceBuffer(lang::GtkSourceLanguage)

Implements `gtk_source_buffer_new_with_language`.
"""
GtkSourceBufferLeaf(lang::GtkSourceLanguage) = GtkSourceBufferLeaf(
     ccall((:gtk_source_buffer_new_with_language, libgtksourceview), Ptr{GObject},
           (Ptr{GObject},), lang) )

"""
    highlight_syntax(buffer::GtkSourceBuffer, highlight::Bool)

Implements `gtk_source_buffer_set_highlight_syntax`.
"""
highlight_syntax(buffer::GtkSourceBuffer, highlight::Bool) =
  ccall((:gtk_source_buffer_set_highlight_syntax,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),buffer,Int32(highlight))

"""
    highlight_matching_brackets(buffer::GtkSourceBuffer, highlight::Bool)

Implements `gtk_source_buffer_set_highlight_matching_brackets`.
"""
highlight_matching_brackets(buffer::GtkSourceBuffer, highlight::Bool) =
  ccall((:gtk_source_buffer_set_highlight_matching_brackets,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),buffer,Int32(highlight))

"""
    style_scheme!(buffer::GtkSourceBuffer, scheme::GtkSourceStyleScheme)

Implements `gtk_source_buffer_set_style_scheme`.
"""
style_scheme!(buffer::GtkSourceBuffer, scheme::GtkSourceStyleScheme) =
  ccall((:gtk_source_buffer_set_style_scheme,libgtksourceview),Nothing,
        (Ptr{GObject},Ptr{GObject}),buffer,scheme)

max_undo_levels(buffer::GtkSourceBuffer) =
  ccall((:gtk_source_buffer_get_max_undo_levels,libgtksourceview),Cint,
        (Ptr{GObject},),buffer)

max_undo_levels!(buffer::GtkSourceBuffer, levels::Integer) =
  ccall((:gtk_source_buffer_set_max_undo_levels,libgtksourceview),Nothing,
        (Ptr{GObject},Cint),buffer,levels)

"""
    undo!(buffer::GtkSourceBuffer)

Implements `gtk_source_buffer_undo`.
"""
undo!(buffer::GtkSourceBuffer) =
  ccall((:gtk_source_buffer_undo,libgtksourceview),Nothing,
        (Ptr{GObject},),buffer)

"""
    redo!(buffer::GtkSourceBuffer)

Implements `gtk_source_buffer_redo`.
"""
redo!(buffer::GtkSourceBuffer) =
  ccall((:gtk_source_buffer_redo,libgtksourceview),Nothing,
        (Ptr{GObject},),buffer)

canundo(buffer::GtkSourceBuffer) = Bool(
  ccall((:gtk_source_buffer_can_undo,libgtksourceview),Cint,
        (Ptr{GObject},),buffer))

canredo(buffer::GtkSourceBuffer) = Bool(
  ccall((:gtk_source_buffer_can_redo,libgtksourceview),Cint,
        (Ptr{GObject},),buffer))

undomanager(buffer::GtkSourceBuffer) = GtkSourceUndoManagerI(
  ccall((:gtk_source_buffer_get_undo_manager,libgtksourceview),Ptr{Nothing},
        (Ptr{GObject},),buffer))

reset_undomanager(buffer::GtkSourceBuffer) = ccall((:gtk_source_buffer_set_undo_manager,libgtksourceview),Nothing,
        (Ptr{GObject},Ptr{GObject}),buffer,C_NULL)


### GtkSourceView

Gtk.@Gtype GtkSourceView libgtksourceview gtk_source_view
GtkSourceViewLeaf(buffer=GtkSourceBuffer()) = GtkSourceView(
    ccall((:gtk_source_view_new_with_buffer,libgtksourceview),Ptr{GObject},(Ptr{GObject},),buffer))


"""
    show_line_numbers!(view::GtkSourceView, show::Bool)

Implements `gtk_source_view_set_show_line_numbers`.
"""
show_line_numbers!(view::GtkSourceView, show::Bool) =
  ccall((:gtk_source_view_set_show_line_numbers,libgtksourceview),Nothing,
        (Ptr{GObject},Cint),view,Int32(show))

auto_indent!(view::GtkSourceView, auto::Bool) =
  ccall((:gtk_source_view_set_auto_indent,libgtksourceview),Nothing,
        (Ptr{GObject},Cint),view,Int32(auto))

"""
    highlight_current_line!(view::GtkSourceView, hl::Bool)

Implements `gtk_source_view_set_highlight_current_line`.
"""
highlight_current_line!(view::GtkSourceView, hl::Bool) =
  ccall((:gtk_source_view_set_highlight_current_line,libgtksourceview),Nothing,
        (Ptr{GObject},Cint),view,Int32(hl))

### GtkSourceCompletion

Gtk.@Gtype GtkSourceCompletion libgtksourceview gtk_source_completion

get_completion(view::GtkSourceView) =
    ccall((:gtk_source_view_get_completion,libgtksourceview),Ptr{GtkSourceCompletion},
        (Ptr{GObject},),view)


### GtkSourceCompletionContext

baremodule GtkSourceCompletionActivation
    const GTK_SOURCE_COMPLETION_ACTIVATION_NONE = 0
    const GTK_SOURCE_COMPLETION_ACTIVATION_INTERACTIVE = 1
    const GTK_SOURCE_COMPLETION_ACTIVATION_USER_REQUESTED = 2
end

Gtk.@Gtype GtkSourceCompletionContext libgtksourceview gtk_source_completion_context

#function add_proposals(context::GtkSourceCompletionContext, provider::GtkSourceCompletionProvider,
#                       proposals::GList, finished::Bool)
#  ccall((:gtk_source_completion_context_add_proposals,libgtksourceview),Nothing,
#        (Ptr{GObject},Ptr{GObject}, Ptr{GList},Cint),context, provider, &proposals, finished)
#end

#getiter(context::GtkSourceCompletionContext, iter::GtkTextIter) =
#   ccall((:gtk_source_completion_context_get_iter,libgtksourceview),Nothing,
#        (Ptr{GObject},Ptr{Nothing}),context, iter)

getactivation(context::GtkSourceCompletionContext) =
   ccall((:gtk_source_completion_context_get_activation,libgtksourceview),Cint,
        (Ptr{GObject},),context)

### GtkSourceCompletionItem

Gtk.@Gtype GtkSourceCompletionItem libgtksourceview gtk_source_completion_item

GtkSourceCompletionItemLeaf(label::String, text::String) = GtkSourceCompletionItemLeaf(
    ccall((:gtk_source_completion_item_new,libgtksourceview),Ptr{GObject},
        (Ptr{UInt8},Ptr{UInt8},Ptr{Nothing},Ptr{UInt8}),
        string(label),string(text),C_NULL,C_NULL))


### GtkSourceCompletionProvider

Gtk.GLib.@Giface GtkSourceCompletionProvider libgtksourceview gtk_source_completion_provider

## GtkSourceSearchSettings

Gtk.@Gtype GtkSourceSearchSettings libgtksourceview gtk_source_search_settings

GtkSourceSearchSettingsLeaf() = GtkSourceSearchSettingsLeaf(
    ccall((:gtk_source_search_settings_new,libgtksourceview),Ptr{GObject},())
)

set_search_text(settings::GtkSourceSearchSettings, text::String) =
    ccall((:gtk_source_search_settings_set_search_text,libgtksourceview),Nothing,
        (Ptr{GObject},Ptr{UInt8}),settings,text)

function get_search_text(settings::GtkSourceSearchSettings)

    s = ccall((:gtk_source_search_settings_get_search_text,libgtksourceview),Ptr{UInt8},
    (Ptr{GObject},),settings)

    return s == C_NULL ? "" : string(s)
end

## GtkSourceSearchContext

Gtk.@Gtype GtkSourceSearchContext libgtksourceview gtk_source_search_context

GtkSourceSearchContextLeaf(buffer::GtkSourceBuffer,settings::GtkSourceSearchSettings) = GtkSourceSearchContextLeaf(
    ccall((:gtk_source_search_context_new,libgtksourceview),Ptr{GObject},(Ptr{GObject},Ptr{GObject}),buffer,settings))

search_context_forward(search::GtkSourceSearchContext, iter::GtkTextIter,match_start::MutableGtkTextIter,match_end::MutableGtkTextIter) =
    convert(Bool,ccall((:gtk_source_search_context_forward,libgtksourceview),Cint,
        (Ptr{GObject},Ref{GtkTextIter},Ptr{MutableGtkTextIter},Ptr{MutableGtkTextIter}),
        search,iter,match_start,match_end))

function search_context_forward(search::GtkSourceSearchContext, iter::GtkTextIter)

    match_start = mutable(GtkTextIter())
    match_end   = mutable(GtkTextIter())

    found = search_context_forward(search,iter,match_start,match_end)
    return (found,match_start,match_end)
end

function search_context_replace(
    search::GtkSourceSearchContext,
    match_start::MutableGtkTextIter, match_end::MutableGtkTextIter,
    replace::String)

    out = ccall((:gtk_source_search_context_replace,libgtksourceview),Cint,
        (Ptr{GObject},Ptr{MutableGtkTextIter},Ptr{MutableGtkTextIter},Ptr{UInt8},Cint,Ptr{Nothing}),
        search,match_start,match_end,string(replace),-1,C_NULL)

    return convert(Bool,out)
end

function search_context_replace_all(search::GtkSourceSearchContext, replace::String)

    out = ccall((:gtk_source_search_context_replace_all,libgtksourceview),Cint,
        (Ptr{GObject},Ptr{UInt8},Cint,Ptr{Nothing}),
        search,string(replace),-1,C_NULL)

    return out
end

highlight(search::GtkSourceSearchContext, highlight::Bool) =
    ccall((:gtk_source_search_context_set_highlight,libgtksourceview),Nothing,
        (Ptr{GObject},Cint), search,highlight)

### GtkSourceGutter

source_view_get_gutter(view::GtkSourceView) =  ccall((:gtk_source_view_get_gutter,libgtksourceview),Ptr{Nothing},(Ptr{GObject},Cint),view,Int32(1))

### GtkSourceMap

function _define_source_map()
    if Sys.islinux()
        return :(
            global SOURCE_MAP = false
        )
    else
        return quote
            global SOURCE_MAP  = true
            Gtk.@Gtype GtkSourceMap libgtksourceview gtk_source_map

    		GtkSourceMapLeaf() = GtkSourceMapLeaf( ccall((:gtk_source_map_new,libgtksourceview),Ptr{GObject},()) )

    		get_view(map::GtkSourceMap) =
    		    ccall((:gtk_source_map_get_view,libgtksourceview),Ptr{GtkSourceView},
    		        (Ptr{GObject},),map)

    		set_view(map::GtkSourceMap,view::GtkSourceView) =
    		    ccall((:gtk_source_map_set_view,libgtksourceview),Nothing,
    		        (Ptr{GObject},Ptr{GObject}),map,view)
        end
    end
end

macro define_source_map() esc(_define_source_map()) end

@define_source_map()

## GtkSourceStyleSchemeChooserWidget

style_scheme_chooser() = Gtk.GtkWidgetLeaf( ccall((:gtk_source_style_scheme_chooser_widget_new,libgtksourceview),Ptr{GObject},()) )
style_scheme_chooser_button() = Gtk.GtkWidgetLeaf( ccall((:gtk_source_style_scheme_chooser_button_new,libgtksourceview),Ptr{GObject},()) )

style_scheme(chooser::Gtk.GtkWidget) = GtkSourceStyleScheme(
    ccall((:gtk_source_style_scheme_chooser_get_style_scheme,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},),chooser)  )

#? https://github.com/JuliaLang/Gtk.jl/blob/40f7442dea20919c5a7b137594fb6d7636fa2329/src/selectors.jl

function __init__()
    global sourceLanguageManager = GtkSourceLanguageManager()
    GtkSourceWidget.set_search_path(sourceLanguageManager,
      Any[joinpath(GtkSourceView_jll.artifact_dir, "share", "gtksourceview-4", "language-specs"), C_NULL])
end

end # module
