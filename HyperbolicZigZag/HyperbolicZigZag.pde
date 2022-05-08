int WIDTH = 600;
int HEIGHT = 600;
int SRC_WIDTH = 100;
int SRC_HEIGHT = 100;
float WINDOW_WIDTH = 10;
float WINDOW_HEIGHT = 10;
float PARAM_RANGE = 2;
int iteration = 0;

PGraphics pg;
PImage src_img, dest_img;
float[] Cx = new float[6];
float[] Cy = new float[6];

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
  
  for (int i=0; i<Cx.length; i++) {
    Cx[i] = random(2*PARAM_RANGE) - PARAM_RANGE;
  }
  for (int i=0; i<Cy.length; i++) {
    Cy[i] = random(2*PARAM_RANGE) - PARAM_RANGE;
  }
  
  frameRate(20);
}

void draw() {
  iteration++;
  background(0);
  for (int i=0; i<WIDTH; i++) {
    for (int j=0; j<HEIGHT; j++) {
      float x = WINDOW_WIDTH * (((float)i)/WIDTH - 0.5); // scaling
      float y = WINDOW_HEIGHT * (((float)j)/HEIGHT - 0.5);
      
      // transformations
      float xnew = //Cx[9]*x*x*x + Cx[8]*x*x*y + Cx[7]*x*y*y + Cx[6]*y*y*y;
                  Cx[5]*x*x + Cx[4]*y*y + Cx[3]*x*y +
                  Cx[2]*x + Cx[1]*y + Cx[0];
      float ynew = //Cy[9]*x*x*x + Cy[8]*x*x*y + Cy[7]*x*y*y + Cy[6]*y*y*y +
                  Cy[5]*x*x + Cy[4]*y*y + Cy[3]*x*y +
                  Cy[2]*x + Cy[1]*y + Cy[0];
      
      int inew = (int) (SRC_WIDTH * (xnew/WINDOW_WIDTH + 0.5));
      int jnew = (int) (SRC_HEIGHT * (ynew/WINDOW_HEIGHT + 0.5));
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
  
  int nx = int(random(Cx.length));
  float r = random(0.01*(1+nx))+0.005;
  Cx[nx] = (Cx[nx] + r + PARAM_RANGE) % (2*PARAM_RANGE) - PARAM_RANGE;
  int ny = int(random(Cy.length));
  r = random(0.01*(1+ny)) + 0.005;
  Cy[ny] = (Cy[ny] + r + PARAM_RANGE) % (2*PARAM_RANGE) - PARAM_RANGE;
}
