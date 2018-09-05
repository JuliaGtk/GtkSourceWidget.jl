__precompile__()
module GtkSourceWidget

export GtkSourceLanguage, GtkSourceLanguageManager, GtkSourceBuffer,
       GtkSourceView, GtkSourceCompletionItem,
       GtkSourceStyleSchemeManager, GtkSourceStyleScheme, GtkSourceMap,
       GtkSourceSearchContext, GtkSourceSearchSettings

export scheme, language, show_line_numbers!, auto_indent!, style_scheme, style_scheme!,
       max_undo_levels, max_undo_levels!, undo!, redo!, canundo, canredo, undomanager,
       highlight_current_line!, highlight_matching_brackets, source_view_get_gutter,
       reset_undomanager, set_view, get_view, style_scheme_chooser, style_scheme_chooser_button,
       set_search_text, get_search_text, search_context_forward, highlight, search_context_replace

using Gtk
using Compat

import ..Gtk: suffix, GObject, GtkTextIter

const MutableGtkTextIter = Gtk.GLib.MutableTypes.Mutable{GtkTextIter}

mutable(it::GtkTextIter) = Gtk.GLib.MutableTypes.mutable(it)

if Gtk.gtk_version == 3
    @static if is_windows()
        const libgtksourceview = joinpath(@__DIR__, "/bin/libgtksourceview-3.0-1.dll")
    end
    @static if is_linux()
        try
            strip(readstring(pipeline(`ldconfig -p`, `grep libgtksourceview-3`, `cut -d'>' -f2`)))
        catch
            run(`sudo apt-get install libgtksourceview-3.0-1`)
        end
        const libgtksourceview = strip(readstring(pipeline(`ldconfig -p`, `grep libgtksourceview-3`, `cut -d'>' -f2`, `head -1`)))
	end
    @static if is_apple()
        using Homebrew
        const libgtksourceview = joinpath(Homebrew.prefix(),"lib/libgtksourceview-3.0")
    end
else
    error("Unsupported Gtk version $gtk_version")
end


### GtkSourceLanguage

Gtk.@Gtype GtkSourceLanguage libgtksourceview gtk_source_language false

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


    # 3-element Array{Ptr{UInt8},1}:
    # Ptr{UInt8} @0x000000001bb85ac0
    # Ptr{UInt8} @0x000000001bb84e70
    # Ptr{UInt8} @0x0000000000000000
    #
    # julia> bytestring(pointer_to_array(p,2)[1])

set_search_path(manager::GtkSourceLanguageManager,dir)  = ccall((:gtk_source_language_manager_set_search_path,libgtksourceview),Void,
    (Ptr{GObject}, Ptr{Ptr{UInt8}}),manager, dir)

# Use: GtkSourceWidget.set_search_path(m,Any["c:/ad","yp",C_NULL])

language(manager::GtkSourceLanguageManager, id::String) = GtkSourceLanguage(
    ccall((:gtk_source_language_manager_get_language,libgtksourceview),Ptr{GObject},
          (Ptr{GObject},Ptr{UInt8}),manager,string(id)))
          
### GtkSourceStyle
          
Gtk.@Gtype GtkSourceStyle libgtksourceview gtk_source_style

### GtkSourceStyleScheme

Gtk.@Gtype GtkSourceStyleScheme libgtksourceview gtk_source_style_scheme


style(scheme::GtkSourceStyleScheme, style_id::String)  = GtkSourceStyle(
    ccall((:gtk_source_style_scheme_get_style,libgtksourceview),Ptr{GObject},
    (Ptr{GObject}, Ptr{UInt8}), scheme, string(style_id)))

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

style_scheme(manager::GtkSourceStyleSchemeManager, scheme_id::String) = GtkSourceStyleScheme(
    ccall((:gtk_source_style_scheme_manager_get_scheme,libgtksourceview),Ptr{GObject},
          (Ptr{GObject},Ptr{UInt8}),manager,string(scheme_id)))

set_search_path(manager::GtkSourceStyleSchemeManager,dir)  = ccall((:gtk_source_style_scheme_manager_set_search_path,libgtksourceview),Void,
    (Ptr{GObject}, Ptr{Ptr{UInt8}}),manager, dir)

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

canundo(manager::GtkSourceUndoManagerI) = Bool(
  ccall((:gtk_source_undo_manager_can_undo,libgtksourceview),Cint,
        (Ptr{Void},),manager.handle))

canredo(manager::GtkSourceUndoManagerI) = Bool(
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
        (Ptr{GObject},Cint),buffer,Int32(highlight))

highlight_matching_brackets(buffer::GtkSourceBuffer, highlight::Bool) =
  ccall((:gtk_source_buffer_set_highlight_matching_brackets,libgtksourceview),Ptr{GObject},
        (Ptr{GObject},Cint),buffer,Int32(highlight))

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

canundo(buffer::GtkSourceBuffer) = Bool(
  ccall((:gtk_source_buffer_can_undo,libgtksourceview),Cint,
        (Ptr{GObject},),buffer))

canredo(buffer::GtkSourceBuffer) = Bool(
  ccall((:gtk_source_buffer_can_redo,libgtksourceview),Cint,
        (Ptr{GObject},),buffer))

undomanager(buffer::GtkSourceBuffer) = GtkSourceUndoManagerI(
  ccall((:gtk_source_buffer_get_undo_manager,libgtksourceview),Ptr{Void},
        (Ptr{GObject},),buffer))

reset_undomanager(buffer::GtkSourceBuffer) = ccall((:gtk_source_buffer_set_undo_manager,libgtksourceview),Void,
        (Ptr{GObject},Ptr{GObject}),buffer,C_NULL)


### GtkSourceView

Gtk.@Gtype GtkSourceView libgtksourceview gtk_source_view
GtkSourceViewLeaf(buffer=GtkSourceBuffer()) = GtkSourceView(
    ccall((:gtk_source_view_new_with_buffer,libgtksourceview),Ptr{GObject},(Ptr{GObject},),buffer))


show_line_numbers!(view::GtkSourceView, show::Bool) =
  ccall((:gtk_source_view_set_show_line_numbers,libgtksourceview),Void,
        (Ptr{GObject},Cint),view,Int32(show))

auto_indent!(view::GtkSourceView, auto::Bool) =
  ccall((:gtk_source_view_set_auto_indent,libgtksourceview),Void,
        (Ptr{GObject},Cint),view,Int32(auto))

highlight_current_line!(view::GtkSourceView, hl::Bool) =
  ccall((:gtk_source_view_set_highlight_current_line,libgtksourceview),Void,
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
        (Ptr{UInt8},Ptr{UInt8},Ptr{Void},Ptr{UInt8}),
        string(label),string(text),C_NULL,C_NULL))


### GtkSourceCompletionProvider

Gtk.GLib.@Giface GtkSourceCompletionProvider libgtksourceview gtk_source_completion_provider

## GtkSourceSearchSettings

Gtk.@Gtype GtkSourceSearchSettings libgtksourceview gtk_source_search_settings

GtkSourceSearchSettingsLeaf() = GtkSourceSearchSettingsLeaf(
    ccall((:gtk_source_search_settings_new,libgtksourceview),Ptr{GObject},())
)

set_search_text(settings::GtkSourceSearchSettings, text::String) =
    ccall((:gtk_source_search_settings_set_search_text,libgtksourceview),Void,
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
        (Ptr{GObject},Ptr{MutableGtkTextIter},Ptr{MutableGtkTextIter},Ptr{UInt8},Cint,Ptr{Void}),
        search,match_start,match_end,string(replace),-1,C_NULL)

    return convert(Bool,out)
end

function search_context_replace_all(search::GtkSourceSearchContext, replace::String)

    out = ccall((:gtk_source_search_context_replace_all,libgtksourceview),Cint,
        (Ptr{GObject},Ptr{UInt8},Cint,Ptr{Void}),
        search,string(replace),-1,C_NULL)

    return out
end

highlight(search::GtkSourceSearchContext, highlight::Bool) =
    ccall((:gtk_source_search_context_set_highlight,libgtksourceview),Void,
        (Ptr{GObject},Cint), search,highlight)

### GtkSourceGutter

source_view_get_gutter(view::GtkSourceView) =  ccall((:gtk_source_view_get_gutter,libgtksourceview),Ptr{Void},(Ptr{GObject},Cint),view,Int32(1))

### GtkSourceMap

function _define_source_map()
    if is_linux()
        return :(
            global const SOURCE_MAP = false
        )
    else
        return quote
            global const SOURCE_MAP  = true
            Gtk.@Gtype GtkSourceMap libgtksourceview gtk_source_map

    		GtkSourceMapLeaf() = GtkSourceMapLeaf( ccall((:gtk_source_map_new,libgtksourceview),Ptr{GObject},()) )

    		get_view(map::GtkSourceMap) =
    		    ccall((:gtk_source_map_get_view,libgtksourceview),Ptr{GtkSourceView},
    		        (Ptr{GObject},),map)

    		set_view(map::GtkSourceMap,view::GtkSourceView) =
    		    ccall((:gtk_source_map_set_view,libgtksourceview),Void,
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

    global const sourceLanguageManager = GtkSourceLanguageManager()
    GtkSourceWidget.set_search_path(sourceLanguageManager,
      Any[Pkg.dir() * "/GtkSourceWidget/share/gtksourceview-3.0/language-specs/",C_NULL])
end


end # module
