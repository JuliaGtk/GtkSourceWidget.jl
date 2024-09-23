module GtkSourceWidget

using Gtk4, GtkSourceView_jll, Gtk4.GLib
import CEnum: @cenum
import BitFlags: @bitflag

export GtkSourceLanguage, GtkSourceLanguageManager, GtkSourceBuffer,
       GtkSourceView, GtkSourceCompletionItem,
       GtkSourceStyleSchemeManager, GtkSourceStyleScheme, GtkSourceMap,
       GtkSourceSearchContext, GtkSourceSearchSettings

export scheme, language, show_line_numbers!, auto_indent!, style_scheme, style_scheme!,
       highlight_current_line!, highlight_matching_brackets, source_view_get_gutter,
       reset_undomanager, set_view, get_view, style_scheme_chooser, style_scheme_chooser_button,
       set_search_text, get_search_text, search_context_forward, highlight, search_context_replace

import ..Gtk4: GObject, GtkTextIter

eval(include("gen/gtksourceview_consts"))
eval(include("gen/gtksourceview_structs"))

module G_

using GtkSourceView_jll

using Gtk4
using Gtk4.GLib
using Gtk4.Pango
using Gtk4.GdkPixbufLib
using ..GtkSourceWidget

eval(include("gen/gtksourceview_methods"))
eval(include("gen/gtksourceview_functions"))

end

### GtkSourceLanguageManager

function GtkSourceLanguageManagerLeaf(default=true; kwargs...)
  if default
    GtkSourceLanguageManagerLeaf(
      ccall((:gtk_source_language_manager_get_default, libgtksourceview), Ptr{GObject}, ()))
  else
    G_.SourceLanguageManager(;kwargs...)
  end
end

get_search_path(manager::GtkSourceLanguageManager) = G_.get_search_path(manager)

"""
    set_search_path(manager::GtkSourceLanguageManager, dir)

Implements `gtk_source_language_manager_set_search_path`.

Example : 
    `GtkSourceWidget.set_search_path(sourceStyleManager, Any[path, ""])`
"""
set_search_path(manager::GtkSourceLanguageManager, dir)  = G_.set_search_path(manager, dir)

"""
    language(manager::GtkSourceLanguageManager, id::String)

Implements `gtk_source_language_manager_get_language`.
"""
language(manager::GtkSourceLanguageManager, id::String) = G_.get_language(manager, id)
          
### GtkSourceStyleScheme

"""
    style(scheme::GtkSourceStyleScheme, style_id::String)

Implements `gtk_source_style_scheme_get_style`.
"""
style(scheme::GtkSourceStyleScheme, style_id::String)  = GtkSourceStyle(
    ccall((:gtk_source_style_scheme_get_style, libgtksourceview), Ptr{GObject},
    (Ptr{GObject}, Ptr{UInt8}), scheme, string(style_id)))

### GtkSourceStyleSchemeManager

function GtkSourceStyleSchemeManagerLeaf(default=true)
  if default
    GtkSourceStyleSchemeManagerLeaf(
      ccall((:gtk_source_style_scheme_manager_get_default, libgtksourceview), Ptr{GObject}, ()))
  else
    G_.StyleSchemeManager_new()
  end
end

"""
    style_scheme(manager::GtkSourceStyleSchemeManager, scheme_id::String)

Implements `gtk_source_style_scheme_manager_get_scheme`.
"""
style_scheme(manager::GtkSourceStyleSchemeManager, scheme_id::String) = GtkSourceStyleScheme(
    ccall((:gtk_source_style_scheme_manager_get_scheme, libgtksourceview), Ptr{GObject},
          (Ptr{GObject}, Ptr{UInt8}), manager, string(scheme_id)))

"""
    set_search_path(manager::GtkSourceStyleSchemeManager, dir)

Implements `gtk_source_style_scheme_manager_set_search_path`.
"""
set_search_path(manager::GtkSourceStyleSchemeManager, dir)  = ccall(
    (:gtk_source_style_scheme_manager_set_search_path, libgtksourceview), Nothing,
    (Ptr{GObject}, Ptr{Ptr{UInt8}}), manager, dir
)

### GtkSourceBuffer

GtkSourceBuffer(; kwargs...) = GtkSourceBuffer(nothing; kwargs...)

#"""
#    GtkSourceBuffer(lang::GtkSourceLanguage)
#
#Implements `gtk_source_buffer_new_with_language`.
#"""

"""
    highlight_syntax(buffer::GtkSourceBuffer, highlight::Bool)

Implements `gtk_source_buffer_set_highlight_syntax`.
"""
highlight_syntax(buffer::GtkSourceBuffer, highlight::Bool) =
  ccall((:gtk_source_buffer_set_highlight_syntax, libgtksourceview), Ptr{GObject},
        (Ptr{GObject}, Cint), buffer, Int32(highlight))

"""
    highlight_matching_brackets(buffer::GtkSourceBuffer, highlight::Bool)

Implements `gtk_source_buffer_set_highlight_matching_brackets`.
"""
highlight_matching_brackets(buffer::GtkSourceBuffer, highlight::Bool) =
  ccall((:gtk_source_buffer_set_highlight_matching_brackets, libgtksourceview), Ptr{GObject},
        (Ptr{GObject}, Cint), buffer, Int32(highlight))

"""
    style_scheme!(buffer::GtkSourceBuffer, scheme::GtkSourceStyleScheme)

Implements `gtk_source_buffer_set_style_scheme`.
"""
style_scheme!(buffer::GtkSourceBuffer, scheme::GtkSourceStyleScheme) =
  ccall((:gtk_source_buffer_set_style_scheme, libgtksourceview), Nothing,
        (Ptr{GObject}, Ptr{GObject}), buffer, scheme)

### GtkSourceView

"""
    show_line_numbers!(view::GtkSourceView, show::Bool)

Implements `gtk_source_view_set_show_line_numbers`.
"""
show_line_numbers!(view::GtkSourceView, show::Bool) =
  ccall((:gtk_source_view_set_show_line_numbers, libgtksourceview), Nothing,
        (Ptr{GObject}, Cint), view, Int32(show))

auto_indent!(view::GtkSourceView, auto::Bool) =
  ccall((:gtk_source_view_set_auto_indent, libgtksourceview), Nothing,
        (Ptr{GObject}, Cint), view, Int32(auto))

"""
    highlight_current_line!(view::GtkSourceView, hl::Bool)

Implements `gtk_source_view_set_highlight_current_line`.
"""
highlight_current_line!(view::GtkSourceView, hl::Bool) = G_.set_highlight_current_line(view,hl)


### GtkSourceCompletion

get_completion(view::GtkSourceView) =
    ccall((:gtk_source_view_get_completion, libgtksourceview), Ptr{GtkSourceCompletion},
        (Ptr{GObject}, ), view)

# Gtk.create_mark(buffer::GtkSourceBuffer, mark_name, it, left_gravity::Bool)  = 
#     GtkTextMarkLeaf(ccall((:gtk_text_buffer_create_mark, Gtk.libgtk), Ptr{GObject},
#     (Ptr{Gtk.GObject}, Ptr{UInt8}, Ref{GtkTextIter}, Cint), buffer, mark_name, it, left_gravity))

# Gtk.create_mark(buffer::GtkTextBuffer, it)  = create_mark(buffer, C_NULL, it, false)


### GtkSourceCompletionContext

#function add_proposals(context::GtkSourceCompletionContext, provider::GtkSourceCompletionProvider,
#                       proposals::GList, finished::Bool)
#  ccall((:gtk_source_completion_context_add_proposals, libgtksourceview), Nothing,
#        (Ptr{GObject}, Ptr{GObject}, Ptr{GList}, Cint), context, provider, &proposals, finished)
#end

#getiter(context::GtkSourceCompletionContext, iter::GtkTextIter) =
#   ccall((:gtk_source_completion_context_get_iter, libgtksourceview), Nothing,
#        (Ptr{GObject}, Ptr{Nothing}), context, iter)

getactivation(context::GtkSourceCompletionContext) =
   ccall((:gtk_source_completion_context_get_activation, libgtksourceview), Cint,
        (Ptr{GObject}, ), context)

## GtkSourceSearchSettings

set_search_text(settings::GtkSourceSearchSettings, text::String) =
    ccall((:gtk_source_search_settings_set_search_text, libgtksourceview), Nothing,
        (Ptr{GObject}, Ptr{UInt8}), settings, text)

function get_search_text(settings::GtkSourceSearchSettings)
    s = ccall((:gtk_source_search_settings_get_search_text, libgtksourceview), Ptr{UInt8},
    (Ptr{GObject}, ), settings)

    return s == C_NULL ? "" : string(s)
end

## GtkSourceSearchContext

function search_context_forward(search::GtkSourceSearchContext, iter)
    found, match_start, match_end, wrapped_around = G_.forward(search, iter)
    return (found, Ref(match_start), Ref(match_end))
end

function search_context_replace(
    search::GtkSourceSearchContext,
    match_start::GtkTextIterLike, match_end::GtkTextIterLike,
    replace::String)
    G_.replace(search, match_start, match_end, replace, -1)
end

function search_context_replace_all(search::GtkSourceSearchContext, replace::String)
    G_.replace_all(search, replace, -1)
end

highlight(search::GtkSourceSearchContext, highlight::Bool) =
    G_.set_highlight(search, highlight)

### GtkSourceGutter

source_view_get_gutter(view::GtkSourceView) =  ccall(
    (:gtk_source_view_get_gutter, libgtksourceview), Ptr{Nothing}, (Ptr{GObject}, Cint),
     view, Int32(1)
)

### GtkSourceMap

get_view(map::GtkSourceMap) =
    ccall((:gtk_source_map_get_view, libgtksourceview), Ptr{GtkSourceView},
        (Ptr{GObject}, ), map)

set_view(map::GtkSourceMap, view::GtkSourceView) =
    ccall((:gtk_source_map_set_view, libgtksourceview), Nothing,
        (Ptr{GObject}, Ptr{GObject}), map, view)

## GtkSourceStyleSchemeChooserWidget

style_scheme_chooser() = GtkWidgetLeaf(
    ccall((:gtk_source_style_scheme_chooser_widget_new, libgtksourceview), Ptr{GObject}, ())
)
style_scheme_chooser_button() = GtkWidgetLeaf(
    ccall((:gtk_source_style_scheme_chooser_button_new, libgtksourceview), Ptr{GObject}, ())
)
style_scheme(chooser::GtkWidget) = GtkSourceStyleScheme(
    ccall((:gtk_source_style_scheme_chooser_get_style_scheme, libgtksourceview), Ptr{GObject},
    (Ptr{GObject}, ), chooser)
)

#? https://github.com/JuliaLang/Gtk.jl/blob/40f7442dea20919c5a7b137594fb6d7636fa2329/src/selectors.jl

function __init__()
    gtype_wrapper_cache_init()
    gboxed_cache_init()
    
    global sourceLanguageManager = GtkSourceLanguageManager()
    GtkSourceWidget.set_search_path(sourceLanguageManager,
      Any[joinpath(GtkSourceView_jll.artifact_dir, "share", "gtksourceview-5", "language-specs"), C_NULL])
end

end # module
