class Network {

	// The array stores the vertex under consideration in each row and its connectios to other vertices in colums. The value of the connection represents their weight. 0 means no connection
	int diameter;
	int[][] network;
	ArrayList<Vertex> vArray = new ArrayList<Vertex>();

	Network(int[][] net, int d) {
		network = net;
		int vertices = network.length;
		int connections = network[1].length;
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
			// First we get the positions of the vertices that are connected to the
			// current one and pass it to the displayVertex function in the end to 
			// show the whole network.
			int[] connectionLines = v.isConnected();

			// This works for now, but now any vertix with index 0 isn't rendered!!!
			// I need to shorten the output array from isConnected in the vertex class definition!!!
			for(int i = 0; i < connectionLines.length; i++){
				if(connectionLines[i] != 0){
					v.displayVertex(vArray.get(connectionLines[i]));
					v.applyForce(vArray.get(connectionLines[i]).position);
				}
			}
		}


	}
}