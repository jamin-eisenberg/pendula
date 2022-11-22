public class Goal{
  private PVector pos;
  private float radius;
  
  public Goal(PVector pos, float radius){
    this.pos = pos.copy();
    this.radius = radius;
  }
  
  public PVector getPos(){
    return pos.copy();
  }
  
  public float getRadius(){
    return radius;
  }
  
  public boolean colliding(PVector point){
    return dist(point.x, point.y, pos.x, pos.y) <= radius;
  }
  
  public void display(){
    noStroke();
    fill(255, 0, 0);
    circle(pos.x, pos.y, radius * 2);
  }
}
