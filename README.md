# RPR MWE

Download + install julia:
https://julialang.org/downloads/

julia-1.10-beta4: https://julialang-s3.julialang.org/bin/winnt/x64/1.9/julia-1.9.0-beta4-win64.exe

Actually works on julia-1.6.7: https://julialang-s3.julialang.org/bin/winnt/x64/1.6/julia-1.6.7-win64.exe

```sh
$ git clone https://github.com/SimonDanisch/RPRMWE.jl.git RPRMWE
$ cd RPRMWE
$ julia --project=. 'using Pkg; Pkg.instantiate()'
$ julia --project=. rpr_mwe.jl
$ julia --project=. rpr_mwe_basic.jl
```
