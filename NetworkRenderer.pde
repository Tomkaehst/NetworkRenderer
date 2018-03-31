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
// (Object-oriented style would be good here)

int[][] testArray = {{1, 1, 1},
					 {1, 1, 0},
					 {1, 0, 1}};
int cols = testArray[1].length;
int rows = testArray.length;


Network net;



void setup() {
	size(512, 512);
	frameRate(30);
	pixelDensity(displayDensity());
	smooth();

	net = new Network(testArray, 30);
}




void draw() {
	background(220);

	net.renderNetwork();
}