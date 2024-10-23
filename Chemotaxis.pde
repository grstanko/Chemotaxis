float UNITS = 0.5;
float ROM = 1.0;

float targetx;
float targety;

boolean pause = false;

boolean snap_to_target = false;

boolean options_shown = false;
float tUNITS = 0.0;

class Agent {
  float x, y;
  float vx, vy;
  float orientation;
  float to;
  Agent() {
    x = (float)Math.random()*width;
    y = (float)Math.random()*height;
    orientation = (float)Math.random()*PI*2;
  }
  void tick() {
    to = 4.7123889803846898576939650749192543262957540990626587314624-atan2(x-targetx, y-targety);
    if (snap_to_target) {
      orientation =  to;
    }
    float diff_a = orientation-to;
    if (diff_a < radians(10)) {
      orientation += (float)radians((float)(Math.random()*ROM/4)-ROM/4/2);
    } else {
      orientation += (float)radians((float)(Math.random()*ROM)-ROM/2);
    }
    
    vx += UNITS * Math.cos(orientation);
    vy += UNITS * Math.sin(orientation);
    x += vx;
    y += vy;
    vx *= 0.65;
    vy *= 0.65;
    
    
    
    if (x > width) x = 0;
    if (x < 0) x = width;
    if (y > height) y = 0;
    if (y < 0) y = height;
    
    if (wh_enable && (dist(x, y, targetx, targety) < 1.0) && snap_to_target) {
      x = wh_x;
      y = wh_y;
    }
  }
  void draw() {
    point(x,y);
  }
}

boolean[] keys;

Agent[] agents;

void setup() {
  size(500, 500);
  agents = new Agent[5000];
  keys = new boolean[265];
  for (int i = 0; i < keys.length; i++) {
    keys[i] = false;
  }
  for (int i = 0; i < agents.length; i++){
    agents[i] = new Agent();
  }
  stroke(#FFFFFF);
    fill(#FFFFFF);
}

void draw() {
  targetx = mouseX;
  targety = mouseY;
  background(#222222);
  for(Agent agent: agents) {
    if (!pause) agent.tick();
    agent.draw();
  }
  
  if (mousePressed && (mouseButton == LEFT)) {
    snap_to_target = true;
  } else {
    snap_to_target = false;
  }
  
  if (mousePressed && (mouseButton == RIGHT)) {
    wh_x = mouseX;
    wh_y = mouseY;
  }
  
  if (keys['o'] == true) {
    options_shown = !options_shown;
    keys['o'] = false;
  }if (keys[' '] == true) {
    pause = !pause;
    keys[' '] = false;
  }if (keys['r'] == true) {
    for (Agent agent : agents) {
      agent.x = (float)Math.random()*width;
      agent.y = (float)Math.random()*height;
    }
    keys['r'] = false;
  }
  if (keys['q']) {
    UNITS += 0.1;
  }
  if (keys['a']) {
    UNITS -= 0.1;
  }
  if (keys['e']) {
    ROM += 00.1;
  }
  if (keys['d']) {
    ROM -= 00.1;
  }
  if (keys['w']) {
    wh_enable = !wh_enable;
    keys['w'] = false;
  }
  if(options_shown) {
    text("FPS: " + frameRate, 40, 40);
    text("(q/a) Walk speed: " + (int)(UNITS*60) + "p/s", 40, 50);
    text("(e/d) ROM: " + (int)(ROM), 40, 70);
    text("(w) White Hole Enable: " + wh_enable, 40, 60);
  }
}

boolean wh_enable;
float wh_x = 0.0;
float wh_y = 0.0;



void keyPressed() {
  if (key > keys.length) return;
  keys[key] = true;
}
void keyReleased() {
  if (key > keys.length) return;
  keys[key] = false;
}
