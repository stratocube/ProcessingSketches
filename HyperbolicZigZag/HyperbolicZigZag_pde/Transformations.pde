PVector TransformHyperbolic(float x, float y, float[] Cx, float[] Cy) {
  float xnew = Cx[5]*x*x + Cx[4]*y*y + Cx[3]*x*y +
                  Cx[2]*x + Cx[1]*y + Cx[0];
  float ynew = Cy[5]*x*x + Cy[4]*y*y + Cy[3]*x*y +
                  Cy[2]*x + Cy[1]*y + Cy[0];
  return new PVector(xnew, ynew);
}

PVector TransformHyperbolic2(float x, float y, float[] Cx, float[] Cy) {
  float xnew = Cx[3]*x*y +
                  Cx[2]*x + Cx[1]*y + Cx[0];
  float ynew = Cy[3]*x*y +
                  Cy[2]*x + Cy[1]*y + Cy[0];
  return new PVector(xnew, ynew);
}

//Cx[9]*x*x*x + Cx[8]*x*x*y + Cx[7]*x*y*y + Cx[6]*y*y*y;
//Cy[9]*x*x*x + Cy[8]*x*x*y + Cy[7]*x*y*y + Cy[6]*y*y*y +
