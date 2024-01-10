using Meshes
using GeoTables
using GeoIO

import GLMakie as Mke

## GeometrySet

p = Point(1, 2)
s = Segment((0, 2), (1, 3))
t = Triangle((0, 0), (1, 0), (1, 1))
b = Ball((2, 2), 1)

geoms = [p, s, t, b]

gset = GeometrySet(geoms)

##

viz(gset)

##

viz(gset, color = 1:4)

##

fig, ax = viz(gset, color = 1:4)

ax.aspect = Mke.DataAspect()

viz!(boundary(b), color = "red")
viz!(boundary(t), color = "black")

## GeoTable

geotable = georef(nothing, gset)

##

geotable = georef((a=1:4, b=rand(4)), gset)

##

geotable[1:2, :]

##

geotable.a

##

geotable |> viewer

## Grid

grid = CartesianGrid(5, 5)

##

fig, ax = viz(grid, color = 1:25)
ax.aspect = Mke.DataAspect()

##

fig, ax = viz(grid, color = 1:25, showfacets = true)
ax.aspect = Mke.DataAspect()

##

fig, ax = viz(grid, color = 1:25, showfacets = true, facetcolor = "red")
ax.aspect = Mke.DataAspect()

##

fig, ax = viz(grid, color = 1:36)
ax.aspect = Mke.DataAspect()

##

table = (; centroid = centroid.(grid))

geotable = georef(table, grid)

## Mesh

sphere = Sphere((0, 0, 0), 1)

mesh = discretize(sphere, RegularDiscretization(30, 50))

##

viz(mesh, showfacets = true)

##

geotable = georef((; area = area.(mesh)), mesh)

##

geotable |> viewer

## GeoIO.load

geotable = GeoIO.load("data/airplane.stl")

##

viz(geotable.geometry)

##  GeoIO.save

GeoIO.save("data/airplane.obj", geotable)
GeoIO.save("data/airplane.off", geotable)
GeoIO.save("data/airplane.msh", geotable)

## Other example

geotable = GeoIO.load("data/world.tif")

##

viz(geotable.geometry, color = geotable.BAND1)