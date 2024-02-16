# Simple Poset Drawings

> This is ancient code that I plan to replace. 

Julia module for drawing Hasse diagrams of partially ordered sets.

See also `SimpleGraphDrawings` which provides similar functionality
for simple graphs.

**Note**: This is an early version of this code. Caveat emptor.

## How to use

The `SimplePosetDrawings` module is used to draw pictures of
partially ordered sets. It relies on several packages from
my `SimpleWorld` collection. Here's the gist:

```
julia> using SimplePosets, SimplePosetDrawings, PyPlot

julia> P = Boolean(3)
SimplePoset{ASCIIString} (8 elements)

julia> X = SimplePosetDrawing(P)
Drawing of SimplePoset{ASCIIString} (8 elements)

julia> draw(X)
```
produces this:
![Hasse diagram of Boolean(3)](./bool3-hasse.png)

## Acknowledgement

The code in this module was created by Connor Schembor.
