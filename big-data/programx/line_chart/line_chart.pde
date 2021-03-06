size(760, 400);
fill(0);
background(255);

float[] temps = {35.0, 26.6, 29.3, 31.8, 30.2, 29.7, 30.9, 31.1, 34.8, 37.6, 37.9, 39.8, 35.1, 23.7, 25.7, 30.1, 36.6, 38.5, 35.9, 34.3, 36.7, 29.9, 25.9, 28.5, 30.0, 33.3, 33.1, 25.9, 19.5, 24.2, 25.3, 33.1, 24.8, 22.9, 24.1, 29.5, 33.1, 31.3, 29.5, 34.8, 34.7, 32.2, 33.9, 29.3, 24.8, 24.3, 24.4, 26.0, 27.5, 24.5, 25.9, 37.0, 39.5, 37.0, 27.7, 26.2, 24.9, 25.4, 29.7, 31.4, 33.3, 34.8, 33.6, 33.2, 38.7, 38.0, 30.7, 37.1, 30.3, 29.0, 31.4, 30.8, 32.2, 26.7, 30.2, 33.3, 35.4, 21.0, 21.7, 23.6, 24.5, 30.3, 25.3, 27.7, 23.4, 21.4, 21.7, 22.7, 21.7, 20.3, 23.9, 28.7, 23.8, 23.3, 27.6, 28.2, 20.1, 19.9, 20.5, 22.4, 22.6, 22.6, 24.0, 24.1, 27.0, 29.1, 21.4, 21.6, 25.6, 30.1, 29.7, 23.5, 20.2, 20.3, 25.3, 28.1, 30.1, 27.6, 26.9, 24.2, 26.3, 18.3, 19.8, 19.6, 18.5, 24.5, 25.0, 24.3, 19.7, 18.1, 18.3, 19.0, 18.7, 21.4, 23.1, 21.0, 22.4, 19.8, 20.1, 18.5, 18.9, 24.3, 23.2, 19.0, 21.0, 14.5, 17.0, 16.3, 17.0, 16.3, 17.8, 18.2, 20.0, 19.0, 17.9, 16.7, 15.8, 15.9, 17.0, 18.0, 15.7, 16.2, 16.1, 15.4, 14.7, 20.8, 20.3, 16.0, 17.1, 15.4, 15.1, 15.0, 16.2, 16.5, 12.6, 12.8, 13.6, 14.3, 15.4, 16.2, 13.2, 14.4, 14.2, 15.7, 15.8, 11.5, 14.0, 14.5, 14.7, 14.4, 14.4, 15.9, 15.8, 11.0, 13.8, 13.7, 14.3, 16.1, 16.9, 19.9, 20.2, 18.5, 22.7, 15.7, 13.9, 13.1, 12.7, 11.8, 14.1, 14.2, 16.1, 17.4, 16.8, 13.9, 14.9, 15.2, 12.6, 14.7, 17.2, 19.5, 22.0, 18.7, 15.0, 16.0, 18.0, 15.8, 17.0, 20.8, 22.6, 21.8, 24.7, 14.3, 15.6, 17.2, 17.6, 16.7, 16.6, 15.5, 14.2, 18.4, 21.8, 22.4, 19.9, 16.8, 19.4, 18.8, 15.7, 17.1, 20.1, 22.6, 25.0, 20.1, 16.7, 15.6, 19.0, 12.9, 13.7, 11.9, 15.4, 19.0, 20.9, 13.8, 16.4, 18.4, 14.0, 15.5, 20.8, 16.6, 17.0, 17.6, 18.3, 19.9, 15.8, 15.6, 21.8, 20.7, 15.0, 16.4, 20.6, 28.8, 24.0, 26.1, 26.4, 16.5, 16.8, 17.2, 19.6, 25.5, 28.3, 15.4, 16.2, 15.4, 20.0, 30.8, 16.5, 15.8, 17.6, 23.1, 27.8, 19.0, 20.8, 22.1, 30.0, 18.2, 18.4, 18.8, 19.5, 25.3, 28.2, 19.3, 25.1, 26.2, 19.3, 23.1, 25.1, 32.0, 20.2, 17.1, 18.5, 19.5, 29.4, 35.2, 25.9, 29.3, 36.1, 32.0, 17.8, 21.2, 21.0, 23.2, 24.8, 27.9, 29.5, 27.3, 23.4, 24.1, 24.9, 32.2, 29.0, 22.7, 23.6, 31.3, 20.7, 21.5, 26.0, 31.2, 36.9, 35.6, 24.4, 23.3, 27.6, 21.7, 27.4, 37.1, 22.8, 26.9, 32.9, 38.3, 36.2, 41.3, 28.4, 29.9, 30.1, 30.8, 24.3, 25.3};

String[] months = {"JAN", "FEB", "MAR", "APR",  "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"};

int hscale = width/380;
int vscale = height/50;

//Draw axes and title
strokeWeight(3);
stroke(0);
line(20, vscale, 20, height-20);
line(20, height-20, width-hscale, height-20);
text("Daily Max Temperature Adelaide 2016 (\u00B0C)", width/3, 20);

//Horizontal labels (months)
for(int i = 0; i < months.length; i++){
    text(months[i], i*30*hscale + 15*hscale + 20, height-5);
}

//Vertical labels (temperature 0-45)
for(int i = 0; i < 50; i = i+5){
    text(i, 2, height - 20 - (i*vscale));
}

//Draw temperature data
stroke(255, 0, 0);
strokeWeight(1);
noFill();
beginShape();
for(int i = 0; i < temps.length; i++){
    vertex(((i+1)*hscale)+20, height - 20 - (vscale*temps[i]));
}
endShape();
