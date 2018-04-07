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

int[][] testArray = {{1, 1, 0, 1, 1},
					 {1, 0, 1, 0, 1},
					 {0, 1, 0, 1, 0},
					 {1, 0, 1, 1, 0},
					 {0, 1, 0, 0, 1}};

Network net;

public void setup() {
	
	frameRate(50);
	
	

	net = new Network(testArray, 30);
}




public void draw() {
	background(220);

	net.renderNetwork();
	println(testArray[0]);
}
class Network {

	// The array stores the vertex under consideration in each row and its connectios to other vertices in colums. The value of the connection represents their weight. 0 means no connection
	int diameter;
	int[][] network;
	ArrayList<Vertex> vArray = new ArrayList<Vertex>();

	Network(int[][] net, int d) {
		network = net;
		int connections = network.length;
		int vertices = network[1].length;
		diameter = d;

		/* NOTE BECAUSE THIS MADE A LOT OF PAIN:
		The ArrayList type is not really an array rather than a list,
		so we need to treat it differently, i.e. the ArrayList has
		it's own functions, that work differently. If we want to add
		an object to position i, we need to give this index to the
		add function as the first argument!!! */

		for(int i = 0; i < vertices; i++) {
			vArray.add(i, new Vertex(diameter, network[i], i));
		}
	}

	// Loop through the Vertex ArrayList and call the Vertex-own function to display them.
	public void renderNetwork() {
		for(Vertex v : vArray) {
			int[] connectionLines = v.isConnected();
			v.mouseDrag();

			// I need to rethink this, because it could lead to some vertices not being displayed, if they're note connected!
			for(int i = 0; i < connectionLines.length; i++){
				if(connectionLines[i] != 0){
					v.displayVertex(vArray.get(connectionLines[i]));
				}
			}
		}

		// Let each vertex "feel" each other vertex by calling one vertex and calculating it's force to every other vertex
		for(int i = 0; i < vArray.size(); i++) {
			Vertex v = vArray.get(i);

			for(int j = 0; j < vArray.size(); j++) {
				v.applyForce(vArray.get(j).position);
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

	public void displayVertex(Vertex ver) {
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

	public int[] isConnected() {
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


	public void applyForce(PVector ver) {
		edgeCollision();
		acceleration = calculateForce(ver);
		acceleration.limit(1);
		movement.add(acceleration);
		position.add(movement);
		acceleration.mult(0);
		movement.mult(0.75f);
	}


	public float forceEquation(float distance) {
		float force = -(0.005f * distance - 20000.0f * pow(distance, -2.0f));

		/* The function can easily go to infinity, because it exceeds the range of the float datatype,
			therefore, we need to catch these infinity cases and return a force of 2, if that happens.
		*/
		if(force == Float.POSITIVE_INFINITY) {
			return(3.0f);
		} else {
			return(force);
		}
	}

	public PVector calculateForce(PVector ver) {
		PVector direction = PVector.sub(position, ver);
		direction.normalize();
		float distance = position.dist(ver);
		float force = forceEquation(distance);
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
  public void settings() { 	size(720, 720); 	noSmooth(); 	pixelDensity(displayDensity()); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "NetworkRenderer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
