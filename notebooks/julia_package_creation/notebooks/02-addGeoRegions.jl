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
	using GeoRegions
	using NCDatasets
	using PlutoUI
	md"Activating JuliaEO Project for work do be done on notebook ..."
end

# ╔═╡ af53ce52-accb-11ee-2a0c-95b8bf3adea9
md"
# 02. Adding Custom GeoRegions
"

# ╔═╡ b6c4ab4f-ff93-4fd4-b4cd-ede1956ed022
TableOfContents()

# ╔═╡ 8ad55e37-3667-4ccd-b700-15174346939b
md"
### A. Adding GeoRegions from a template file

You can add GeoRegions directly from files without having to specify them explicity in the code.

If you go to `src`, you will see the following files
* RectRegions.txt
* PolyRegions.txt
* example_RectRegions.txt
* example_PolyRegions.txt

example\_RectRegions.txt and example\_PolyRegions.txt are example files. You will attempt to modify RectRegions.txt and PolyRegions.txt later.
"

# ╔═╡ b47c46f7-5dfd-4fea-b47d-a51a3f990ca0
begin
	a = zeros(1)
	resetGeoRegions()
	md"Reset the list of GeoRegions"
end

# ╔═╡ 22ea1049-31b9-4627-8f91-d68d2714fe74
begin
	a[1] += 1
	b     = zeros(1)
	tableGeoRegions(onlycustom=true)
end

# ╔═╡ 114f759b-1164-4577-b0a8-af9ad541e8c1
md"We then proceed to add the GeoRegions in `example_RectRegion.txt` and `example_PolyRegion.txt` using the function `addGeoRegions()`"

# ╔═╡ ef7245e2-3d0a-4c60-ae7d-c92565ee5e2c
begin
	b[1] += 1
	c     = zeros(1)
	addGeoRegions(srcdir("example_RectRegion.txt"))
	addGeoRegions(srcdir("example_PolyRegion.txt"))
end

# ╔═╡ 752b09e6-d766-4927-8c93-e5524306618d
begin
	c[1] += 1
	d     = zeros(1)
	tableGeoRegions(onlycustom=true)
end

# ╔═╡ b30cfa6e-d81f-4dbd-8a28-154528b111a9
md"
### B. Modifying your Custom Files

Now, you try modifying the custom files `RectRegions.txt` and `PolyRegions.txt`
"

# ╔═╡ 158b0d84-05d5-4500-98fa-e3b2e000ccd3
begin
	d[1] += 1
	e  	  = zeros(1)
	resetGeoRegions()
	md"Reset the list of GeoRegions"
end

# ╔═╡ df45a247-8bd0-4728-9133-0a3690201fcb
begin
	e[1] += 1
	f  	  = zeros(1)
	tableGeoRegions(onlycustom=true)
end

# ╔═╡ 9eee56b4-1e3c-427c-aa0c-9e729e709b81
begin
	f[1] += 1
	g  	  = zeros(1)
	# addGeoRegions()
	# addGeoRegions()
	md"Adding your custom GeoRegions for a custom file"
end

# ╔═╡ 302126f3-6bb4-4bb9-9036-75e830970799
begin
	g[1] += 1
	h  	  = zeros(1)
	tableGeoRegions(onlycustom=true)
end

# ╔═╡ Cell order:
# ╟─af53ce52-accb-11ee-2a0c-95b8bf3adea9
# ╟─dcf31c28-cbb0-4aa9-b371-72e002bfb455
# ╟─c5ce5d54-21fe-4be3-b5b4-4d68dac1a190
# ╟─b6c4ab4f-ff93-4fd4-b4cd-ede1956ed022
# ╟─8ad55e37-3667-4ccd-b700-15174346939b
# ╟─b47c46f7-5dfd-4fea-b47d-a51a3f990ca0
# ╟─22ea1049-31b9-4627-8f91-d68d2714fe74
# ╟─114f759b-1164-4577-b0a8-af9ad541e8c1
# ╠═ef7245e2-3d0a-4c60-ae7d-c92565ee5e2c
# ╟─752b09e6-d766-4927-8c93-e5524306618d
# ╟─b30cfa6e-d81f-4dbd-8a28-154528b111a9
# ╠═158b0d84-05d5-4500-98fa-e3b2e000ccd3
# ╠═df45a247-8bd0-4728-9133-0a3690201fcb
# ╠═9eee56b4-1e3c-427c-aa0c-9e729e709b81
# ╠═302126f3-6bb4-4bb9-9036-75e830970799
