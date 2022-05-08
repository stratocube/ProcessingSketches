int WIDTH = 600;
int HEIGHT = 600;
int SRC_WIDTH = 100;
int SRC_HEIGHT = 100;
float WINDOW_WIDTH = 10;
float WINDOW_HEIGHT = 10;
float PARAM_RANGE = 2;
int iteration = 0;
int cycle = 10;
int nx, ny;

PGraphics pg;
PImage src_img, dest_img;
float[] CoeffX = new float[6];
float[] CoeffY = new float[6];
float[] DeltaX = new float[6];
float[] DeltaY = new float[6];

void settings() {
  size(WIDTH, HEIGHT);
}

void setup() {
  pg = createGraphics(SRC_WIDTH, SRC_HEIGHT);
  pg.beginDraw();
  pg.strokeWeight(0);
  pg.fill(0, 255, 0);
  pg.rect(SRC_WIDTH/4, SRC_HEIGHT/4, SRC_WIDTH, SRC_HEIGHT);
  pg.fill(0);
  pg.rect(0, 0, 3*SRC_WIDTH/4, 3*SRC_HEIGHT/4);
  pg.fill(0, 255, 0);
  pg.rect(0, 0, SRC_WIDTH/2, SRC_HEIGHT/2);
  pg.fill(0);
  pg.rect(0, 0, SRC_WIDTH/4, SRC_HEIGHT/4);
  pg.endDraw();
  src_img = pg.get();
  dest_img = createImage(WIDTH, HEIGHT, RGB);
  
  randomizeCoeffs();  
  frameRate(20);
}

void randomizeCoeffs() {
  for (int i=0; i<CoeffX.length; i++) {
    CoeffX[i] = random(2*PARAM_RANGE) - PARAM_RANGE;
    DeltaX[i] = 0.05 * (2*(int)random(2) - 1);
  }
  for (int i=0; i<CoeffY.length; i++) {
    CoeffY[i] = random(2*PARAM_RANGE) - PARAM_RANGE;
    DeltaY[i] = 0.05 * (2*(int)random(2) - 1);
  }
}

void draw() {
  background(0);
  for (int i=0; i<WIDTH; i++) {
    for (int j=0; j<HEIGHT; j++) {
      float x = map(i, 0, WIDTH, -WINDOW_WIDTH/2, WINDOW_WIDTH/2);
      float y = map(j, 0, HEIGHT, -WINDOW_HEIGHT/2, WINDOW_HEIGHT/2);
      
      // transformations
      PVector v = TransformHyperbolic(x, y, CoeffX, CoeffY);
      
      int inew = (int) map(v.x, -WINDOW_WIDTH/2, WINDOW_WIDTH/2, 0, SRC_WIDTH);
      int jnew = (int) map(v.y, -WINDOW_HEIGHT/2, WINDOW_HEIGHT/2, 0, SRC_HEIGHT);
      
      while (inew < 0) {
        inew += SRC_WIDTH;
      }
      while (jnew < 0) {
        jnew += SRC_HEIGHT;
      }
      inew += iteration;
      jnew += iteration;
      inew %= SRC_WIDTH;
      jnew %= SRC_HEIGHT;
      
      // lookup image indicies
      dest_img.pixels[j*WIDTH + i] = src_img.pixels[jnew*SRC_WIDTH + inew];
    }
  }
  dest_img.updatePixels();
  image(dest_img, 0, 0);
  
  if (cycle == 0) {
    cycle = (int)random(10) + 10;
    nx = int(random(CoeffX.length));
    ny = int(random(CoeffY.length));
  }
  
  float nextVal = CoeffX[nx] + DeltaX[nx];
  if (nextVal < -PARAM_RANGE || nextVal > PARAM_RANGE) {
    DeltaX[nx] = -DeltaX[nx];
  }
  CoeffX[nx] += DeltaX[nx];
  
  nextVal = CoeffY[ny] + DeltaY[ny];
  if (nextVal < -PARAM_RANGE || nextVal > PARAM_RANGE) {
    DeltaY[ny] = -DeltaX[ny];
  }
  CoeffY[ny] += DeltaY[ny];
  
  cycle--;
  iteration += 2;
  
  if (iteration % 1000 == 0) {
    randomizeCoeffs();
  }
}
