class Network {

	// The array stores the vertex under consideration in each row and its connectios to other vertices in colums. The value of the connection represents their weight. 0 means no connection
	int diameter;
	int[][] network;
	ArrayList<Vertex> vArray = new ArrayList<Vertex>();

	Network(int[][] net, int d) {
		network = net;
		int connections = network.length;
		int vertices = network[1].length;
		diameter = d;

		/* NOTE BECAUSE THIS MADE A LOT OF PAIN:
		The ArrayList type is not really an array rather than a list,
		so we need to treat it differently, i.e. the ArrayList has
		it's own functions, that work differently. If we want to add
		an object to position i, we need to give this index to the
		add function as the first argument!!! */

		for(int i = 0; i < vertices; i++) {
			vArray.add(i, new Vertex(diameter, network[i]));
		}
	}

	// Loop through the Vertex ArrayList and call the Vertex-own function to display them.
	void renderNetwork() {
		for(Vertex v : vArray) {
			int[] connectionLines = v.isConnected();

			if(v.isClicked() == true) {
				v.mouseDrag();
			}

			// I need to rethink this, because it could lead to some vertices not being displayed, if they're note connected!
			for(int i = 0; i < connectionLines.length; i++){
				if(connectionLines[i] != 0){
					v.displayVertex(vArray.get(connectionLines[i]));
				}
			}
		}

		// Let each vertex "feel" each other vertex by calling one vertex and calculating it's force to every other vertex
		for(int i = 0; i < vArray.size(); i++) {
			Vertex v = vArray.get(i);

			for(int j = 0; j < vArray.size(); j++) {
				v.applyForce(vArray.get(j).position);
			}
		}


	}
}