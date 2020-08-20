# This code developed by Connor Schembor

module SimplePosetDrawings

using SimplePosets
using PyPlot

import PyPlot.draw
import Base.show

export generateHasse, draw, SimplePosetDrawing


const DEFAULT_MARKER_SIZE = 10
MARKER_SIZE = DEFAULT_MARKER_SIZE

"""
A `SimplePosetDrawing` is a data type representing a Hasse diagram
of a poset.
"""
struct SimplePosetDrawing
  P::SimplePoset
  directConnections::Array{}
  xy::Dict{Any,Vector{Float64}}

  function SimplePosetDrawing(PP::SimplePoset)
    hasse = generateHasse(PP)
    d = createLocations(hasse)
    connections = getDirectConnections(PP)
    new(PP,connections,d)
  end
end

"""Gets only the direct connections of the poset, and returns the direct connections as a list"""
function getDirectConnections(PP::SimplePoset)
  pairs = relations(PP)
  mins = minimals(PP)
  maxs = maximals(PP)

  relationList = []
  for pair in pairs
    tempList = []
    push!(tempList, pair[1])
    push!(tempList, pair[2])
    push!(relationList, tempList)
    for rel in relationList
      if rel[end] == tempList[1]
        #print("inserting after rel: ", rel, "\n")
        t = deepcopy(rel)
        push!(relationList, t)
        push!(relationList[end], tempList[2])
      end
      if rel[1] == tempList[end]
        #print("inserting after pair: ", rel, "\n")
        t = deepcopy(relationList[end])
        push!(relationList, t)
        push!(relationList[end], rel[end])
      end
      #print(relationList, "\n")
    end
  end

  #print("Relation List: ", relationList, "\n")
  """Remove the shorter distance, or 'unnecessary', relations from the relationList"""
  for relation in relationList
    j = length(pairs)
    i = 1
    while i <= j
      if relation[1] == pairs[i][1] && relation[end] == pairs[i][2]
        if length(relation) > length(pairs[i])
          deleteat!(pairs, i)
        end
      end
      j = length(pairs)
      i += 1
    end
  end
  #print(pairs)
  return pairs
end

"""Creates a structure to represent the Hasse diagram. This structure is a dictionary
   that maps each element to all of the elements that 'cover' it"""
function generateHasse(PP::SimplePoset)
  pairs = relations(PP)
  mins = minimals(PP)
  maxs = maximals(PP)

  """Remove reflexive relation pairs"""
  for pair in pairs
    if pair[1] == pair[2]
      filter!(p->p != pair, pairs)
    end
  end

  pairs = getDirectConnections(PP)
  """Construct data structure for the graph"""
  hasseDiagram = Dict()
  for pair in pairs
    if haskey(hasseDiagram, pair[1])
      push!(hasseDiagram[pair[1]], pair[2])
    else
      hasseDiagram[pair[1]] = [pair[2]]
    end
  end
  # print("\n", "hasse diagram: ", hasseDiagram, "\n")
  return hasseDiagram
end


"""Creates coordinate locations for each element in the poset, and returns a coordinate dictionary
   which maps each element to its proper coordinate location"""
function createLocations(hasseDiagram::Dict)
  currentXcoordinate = 0
  currentYcoordinate = 0
  coordinateDict = Dict{Any,Vector{Float64}}()
  FACTOR = 4     #Factor can be adjusted to the desired amount between nodes
  plotted = []
  """Create dictionary of coordinates for each node based on their relation to other nodes"""
  for k in sort(collect(keys(hasseDiagram)))
    #print(k, " - ", hasseDiagram[k])
    len = length(hasseDiagram[k])
    x_tracker = 0 - ((len - 1) * 2)

    if !(k in plotted) && !(hasseDiagram[k] in plotted)
      newX = currentXcoordinate + FACTOR
      positionTaken = true
      while positionTaken
        """Check to see if the position of the node has not been taken"""
        if !([newX,0] in values(coordinateDict))
          coordinateDict[k] = [newX,0]
          push!(plotted, k)
          positionTaken = false
        else
          """If there is already a node there, move the new position in the positive x-direction until
             there is an empty space for it"""
          newX = newX + FACTOR
        end
      end
    elseif !(k in plotted)
      coordinateDict[k] = [currentXcoordinate, currentYcoordinate]
      push!(plotted, k)
    end

    currentXcoordinate = coordinateDict[k][1]
    currentYcoordinate = coordinateDict[k][2]

    for next in hasseDiagram[k]
      if !(next in plotted)
        x = currentXcoordinate + x_tracker
        y = currentYcoordinate + FACTOR
        positionTaken = false
        while !positionTaken
          if ([x,y] in values(coordinateDict))
            x = x + FACTOR
          else
            coordinateDict[next] = [x,y]
            push!(plotted, next)
            positionTaken = true
          end
        end
      end
      x_tracker = x_tracker + FACTOR
    end

  end
  #print(coordinateDict)
  return coordinateDict
end


function edraw(v::Vector{Float64}, w::Vector{Float64})
    plot([v[1],w[1]], [v[2],w[2]],
         color="black", marker="o", markersize=MARKER_SIZE,
         markerfacecolor="white", label="HI", clip_on=false)
end


"""
`draw(X::SimplePosetDrawing)` draws the Hasse diagram of the poset.
"""
function draw(X::SimplePosetDrawing)
  # code (with calls to PyPlot commands) to draw this poset drawing
  conns = X.directConnections
  #print("Direct Conns: ", conns)
  coords = X.xy
  for e in conns
    if length(e) == 2
      edraw(coords[e[1]], coords[e[2]])
    end
  end
  axis("off")
  axis("equal")
  nothing
end



function show(io::IO, X::SimplePosetDrawing)
    print(io,"Drawing of $(X.P)")
end


end # end of module
