public class Round {
  private CircleSeries parent;
  private Goal goal;
  private boolean playing;
  private boolean won;
  private boolean over;
  private float scaleFactor;
  private float targetScaleFactor;

  public Round(Goal goal, float[] radii) {
    initRound(goal, radii);
  }

  public Round(int level) {
    JSONObject levelJSON = loadJSONObject("level" + level + ".json");

    JSONObject goalJSON = levelJSON.getJSONObject("goal");
    PVector goalPos = PVector.random2D().setMag(goalJSON.getInt("dist from center")).add(new PVector(width / 2, height / 2));
    int radius = goalJSON.getInt("radius");
    Goal g = new Goal(goalPos, radius);

    JSONArray radiiJSON = levelJSON.getJSONArray("radii");
    int[] radiiInts = radiiJSON.getIntArray();
    float[] radii = new float[radiiInts.length];
    int newLoc = radiiInts.length - 1;
    for (int i = 0; i < radiiInts.length; i++) {
      radii[newLoc] = radiiInts[i];
      newLoc--;
    }

    initRound(g, radii);
  }

  private void initRound(Goal goal, float[] radii) {
    Stack<CircleSeries> parentStack = new Stack<CircleSeries>();

    for (int i = radii.length - 1; i >= 1; i--) {
      parentStack.push(new CircleSeries(null, radii[i]));
    }
    parentStack.push(new CircleSeries(new PVector(width / 2, height / 2), radii[0]));

    parent = new CircleSeries(parentStack);

    parent.step();
    parent.makeActiveTheta();

    this.goal = goal;
    playing = false;
    won = false;
    over = false;
    scaleFactor = 1;
    targetScaleFactor = 1;
  }

  public boolean isOver() {
    return over;
  }

  public boolean hasWon() {
    return won;
  }

  public void handleClick() {
    if (playing) {
      parent.freezeNext();
      targetScaleFactor++;
      freezeSound.play();
    } else {
      playing = true;
    }
  }

  public void step() {
    float error = targetScaleFactor - scaleFactor;
    scaleFactor += error * 0.05;

    if (playing) {
      parent.step();
    }

    if (parent.getFurthest().isStopped()) {
      won = goal.colliding(parent.getEndPoint());
      over = true;
      playing = false;
    }

    if (!playOutImpossible && playing && parent.getActive().getPos().sub(goal.getPos()).mag() > parent.getUnfrozenLength() + goal.getRadius()) {
      won = false;
      over = true;
      playing = false;
    }
  }

  public void display() {
    if (darkMode) background(0);
    else background(255);

    pushMatrix();

    if (!playOutImpossible) {
      translate(goal.getPos().x, goal.getPos().y);
      scale(scaleFactor);
      translate(-goal.getPos().x, -goal.getPos().y);
    } else {
      PVector furthestPos = parent.getActive().getPos();
      translate(furthestPos.x, furthestPos.y);
      scale(scaleFactor);
      translate(-furthestPos.x, -furthestPos.y);
    }

    parent.dispCircles();
    goal.display();
    parent.display();

    popMatrix();
  }
}
