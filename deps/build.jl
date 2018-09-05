println("checking for libgtksourceview...")
@static if is_linux()
    try
        strip(readall(pipeline(`ldconfig -p`, `grep libgtksourceview-3`, `cut -d'>' -f2`)))
    catch
        run(`sudo apt-get install libgtksourceview-3.0-1`)
    end
end
@static if is_apple()
    using Homebrew
    if !Homebrew.installed("gtksourceview3")
        Homebrew.add("gtksourceview3")
    end
    if !Homebrew.linked("gtksourceview3")
        Homebrew.link("gtksourceview3")
    end
end


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