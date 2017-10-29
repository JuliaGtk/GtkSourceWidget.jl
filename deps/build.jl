println("checking for libgtksourceview...")
@static if is_linux()
    try
        strip(readall(pipeline(`ldconfig -p`, `grep libgtksourceview-3`, `cut -d'>' -f2`)))
    catch
        run(`sudo apt-get install libgtksourceview-3.0-1`)
    end
end
@static if is_apple()
    if !isfile( Pkg.dir() * "/Homebrew/deps/usr/lib/libgtksourceview-3.0.dylib" )
        using Homebrew
        Homebrew.add("gtksourceview3")
    end
end
