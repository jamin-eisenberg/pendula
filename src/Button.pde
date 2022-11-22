public class Button extends Component {
  private PVector size;
  private String text;
  private Mode modeToLaunch;

  public Button(PVector pos, PVector size, String text, Mode modeToLaunch) {
    this.pos = pos.copy();
    this.size = size.copy();
    this.text = text;
    this.modeToLaunch = modeToLaunch;
  }

  public void handleClick() {
    if (mouseX > pos.x - size.x / 2 && mouseX < pos.x + size.x / 2 && mouseY > pos.y - size.y / 2 && mouseY < pos.y + size.y / 2)
      screen = new ComponentScreen(modeToLaunch);
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
    
    textSize(80);
    textAlign(CENTER, CENTER);
    text(text, pos.x, pos.y - size.y * 1/20);

    noFill();

    rect(pos.x - size.x / 2, pos.y - size.y / 2, size.x, size.y);
  }
}
