class Vertex {
	PVector position;
	PVector movement;
	int diameter;
	int[] connectance;

	Vertex(int d, int conn[]) {
		position = new PVector(random(50, width - diameter), random(50, height - diameter));
		diameter = d;
		connectance = conn;
	}

	void displayVertex(Vertex ver) {
		pushMatrix();
		translate(position.x, position.y);
		noStroke();
		fill(195, 82, 80);
		ellipse(0, 0, diameter, diameter);
		popMatrix();

		stroke(2);
		line(position.x, position.y, ver.position.x, ver.position.y);
	}

	// Practise a little bit of functional programming: divide the rendering process for the vertex connections into serveral functions.
	// 1. Get to know, to which vertex this one is connected (output: array); 2. Save their position in a PVector and return it (output: PVector); 3. We can then call
	// both functions in the displayVertex function and simply draw a line to these positions.

	int[] isConnected() {
		int amountConnections = 0;

		for(int i = 0; i < connectance.length; i++) {
			if(connectance[i] != 0){
				amountConnections++;
			}
		}

		int[] connectanceArrayPos = new int[amountConnections];
		int j = 0;

		for(int i = 0; i < connectance.length; i++){
			if(connectance[i] == 1) {
				connectanceArrayPos[j] = i;
				j++;
			}
		}

		return(connectanceArrayPos);
	}

	void applyForce(PVector force) {

	}

	PVector calculateForce(Vertex ver) {
		float distance = position.dist(ver.position);
		

		return(new PVector(distance, distance));
	}

	void edgeCollision() {
		
	}
}







