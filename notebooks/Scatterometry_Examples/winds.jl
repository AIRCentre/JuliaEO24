using NCDatasets, GLMakie, Tyler, TileProviders, MapTiles, Extents,Dates

# Data found on the google drive
nc = Dataset("ascat_20231218_093600_metopc_26530_eps_o_coa_3301_ovw.l2.nc")


start_index = findfirst(nc["time"][1,:] .> DateTime("2023-12-18T10:12:00.005"))
end_index = findlast(nc["time"][1,:] .< DateTime("2023-12-18T10:14:59.984"))

replace_missing(A) = Float64.(replace(x -> ismissing(x) ? NaN : x,  A))

latitude = replace_missing(nc["lat"][:,start_index:end_index])
longitude = replace_missing(nc["lon"][:,start_index:end_index])
longitude[longitude.>180] .-= 360


wind_speed = replace_missing(nc["wind_speed"][:,start_index:end_index])
wind_direction = replace_missing(nc["wind_dir"][:,start_index:end_index])
wind_flags = Int.(nc["wvc_quality_flag"][:,start_index:end_index])

rotation =2*pi .-  wind_direction[:] .* (pi/180) 
#maker_size =  5 .* Vec2f.(6, wind_speed[:])
maker_size =  5 .*  wind_speed[:]
flagged = wind_flags[:] .!= 0
unique(wind_flags)
valid = .!isnan.(rotation) .&  .!isnan.(maker_size) 

pts = [Point2f(MapTiles.project((longitude[i],latitude[i]), MapTiles.wgs84, MapTiles.web_mercator)) for i in eachindex(longitude)]

screen = let
    provider = TileProviders.Esri(:NatGeoWorldMap)
    lat_lisabon = 38.76
    lon_lisabon = -9.13
    delta = 5;
    extent = Extent(X = (lon_lisabon - delta/2, lon_lisabon + delta/2), Y = (lat_lisabon-delta/2, lat_lisabon+delta/2));

    m = Tyler.Map(extent; provider, figure=Figure(resolution=(1000, 600)))
    # wait for tiles to fully load
    wait(m)

    scatter!(m.axis, pts[valid .& .!flagged],  rotations = rotation[valid.& .!flagged], markersize = maker_size[valid.& .!flagged], marker = '↑', color="black")
    scatter!(m.axis, pts[valid .& flagged],  rotations = rotation[valid.& flagged], markersize = maker_size[valid.& flagged], marker = '↑', color="darkred")
    display(GLMakie.Screen(), m.figure)
end
wait(screen)