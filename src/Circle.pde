public class CircleSeries {
  private float R_VEL = 3;
  private PVector pos;
  private PVector dir;
  private boolean stopped;
  private float madeActiveTheta;
  private int revolutions;
  private CircleSeries child;

  public CircleSeries(Stack<CircleSeries> children) {
    CircleSeries me = children.pop();
    pos = me.pos;
    dir = me.dir;
    stopped = false;
    madeActiveTheta = 3 * PI;
    revolutions = 0;

    if (children.isEmpty()) {
      child = null;
    } else {
      child = new CircleSeries(children);
    }
  }

  public CircleSeries(PVector pos, float radius) {
    this.pos = pos;
    this.dir = new PVector(0, -radius);
  }

  public PVector getEndPoint() {
    if (child == null) {
      return pos.copy().add(dir);
    } else {
      return child.getEndPoint();
    }
  }

  public CircleSeries getFurthest() {
    if (child == null) { 
      return this;
    } else {
      return child.getFurthest();
    }
  }

  public boolean isStopped() {
    return stopped;
  }

  public PVector getPos() {
    return pos.copy();
  }

  public CircleSeries getActive() {
    return getActive(true);
  }

  private CircleSeries getActive(boolean parentStopped) {
    if (parentStopped && !stopped) {
      return this;
    } else {
      if (child == null) return child;
      return child.getActive(stopped);
    }
  }

  public float getUnfrozenLength() {
    if (child == null) {
      return dir.mag();
    } else if (stopped) {
      return child.getUnfrozenLength();
    } else {
      return dir.mag() + child.getUnfrozenLength();
    }
  }

  public int getTotalRevolutions() {
    if (child == null) {
      return revolutions;
    } else {
      return revolutions + child.getTotalRevolutions();
    }
  }

  public void freezeNext() {
    if (stopped) { 
      child.freezeNext();
    } else {
      stopped = true;
      if (child != null)
        makeActiveTheta();
    }
  }

  public void makeActiveTheta() {
    if (child != null)
      child.madeActiveTheta = child.dir.heading();
  }

  public void step() {
    if (!stopped && dir.heading() < madeActiveTheta && dir.heading() + (R_VEL / frameRate) >= madeActiveTheta) { 
      madeActiveTheta = dir.heading();
      revolutions++;
    }

    if (!stopped) {
      dir.rotate(R_VEL / frameRate);
    }

    if (child != null) {
      child.pos = pos.copy().add(dir);   
      child.step();
    }
  }

  public void dispCircles() {
    if (dispCircles) {
      noFill();
      stroke(0, 0, 180);
      circle(pos.x, pos.y, dir.mag() * 2);
      if (madeActiveTheta <= TWO_PI) {
        PVector activeThetaPoint = PVector.fromAngle(madeActiveTheta).mult(dir.mag()).add(pos);
        line(pos.x, pos.y, activeThetaPoint.x, activeThetaPoint.y);
      }
    }

    if (child != null) {
      child.dispCircles();
    }
  }

  public void display() {
    display(true);
  }

  private void display(boolean parentStopped) {
    color col;
    PVector endPos = pos.copy().add(dir);

    if (darkMode) col = color(255);
    else col = color(0);

    if (stopped) col = color(130);
    else if (parentStopped && !stopped) col = color(0, 255, 0);

    fill(col);
    stroke(col);

    circle(pos.x, pos.y, dir.mag() / 10);
    line(pos.x, pos.y, endPos.x, endPos.y);
    
    if (child != null) {
      child.display(stopped);
    }
    else{
      circle(endPos.x, endPos.y, 2); 
    }
  }
}
