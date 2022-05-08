import java.util.List;
import java.util.LinkedList;

//final int WIDTH = 800;
//final int HEIGHT = 200;
int iteration = 0;
List<PolySnake> snakeArray = new ArrayList<PolySnake>();

void settings() {
  //size(WIDTH, HEIGHT);
  fullScreen();
}

void setup() {
  PolySnake S1 = new PolySnake(
    new PVector(2*width/3, height/2),
    new PVector(1, 0),
    100, 100);
  PolySnake S2 = new PolySnake(
    new PVector(width/3, height/2),
    new PVector(-1, 0),
    50, 150);
  PolySnake S3 = new PolySnake(
    new PVector(width/2, 2*height/3),
    new PVector(0, 1),
    25, 200);
    
  snakeArray.add(S1);
  snakeArray.add(S2);
  snakeArray.add(S3);
    
  colorMode(HSB);
  background(0);
  frameRate(1000);
}

void draw() {
  iteration = iteration % 10;
  if (iteration == 0) {
    for (PolySnake S : snakeArray) {
      S.extend();
    }
  }
  
  background(0);
  for (PolySnake S : snakeArray) {
    S.drawSnake();
  }
  
  iteration++;
}

class PolySnake {
  int lifetime;
  int shape_size;
  int colorVal = int(random(255));

  List trail = new LinkedList<Shape>();
  PVector curEdgePos;
  PVector curDir;
  
  PolySnake(PVector edgePos, PVector dir, int shape_size, int lifetime) {
    this.curEdgePos = edgePos;
    this.curDir = dir;
    this.shape_size = shape_size;
    this.lifetime = lifetime;
  }
  
  void extend() {
    int n = 3 + int(random(4));
    colorVal = (colorVal + 5) % 255;
    Shape s = new Shape(n, curEdgePos, curDir, colorVal, shape_size, lifetime);
    trail.add(s);
    
    if (curEdgePos.x < shape_size) {
      PVector adjPos = new PVector(curEdgePos.x + width, curEdgePos.y);
      trail.add(new Shape(n, adjPos, curDir, colorVal, shape_size, lifetime));
    }
    if (curEdgePos.x > width - shape_size) {
      PVector adjPos = new PVector(curEdgePos.x - width, curEdgePos.y);
      trail.add(new Shape(n, adjPos, curDir, colorVal, shape_size, lifetime));
    }
    if (curEdgePos.y < shape_size) {
      PVector adjPos = new PVector(curEdgePos.x, curEdgePos.y + height);
      trail.add(new Shape(n, adjPos, curDir, colorVal, shape_size, lifetime));
    }
    if (curEdgePos.y > height - shape_size) {
      PVector adjPos = new PVector(curEdgePos.x, curEdgePos.y - height);
      trail.add(new Shape(n, adjPos, curDir, colorVal, shape_size, lifetime));
    }
    
    curEdgePos = s.nextEdgePos;
    curDir = s.nextDir;
    
    curEdgePos.x = (curEdgePos.x + width) % width;
    curEdgePos.y = (curEdgePos.y + height) % height;
  }
  
  void drawSnake() {
    for (int i=0; i < trail.size(); i++) {
      Shape s = (Shape)trail.get(i);
      s.age++;
      s.updateColor();
      shape(s.shape);
    }
    if (((Shape)trail.get(0)).age > lifetime) {
      trail.remove(0);
    }
  }
}

class Shape {
  int age = 0;
  int colorVal;
  int lifetime;
  PShape shape;
  PVector nextEdgePos;
  PVector nextDir;
  
  Shape(int n, PVector edgePos, PVector dir, int colorVal, int size, int lifetime) {
    float t = PI / n;
    float a = size/2 / tan(t);
    float r = size/2 / sin(t);
    
    PVector center = PVector.add(edgePos, PVector.mult(dir, a));
    PVector vDir = dir.copy();
    
    if (n % 2 == 0) {
      vDir.rotate(t);
    }
    
    shape = createShape();
    shape.beginShape();
    shape.strokeWeight(2);
    PVector v;
    for (int i=0; i<n; i++) {
      v = PVector.add(center, PVector.mult(vDir, r));
      shape.vertex(v.x, v.y);
      vDir = vDir.rotate(2*t);
    }
    shape.endShape(CLOSE);
    
    if (n % 2 == 0) {
      nextDir = dir.copy();
    }
    else {
      int choice = int(random(2));
      nextDir = dir.copy().rotate(-t + choice*2*t);
    }
    nextEdgePos = PVector.add(center, PVector.mult(nextDir, a));
    
    this.colorVal = colorVal;
    this.lifetime = lifetime;
  }
  
  void updateColor() {
    float alpha = getAlpha();
    shape.setStroke(color(100, alpha));
    shape.setFill(color(colorVal, 255, 255, alpha));
  }
  
  float getAlpha() {
    /*if (age < lifetime/4.0) {
      return 255 * age / (lifetime/4.0);
    }*/
    if (age > 3*lifetime/4.0) {
      return 255 * (lifetime - age) / (lifetime/4.0);
    }
    return 255;
  }
}
