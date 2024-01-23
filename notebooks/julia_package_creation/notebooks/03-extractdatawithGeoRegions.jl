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
	using NCDatasets
	using PlutoUI
	
	using CairoMakie
	md"Activating JuliaEO Project for work do be done on notebook ..."
end

# ╔═╡ af53ce52-accb-11ee-2a0c-95b8bf3adea9
md"
# 03. Extract Data using GeoRegions.jl
"

# ╔═╡ b6c4ab4f-ff93-4fd4-b4cd-ede1956ed022
TableOfContents()

# ╔═╡ f07f1d25-80f9-4017-a4ab-09b1a52db3ee
begin
	if !isfile(datadir("coast.cst"))
		download(
			"https://raw.githubusercontent.com/natgeo-wong/GeoPlottingData/main/coastline_resl.txt",
			datadir("coast.cst")
		)
	end
	coast = readdlm(datadir("coast.cst"),comments=true)
	clon  = coast[:,1]
	clat  = coast[:,2]
	md"Preloading coastline data"
end

# ╔═╡ 047ef605-7572-4a36-95c7-4861a06946ad
begin
	fig = Figure()
	
	ax1 = Axis(
	    fig[1,1],width=700,height=700/3,
	    title="Plotting Coastlines and GeoRegions",
		xlabel="Longitude / º",ylabel="Latitude / º",
	    limits=(-180,360,-90,90)
	)

	ax2 = Axis(
	    fig[2,1],width=700,height=700/3,
	    title="Plotting Coastlines and GeoRegions for Test GeoRegion 1",
		xlabel="Longitude / º",ylabel="Latitude / º",
	    limits=(-180,360,-90,90)
	)

	ax3 = Axis(
	    fig[3,1],width=700,height=700/3,
	    title="Plotting Coastlines and GeoRegions for Test GeoRegion 2",
		xlabel="Longitude / º",ylabel="Latitude / º",
	    limits=(-180,360,-90,90)
	)

	ax4 = Axis(
	    fig[4,1],width=700,height=700/3,
	    title="Plotting Coastlines and GeoRegions for Test GeoRegion 2",
		xlabel="Longitude / º",ylabel="Latitude / º",
	    limits=(-180,360,-90,90)
	)
	
	lines!(ax1,clon,clat,color=:black,linewidth=0.5)
	lines!(ax2,clon,clat,color=:black,linewidth=0.5)
	lines!(ax3,clon,clat,color=:black,linewidth=0.5)
	lines!(ax4,clon,clat,color=:black,linewidth=0.5)
	
	resize_to_layout!(fig)
	fig
end

# ╔═╡ ec4ae8bf-cfbd-430f-8242-6d129bd963db
md"
### A. Loading Datasets and Predefining GeoRegions
"

# ╔═╡ 2215440a-5cf1-47b9-aa4b-775f10b7c6cc
begin
	ds  = NCDataset(datadir("emask.nc"))
	lon = ds["longitude"][:]
	lat = ds["latitude"][:]
	z   = ds["z"][:,:] / 9.81; z[z.<10] .= -1
	close(ds)
	md"Loading ERA5 topographical data ..."
end

# ╔═╡ b47c46f7-5dfd-4fea-b47d-a51a3f990ca0
begin
	contourf!(
	    ax1,lon,lat,z/1000,colormap=:delta,
	    levels=range(-5,5,length=11),extendlow=:auto,extendhigh=:auto
	)
	lines!(ax1,clon,clat,color=:black,linewidth=0.5)
	fig
end

# ╔═╡ 84dd9d36-e84e-477a-87cf-c1d37aac2a92
geo1 = RectRegion(
	"", "GLB", "",
	[45,-45,330,240], savegeo = false
)

# ╔═╡ e7dd7079-8a5e-47bd-81b5-1a714b668560
geo2 = RectRegion(
	"", "GLB", "",
	[45,-45,geo1.E-360,geo1.W-360], savegeo = false
)

# ╔═╡ aab05668-34d1-4a5d-8040-c2eefb325231
md"
### B. Extracting Data using RegionGrids

Using a GeoRegion, and a pair of longitude/latitude vectors, we can define a RegionGrid, which maps gridded lon-lat data to the given GeoRegion.
"

# ╔═╡ e747dc18-c244-4fe5-a031-01329d70cd5d
grd1 = RegionGrid(geo1,lon,lat)

# ╔═╡ 6d1084e0-fc02-4ebf-9ecc-8dc1819edf3e
begin
	ndata1 = extractGrid(z,grd1)
	md"Extracting data for Test GeoRegion 1 ..."
end

# ╔═╡ 6c734d5f-7a92-4740-b3fe-6ac419f8a537
begin
	contourf!(
	    ax2,grd1.lon,grd1.lat,ndata1/1000,colormap=:delta,
	    levels=range(-5,5,length=11),extendlow=:auto,extendhigh=:auto
	)
	lines!(ax2,clon,clat,color=:black,linewidth=0.5)
	fig
end

# ╔═╡ 8e80873e-e7d5-4ed8-9d45-da3f681513f5
md"
### C. $\pm$180 or 0-360? Does it Matter?

When dealing with global gridded data, the longitude vector can be either of:
* -180 to 180
* 0 to 360

With GeoRegions.jl, it doesn't matter what the initial data's longitude grid is. What matters is what the bounds of the given GeoRegion are.

Above, we defined `geo2` in such a manner that it is exactly the same as the `geo1` GeoRegion, except that the longitude coordinates are shifted by 360º. We see that the data is extracted exactly the same. But the RegionGrid longitude vector follows the 180-grid.
"

# ╔═╡ 988d4c59-de0b-4202-b0cc-d71ed480fcfe
grd2 = RegionGrid(geo2,lon,lat)

# ╔═╡ 2937444f-79cc-4dcb-8301-0af7f1d50290
begin
	ndata2 = extractGrid(z,grd2)
	md"Extracting data for Test GeoRegion 2 ..."
end

# ╔═╡ 2a8dc43b-003d-4ec1-9830-b383b4b89563
begin
	contourf!(
	    ax3,grd2.lon,grd2.lat,ndata2/1000,colormap=:delta,
	    levels=range(-5,5,length=11),extendlow=:auto,extendhigh=:auto
	)
	lines!(ax3,clon,clat,color=:black,linewidth=0.5)
	fig
end

# ╔═╡ d650f234-992f-4581-8195-89e39a54fc03
md"
### D. Or we could combine both

RegionGrids can also handle scenarios where you are required to stitch data together from both ends of the longitude vector. See below for an example
"

# ╔═╡ 72b1dce2-b7ab-4178-aaf0-68a4f316347a
geo3 = RectRegion(
	"","GLB","",
	[45,-45,45,-45],savegeo=false
)

# ╔═╡ 02570cdd-c948-4dc8-8531-3ccd68259bbb
begin
	grd3 = RegionGrid(geo3,lon,lat)
	ndata3 = extractGrid(z,grd3)
	contourf!(
	    ax4,grd3.lon,grd3.lat,ndata3/1000,colormap=:delta,
	    levels=range(-5,5,length=11),extendlow=:auto,extendhigh=:auto
	)
	lines!(ax4,clon,clat,color=:black,linewidth=0.5)
	fig
end

# ╔═╡ Cell order:
# ╟─af53ce52-accb-11ee-2a0c-95b8bf3adea9
# ╟─dcf31c28-cbb0-4aa9-b371-72e002bfb455
# ╟─c5ce5d54-21fe-4be3-b5b4-4d68dac1a190
# ╟─b6c4ab4f-ff93-4fd4-b4cd-ede1956ed022
# ╟─f07f1d25-80f9-4017-a4ab-09b1a52db3ee
# ╟─047ef605-7572-4a36-95c7-4861a06946ad
# ╟─ec4ae8bf-cfbd-430f-8242-6d129bd963db
# ╠═2215440a-5cf1-47b9-aa4b-775f10b7c6cc
# ╠═b47c46f7-5dfd-4fea-b47d-a51a3f990ca0
# ╠═84dd9d36-e84e-477a-87cf-c1d37aac2a92
# ╠═e7dd7079-8a5e-47bd-81b5-1a714b668560
# ╟─aab05668-34d1-4a5d-8040-c2eefb325231
# ╠═e747dc18-c244-4fe5-a031-01329d70cd5d
# ╠═6d1084e0-fc02-4ebf-9ecc-8dc1819edf3e
# ╟─6c734d5f-7a92-4740-b3fe-6ac419f8a537
# ╟─8e80873e-e7d5-4ed8-9d45-da3f681513f5
# ╠═988d4c59-de0b-4202-b0cc-d71ed480fcfe
# ╠═2937444f-79cc-4dcb-8301-0af7f1d50290
# ╟─2a8dc43b-003d-4ec1-9830-b383b4b89563
# ╟─d650f234-992f-4581-8195-89e39a54fc03
# ╟─72b1dce2-b7ab-4178-aaf0-68a4f316347a
# ╟─02570cdd-c948-4dc8-8531-3ccd68259bbb
