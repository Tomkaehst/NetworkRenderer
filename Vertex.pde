class Vertex {
	PVector position;
	PVector movement;
	PVector acceleration;
	int radius;
	int[] connectance;

	Vertex(int r, int conn[]) {
		position = new PVector(random(50, width - radius * 2), random(50, height - radius * 2));
		movement = new PVector(0, 0);
		acceleration = new PVector(0, 0);
		radius = r;
		connectance = conn;
	}

	void displayVertex(Vertex ver) {
		fill(195, 82, 80);
		ellipse(position.x, position.y, radius*2, radius*2);

		stroke(2);
		line(position.x, position.y, ver.position.x, ver.position.y);

		applyForce(ver.position);
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
		PVector movementForce = calculateForce(ver);
		movementForce.limit(1);
		acceleration.add(movementForce);
		movement.add(acceleration);
		position.add(movement);
		acceleration.mult(0);
		movement.mult(0);
	}

	float forceEquation(float distance) {
		float force = 0.0001*distance - 10000/pow(distance, 2);
		return(force);
	}

	PVector calculateForce(PVector ver) {
		PVector distance = position.sub(ver);
		PVector force = new PVector(forceEquation(distance.x), forceEquation(distance.y));
		return(force);
	}

	void edgeCollision() {
		if(position.x > (width - radius)) {
			movement.x *= -1;
		} else if(position.x < radius) {
			movement.x *= -1;
		}

		if(position.y > (height - radius)) {
			movement.y *= -1;
		} else if(position.y < radius) {
			movement.y *= -1;
		}
	}
}







