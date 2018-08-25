// Need G4P library
import g4p_controls.*;
import grafica.*;
import processing.serial.*;

GPlot plotUpper, plotLower;
PIDController pid;
Serial serialPort;
String comPort = "COM6";

int input, output, setpoint;

// initialise plot variables
int i = 0; // variable that changes for point calculation
int points = 1000; // number of points to display at a time
int totalPoints = 1000; // number of points on x axis
long previousMillis = 0;
int duration = 20;

public void setup(){
  size(1280, 760, JAVA2D);
  
  serialPort = new Serial(this,comPort,9600); 
  serialPort.clear();
  
  pid = new PIDController(1,0,0,0);
  pid.setOutputLimits(80,255);
  pid.setMode(1);
  
  createGUI();
  customGUI();  
  
  delay(2000);
}

public void draw(){
  background(255,255,255);
  
  rect(10,25,380,340); // decoração da janela
  rect(10,380,380,340);
  
  //draw the plot
  plotUpper.beginDraw();
  plotUpper.drawBackground();
  plotUpper.drawBox();
  plotUpper.drawXAxis();
  plotUpper.drawYAxis();
  plotUpper.drawTitle();
  plotUpper.getMainLayer().drawLines();
  plotUpper.getLayer("setpointLayer").drawLines();
  plotUpper.drawGridLines(GPlot.VERTICAL);
  plotUpper.drawGridLines(GPlot.HORIZONTAL);
  plotUpper.endDraw();
  
    //draw the plot2
  plotLower.beginDraw();
  plotLower.drawBackground();
  plotLower.drawBox();
  plotLower.drawXAxis();
  plotLower.drawYAxis();
  plotLower.drawTitle();
  plotLower.getMainLayer().drawLines();
  plotLower.drawFilledContours(GPlot.HORIZONTAL, 0);
  plotLower.drawGridLines(GPlot.VERTICAL);
  plotLower.drawGridLines(GPlot.HORIZONTAL);
  plotUpper.endDraw();
  
  // check if i has exceeded the plot size
  if (i > totalPoints){
    
    i=0; // reset to zero if it has
    
    plotUpper.setPoints(new GPointsArray(points));
    plotUpper.getLayer("setpointLayer").setPoints(new GPointsArray(points));
    
    plotLower.setPoints(new GPointsArray(points));
    
    println(millis());
 
  } 
  
  pid.compute();
  output = (int)pid.getOutput();

  // get new value from serial port
  if ( millis() > previousMillis + duration) { // If data is available,
    // get new valeu
    // Add the point at the end of the array
    i++;
    
    plotUpper.addPoint(i,input);
    plotUpper.getLayer("setpointLayer").addPoint(i,setpoint);
   
    plotLower.addPoint(i, output);
    
    spLabel.setText(setpointSlider.getValueS());
    inputLabel.setText(str(input)); // str() converte em String
    outputLabel.setText(str(output));
    errorLabel.setText(str(setpoint-input));
    
    previousMillis = previousMillis + duration;
  }
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){
  
  kpTextfield.setText(str(pid.getKp()));
  kiTextfield.setText(str(pid.getKi()));
  kdTextfield.setText(str(pid.getKd()));
  
    // Place your setup code here
  GPointsArray pointsArray = new GPointsArray(points);
  GPointsArray points2 = new GPointsArray(points);
  
  GPointsArray pointsOutput = new GPointsArray(points);
  
  // Cria o gráfico superior
  plotUpper = new GPlot(this);
  plotUpper.setPos(420, 0); // set the position of to left corner of plot
  plotUpper.setDim(750, 300); // set plot size
  
  plotUpper.getXAxis().setNTicks(20);
  
  // Set the plot limits (this will fix them)
  plotUpper.setXLim(0, totalPoints); // set x limits
  plotUpper.setYLim(0, 100); // set y limits
  
  // Set the plot title and the axis labels
  plotUpper.setTitleText("Distância vs. Tempo"); // set plot title
  //plotUpper.getYAxis().setAxisLabelText("Distancia (mm)"); // set y axis label
  
  // Add the set of points to the plot 
  plotUpper.setPoints(pointsArray);
  plotUpper.addLayer("setpointLayer",points2);
  
  // configura a layer padrao
  plotUpper.setLineWidth(2);
  
  // configura a layer setpoint
  plotUpper.setBoxBgColor(255); // 0 - preto, 255  - branco
  plotUpper.getLayer("setpointLayer").setLineColor(color(255, 0, 0)); 
  plotUpper.getLayer("setpointLayer").setLineWidth(2);

// Cria o gráfico inferior
  plotLower = new GPlot(this);
  plotLower.setPos(420, 350); // set the position of to left corner of plot
  plotLower.setDim(750, 300); // set plot size

  plotLower.getXAxis().setNTicks(20);
  
  // Set the plot limits (this will fix them)
  plotLower.setXLim(0, totalPoints); // set x limits
  plotLower.setYLim(0, 255); // set y limits
  
  plotLower.getXAxis().setAxisLabelText("Amostras (1 s/div)"); // set x axis label
  
  // Add the set of points to the plot 
  plotLower.setPoints(pointsOutput);
  
  // troca a cor da layer
  plotLower.setBoxBgColor(255); // 0 - preto, 255  - branco
  plotLower.setLineColor(color(100,188,57));
 
}

void serialEvent(Serial serialPort) {
  input = serialPort.read();
  serialPort.write(output);
}

void keyPressed() {
  switch(key) {
    case 'a':
      setpoint = setpointSlider.getValueI() + 20;
      break;
    case 'b':
      println("B pressionado");
      setpoint = setpointSlider.getValueI() - 20;
      break;
    case 'z':
      println("z pressionado");
      setpoint = setpointSlider.getValueI();
  }
      
}

void exit() {
  serialPort.stop();
  super.exit();
}
