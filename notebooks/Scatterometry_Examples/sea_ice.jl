using GLMakie, GeoMakie, NCDatasets, Colors

# Data found on the google drive
ds = Dataset("S-OSI_-NOR_-MULT-GL_NH_EDGEn_-202312181200Z.nc")


lats = ds["lat"][:,:]
lons = ds["lon"][:,:]
field_raw = ds["ice_edge"][:,:,1]

field = zeros(Float32,size(field_raw))
field[.!ismissing.(field_raw)] .= Float32.(field_raw[.!ismissing.(field_raw)])

field_color = zeros(RGB,size(field_raw))
field_color[field.==0] .= colorant"grey28"
field_color[field.==1] .= colorant"royalblue1"
field_color[field.==2] .= colorant"purple1"
field_color[field.==3] .= colorant"white"


screen = let
    fig = Figure()
    ga = GeoAxis(
        fig[1, 1],
        dest="+proj=ortho +lat_0=90",
        title = "Sea ice edge 18/12 2023")
    lines!(ga, GeoMakie.coastlines())
    sp = scatter!(ga, lons[:], lats[:],color=field_color[:])
    display(GLMakie.Screen(), fig)
end

wait(screen)