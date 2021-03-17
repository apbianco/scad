// donbright/fakeclipplane.scad
// https://gist.github.com/donbright/0ba2934c6c9b7b69c411

function full_asin(x,y,S) = (
    (x<0) ? 180-sign(y)*asin(sqrt(S)) : sign(y)*asin(sqrt(S))
);

module FakeClipPlane(normal,dist,cubesize) {
  nx = normal[0];
  ny = normal[1];
  nz = normal[2];
  Qx = nx*nx;
  Qy = ny*ny;
  Qz = nz*nz;
  Syaw = (Qy+Qx)==0 ? 0 : Qy/(Qy+Qx);
  Spitch = Qz/(Qx+Qy+Qz);
  roll = 0;
  yaw = full_asin(nx,ny,Syaw);
  pitch = -full_asin(abs(nx),nz,Spitch);
  newdist = dist + cubesize/2;
  position_scaler = newdist/sqrt(Qx+Qy+Qz);
  newpos = normal * position_scaler;
  translate(newpos) {
    rotate([roll,pitch,yaw]) {
      cube(cubesize,center=true);
    }
  }
}
