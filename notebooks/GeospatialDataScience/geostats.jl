using GeoStats

import GLMakie as Mke

## Example of GeoTable

N = 10000
a = [2randn(N÷2) .+ 6; randn(N÷2)]
b = [3randn(N÷2); 2randn(N÷2)]
c = randn(N)
d = c .+ 0.6randn(N)

table = (; a, b, c, d)

gt = georef(table, CartesianGrid(100, 100))

## Multivariate analysis

using PairPlots

pairplot(values(gt))

## Alternative syntax with Julia's pipe operator

gt |> values |> pairplot

# ------
# BASIC
# ------

## Select/Reject

gt |> Select("a", "b") # select columns "a" and "b"

gt |> Select(1:3) # select columns 1 to 3

gt |> Select(r"[bcd]") # columns matching regular expression

gt |> Select("a" => "A", "b" => "B") # select and rename

gt |> Reject("b") # reject column "b"

gt |> Select("a") |> viewer

## Rename

gt |> Rename("a" => "A", "b" => "B")

## Functional

gt |> Functional(cos) |> values |> pairplot

## Map

gt |> Map("a" => sin, "b" => cos => "cos(b)")

gt |> Map([2, 3] => ((b, c) -> 2b + c) => "f(b, c)")

## Filter

gt |> Filter(row -> row.a < 0 && row.b > 0)

## Sort

gt |> Sort("a", "b")

# ---------
# CLEANING
# ---------

ut = gt |> Select("a" => "aBc De-F", "b" => "b_2 (1)")

## StdNames

ut |> StdNames()

ut |> StdNames(:uppercamel)

ut |> StdNames(:upperflat)

## Replace

rt = georef((a=[1,-999,3], b=[NaN,5,6]))

rt |> Replace(-999 => missing, NaN => missing)

rt |> Replace(<(0) => missing)

## Coalesce

ct = georef((a=[1,missing,3], b=[4,5,6])) |> Coalesce(value=2)

typeof(ct.a)

## DropMissing

georef((a=[1,missing,3], b=[4,5,6])) |> DropMissing()

# ------------
# STATISTICAL
# ------------

## Sample

gt |> Sample(1000, replace=false) |> viewer

## Center

gt |> describe

gt |> Center("a") |> describe

## MinMax

gt |> MinMax() |> describe

## ZScore

gt |> ZScore() |> describe

## StdFeats

gt |> StdFeats() |> describe

## Quantile

gt |> Quantile() |> values |> pairplot

## Coerce

using GeoStats.DataScienceTraits: Continuous

st = georef((a=[1,2,2,2,3,3], b=[1,2,3,4,5,6])) |> Coerce("b" => Continuous)

eltype(st.b)

## Levels

st = st |> Levels("a" => [1,2,3,4])

## OneHot

st |> OneHot("a")

## Indicator

st |> Indicator("b", k=3, scale=:quantile)

# -----------
# COORDINATE
# -----------

using GeoIO

bt = GeoIO.load("data/beethoven.ply")

viz(bt.geometry)

## Rotate

rt = bt |> Rotate((0, 1, 0), (0, 0, 1))

viz(rt.geometry)

rt = rt |> Rotate((1, 0, 0), (-1, 1, 0))

viz(rt.geometry)

gt |> Rotate(Angle2d(π/4)) |> viewer

## Translate

gt |> Translate(-50, -50) |> viewer

## Stretch

gt |> Stretch(0.1, 0.2) |> viewer

## StdCoords

gt |> StdCoords() |> viewer

# ---------
# ADVANCED
# ---------

outer = [(0.0, 0.0), (1.0, 0.0), (1.0, 1.0), (0.0, 1.0)]
hole1 = [(0.2, 0.2), (0.4, 0.2), (0.4, 0.4), (0.2, 0.4)]
hole2 = [(0.6, 0.2), (0.8, 0.2), (0.8, 0.4), (0.6, 0.4)]
poly  = PolyArea([outer, hole1, hole2])

viz(poly)

## Bridge

poly |> Bridge(0.01) |> viz

## TaubinSmoothing

st = bt |> TaubinSmoothing(30)

fig = Mke.Figure()
viz(fig[1,1], bt.geometry)
viz(fig[1,2], st.geometry)
fig

# -----------
# GEOSPATIAL
# -----------

## Quadratic + Noise

r = range(-1, stop=1, length=100)
μ = [x^2 + y^2 for x in r, y in r]
ϵ = 0.1rand(100, 100)
t = georef((z=μ+ϵ,))

t |> viewer

## Detrend

t |> Detrend(degree=2) |> viewer

# Letters A and b

letters = GeoIO.load("data/letters.png")

## Potrace

Ab = letters |> Potrace("color", ϵ=0.8)

viz(Ab.geometry[2], color = "black")

## Examples of polygons

A = [1, 2, 3, 4, 5]
B = [1.1, 2.2, 3.3, 4.4, 5.5]
p1 = PolyArea((2, 0), (6, 2), (2, 2))
p2 = PolyArea((0, 6), (3, 8), (0, 10))
p3 = PolyArea((3, 6), (9, 6), (9, 9), (6, 9))
p4 = PolyArea((7, 0), (10, 0), (10, 4), (7, 4))
p5 = PolyArea((1, 3), (5, 3), (6, 6), (3, 8), (0, 6))
pt = georef((; A, B), [p1, p2, p3, p4, p5])

pt |> viewer

## Rasterize

nt = pt |> Rasterize(20, 20)

nt |> viewer

# -----------
# SEQUENTIAL
# -----------

## Quantile of columns "a", "b" and "c" of any GeoTable

pipeline = Select("a", "b", "c") → Quantile()

## Apply pipeline after it is constructed

gt |> pipeline

## Optimizations are performed whenever possible

pipeline → Identity()

# ---------
# PARALLEL
# ---------

## Indicator of column "a" of any GeoTable

pipeline1 = Select("a") → Indicator("a", k=3)

gt |> pipeline1

## PCA of columns "b", "c" and "d" of any GeoTable

pipeline2 = Select("b", "c", "d") → PCA(maxdim=2)

gt |> pipeline2

## Combine pipelines into parallel pipeline

pipeline = pipeline1 ⊔ pipeline2

## Resulting columns are concatenated

gt |> pipeline