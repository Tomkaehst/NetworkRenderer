// Network Graph Renderer, by Tom Kache, Friedrich-Schiller University Jena, March 29th 2018

// Initialization of the graph array/matrix. Each
// rows represents one vertex, which is connected
// to other vertices by connections that are de-
// noted as values in the colums. E.g. the one in
// row 3, column 2 means, that vertex 3 is con-
// ected to vertex 2. So, in order to display the
// network, we loop through each row and create
// some nice data type which can store the posi-
// tion of the vertex itself and all the other
// ones it is conntected to. This seems quite
// tricky! Let's see how I do . . .

// IMPORTANT: What I implemented here is NOT an adjacency matrix!
// I have been quite stupid and misunderstood the whole concept. An adjacency
// matrix is defined as A = (a_{i, j}) which defines edges from node i to j!!!

// Additionally, I messed up my force calculations now... 

int[][] testArray = {{0, 1, 0, 0},
					 					{0, 0, 1, 1},
					 					{0, 0, 0, 1},
					 					{0, 0, 0, 0}};

Network net;

void setup() {
	size(720, 720);
	frameRate(40);
	pixelDensity(1);
	smooth();

	net = new Network(testArray, 30);
}




void draw() {
	background(220);

	net.renderNetwork();

}
