PVector HyperbolicTransform(float x, float y, float[] Cx, float[] Cy) {
  float xnew = Cx[5]*x*x + Cx[4]*y*y + Cx[3]*x*y +
                  Cx[2]*x + Cx[1]*y + Cx[0];
  float ynew = Cy[5]*x*x + Cy[4]*y*y + Cy[3]*x*y +
                  Cy[2]*x + Cy[1]*y + Cy[0];
  return new PVector(xnew, ynew);
}

PVector MysteryTransform(float x, float y, float[] Cx, float[] Cy) {
  float hx_xy = 0, hx_yx = 0, hy_xy = 0, hy_yx = 0;
  
  int N = 3;
  hx_yx = Cx[3]*y/(x*x+N);
  hx_xy = Cx[4]*x/(y*y+N);
  
  hy_yx = Cy[3]*y/(x*x+N);
  hy_xy = Cy[4]*x/(y*y+N);
  
  float xnew = hx_xy + hx_yx + Cx[2]*x + Cx[1]*y + Cx[0];
  float ynew = hy_xy + hy_yx + Cy[2]*x + Cy[1]*y + Cy[0];
  return new PVector(xnew, ynew);
}
