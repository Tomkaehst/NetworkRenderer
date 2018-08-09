class Network {

	// The array stores the vertex under consideration in each row and its connectios to other vertices in colums. The value of the connection represents their weight. 0 means no connection
	int diameter, connections, vertices;
	int[][] network;
	ArrayList<Vertex> vArray = new ArrayList<Vertex>();

	Network(int[][] net, int d) {
		network = net;
		connections = network.length;
		vertices = network[1].length;
		diameter = d;

		/* NOTE BECAUSE THIS CAUSED A LOT OF PAIN:
		The ArrayList type is not really an array rather than a list,
		so we need to treat it differently, i.e. the ArrayList has
		it's own functions, that work differently. If we want to add
		an object to position i, we need to give this index to the
		add function as the first argument!!! */
		for(int i = 0; i < vertices; i++) {
			vArray.add(i, new Vertex(diameter, network[i], i));
		}
	}

	// Loop through the Vertex ArrayList and call the Vertex-own function to display them and their connectections. The forces and the mouseDrag is also called --> only this function needs to be called in the main programm
	void renderNetwork() {
		for (Vertex v : vArray) {
			v.displayVertex();
			v.mouseDrag();
			renderConnections();
			applyForce();
		}
	}

	// Loops through the connectance array and displays one line for each connection.
	// STILL WAY TO MANY LINES! I CURRENTLY DON'T KNOW HOW TO DO THAT: WHAT WOULD BE A GOOD ALGORITHM TO DISPLAY ONLY ONE CONNECTION BETWEEN VERTICES FROM AN ADJACENCY MATRIX???
	void renderConnections() {
		for (Vertex v : vArray) {
			for(int i = 0; i < v.connectance.length; i++) {
				if(v.connectance[i] == 1) {
					PVector nextVertexPos = vArray.get(i).position;

					pushStyle();
					stroke(3);
					fill(20);
					line(v.position.x, v. position.y, nextVertexPos.x, nextVertexPos.y);
					popStyle();
				}
			}
		}
	}

	// Calculate the force between each connected vertex according to the vertex function apply force. For the formula see the README
	void applyForce() {
		for (Vertex v : vArray) {
			for(int i = 0; i < vArray.size(); i++) {
				// Get the position of the connected vertex for that we want to calculate the force
				PVector nextVertexPos = vArray.get(i).position;

				// Now if the two (the called and the one with loaded position in nextVertexPos) are connected the applyForce
				if(v.connectance[i] == 1) {
					v.applyForce(nextVertexPos, true);
				} else if(v.connectance[i] == 0) {
					v.applyForce(nextVertexPos, false);
				}
			}
		}
	}
}
