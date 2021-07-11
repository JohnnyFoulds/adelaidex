/**
 * Author: Johannes Foulds
 * Project: Assignment 2
 */
 
 /*
  * setup
  */
 void setup() {
 }
 
 /*
  * draw
  */
 void draw() {
   // get the data
  int[] data = getData(10);
  float mean = calculateMean(data);
 }
 
 /**
  * Get n ramdom numbers.
  */
int[] getData(int n) {
  int[] data = new int[n];
   
  // generate the random numbers
  randomSeed(1);
  for (int i = 0; i < n; i++) {
    data[i] = ceil(random(1, 10));
 }
 
 return data;
}

/*
 * Calculate the mean for the data points.
 */
float calculateMean(int[] data) {
  float total = 0;
  
  for (int i = 0; i < data.length; i++) {
    total += data[i];
  }
  
  return total / n;
}
