# Network Renderer
A processing script that renders a network and aligns them in space according to forces between nodes, i.e. a self-driven graph layout. The code my solution of an exercise from 'Principles of Computational Cell Biology' by Volkhard Helms (Wiley-VCH, 2008).

The aim is to render a network consisting of vertices which are connected. These networks are expressed as matrices (vertices x connection), like that:

  **X** = [[1, 1, 0],
           [1, 1, 0],
           [1, 0, 1]]
           
The example matrix **X** results in a network where only node 1 is connected to node 2 and node 3, whereas node 2 and 3 aren't connected. In processing, this is handled with two objects: *Vertex* and *Network*. The object *Vertex* renders a single vertex and it’s connections to other vertex objects. A whole network of vertices is initialised as a network object. 

Two kind of forces act on each vertex. First, the connections pull vertices together which is modelled as the force of a spring. The second force is repelling and states as electrostatic interaction, i.e. Columb’s law. Both forces act together on one vertex and are consequentially added. Note that these two components are initially calculated as potential energies dictating an optimal position for each vertex in space. This potential energy has to be translated into a force that is applied to the position of each vertex. 
The force is calculated as the negative, first derivative of the sum of the potential energies.

![](/img/spring_force.png)
