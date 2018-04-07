class Vertex {
	/* Definition of the vertex class. A vertex is a "node" in a network, that is connected via lines. A vertex has an ID for easy retracing and drawing from the adjacency matrix. The movement of the vertex is accomplished by it's PVectors position, movement and acceleration; acceleration is added to movement, which is added to the position. Upon initialization, the vertex get's a radius and the rows from the adjacency matrix, that contains its connections to the other vertices.  */
	int vertexID;
	PVector position;
	PVector movement;
	PVector acceleration;
	int radius;
	int[] connectance;

	Vertex(int r, int conn[], int ID) {
		vertexID = ID;
		println(vertexID);
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

		fill(220, 60);
		textSize(32);
		text(vertexID + 1, -10, 10);
		popMatrix();

		stroke(2);
		line(position.x, position.y, ver.position.x, ver.position.y);

	}

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
				if(i != vertexID) {
					connectanceArrayPos[j] = i;
					j++;
				}
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