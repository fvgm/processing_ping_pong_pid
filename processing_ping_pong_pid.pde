// Need G4P library
import g4p_controls.*;
import grafica.*;
import processing.serial.*;


GPlot plot;
Serial serialPort;
String comPort = "COM6";

int rxVal, txVal;

// initialise plot variables
int i = 0; // variable that changes for point calculation
int points = 250; // number of points to display at a time
int totalPoints = 300; // number of points on x axis
long previousMillis = 0;
int duration = 20;

public void setup(){
  size(1280, 760, JAVA2D);
  createGUI();
  customGUI();  
  
  serialPort = new Serial(this,comPort,9600); 

}

public void draw(){
  background(255,255,255);
  
  rect(10,25,380,340);
  
  //draw the plot
  plot.beginDraw();
  plot.drawBackground();
  plot.drawBox();
  plot.drawXAxis();
  plot.drawYAxis();
  plot.drawTopAxis();
  plot.drawRightAxis();
  plot.drawTitle();
  plot.getMainLayer().drawLines();
  plot.getLayer("setpointLayer").drawLines();
  plot.drawGridLines(GPlot.VERTICAL);
  plot.drawGridLines(GPlot.HORIZONTAL);
  plot.endDraw();
  
  // check if i has exceeded the plot size
  if (i > totalPoints){
    
    i=0; // reset to zero if it has
    
    plot.setPoints(new GPointsArray(points));
    plot.getLayer("setpointLayer").setPoints(new GPointsArray(points));
 
  } 
  
  // get new value from serial port
  if ( millis() > previousMillis + duration) { // If data is available,
    // get new valeu
    // Add the point at the end of the array
    i++;
    
    println("Valor recebido: " + i + "-" + rxVal); 
    
    plot.addPoint(i,rxVal);
    plot.getLayer("setpointLayer").addPoint(i,random(30,40));
    
    previousMillis = previousMillis + duration;

  } 
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){
  
  

    // Place your setup code here
    
  GPointsArray pointsArray = new GPointsArray(points);
  GPointsArray points2 = new GPointsArray(points);

  // //calculate initial display points
  //for (i = 0; i < points; i++) {
  //  pointsArray.add(i,0);
  //}
  
  // Create the plot
  plot = new GPlot(this);
  plot.setPos(420, 0); // set the position of to left corner of plot
  plot.setDim(750, 300); // set plot size

  
  plot.getXAxis().setNTicks(10);
  
  // Set the plot limits (this will fix them)
  plot.setXLim(0, totalPoints); // set x limits
  plot.setYLim(0, 100); // set y limits
  
  // Set the plot title and the axis labels
  plot.setTitleText("Distance Sensor Example"); // set plot title
  plot.getXAxis().setAxisLabelText("x axis"); // set x axis label
  plot.getYAxis().setAxisLabelText("Distance"); // set y axis label
  
  // Add the set of points to the plot 
  plot.setPoints(pointsArray);
  plot.addLayer("setpointLayer",points2);
  
  // troca a cor da layer
  plot.getLayer("setpointLayer").setLineColor(color(255, 0, 0)); 
  

  
}

void serialEvent(Serial serialPort) {
  rxVal = serialPort.read();  
}

void keyPressed() {
  if (key == ESC) {
    exit();
  }
}

void exit() {
  serialPort.write(0);
  super.exit();
}
