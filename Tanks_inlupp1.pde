
Tank[] team1 = new Tank[3];
Obstacle[]  obstacles = new Obstacle[3];
ArrayList<Cannonball> myShots;
int wait = 3000; //wait 3 sec (reload)
int savedTime;

void setup(){
  size(800,800);
  
  obstacles[0] = new Obstacle(230, 600);
  obstacles[1] = new Obstacle(280, 220);
  obstacles[2] = new Obstacle(530, 520);
  
  myShots = new ArrayList<Cannonball>();
  for(int i = 0; i < 3; i++){
    myShots.add(new Cannonball());
  }
  
  team1[0] = new Tank(0, 40, 50, 50, myShots.get(0));
  team1[1] = new Tank(1, 40, 150, 50, myShots.get(1));
  team1[2] = new Tank(2, 40, 250, 50, myShots.get(2));
  
  loadShots();
  savedTime = millis(); //store the current time.
}

void draw(){
  background(200);
  displayHomeBaseTeam1();
  displayHomeBaseTeam2();
  
  displayPlayersTeam2(760, height-50);
  displayPlayersTeam2(760, height-150);
  displayPlayersTeam2(760, height-250);
  
  displayObstacle();
  displayTanks();
  displayShots();
  
  walkTank();
  checkCollisionTanks();
  
  updateTankLogic();
  updateShotsLogic();
}

void displayHomeBaseTeam1() {
  strokeWeight(1);
  fill(204, 50, 50, 15);
  rect(0, 0, 150, 350);
}

void displayHomeBaseTeam2() {
  strokeWeight(1);
  fill(0, 150, 200, 15);
  rect(width - 151, height - 351, 150, 350);
}

void displayObstacle(){
  for(int i = 0; i < obstacles.length; i++){
    obstacles[i].display();
  }
}

void displayTanks(){
  for(int i = 0; i < team1.length; i++){
    team1[i].display();
  }
}

void displayShots(){
  for (int i = 0; i < myShots.size(); i++) {
    myShots.get(i).display();
  }
}

void displayPlayersTeam2(float x, float y) {
  fill(0, 150, 200, 50);
  ellipse(x,y, 50, 50);
  strokeWeight(2);
  line(x, y, x-25, y);
  strokeWeight(1);
  fill(0, 150, 200, 100);
  ellipse(x, y, 25, 25);
  strokeWeight(2);
  line(x, y, x-25, y);
  strokeWeight(1);
}

void walkTank(){
  team1[0].walk();
}

void updateTankLogic() {
 for (int i = 0; i < team1.length; i++) {
    team1[i].updateShots();
  } 
}

void shoot(int id) {
  println("App.shoot()");
  myShots.get(id).isInMotion = true;
  myShots.get(id).startTimer();
}

void loadShots() {
    team1[0].loadShot();
}

void updateShotsLogic() {
  for (int i = 0; i < myShots.size(); i++) {
    if ((myShots.get(i).passedTime > wait) && (!team1[i].hasShot)) {
      myShots.get(i).resetTimer();
      team1[i].loadShot();
    }
    myShots.get(i).updateShotPosition();
  }
}

void checkCollisionTanks(){
  team1[0].checkEnvironment();
  for(int i = 0; i < obstacles.length; i++){
    team1[0].checkCollision(obstacles[i]);
    for(int j = 0; j < team1.length; j++){
      if(j != team1[0].getId()){
        team1[0].checkCollision(team1[j]);
      }
    }
  }
  
}//End of class
