class Vertex {
	PVector position;
	PVector movement;
	PVector acceleration;
	int radius;
	int[] connectance;

	Vertex(int r, int conn[]) {
		position = new PVector(random(width/2 - 10, width/2 + 10), random(height/2-10, height/2+10));
		movement = new PVector(0, 0);
		acceleration = new PVector(0, 0);
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
	// REVIEW THIS CODE; THIS CAN'T BE RIGHT!!!

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
		acceleration.limit(1);
		movement.add(acceleration);
		position.add(movement);
		acceleration.mult(0);
		movement.mult(0.75);
	}


	float forceEquation(float distance) {
		float force = -(0.005 * distance - 20000.0 * pow(distance, -2.0));

		/* The function can easily go to infinity, because it exceeds the range of the float datatype,
			therefore, we need to catch these infinity cases and return a force of 2, if that happens.
		*/
		if(force == Float.POSITIVE_INFINITY) {
			return(3.0);
		} else {
			//println(force);
			return(force);
		}
	}

	PVector calculateForce(PVector ver) {
		PVector direction = PVector.sub(position, ver);
		direction.normalize();
		float distance = position.dist(ver);
		float force = forceEquation(distance);
		direction.mult(force);
		return(direction);
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

	// Implement function, that allows dragging one vertex! [later]
	void mouseDrag() {
		if(mouseX < position.x + 2*radius && mouseX > position.x - 2* radius) {
			if(mouseY < position.y + 2*radius && mouseY > position.y - 2* radius) {
				if(mousePressed == true){
					PVector mouse = new PVector(mouseX, mouseY);
					position = mouse;
				}
			}
		}
	}
}