// level contains a goal jsonobject, with attributes position and radius, and a circles jsonarray, each with attributes pos and radius

JSONObject goal;
JSONArray radii;
JSONObject level;

int levelNum = 1;

int step = 0; // set goal pos, set goal radius, set line radius xInf

PVector lastLinePos;
//PVector goalPos;

void setup() {
  size(800, 800);

  goal = new JSONObject();
  radii = new JSONArray();
  level = new JSONObject();

  while (new File(dataPath("level" + levelNum + ".json")).exists()) {
    levelNum++;
  }

  fill(255, 0, 0);
  background(0);
  stroke(255);

  printStep();
}

void draw() {
  if (step == 2) {
    //PVector goalPos = new PVector(goal.getInt("x position"), goal.getInt("y position"));
    PVector goalPos = lastLinePos.copy();
    circle(goalPos.x, goalPos.y, goal.getInt("radius") * 2);
  }
}

void mousePressed() {
  PVector mousePos = new PVector(mouseX, mouseY);

  switch(step) {
  case 0:
    goal.setInt("dist from center", (int) dist(width / 2, height / 2, mouseX, mouseY));
    lastLinePos = mousePos.copy();
    break;
  case 1:
    goal.setInt("radius", ceil(mousePos.dist(lastLinePos)));
    break;
  default:
    line(mousePos.x, mousePos.y, lastLinePos.x, lastLinePos.y);
    radii.setInt(step - 2, int(mousePos.copy().sub(lastLinePos).mag()));
    lastLinePos = mousePos.copy();
    break;
  }

  step++;

  printStep();
}

void keyPressed() {
  if (keyCode == ENTER || keyCode == RETURN) end();
  else if (key == 'c') {
    background(0);
    step = 0;
    println("erased");
  }

  printStep();
}

void printStep() {
  switch(step) {
  case 0: 
    println("setting goal pos");
    break;
  case 1:
    println("setting goal radius");
    break;
  default:
    println("setting line " + (step - 1) + " radius");
    break;
  }
}

void end() {
  PVector centerPos = new PVector(width / 2, height / 2);
  radii.setInt(step - 2, int(centerPos.copy().sub(lastLinePos).mag()));
  line(centerPos.x, centerPos.y, lastLinePos.x, lastLinePos.y);

  level.setJSONObject("goal", goal);
  level.setJSONArray("radii", radii);
  String filepath = "data/level" + levelNum + ".json";
  saveJSONObject(level, filepath);
  println("Saved " + filepath);
}
