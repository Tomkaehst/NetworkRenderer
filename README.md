# Network Renderer
A processing script that renders a network and aligns them in space according to forces between nodes, i.e. a self-driven graph layout. The code my solution of an exercise from 'Principles of Computational Cell Biology' by Volkhard Helms (Wiley-VCH, 2008).

The aim is to render a network consisting of vertices which are connected. These networks are expressed as matrices (vertices x connection), like that:

![](/img/sample_matrix.png)
           
The example matrix **X** results in a network where only node 1 is connected to node 2 and node 3, whereas node 2 and 3 aren't connected. In processing, this is handled with two objects: *Vertex* and *Network*. The object *Vertex* renders a single vertex and it’s connections to other vertex objects. A whole network of vertices is initialised as a network object. 

Two kind of forces act on each vertex. First, the connections pull vertices together which is modelled as the force of a spring. The second force is repelling and states as electrostatic interaction, i.e. Columb’s law. Both forces act together on one vertex and are consequentially added. Note that these two components are initially calculated as potential energies dictating an optimal position for each vertex in space. This potential energy has to be translated into a force that is applied to the position of each vertex. 
The force is calculated as the negative, first derivative of the sum of the potential energies.

The pulling force between the vertices is formulated according to this equation, which is the classical spring equation with *k* as the spring constant.
![](/img/spring_force.png)

The repulsion is expressed with the following equation; essentially Coloumb’s law.

![](/img/columb_force.png)

The force is calculated as follows

![](/img/force_field.png) with ![](/img/nabla.png).

Therefore, the ‘goal’ of the algorithm is to find a configuration of the vertices, in which no net force is acting on them, i.e. the state of minimal energy of the system. 


*What has to be done*
* Adding an algorithm for the force calculation
* Find a good way to visualise the state of the system (map the change of potential energy to the vertices colour values?)
* Add function to add vertices and connections by clicking

