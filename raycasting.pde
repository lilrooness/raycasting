int[][] map = {{0,0,0,0,0},
               {0,0,0,0,0},
               {0,0,0,0,0}, 
               {0,0,1,0,1},
               {0,0,0,0,0},
               {1,0,1,0,1},
               {0,0,0,0,0},
               {1,0,1,0,1}};

float quater;
float dist;
float angle, pangle;
float steps;
int dimention;
int px, py;
float plx, ply;
float lx, ly;
int maxHeight;

void setup() {
  maxHeight = 200;
  dimention = 10;
  quater = (float)(Math.PI*2)/4.0f;
  dist = 1000;
  size(640, 480);
  steps = width;
  angle = (float)Math.PI/2 / steps;
  px = 0;
  py = 0;
  pangle = (float)Math.PI / 2;
  plx = 0;
  ply = 0;
}

void draw() {
  background(100,0,0);
  plx = sin(pangle);
  ply = cos(pangle);
  
  //poll input
  if(keyPressed) {
    if(key == 'w') {
      px += plx*10;
      py += ply*10;
    }else if(key == 's') {
      px -= plx*10;
      py -= ply*10;
    }
    if(key == 'a') {
      pangle -= 0.1;
    }else if(key == 'd') {
      pangle += 0.1;
    }
  }
  
  //render screen
  for(int i = 0; i <steps; i++) {
    float newAngle = angle * i;
    lx = sin((newAngle)+pangle-(newAngle/2));
    ly = cos((newAngle)+pangle-(newAngle/2));
    float mag = magnitude(lx, ly);
    lx = lx/mag;
    ly = ly/mag;
    lx *= dist;
    ly *= dist;
    float hit = rayCast(px/dimention, py/dimention, (int)lx, (int)ly, map);
    int segmentHeight = (int) maxHeight - (int)hit;
    float segmentX = i*2;
    if(hit != -1) {
      rect(segmentX, (height/2)-(segmentHeight/2), 1, segmentHeight);
      text(String.format("player gridX = %d player gridY = %d", px / dimention, py / dimention), 10, 10);
    }
  }
}

float magnitude(float x, float y) {
  return (float)Math.sqrt((x * x) + (y * y));
}

float rayCast(int x1, int y1, int x2, int y2, int[][] map) {
  int xinc = 1;
  int yinc = 1;

  if (x2 < x1) {
    xinc = -1;
  }
  if (y2 < y1) {
    yinc = -1;
  }

  int dx = x2 - x1;
  int dy = y2 - y1;

  if (dx >= dy) {
    int y = y1;
    int ynum = dx/2;

    for (int x = x1; x!= x2; x+=xinc) {
      if(x/dimention > map[1].length-1 || y/dimention > map.length-1 || x < 0 || y < 0) {
        return -1;
      }else if(map[y/dimention][x/dimention] == 1) {
        return (float)Math.sqrt((x - x1)*(x - x1)+(y - y1)*(y - y1));
      }
      ynum += dy;

      if (yinc > 0) {
        if (ynum >= dx) {
          ynum -= dx;
          y+=yinc;
        }
      }
      else if (yinc < 0) {
        if (ynum <= dx) {
          ynum += dx;
          y+=yinc;
        }
      }
    }
  }else{
    int x = x1;
    int xnum = dy/2;
    
    for(int y=y1; y!=y2; y+=yinc) {
      if(x/dimention > map[1].length-1 || y/dimention > map.length-1 || x < 0 || y < 0) {
        return -1;
      }else if(map[y/dimention][x/dimention] == 1) {
        return (float)Math.sqrt((x - x1)*(x - x1)+(y - y1)*(y - y1));
      }
      xnum += dx;
      
      if(xinc > 0) {
        if(xnum >= dy) {
          xnum -= dy;
          x += xinc;
        }
      }
      else if(xinc < 0) {
        if(xnum < dy) {
          xnum += dy;
          x += xinc;
        }
      }
    }
  }
  return -1;
}

