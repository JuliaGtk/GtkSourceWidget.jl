using BinDeps, Compat

@BinDeps.setup

libgtksourceview = library_dependency("gtksourceview3", aliases = ["libgtksourceview-3.0-1"])

if Sys.isapple()
    using Homebrew
    provides(Homebrew.HB, "gtksourceview3", libgtksourceview, os = :Darwin)
end
if Sys.islinux()
    provides(AptGet, "libgtksourceview-3.0-1", libgtksourceview)
    provides(Yum, "libgtksourceview-3.0-1", libgtksourceview)
    provides(Pacman, "libgtksourceview-3.0-1", libgtksourceview)
end
if Sys.iswindows()
    using WinRPM
    provides(WinRPM.RPM,"gtksourceview3", libgtksourceview, os = :Windows)
end

@BinDeps.install Dict(
    "libgtksourceview" => "libgtksourceview",
)