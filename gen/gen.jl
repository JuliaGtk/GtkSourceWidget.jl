using GI
GI.prepend_search_path("/usr/lib64/girepository-1.0")
GI.prepend_search_path("/usr/local/lib64/girepository-1.0")

toplevel, exprs, exports = GI.output_exprs()

path="../src/gen"

ns = GINamespace(:GtkSource,"5")

## constants, enums, and flags

const_mod = Expr(:block)

const_exports = Expr(:export)

c = GI.all_const_exprs!(const_mod, const_exports, ns; skiplist= [])
push!(const_mod.args, const_exports)

push!(exprs, const_mod)

## export constants, enums, and flags code
GI.write_to_file(path,"gtksourceview_consts",toplevel)

## structs and objects

toplevel, exprs, exports = GI.output_exprs()
GI.struct_cache_expr!(exprs)
GI.all_interfaces!(exprs,exports,ns;skiplist=[])
GI.all_objects!(exprs,exports,ns,skiplist=[],constructor_skiplist=[])

disguised = []
special = []
struct_skiplist=vcat(disguised, special, [])

struct_skiplist = GI.all_struct_exprs!(exprs,exports,ns;excludelist=struct_skiplist)
GI.all_callbacks!(exprs, exports, ns)

push!(exprs,exports)

GI.write_to_file(path,"gtksourceview_structs",toplevel)

## struct methods

toplevel, exprs, exports = GI.output_exprs()

GI.all_struct_methods!(exprs,ns,struct_skiplist=vcat(struct_skiplist,[]);print_detailed=true)

## object methods

objects=GI.get_all(ns,GI.GIObjectInfo)

object_skiplist=[]

skiplist=[:get_default]

GI.all_object_methods!(exprs,ns;skiplist=skiplist,object_skiplist=object_skiplist,interface_helpers=false)
GI.all_interface_methods!(exprs,ns;skiplist=[],interface_skiplist=[])

GI.write_to_file(path,"gtksourceview_methods",toplevel)

## functions

toplevel, exprs, exports = GI.output_exprs()

GI.all_functions!(exprs,ns,skiplist=skiplist)

GI.write_to_file(path,"gtksourceview_functions",toplevel)
