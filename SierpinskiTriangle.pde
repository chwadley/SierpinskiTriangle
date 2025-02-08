void unit(float size, float x, float y) {
  stroke(0);
  if (size>20) {
    strokeWeight((float)Math.sin((float)frameCount/30)*2+5);
  } else {
    strokeWeight(size/20*((float)Math.sin((float)frameCount/30)*2+5));
  }
  int f = (int)((size*739+x*294+y*933+frameCount)%(60*2*PI));
  fill((int)(Math.sin((float)f/60)*128+128),(int)(Math.sin((float)f/60)*64+128),(int)(Math.cos((float)f/60)*64+192));
  beginShape();
  for (int i=0;i<b;i++) {
    vertex(x+sin(i*2*PI/b)*size,y-cos(i*2*PI/b)*size);
  }
  endShape(CLOSE);
  noStroke();
  fill(0,0,0,128);
  ellipse(x,y,size*2,size*2);
}

void sierpinski(float size, float x, float y, float n) {
  if (n<=0) {
    unit(size,x,y);
  } else {
    for (int i=0;i<b;i++) {
      sierpinski(size/c,x+sin(i*2*PI/b)*(c-1)*size/c,y-cos(i*2*PI/b)*(c-1)*size/c,n-1);
    }
  }
}

int a=3;
int b=3;
float c=2;
int mode=0;

void setup() {
  size(1000,1000);
}

void draw() {
  if (mode==0) {
    background(220);
    fill(255);
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    rect(width/3,height/2,200,30);
    rect(2*width/3,height/2,100,30);
    noStroke();
    fill(0);
    strokeWeight(1);
    textAlign(CENTER,CENTER);
    text("Sierpinski Triangle (plus variations)",width/3,height/2);
    text("Mandelbrot Set",width-width/3,height/2);
  } else if (mode==1) {
    sierpinskiDraw();
  } else if (mode==2) {
    mandelbrotDraw();
  }
}

void mousePressed() {
  float x = mouseX;
  float y = mouseY;
  if (y>=height/2-15&&y<=height/2+15) {
    if (x>=width/3-55&&x<=width/3+55) {
      mode=1;
      sierpinskiSetup();
    }
    if (x>=2*width/3-55&&x<=2*width/3+55) {
      mode=2;
      mandelbrotSetup();
    }
  }
}

void keyPressed() {
  if (mode==1) {
    sierpinskiKeyPressed();
  }
  if (mode==2) {
    mandelbrotKeyPressed();
  }
}

void sierpinskiSetup() {
  keyPressed();
}

void sierpinskiDraw() {
  fill(0);
  noStroke();
  background(220);
  sierpinski(400,width/2,height/2,a);
  text(keyCode,width-50,50);
  textAlign(LEFT,CENTER);
  text("Iterations: "+a+" - change with W and S",50,50);
  text("Shape: "+b+" - change with up and down arrow keys",50,100);
  text("Size: "+c+" - change with A and D",50,150);
  //text(c,50,50);
}
//111C
//CS 160A, Introduction to Unix/Linux
void sierpinskiKeyPressed() {
  if (key=='w') a++;
  if (key=='s') a--;
  if (key=='a') c+=0.03;
  if (key=='d') c-=0.03;
  if (keyCode==38) b++;
  if (keyCode==40) b--;
  
}
//3: 2.15
//4: 2.19
//5: 2.7
//6: 3
//7: 3.25
//8: 3.42?
//9: 3.88
//10: 4.25
//11: 4.52
int fractal(float x, float y, float zx, float zy, int n, boolean show) {
  fill(255, 255, 0);
  if (show) {
    circle(zx*s, zy*s, 5);
    //System.out.print(zx+", ");
    //System.out.println(zy);
  }
  if (dist(zx, zy, 0, 0)>2) {
    return n;
  } else if (n>it-2) {
    return -1;
  } else {
    return fractal(x, y, zx*zx-zy*zy+x, zx*zy*2+y, n+1, show);
  }
}

int s=500;
int it=15;
int ox=0;
int oy=0;
color[] cols = new color[it];
int res=4;
int n,px,py;

void mandelbrotSetup() {
  background(220);
  for (int i=0; i<cols.length; i++) {
    cols[i] = color((int)(Math.random()*255), (int)(Math.random()*255), (int)(Math.random()*255));
  }
}

void mandelbrotDraw() {
  background(220);
  translate(width/2,height/2);
  noStroke();
  for (float y=Math.max(-s,-height/2)+oy; y<Math.min(height/2,s)+oy; y+=res) {
    for (float x=Math.max(-s,-width/2)+ox; x<Math.min(width/2,s)+ox; x+=res) {
      n = fractal(2*x/s, 2*y/s, 0, 0, 0, false);
      if (n==-1) {
        fill(0, 0, 0);
      } else {
        fill(cols[Math.min(cols.length-1,n)]);
      }
      int size = res+((res%2==0)?0:1);
      rect(x-ox, y-oy, size, size);
    }
  }
  //fractal((float)(mouseX)/s, (float)(mouseY)/s, 0, 0, 0, true);
  //text(frameCount,-50,-50);
  noStroke();
  fill(0);
  translate(-width/2,-height/2);
  text(keyCode,50,50);
  stroke(0);
  strokeWeight(2);
  fill(255);
  rectMode(CORNER);
  rect(5,5,190,50);
  rect(200,5,140,50);
  rect(345,5,150,50);
  rect(500,5,190,50);
  strokeWeight(1);
  fill(0);
  noStroke();
  text("Change resolution with T and G",100,30);
  text("Translate with WASD",270,30);
  text("Scale with up/down arrows",420,30);
  text("Change iterations with right/left",595,30);
  noLoop();
}

void mandelbrotKeyPressed() {
  if (keyCode==38) {
    s*=1.1;
    ox*=1.1;
    oy*=1.1;
    redraw();
  }
  if (keyCode==40) {
    s/=1.1;
    ox/=1.1;
    oy/=1.1;
    redraw();
  }
  if (key=='w') {
    oy-=15;
    redraw();
  }
  if (key=='s') {
    oy+=15;
    redraw();
  }
  if (key=='a') {
    ox-=15;
    redraw();
  }
  if (key=='d') {
    ox+=15;
    redraw();
  }
  if (keyCode==39) {
    it++;
    color[] newCols = new color[it];
    for (int i=0;i<newCols.length-1;i++) {
      newCols[i]=cols[i];
    }
    newCols[newCols.length-1]=color((int)(Math.random()*255), (int)(Math.random()*255), (int)(Math.random()*255));
    cols=newCols;
    redraw();
  }
  if (keyCode==37) {
    it--;
    redraw();
  }
  if (key=='t'&&res>1) {
    res--;
    redraw();
  }
  if (key=='g') {
    res++;
    redraw();
  }
}
