// TODO: redo slider class?, cool buttonmations

import java.util.Stack;
import java.util.Arrays;
import processing.sound.*;

ComponentScreen screen;

// settings:
boolean darkMode;
boolean dispCircles;
boolean playOutImpossible;
int musicVol;
int SFXVol;

// other saved:
int highScore;
int level;

JSONObject saved;

SoundFile homeMusic;
SoundFile playMusic;
SoundFile freezeSound;
SoundFile winSound;
SoundFile loseSound;

void setup() {
  //size(800, 800);
  fullScreen();

  initSaved();

  screen = new ComponentScreen(Mode.Title);
}

void draw() { 
  if(darkMode) background(0);
  else         background(255);
  
  screen.step();
  screen.display();

  if (frameCount % 30 == 0) { 
    saveJSONObject(saved, dataPath("saved.json"));
  }
}

void mousePressed() {
  screen.handleClick();
}

void keyPressed(){
  if(keyCode == LEFT){
    screen.handleBackpress();
  }
  screen.handleClick();
}

void backPressed(){
  screen.handleBackpress();
}

void initSaved() {
  saved = loadJSONObject(dataPath("saved.json"));

  darkMode = saved.getBoolean("dark mode");
  dispCircles = saved.getBoolean("disp circles");
  playOutImpossible = saved.getBoolean("play out impossible");
  musicVol = saved.getInt("music volume");
  SFXVol = saved.getInt("SFX volume");
  highScore = saved.getInt("high score");
  level = saved.getInt("level");


  homeMusic = new SoundFile(this, dataPath("homeMusic.mp3"));
  playMusic = new SoundFile(this, dataPath("playMusic.mp3"));
  freezeSound = new SoundFile(this, dataPath("freezeSound.mp3"));
  winSound = new SoundFile(this, dataPath("winSound.mp3"));
  loseSound = new SoundFile(this, dataPath("loseSound.mp3"));
}
