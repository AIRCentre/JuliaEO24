

# Getting started

* Download and install [julia](https://julialang.org/downloads/) available for major operating systems (Linux, Mac OS, Windows ...). Other sources of julia like the Linux package manager are untested.  
* Start julia and type (or copy-paste) the following commands in the julia terminal:

 ```julia
using Pkg
Pkg.add("Pluto") # you can skip this if Pluto is already installed
using Pluto
Pluto.run()
```

* Click on input field "Enter path or URL" and paste the URL:

```
https://raw.githubusercontent.com/AIRCentre/JuliaEO24/main/notebooks/Workshop_DIVAnd/optim-observations-locations-game.jl
```

* Select `Run notebook code` and confirm "Are you sure that you trust this file" with "yes".

* Downloading and installing the package can take some time. There is a somewhat subtle progress-bar under the address line.
