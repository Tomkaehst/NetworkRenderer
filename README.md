# Network Renderer
A processing script that renders a network and aligns them in space according to forces between nodes. The code my solution of an exercise from 'Principles of Computational Cell Biology' by Volkhard Helms (Wiley-VCH, 2008).

The aim is to render a network consisting of vertices which are connected. These networks are expressed as matrices (vertices x connection), like that:

  **X** = [[1, 1, 0],
           [1, 1, 0],
           [1, 0, 1]]
           
The example matrix **X** results in a network where only node 1 is connected to node 2 and node 3, whereas node 2 and 3 aren't connected. In processing, this is handled with two objects: *Vertex* and *Network*.
The object *Vertex*
