/**
 * Author: Johannes Foulds
 * Project: Assignment 04-02
 */
 
 void setup() {
   size(500, 300);
   
   // set the grid size, for example size 3 results in a 3x3 grid.
   int gridSize = 5;
   
   // determine the ball size
   float ballWidth = width / gridSize;
   float ballHeight = height / gridSize;
   
   // set the text alignment
   textAlign(CENTER, CENTER);
   
   int currentBall = 1;
   for (int row = 0; row < gridSize; row++) {
     for (int column = 0; column < gridSize - row; column++) {
       // determine the ball color
       if (row % 2 == 0)
         fill(0,0,255);
       else
         fill(255,0,0);
       
       // find the center point for the ball
       float x = (column * ballWidth) + (ballWidth / 2);
       float y = (row * ballHeight) + (ballHeight / 2);
       
       // draw the ball
       ellipse(x, y, ballWidth, ballHeight);
       
       // display the ball number
       fill(0);
       text(currentBall, x, y);
       
       // increment the ball number
       currentBall++;
     }
   }
   
   // save the output
   save("assignment_04_02.png");
 }
