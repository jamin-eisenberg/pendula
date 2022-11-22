public class Checkbox extends Component {
  private boolean state;
  private PVector size;
  private String text;

  public Checkbox(boolean state, PVector pos, PVector size, String text) {
    this.state = state;
    this.pos = pos.copy();
    this.size = size.copy();
    this.text = text;
  }

  public boolean getState() {
    return state;
  }

  public void handleClick() {
    if (mouseX > pos.x && mouseX < pos.x + size.x && mouseY > pos.y && mouseY < pos.y + size.y) {
      state = !state;
    }
  }

  public void display() {
    strokeWeight(5);
    if (darkMode) { 
      stroke(255); 
      fill(255);
    } else { 
      stroke(0);
      fill(0);
    }
    
    textAlign(LEFT, TOP);
    textSize(50);
    text(text, pos.x + size.x + 20, pos.y + size.y * 1/7);

    if (state) fill(0, 0, 255);
    else      noFill();

    rect(pos.x, pos.y, size.x, size.y);
  }
}
