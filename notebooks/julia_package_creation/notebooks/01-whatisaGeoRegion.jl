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
# 01. Introducing GeoRegions.jl
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
	aspect = 2
	
	ax1 = Axis(
	    fig[1,1],width=700,height=700/aspect,
	    title="Plotting Coastlines and GeoRegions",
		xlabel="Longitude / º",ylabel="Latitude / º",
	    limits=(0,360,-90,90)
	)
	lines!(ax1,clon,clat,color=:black,linewidth=0.5)
	
	resize_to_layout!(fig)
	fig
end

# ╔═╡ 8ad55e37-3667-4ccd-b700-15174346939b
md"
### A. What is a GeoRegion?

* Short for **_Geo_**graphical **_Region_**.
* Defined either by [N,S,E,W] coordinates (RectRegion), or by a lon/lat polygon (PolyRegion)

Let's load a predefined GeoRegion \"AR6_SEA\" (comes with GeoRegions.jl)
"

# ╔═╡ b47c46f7-5dfd-4fea-b47d-a51a3f990ca0
begin
	geo_AR6 = GeoRegion("AR6_SEA")
	md"Loading the GeoRegion \"AR6_SEA\""
end

# ╔═╡ 22ea1049-31b9-4627-8f91-d68d2714fe74
typeof(geo_AR6)

# ╔═╡ ef7245e2-3d0a-4c60-ae7d-c92565ee5e2c
geo_AR6

# ╔═╡ 752b09e6-d766-4927-8c93-e5524306618d
begin
	blon_AR6,bplat_AR6,slon_AR6,slat_AR6 = coordGeoRegion(geo_AR6)
	md"Finding the coordinates of the PolyRegion boundaries"
end

# ╔═╡ 5d41ced0-94dd-4de4-acf9-1a9202eba1e5
begin
	lines!(ax1,slon_AR6,slat_AR6,color=:blue,linewidth=2)
	fig
end

# ╔═╡ e5a51b51-84cc-44e7-9350-a9b19ac65bec
md"You can load a list of all the predefined GeoRegions using `tableGeoRegions()`"

# ╔═╡ 213fea1b-8923-4007-ab96-c5e978bff666
tableGeoRegions()

# ╔═╡ b30cfa6e-d81f-4dbd-8a28-154528b111a9
md"
### B. Defining your Custom RectRegion

In this very basic example, let us define a Rectangular GeoRegion.  An example is given below.

Once you have defined this `GeoRegion`, let us then plot the bounds using Makie
"

# ╔═╡ 158b0d84-05d5-4500-98fa-e3b2e000ccd3
rgeo1 = RectRegion(
	"", "GLB", "Test GeoRegion",
	[30,20,50,10], savegeo = false
)

# ╔═╡ 9eee56b4-1e3c-427c-aa0c-9e729e709b81
md"Note: `savegeo = false` because we don't want to save this GeoRegion as a custom GeoRegion"

# ╔═╡ 11061da0-c784-40b4-b3b2-de0e217273d5
# Add your custom RectRegion here!
# rgeo2 = RectRegion(

# )

# ╔═╡ 302126f3-6bb4-4bb9-9036-75e830970799
begin
	rblon1,rblat1 = coordGeoRegion(rgeo1)
	# rblon2,rblat2 = coordGeoRegion(rgeo2)
	md"Finding the coordinates of the RectRegion boundaries"
end

# ╔═╡ 395d8f1a-94c6-4397-b7b4-2fc37cf9ff0f
begin
	lines!(ax1,rblon1,rblat1,color=:red,linewidth=2)
	# lines!(ax1,rblon2,rblat2,color=:green,linewidth=2)
	fig
end

# ╔═╡ 922919b3-4873-4539-a973-5dee4de1441b
md"
### C. Defining your Custom PolyRegion

In geographical analysis, many of the regions we would like to analyze are not rectilinear in longitude-latitude.  However, GeoRegions.jl allows for the definition of _**simple**_ (i.e. non self-intersecting) polygon regions
"

# ╔═╡ bf71173d-4d7f-47c4-9a3b-ffe05bc897eb
pgeo1 = PolyRegion(
	"", "GLB", "Test PolyRegion",
	[60.0, 60.0, 75.0, 88.0, 100.0, 100.0, 95.0, 87.0, 79.0, 76.0, 70.0, 66.5, 60.0],
	[23.5, 30.0, 30.0, 26.0, 30.0, 19.5, 19.5, 19.5, 7.0, 7.0, 19.5, 23.5, 23.5],
	savegeo = false
)

# ╔═╡ bf751101-5910-4283-adf4-0fef3a83af0c
# Add your custom PolyRegion here!
# pgeo2 = PolyRegion(
#
# 	savegeo = false
# )

# ╔═╡ 341ecc4b-57f4-4e4c-b02c-e4acd9c8e6d9
begin
	pblon1,pblat1,pslon1,pslat1 = coordGeoRegion(pgeo1)
	# pblon2,pblat2,pslon2,pslat2 = coordGeoRegion(pgeo2)
	md"Finding the coordinates of the PolyRegion boundaries"
end

# ╔═╡ 0b14a9cd-6731-4fa6-8920-a8c72936a224
begin
	lines!(ax1,pslon1,pslat1,color=:red,linewidth=2)
	lines!(ax1,pblon1,pblat1,color=:red,linewidth=2,linestyle=:dash)
	# lines!(ax1,pslon2,pslat2,color=:green,linewidth=2)
	# lines!(ax1,pblonb,pblat2,color=:green,linewidth=2,linestyle=:dash)
	fig
end

# ╔═╡ 8e7c0ae7-6ecf-49df-bb82-0c15d8db6561
md"
### D. Adding a Custom GeoRegion
"

# ╔═╡ aec1003e-967a-45f1-8745-372f4c8adb2c
begin
	a = zeros(1)
	RectRegion(
		"TST", "GLB", "Test GeoRegion",
		[30,20,50,10]
	)
end

# ╔═╡ 47c46fcb-8b7b-4423-912c-a133dabc7b96
begin
	a[1] += 1
	b     = zeros(1)
	tableGeoRegions(onlycustom=true)
end

# ╔═╡ b97da28e-7ba2-467c-bd97-fcc06bc783fa
begin
	b[1] += 1
	c     = zeros(1)
	GeoRegion("TST")
end

# ╔═╡ 0e738869-8cdd-4fc1-ab5c-96f08f50cc8a
begin
	c[1] += 1
	removeGeoRegion("TST")
	tableGeoRegions(onlycustom=true)
end

# ╔═╡ Cell order:
# ╟─af53ce52-accb-11ee-2a0c-95b8bf3adea9
# ╟─dcf31c28-cbb0-4aa9-b371-72e002bfb455
# ╟─c5ce5d54-21fe-4be3-b5b4-4d68dac1a190
# ╟─b6c4ab4f-ff93-4fd4-b4cd-ede1956ed022
# ╟─f07f1d25-80f9-4017-a4ab-09b1a52db3ee
# ╟─047ef605-7572-4a36-95c7-4861a06946ad
# ╟─8ad55e37-3667-4ccd-b700-15174346939b
# ╠═b47c46f7-5dfd-4fea-b47d-a51a3f990ca0
# ╠═22ea1049-31b9-4627-8f91-d68d2714fe74
# ╠═ef7245e2-3d0a-4c60-ae7d-c92565ee5e2c
# ╠═752b09e6-d766-4927-8c93-e5524306618d
# ╟─5d41ced0-94dd-4de4-acf9-1a9202eba1e5
# ╟─e5a51b51-84cc-44e7-9350-a9b19ac65bec
# ╠═213fea1b-8923-4007-ab96-c5e978bff666
# ╟─b30cfa6e-d81f-4dbd-8a28-154528b111a9
# ╠═158b0d84-05d5-4500-98fa-e3b2e000ccd3
# ╟─9eee56b4-1e3c-427c-aa0c-9e729e709b81
# ╠═11061da0-c784-40b4-b3b2-de0e217273d5
# ╠═302126f3-6bb4-4bb9-9036-75e830970799
# ╟─395d8f1a-94c6-4397-b7b4-2fc37cf9ff0f
# ╟─922919b3-4873-4539-a973-5dee4de1441b
# ╠═bf71173d-4d7f-47c4-9a3b-ffe05bc897eb
# ╠═bf751101-5910-4283-adf4-0fef3a83af0c
# ╠═341ecc4b-57f4-4e4c-b02c-e4acd9c8e6d9
# ╟─0b14a9cd-6731-4fa6-8920-a8c72936a224
# ╟─8e7c0ae7-6ecf-49df-bb82-0c15d8db6561
# ╠═aec1003e-967a-45f1-8745-372f4c8adb2c
# ╠═47c46fcb-8b7b-4423-912c-a133dabc7b96
# ╠═b97da28e-7ba2-467c-bd97-fcc06bc783fa
# ╠═0e738869-8cdd-4fc1-ab5c-96f08f50cc8a
