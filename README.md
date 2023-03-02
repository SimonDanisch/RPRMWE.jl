# RPR MWE

Download + install julia:
https://julialang.org/downloads/

Not working julia versions:

julia-1.9-beta4: https://julialang-s3.julialang.org/bin/winnt/x64/1.9/julia-1.9.0-beta4-win64.exe
julia-1.8.5:     https://julialang-s3.julialang.org/bin/winnt/x64/1.8/julia-1.8.5-win64.zip

Working julia versions:

julia-1.6.7: https://julialang-s3.julialang.org/bin/winnt/x64/1.6/julia-1.6.7-win64.exe

```sh
$ git clone https://github.com/SimonDanisch/RPRMWE.jl.git RPRMWE
$ cd RPRMWE
$ julia --project=. -e 'using Pkg; Pkg.instantiate()'
$ julia --project=. rpr_mwe.jl
$ julia --project=. rpr_mwe_basic.jl
```
