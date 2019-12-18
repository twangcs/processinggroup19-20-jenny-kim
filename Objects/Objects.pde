/* 
My project is based on the snake game, except that it is a more simple version. The goal of my project
is to simply make the snake move accordingly to the arrow keys and eat the apple. Then a new apple will 
appear in a random point and the game continues. I also have to make sure that each time the snake eats 
the apple, it needs to grow. The main reason why I chose to make this game was because of it's complexity.
Although it might look simple and easy to code, the code went on and one as I broke down the game. 
I was interested in making this game because I wanted to challenge myself. This project also needed me to 
learn a bunch of new stuff, which expanded my knowledge on coding, too. 
*/

// must import these in order to make code work
import java.util.Random;
import java.lang.Math;
import java.awt.Point;

// initializing the vneeded araibles
Apple food;
Snake snake;
int eat;
//PFont f;

void setup() {
  // setting of the rectangle
  size(640, 360);  
  stroke(255);    
  frameRate(5);
  noLoop();

  food = new Apple();
  snake = new Snake(90,0);
  eat = 1;
  //printArray(PFont.list());
  //textAlign(CENTER, CENTER);
}


void draw() { 
  background( 230,230,250);   // Set the background to black
  snake.build();
  Point prev = snake.getCurrentPosition();
    
  food.drawApple();
  if(food.valuesAlign(prev) == true){
    eat++;
    food.changePos();
    snake.addBody(prev);
  }
  snake.move();  
  if(snake.touchingItself() == true) {
    noLoop();
    background(230,230,250);
    /* writing GAME OVER 
    text('G', 300, 180);
    text('A', 324, 180);*/
  }
  
} 

void mousePressed() {
  loop();
}

void keyPressed() {
  snake.setDirection();
}


class Snake {
  int x; //point x
  int y; //point y
  int direction;
  // arraylist that contains the head, body, tail points 
  ArrayList<Point> snake; 
  ArrayList<PImage> head;
  ArrayList<PImage> body;
  ArrayList<PImage> tail;
  
  public Snake(int x, int y) {
    this.x =x;
    this.y=y;
    direction =0;  
    snake = new ArrayList<Point>();
    snake.add(new Point(x,y));
    snake.add(new Point(x-10,y));
    snake.add(new Point(x-20,y));


    // setting the head possibilities
    head = new ArrayList<PImage>();
    head.add(loadImage("head_right.png"));
    head.add(loadImage("head_left.png"));
    head.add(loadImage("head_top.png"));
    head.add(loadImage("head_down.png"));
    // setting the body possibilities
    body = new ArrayList<PImage>();
    body.add(loadImage("body_horizontal.png"));
    body.add(loadImage("body_vertical.png"));
    body.add(loadImage("curve_1.png"));
    body.add(loadImage("curve_2.png"));
    body.add(loadImage("curve_3.png"));
    body.add(loadImage("curve_4.png"));
    // setting the tail
    tail = new ArrayList<PImage>();
    tail.add(loadImage("tail_down.png"));
    tail.add(loadImage("tail_left.png"));
    tail.add(loadImage("tail_right.png"));
    tail.add(loadImage("tail_up.png"));
  }
  
  public void setDirection() {
    if(key == CODED){
      if (keyCode == RIGHT && direction != 1) {
        direction = 0;
      } else if (keyCode == LEFT && direction != 0) {
        direction = 1;
      } else if (keyCode == UP && direction !=3) {
        direction = 2;
      } else if (keyCode == DOWN && direction !=2) {
        direction = 3;
      }
    }
  }
  
  public void build() {    
    if(direction == 0) {
      x = x+10;
    } else if ( direction == 1) {
            x = x-10;
    } else if ( direction == 2) {
      y -= 10;
    } else {
      y+= 10;
    }
    
    if(x < 0) {
      x =0;
    } else if(x>630) {
      x = 630;
    }
    if(y < 0) {
      y = 0;
    } else if(y>350){
      y = 350;
    }
  }
  
  public Point getCurrentPosition() {
    return new Point(x,y);
  }
  
  public void addBody(Point point) {
    snake.add(point);
  }
  
  public void move() {
    // add head; based on direction
    snake.add(0, new Point(x,y));
    // remove tail
    snake.remove(snake.size()-1);
    // draw in loop
    Point headPos = snake.get(0);
    Point tailPos = snake.get(snake.size()-1);
    int tailDirection = 0;
    
    // Draw head
    image(head.get(direction), headPos.x, headPos.y, 10, 10);
    
    for(int i = 1; i < snake.size()-1; i++){
        Point current = snake.get(i);
        Point before = snake.get(i-1);
        Point after = snake.get(i+1);
        int gapY = before.y - after.y;
        int gapX = before.x - after.x;
        
        // Draw vertial body
        if(gapX == 0 && gapY != 0) {
          image(body.get(1), current.x, current.y, 10, 10);
          if(before.y > after.y) {
            tailDirection = 0;
          } else {
            tailDirection = 3;
          }
        // Draw horizontal body
        } else if(gapX != 0 && gapY == 0) {
          image(body.get(0), current.x, current.y, 10, 10);
          if(before.x > after.x) {
            tailDirection = 2;
          } else {
            tailDirection = 1;
          }
        // Draw curve body
        }  else if(gapX > 0 && gapY > 0){
          if(after.x == current.x) {
            image(body.get(3), current.x, current.y, 10, 10);
            tailDirection = 0;
          } else {
             image(body.get(5), current.x, current.y, 10, 10);
             tailDirection = 2; 
          }
        } else if(gapX < 0 && gapY < 0){
          if(after.x == current.x) {
             image(body.get(5), current.x, current.y, 10, 10);
             tailDirection = 3;
          } else {
            image(body.get(3), current.x, current.y, 10, 10);
            tailDirection = 1;
          }
        } else if(gapX > 0 && gapY < 0) {
          if(after.x == current.x) {
            image(body.get(2), current.x, current.y, 10, 10);
            tailDirection = 3;
          } else {
            image(body.get(4), current.x, current.y, 10, 10);
            tailDirection = 2;
          }
        } else if(gapX < 0 && gapY > 0){
          if(after.x == current.x){
            image(body.get(4), current.x, current.y, 10, 10);
            tailDirection = 0;
          } else {
            image(body.get(2), current.x, current.y, 10, 10);
            tailDirection = 1;
          }
        } 
    }
    
    // Draw tail
    image(tail.get(tailDirection), tailPos.x, tailPos.y, 10, 10);
  }
  
  public boolean touchingItself() {
    Point head = snake.get(0);
    for(int i = 1; i < snake.size(); i++) {
      Point bodyPart = snake.get(i);
      if(head.x == bodyPart.x && head.y == bodyPart.y) {
        return true;
      }
    }
    return false;
  }
}
//apple class; places apples at random positions
class Apple {
  int x;
  int y;
  Random rand;
  PImage img;
  
  public Apple() {
    rand = new Random();
    x = rand.nextInt(63)*10;
    y = rand.nextInt(35)*10;
    img = loadImage("apple.png");
  }
  
  public void changePos() {
    x = rand.nextInt(63)*10;
    y = rand.nextInt(35)*10;
  }
  
  public void drawApple() {
    image(img, x, y, 10, 10);
  }
  
  public boolean valuesAlign(Point point) {
    if(point.x == x && point.y == y) {
      return true;
    } else {
      return false;
    }
  }
}
