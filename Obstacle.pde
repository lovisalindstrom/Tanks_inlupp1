class Obstacle{
  
  PImage img;
  PVector position;
  PVector velocity = new PVector(0,0);
  float diameter;
  float radius;
  
  Obstacle(int x, int y){
    //this.img = loadImage("tree01_v2.png");
    this.position = new PVector(x,y); 
    //this.diameter = this.img.width/2;
    this.diameter = 150;
    this.radius = diameter/2;
  }
  
  void display() {
    fill(204, 102, 0, 100);
    ellipse(this.position.x, this.position.y, diameter, diameter);
    //image(img, this.position.x, this.position.y);
  }
 
}
