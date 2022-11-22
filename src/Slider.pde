public class Slider extends Component {
  private int value;
  private PVector range;
  private PVector pos;
  private float length;
  private String name;
  private boolean isSelected;

  public Slider(int value, PVector range, PVector pos, float length, String name) {
    this.value = value;
    this.range = range.copy();
    this.pos = pos.copy();
    this.length = length;
    this.name = name;
  }

  public int getValue() {
    return value;
  }

  public void handleClick() {
    int x = mouseX;
    int y = mouseY;

    if (x >= pos.x && x <= pos.x + length &&
      y >= pos.y - 20 && y <= pos.y + 20) {
      isSelected = true;
    }
  }

  public void update() {
    if (!mousePressed) isSelected = false;

    if (!isSelected) return;

    float consMouseX = constrain(mouseX, pos.x, pos.x + length);

    value = int(map(consMouseX, pos.x, pos.x + length, range.x, range.y));
  }

  public void display() {
    strokeWeight(3);

    if (darkMode) {
      stroke(255);
      fill(255);
    } else { 
      stroke(0);
      fill(0);
    }

    line(pos.x, pos.y, pos.x + length, pos.y);
    textAlign(LEFT, CENTER);
    text(name + ": " + value, pos.x + length + 25, pos.y - 5);

    float sliderPos = map(value, range.x, range.y, pos.x, pos.x + length);

    pushMatrix();

    translate(sliderPos, pos.y);
    scale(1.5);

    noStroke();
    if (isSelected) fill(0, 0, 150);
    else            fill(0, 0, 255);
    rect(-10, -15, 20, 30);

    stroke(0);
    strokeWeight(1);
    line(-5, 10, 5, 10);
    line(-5, 0, 5, 0);
    line(-5, -10, 5, -10);

    popMatrix();
  }
}
