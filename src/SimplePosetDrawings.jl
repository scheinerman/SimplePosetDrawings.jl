using SimplePosets
using PyPlot

module SimplePosetDrawings

"""
A `SimplePosetDrawing` is a data type representing a Hasse diagram
of a poset.
"""
type SimplePosetDrawing
  P::SimplePoset
  xy:Dict{Any,Vector{Float64}}

  function SimplePosetDrawing(PP::SimplePoset)
    d = MethodForMakingHasseDiagram(P)   # don't use this name :-)
    new(PP,d)
  end
end

"""
`draw(X::SimplePosetDrawing)` draws this Hasse diagram in a window.
"""
function draw(X::SimplePosetDrawing)
  # code (with calls to PyPlot commands) to draw this poset drawing
end

end # end of module
