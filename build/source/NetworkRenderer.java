import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class NetworkRenderer extends PApplet {

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

int[][] testArray = {{0, 1, 0, 0},
					 					{0, 0, 1, 1},
					 					{0, 0, 0, 1},
					 					{0, 0, 0, 0}};

Network net;

public void setup() {
	
	frameRate(40);
	
	

	net = new Network(testArray, 30);
}




public void draw() {
	background(220);

	net.renderNetwork();

}
class Network {

	// The array stores the vertex under consideration in each row and its connectios to other vertices in colums. The value of the connection represents their weight. 0 means no connection
	int diameter, connections, vertices;
	int[][] network;
	ArrayList<Vertex> vArray = new ArrayList<Vertex>();

	Network(int[][] net, int d) {
		network = net;
		connections = network.length;
		vertices = network[1].length;
		diameter = d;

		/* NOTE BECAUSE THIS CAUSED A LOT OF PAIN:
		The ArrayList type is not really an array rather than a list,
		so we need to treat it differently, i.e. the ArrayList has
		it's own functions, that work differently. If we want to add
		an object to position i, we need to give this index to the
		add function as the first argument!!! */
		for(int i = 0; i < vertices; i++) {
			vArray.add(i, new Vertex(diameter, network[i], i));
		}
	}

	// Loop through the Vertex ArrayList and call the Vertex-own function to display them and their connectections. The forces and the mouseDrag is also called --> only this function needs to be called in the main programm
	public void renderNetwork() {
		for (Vertex v : vArray) {
			v.displayVertex();
			v.mouseDrag();
			renderConnections();
			applyForce();
		}
	}

	// Loops through the connectance array and displays one line for each connection.
	// STILL WAY TO MANY LINES! I CURRENTLY DON'T KNOW HOW TO DO THAT: WHAT WOULD BE A GOOD ALGORITHM TO DISPLAY ONLY ONE CONNECTION BETWEEN VERTICES FROM AN ADJACENCY MATRIX???
	public void renderConnections() {
		for (Vertex v : vArray) {
			for(int i = 0; i < v.connectance.length; i++) {
				if(v.connectance[i] == 1) {
					PVector nextVertexPos = vArray.get(i).position;

					pushStyle();
					stroke(3);
					fill(20);
					line(v.position.x, v. position.y, nextVertexPos.x, nextVertexPos.y);
					popStyle();
				}
			}
		}
	}

	// Calculate the force between each connected vertex according to the vertex function apply force. For the formula see the README
	public void applyForce() {
		for (Vertex v : vArray) {
			for(int i = 0; i < vArray.size(); i++) {
				// Get the position of the connected vertex for that we want to calculate the force
				PVector nextVertexPos = vArray.get(i).position;

				// Now if the two (the called and the one with loaded position in nextVertexPos) are connected the applyForce
				if(v.connectance[i] == 1) {
					v.applyForce(nextVertexPos, true);
				} else if(v.connectance[i] == 0) {
					v.applyForce(nextVertexPos, false);
				}
			}
		}
	}
}
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

	public void displayVertex() {
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

	public void applyForce(PVector ver, boolean connected) {
		edgeCollision();
		acceleration = calculateForce(ver, connected);
		acceleration.limit(1.2f);
		movement.add(acceleration);
		position.add(movement);
		acceleration.mult(0);
		movement.mult(0.75f);
	}


	// This force equation is applied to connected vertices so that they position themselves according to minimal energy
	public float forceEquation(float distance) {
		float force = -(0.05f * distance - 20.0f * pow(distance, -2.0f));
		/* The function can easily go to infinity, because it exceeds the range of the float datatype,
			therefore, we need to catch these infinity cases and return a force of 2, if that happens.
		*/
		if(force == Float.POSITIVE_INFINITY) {
			return(3.0f);
		} else {
			return(force);
		}
	}

	// This force is applied to unconnected vertices; otherwise they would completelty overlap at some point in time.
	public float simpleRepulsion(float distance) {
		float force = pow(distance, 2) * 0.001f;

		if(force == Float.POSITIVE_INFINITY) {
			return(2.0f);
		} else if(force == Float.NEGATIVE_INFINITY) {
			return(-2.0f);
		} else {
			return(force);
		}
	}

	public PVector calculateForce(PVector ver, boolean connected) {
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
			force = 1.0f;
		}

		direction.mult(force);
		return(direction);
	}

	public void edgeCollision() {
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
	public void mouseDrag() {
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
  public void settings() { 	size(720, 720); 	smooth(); 	pixelDensity(1); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "NetworkRenderer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
