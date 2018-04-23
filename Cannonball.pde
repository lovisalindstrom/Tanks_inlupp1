// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Cannonball { 
  // Explosion
  ArrayList<Particle> particles;
  PVector position_temp; //spara temp senaste pos.
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector hitArea;
  float diameter, radius;
  boolean isLoaded;  // The shot is loaded and ready to shoot (visible on screen.)
  boolean isInMotion; // The shot is on its way.
  boolean isExploding;
  float topspeed = 10;
  int savedTime;
  int passedTime;
  boolean isCounting;

  Cannonball() {
    this.position = new PVector();
    this.position_temp = new PVector();
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.isInMotion = false;
    this.isCounting = false;
    this.radius = 8;
    this.isExploding = false;
  }

  // Called by tank object.
  void updateLoadedPosition(PVector pvec) {
    //println("*** CannonBall.updateLoadedPosition()");
    this.position.set(pvec);
    this.position_temp.set(this.position);
  }

  // Called by tank object.
  void loaded() {
    println("*** CannonBall.loaded()");
    this.isLoaded = true;
  }

  // Called by tank object, when shooting.
  void applyForce(PVector force) {
    println("CannonBall force: " + force);
    this.acceleration.add(force);
  }
  
  void startTimer() {
    println("*** CannonBall.startTimer()");
    this.isCounting = true;
    this.savedTime = millis();
    this.passedTime = 0;
    
  }
  
  void resetTimer() {
    println("*** CannonBall.resetTimer()");
    this.isCounting = false;
    this.savedTime = 0;
    this.passedTime = 0;
    this.isInMotion = false;
    this.isLoaded = false;
    this.velocity.set(0,0,0);
    this.acceleration.set(0,0,0);
  }
  
  void displayExplosion() {
    this.isExploding = true;
    this.isInMotion = false;
    this.particles = new ArrayList<Particle>();
    this.particles.add(new Particle(new PVector(0,0)));
    this.particles.add(new Particle(new PVector(0,0)));
    this.particles.add(new Particle(new PVector(0,0)));
  }
  
    // Standard Euler integration
  void updateShotPosition() { 
    if (this.isInMotion) {
      println("CannonBall: " + this.position);
      this.position_temp.set(this.position); // spara senaste pos.
      this.velocity.add(this.acceleration);
      this.velocity.limit(this.topspeed);
      this.position.add(this.velocity);
      this.acceleration.mult(0);
    }
    if (isCounting) {
      this.passedTime = millis() - this.savedTime;
    }
  }
  
  void checkCollision() {
    if (this.isInMotion) {

    }
  }
  
  void checkCollision(Obstacle other) {
     if (this.isInMotion) {
        //println("*** Tank.checkCollision(Hinder)");
    
        // Get distances between the balls components
        PVector distanceVect = PVector.sub(other.position, this.position);
    
        // Calculate magnitude of the vector separating the balls
        float distanceVectMag = distanceVect.mag();
    
        // Minimum distance before they are touching
        float minDistance = this.radius + other.radius;
    
        if (distanceVectMag <= minDistance) {
          println("collision Hinder");
          this.position.set(this.position_temp); // Move back to latest position.
          displayExplosion();
          
        }
      }
    }
  
  
  void checkCollision(Tank other) {
    if (this.isInMotion) {
      println("*** CannonBall.checkCollision(Tank): " + other);
  
      // Get distances between the balls components
      PVector distanceVect = PVector.sub(other.position, this.position);
  
      // Calculate magnitude of the vector separating the balls
      float distanceVectMag = distanceVect.mag();
  
      // Minimum distance before they are touching
      float minDistance = this.radius + other.radius;
  
      if (distanceVectMag < minDistance) {
        println("CannonBall collision Tank");
        this.position.set(this.position_temp); // Move back to latest position.
        other.takeDamage();
        displayExplosion();
        
      }
    }
  }

  void display() { 
    //if (this.isLoaded) {
      imageMode(CENTER);
      stroke(0);
      strokeWeight(2);
      pushMatrix();
      translate(this.position.x,this.position.y);
      
      if (this.isExploding) {
        for(int i=0; i < this.particles.size(); i++){
          //for (Particle p : explosion){
          this.particles.get(i).run();
          if (this.particles.get(i).isDead()) {
            //p = new Particle(new PVector(width/2,20));
            //println("Particle dead!"); 
            this.isExploding = false;
          }
        }
      }
      else {
        if (!(this.isCounting && !this.isInMotion)) {
          ellipse(0, 0, this.radius*2, this.radius*2);
        }
      }
      popMatrix();
  }
}
