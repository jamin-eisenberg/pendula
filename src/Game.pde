public class Game extends Component{
  Round round;
  int score;
  color backFill;
  boolean endless;

  public Game() {
    round = createRandRound();
    score = 0;
    backFill = color(255, 255);
    endless = true;
  }

  public Game(int level) {
    round = new Round(level);
    score = 0;
    backFill = color(255, 255);
    endless = false;
  }

  private Round createRandRound() {
    Goal goal = new Goal(PVector.random2D().mult(random(30, 375)).add(new PVector(width / 2, height / 2)), 6.25);
    float[] radii = {200, 100, 50, 25, 12.5};

    return new Round(goal, radii);
  }

  public void handleClick() {
    round.handleClick();
  }

  public void step() {
    round.step();

    if (round.isOver()) {
      freezeSound.stop();
      if (round.hasWon()) {
        level++;
        winSound.play();
        backFill = color(0, 255, 0);
        int prevScore = score;
        score += 10 - round.parent.getTotalRevolutions();
        if (score < prevScore) score = prevScore;
      } else {
        loseSound.play();
        backFill = color(255, 0, 0);
        score = 0;
      }

      if (score > highScore) {
        highScore = score;
        saved.setInt("high score", score);
      }

      if (endless) {
        round = createRandRound();
      } else {
        round = new Round(level);
        saved.setInt("level", level);
      }
      backFill = color(red(backFill), green(backFill), blue(backFill), 255);
    }
  }

  public void display() {
    strokeWeight(1);
    round.display();

    fill(backFill);
    backFill = color(red(backFill), green(backFill), blue(backFill), alpha(backFill) - 3);
    rect(-1, -1, width + 1, height + 1);

    if (darkMode) fill(255);
    else fill(0);
    textSize(35);
    textAlign(LEFT, CENTER);
    if (endless) {
      text("Score: " + score, 30, 50);
      text("High Score: " + highScore, 30, 80);
    } else {
      text("Level " + level, 10, 40);
    }
  }
}
