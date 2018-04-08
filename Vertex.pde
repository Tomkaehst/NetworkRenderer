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

	void displayVertex() {
		pushMatrix();
		pushStyle();
		translate(position.x, position.y);
		fill(195, 82, 80);
		ellipse(0, 0, radius, radius);
		
		// Render some text with the ID of the vertex + 1, so we don't see the array index but the "real world" index in the matrix.
		fill(220, 60);
		textSize(32);
		text(vertexID + 1, -10, 10);
		popStyle();
		popMatrix();
	}

	void applyForce(PVector ver, boolean connected) {
		edgeCollision();
		acceleration = calculateForce(ver, connected);
		acceleration.limit(1.2);
		movement.add(acceleration);
		position.add(movement);
		acceleration.mult(0);
		movement.mult(0.75);
	}


	// This force equation is applied to connected vertices so that they position themselves according to minimal energy
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

	// This force is applied to unconnected vertices; otherwise they would completelty overlap at some point in time.
	float simpleRepulsion(float distance) {
		float force = pow(distance - 5, 2) * 0.01;
		if(force == Float.POSITIVE_INFINITY) {
			return(2.0);
		} else if(force == Float.NEGATIVE_INFINITY) {
			return(-2.0);
		} else {
			return(force);
		}
	}

	PVector calculateForce(PVector ver, boolean connected) {
		PVector direction = PVector.sub(position, ver);
		direction.normalize();
		float distance = position.dist(ver);
		float force;

		// the boolean value connected is passed from the applyForce function, that get's it from the Network function applyForce (see DrawNetwork.pde)
		if(connected == true) {
			force = forceEquation(distance);	
		} else if(connected == false) {
			force = simpleRepulsion(distance);
		} else {
			force = 1.0;
		}

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
		if(mouseX < position.x + radius && mouseX > position.x - radius) {
			if(mouseY < position.y + radius && mouseY > position.y - radius) {
				if(mousePressed == true){
					PVector mouse = new PVector(mouseX, mouseY);
					position = mouse;
				}
			}
		}
	}
}