println("checking for libgtksourceview...")
@linux_only begin
    try
        strip(readall(pipeline(`ldconfig -p`, `grep libgtksourceview-3`, `cut -d'>' -f2`)))
    catch
        run(`sudo apt-get install libgtksourceview-3.0-1`)
    end
end
@osx_only begin
    if !isfile( Pkg.dir() * "/Homebrew/deps/usr/lib/libgtksourceview-3.0.dylib" )
        using Homebrew
        Homebrew.add("gtksourceview3")
    end
end
