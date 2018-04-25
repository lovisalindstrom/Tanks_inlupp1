
class Tank{  
  PVector position;
  PVector position_temp;
  PVector velocity;
  PVector acceleration;
  Turret turret;
  Cannonball ball;
  float diameter;
  float radius;
  float heading;
  float wandertheta;
  float maxforce;
  int id;
  int health;
  int maxspeed;
  float rotation_speed;
  boolean hasShot;
  
  public Tank(int id, float x, float y, float diameter, Cannonball ball){
    this.id = id;
    turret = new Turret(diameter/2);
    this.ball = ball;
    position = new PVector(x,y);
    position_temp = new PVector();
    velocity = new PVector();
    acceleration = new PVector(1,0);
    this.diameter = diameter;
    this.radius = diameter/2;
    this.heading = radians(0);
    this.maxspeed = 5;
    this.health = 3;
    this.wandertheta = 0;
    this.maxforce = 0.05;
    this.rotation_speed = radians(2);
    this.hasShot = false;
  }
  
  int getId(){
    return id;
  }
  
  void updatePosition(){
    this.position_temp.set(this.position); // save latest location
    acceleration = PVector.random2D();  // walk in random directions
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    this.acceleration.mult(0);
  }
  
  //FROM NATURE OF CODE Exercise_6_04_Wander 
  //void wander() {
  //  float wanderR = 10;         // Radius for our "wander circle"
  //  float wanderD = 50;         // Distance for our "wander circle"
  //  float change = 0.3;
  //  wandertheta += random(-change,change);     // Randomly change wander theta

  //  // Now we have to calculate the new position to steer towards on the wander circle
  //  PVector circlepos = velocity.get();    // Start with velocity
  //  circlepos.normalize();            // Normalize to get heading
  //  circlepos.mult(wanderD);          // Multiply by distance
  //  circlepos.add(position);               // Make it relative to boid's position

  //  float h = velocity.heading2D();        // We need to know the heading to offset wandertheta

  //  PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h),wanderR*sin(wandertheta+h));
  //  PVector target = PVector.add(circlepos,circleOffSet);
  //  seek(target);
  //}


  //FROM NATURE OF CODE Exercise_6_04_Wander 
  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  //void seek(PVector target) {
  //  PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target

  //  // Normalize desired and scale to maximum speed
  //  desired.normalize();
  //  desired.mult(maxspeed);
  //  // Steering = Desired minus Velocity
  //  PVector steer = PVector.sub(desired,velocity);
  //  steer.limit(maxforce);  // Limit to maximum steering force
  //  applyForce(steer);
  //}
  
  void checkEnvironment() {
    if ((this.position.y+radius > height) || (this.position.y-radius < 0) ||
      (this.position.x+radius > width) || (this.position.x-radius < 0)) {
        this.position.set(this.position_temp); // Move back to latest position.
    }
  }
  
  void checkCollision(Obstacle other) {
    // Get distances between obstacle and tank
    PVector distanceVect = PVector.sub(other.position, this.position);
    // Calculate magnitude of the vector separating obstacle and tank
    float distanceVectMag = distanceVect.mag();
    // Minimum distance before they are touching
    float minDistance = this.radius + other.radius;
    if (distanceVectMag < minDistance) {
      println("Tank collision Obstacle");
      this.position.set(this.position_temp); // Move back to latest position.
      if (this.hasShot) {
        this.ball.updateLoadedPosition(this.position_temp);
      }
    }
  }
  
  void checkCollision(Tank other) {
    // Get distances between the balls components
    PVector distanceVect = PVector.sub(other.position, this.position);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = this.radius + other.radius;
    if(distanceVectMag < minDistance) {
      println("Tank collision Tank");
      this.position.set(this.position_temp); // Move back to latest position.
      if (this.hasShot) {
        this.ball.updateLoadedPosition(this.position_temp);
      }
    }
  }
  
  void drawTank(float x, float y){
    fill((((255/6) * this.health) * 40), 50, 50, 255 - this.health*60);
    ellipse(x,y, 50, 50);
    strokeWeight(2);
    line(x, y, x+25, y);
  }
  
  void takeDamage() {
    this.health -= 1;
    if (this.health < 0) {
      this.health = 0;    
    }
  }
  
  // After calling this method, the tank can shoot.
  void loadShot() {
    println("*** Tank.loadShot()");
    println(this.position);
    this.hasShot = true;
    this.ball.loaded();
  }
  
  void fire() {
    println("*** Tank.fire()");
    if (this.hasShot) {
      println("PANG.");
      this.hasShot = false;
      PVector force = PVector.fromAngle(this.heading + this.turret.heading);
      force.mult(10);
      this.ball.applyForce(force);
      shoot(this.id); // global function in main file
    }
    else {
      println("You have no shot loaded and ready.");
    }
  }
  
  void updateShots(){
    if (this.hasShot) {
      this.ball.updateLoadedPosition(this.position);
    }
  }
  
 // Newton's law: F = M * A
  void applyForce(PVector force) {
    PVector f = force.get();
    //f.div(mass); // ignoring mass right now
    this.acceleration.add(f);
  }
  
  void turnTurretLeft() {
    this.turret.turnLeft();
  }
  
  void turnTurretRight() {
    this.turret.turnRight();
  }
  
  void turnLeft() {
    this.heading -= rotation_speed;
  }
  
  void turnRight() {
    this.heading += rotation_speed;
  }
  
  void display(){
    imageMode(CENTER);
    pushMatrix();
    translate(this.position.x, this.position.y);
    rotate(this.heading);
    drawTank(0,0);
    this.turret.display();
    popMatrix();
  }
 
}
