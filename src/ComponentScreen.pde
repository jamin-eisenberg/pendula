public class ComponentScreen {
  private Mode mode;
  private Component[] components;

  public ComponentScreen(Mode mode) {
    this.mode = mode;
    homeMusic.stop();
    playMusic.stop();
    switch(mode) {
    case Title:
      components = new Component[]{
        new Button(new PVector(width / 2, height * 5 / 10), new PVector(width, height / 5), "Play", Mode.Levels), 
        new Button(new PVector(width / 2, height * 7 / 10), new PVector(width, height / 5), "Endless", Mode.Endless), 
        new Button(new PVector(width / 2, height * 9 / 10), new PVector(width, height / 5), "Settings", Mode.Settings)
      };
      homeMusic.play();
      homeMusic.loop();
      break;
    case Levels:
      components = new Component[]{
        new Game(level)
      };
      playMusic.play();
      playMusic.stop();
      break;
    case Endless:
      components = new Component[]{
        new Game()
      };
      playMusic.play();
      playMusic.stop();
      break;
    case Settings:
      PVector dims = new PVector(80, 80);
      components = new Component[]{
        new Checkbox(darkMode, new PVector(50, 50), dims, "Dark mode"), 
        new Checkbox(dispCircles, new PVector(50, 150), dims, "Display circles"), 
        new Checkbox(playOutImpossible, new PVector(50, 250), dims, "Play out impossible"), 
        new Slider(musicVol, new PVector(0, 10), new PVector(50, 400), 300, "Music volume"), 
        new Slider(SFXVol, new PVector(0, 10), new PVector(50, 475), 300, "SFX volume")
      };
      homeMusic.play();
      homeMusic.loop();
      break;
    }
  }

  public Mode getMode() {
    return mode;
  }

  public void handleClick() {
    for (Component c : components) {
      c.handleClick();
    }
  }

  public void handleBackpress() {
    if (mode != Mode.Title) {
      screen = new ComponentScreen(Mode.Title);
    } else {
      exit();
    }
  }

  public void step() {
    if (mode == Mode.Levels || mode == Mode.Endless) {
      ((Game) components[0]).step();
    } else if (mode == Mode.Settings) {
      for (Component c : components) {
        if (c instanceof Slider) {
          ((Slider) c).update();
        }
      }

      darkMode = ((Checkbox) components[0]).getState();
      dispCircles = ((Checkbox) components[1]).getState();
      playOutImpossible = ((Checkbox) components[2]).getState();
      musicVol = ((Slider) components[3]).getValue();
      SFXVol = ((Slider) components[4]).getValue();

      saved.setBoolean("dark mode", darkMode);
      saved.setBoolean("disp circles", dispCircles);
      saved.setBoolean("play out impossible", playOutImpossible);
      saved.setInt("music volume", musicVol);
      saved.setInt("SFX volume", SFXVol);
    }

    float newMusicVol = musicVol / 10.0;
    float newSFXVol   = SFXVol / 10.0;

    homeMusic.amp(newMusicVol);
    playMusic.amp(newMusicVol);
    freezeSound.amp(newSFXVol);
    winSound.amp(newSFXVol);
    loseSound.amp(newSFXVol);
  }

  public void display() {
    if (mode == Mode.Title) {
      if (darkMode) fill(255);
      else         fill(0);
      textAlign(CENTER, CENTER);
      textSize(100);
      text("PENDULA", width / 2, 100);
      textSize(30);
      text("Created by Jamin Eisenberg", width / 2, 200);
    }

    for (Component c : components) {
      c.display();
    }
  }
}
