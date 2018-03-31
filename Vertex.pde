class Vertex {
	PVector position;
	PVector movement;
	PVector acceleration;
	int radius;
	int[] connectance;

	Vertex(int r, int conn[]) {
		position = new PVector(random(50, width - radius * 2), random(50, height - radius * 2));
		movement = new PVector(0, 0);
		acceleration = new PVector(random(-1, 1), random(-1, 1));
		radius = r;
		connectance = conn;
	}

	void displayVertex(Vertex ver) {
		pushMatrix();
		translate(position.x, position.y);
		fill(195, 82, 80);
		ellipse(0, 0, radius*2, radius*2);
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


	void applyForce(PVector ver) {
		edgeCollision();
		acceleration = calculateForce(ver);
		movement.add(acceleration);
		position.add(movement);
		acceleration.mult(0);
	}


// I got it. I just added the raw force value to the indidivual accelerations, which make the vertices bounce without any sense. I need to translate and rotate the scene to the target vertex and let it move in that direction!
	float forceEquation(float distance) {
		//float force = -0.05 * distance;
		float force = pow(distance, 2) / 15;
		force *= 0.25;
		//float force = 0.5;
		return(force);
	}

	PVector calculateForce(PVector ver) {
		PVector distance = PVector.sub(position, ver);
		float forceX = forceEquation(distance.x);
		float forceY = forceEquation(distance.y);
		PVector force = new PVector(forceX, forceY);
		force.limit(1);
		return(force);
	}

	void edgeCollision() {
		if(position.x > (width - radius)) {
			movement.x *= -1;
			position.x = width - radius;
		} else if(position.x < radius) {
			movement.x *= -1;
			position.x = radius;
		}

		if(position.y > (height - radius)) {
			movement.y *= -1;
			position.y = height - radius;
		} else if(position.y < radius) {
			movement.y *= -1;
			position.y = radius;
		}
	}
}







