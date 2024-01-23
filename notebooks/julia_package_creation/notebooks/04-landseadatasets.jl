### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ dcf31c28-cbb0-4aa9-b371-72e002bfb455
begin
	using Pkg; Pkg.activate()
	using DrWatson
	md"Using DrWatson to ensure package compatability"
end

# ╔═╡ c5ce5d54-21fe-4be3-b5b4-4d68dac1a190
begin
	@quickactivate "JuliaEO2024_Nat"
	using DelimitedFiles
	using GeoRegions
	using NASAPrecipitation
	using NCDatasets
	using PlutoUI

	using CairoMakie
	md"Activating JuliaEO Project for work do be done on notebook ..."
end

# ╔═╡ af53ce52-accb-11ee-2a0c-95b8bf3adea9
md"
# 04. Land-Sea Datasets
"

# ╔═╡ b6c4ab4f-ff93-4fd4-b4cd-ede1956ed022
TableOfContents()

# ╔═╡ d3c4f7a6-1222-4484-8fb8-745f6e05f184
begin
	coast = readdlm(datadir("SEA.cst"),comments=true)
	clon  = coast[:,1]
	clat  = coast[:,2]
	md"Preloading coastline data"
end

# ╔═╡ 8ad55e37-3667-4ccd-b700-15174346939b
md"
### A. What is a LandSea Dataset?

A LandSea dataset contains information on the topography and the land-sea mask.

The supertype is `AbstractLandSea`, with the following subtypes:
* `LandSeaTopo` for datasets with topographic information
* `LandSeaFlat` for datsets with only the land-sea mask and no topographic info

Why do we need to know the Land-Sea Mask?

Quite often, algorithmic retrieval of atmospheric properties is dependent on whether the surface is land or ocean/water.

GeoRegions.jl exports the `AbstractLandSea`, `LandSeaTopo` and `LandSeaFlat` types, so other packages (e.g., NASAPrecipitation.jl, ERA5Reanalysis.jl) can use it.
"

# ╔═╡ 38279b06-efd5-474d-ae16-5caa5342d190
md"
### B. ETOPO Land-Sea Mask

Starting from v5, GeoRegions.jl now fully supports the retrieval of 30- and 60-arcsecond ETOPO orographic data, which includes the following options:

* Topography that follows the ice-surface (surface)
* Topography that follows the bedrock beneath the ice (bedrock)
* Geoid data that converts the Topography into WTGS84 ellipsoid elevation heights

Let's do an example that covers Singapore (my homeland)
"

# ╔═╡ 91980a36-ee56-42d4-a7e4-4e7af283e6b7
geo = RectRegion(
	"MLY","GLB","Malaya",
	[5,0,105,100],savegeo=false
)

# ╔═╡ 58749000-f23f-4f9d-a32f-13f5abaeb908
lsd = getLandSea(geo,savelsd=false)

# ╔═╡ 19583f27-b37b-473d-a5d4-c6a4d5829c2e
begin
	fig = Figure()

	axsize = 400
	ax1 = Axis(
	    fig[1,1],width=axsize,height=axsize/((geo.E-geo.W)/(geo.N-geo.S)),
	    title="Tropography",xlabel="Longitude / º",ylabel="Latitude / º",
	    limits=(geo.W,geo.E,geo.S,geo.N)
	)
	ax2 = Axis(
	    fig[1,2],width=axsize,height=axsize/((geo.E-geo.W)/(geo.N-geo.S)),
	    title="Land-Sea Mask",xlabel="Longitude / º",
	    limits=(geo.W,geo.E,geo.S,geo.N)
	)

	contourf!(
	    ax1,lsd.lon,lsd.lat,lsd.z/1000,colormap=:delta,
	    levels=range(-0.5,0.5,length=51),extendlow=:auto,extendhigh=:auto
	)
	contourf!(
	    ax2,lsd.lon,lsd.lat,lsd.lsm,colormap=:delta,
	    levels=range(0,1,length=2),extendlow=:auto,extendhigh=:auto
	)
	lines!(ax1,clon,clat,color=:black,linewidth=0.5)
	lines!(ax2,clon,clat,color=:black,linewidth=0.5)
	
	resize_to_layout!(fig)
	fig
end

# ╔═╡ b0dbdafa-74dd-4c85-8aca-989854c44704
md"
### C. Now you try!
"

# ╔═╡ 35d7077f-4bb4-467f-8a1b-8544a5999303
# tst = RectRegion(
# 	"","GLB","",
# 	[],savegeo=false
# )

# ╔═╡ 3a975d77-3494-4d99-8472-b6914143ccca
lsd_tst = getLandSea(tst,savelsd=false)

# ╔═╡ de4a1d2c-752e-4e36-84e6-c1e21b1acb7d
#=╠═╡
begin
	fig2 = Figure()

	ax2_1 = Axis(
	    fig2[1,1],width=axsize,height=axsize/((geo.E-geo.W)/(geo.N-geo.S)),
	    title="Tropography",
		xlabel="Longitude / º",ylabel="Latitude / º",
	    limits=(geo.W,geo.E,geo.S,geo.N)
	)
	ax2_2 = Axis(
	    fig2[1,2],width=axsize,height=axsize/((geo.E-geo.W)/(geo.N-geo.S)),
	    title="Land-Sea Mask",
		xlabel="Longitude / º",ylabel="Latitude / º",
	    limits=(geo.W,geo.E,geo.S,geo.N)
	)

	contourf!(
	    ax2_1,lsd_tst.lon,lsd_tst.lat,lsd_tst.z/1000,colormap=:delta,
	    levels=range(-0.5,0.5,length=51),extendlow=:auto,extendhigh=:auto
	)
	contourf!(
	    ax2_2,lsd_tst.lon,lsd_tst.lat,lsd_tst.lsm,colormap=:delta,
	    levels=range(0,1,length=2),extendlow=:auto,extendhigh=:auto
	)
	lines!(ax2_1,clon,clat,color=:black,linewidth=0.5)
	lines!(ax2_2,clon,clat,color=:black,linewidth=0.5)
	
	resize_to_layout!(fig2)
	fig2
end
  ╠═╡ =#

# ╔═╡ 76867a59-5632-40b9-a769-1c4806b59a20
md"
### D. Exporting GeoRegions.jl LandSea Functionality

The true use of the LandSea dataset in GeoRegions.jl is not its ability to download ETOPO landsea datasets, but the fact that we can extend the `LandSea` Type to other pakcages.

Take for example NASAPrecipitation.jl
"

# ╔═╡ cce20789-82f0-4bd3-b818-9142f1400414
npd = IMERGDummy(path=datadir())

# ╔═╡ e9f23658-8a92-4730-9a39-d7223be93411
# ╠═╡ show_logs = false
lsd_npd = getLandSea(npd,geo)

# ╔═╡ 4a47478c-88dd-447a-aa4e-e4503bf5fbc9
typeof(lsd_npd)

# ╔═╡ d6fcb37a-3be1-41f5-a7de-d07e19c02c08
typeof(lsd_npd) <: GeoRegions.LandSeaFlat

# ╔═╡ Cell order:
# ╟─af53ce52-accb-11ee-2a0c-95b8bf3adea9
# ╟─dcf31c28-cbb0-4aa9-b371-72e002bfb455
# ╟─c5ce5d54-21fe-4be3-b5b4-4d68dac1a190
# ╟─b6c4ab4f-ff93-4fd4-b4cd-ede1956ed022
# ╟─d3c4f7a6-1222-4484-8fb8-745f6e05f184
# ╟─8ad55e37-3667-4ccd-b700-15174346939b
# ╟─38279b06-efd5-474d-ae16-5caa5342d190
# ╠═91980a36-ee56-42d4-a7e4-4e7af283e6b7
# ╠═58749000-f23f-4f9d-a32f-13f5abaeb908
# ╠═19583f27-b37b-473d-a5d4-c6a4d5829c2e
# ╟─b0dbdafa-74dd-4c85-8aca-989854c44704
# ╠═35d7077f-4bb4-467f-8a1b-8544a5999303
# ╠═3a975d77-3494-4d99-8472-b6914143ccca
# ╠═de4a1d2c-752e-4e36-84e6-c1e21b1acb7d
# ╟─76867a59-5632-40b9-a769-1c4806b59a20
# ╟─cce20789-82f0-4bd3-b818-9142f1400414
# ╠═e9f23658-8a92-4730-9a39-d7223be93411
# ╠═4a47478c-88dd-447a-aa4e-e4503bf5fbc9
# ╠═d6fcb37a-3be1-41f5-a7de-d07e19c02c08
