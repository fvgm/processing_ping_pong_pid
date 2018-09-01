// Need G4P library
import g4p_controls.*;
import grafica.*;
import processing.serial.*;

GPlot plotUpper, plotLower;
PIDController pid;
Serial serialPort;
String comPort = "COM7";

int pv, pwm, setpoint;
int outputMinimum = 80;

// initialise plot variables
int i = 0; // variable that changes for point calculation
int points = 1000; // number of points to display at a time
int totalPoints = 1000; // number of points on x axis
long previousMillis = 0;
int duration = 20;
boolean isPaused = false;

boolean isAutomaticMode = true;

public void setup(){
  size(1270, 760, JAVA2D);
  
  
  serialPort = new Serial(this,comPort,9600); 
  serialPort.clear();
  
  pid = new PIDController(1,0,0,0);
  pid.setOutputLimits(outputMinimum,255);
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
  
  if (isAutomaticMode == true) {
    pid.compute();
    pwm = (int)pid.getCO();
  } else {
    pwm = manual_slider.getValueI();
  }

  if ( (millis() > previousMillis + duration) && !isPaused) {  // adiciona novos pontos no gráfico, se não estiver pausado
    i++;
    
    plotUpper.addPoint(i,pv);
    plotUpper.getLayer("setpointLayer").addPoint(i,setpoint);
   
    plotLower.addPoint(i, pwm);
    
    spLabel.setText(setpointSlider.getValueS());
    inputLabel.setText(str(pv)); // str() converte em String
    outputLabel.setText(str(pwm));
    errorLabel.setText(str(setpoint-pv));
    
    previousMillis = previousMillis + duration;
  }
}


// customiza a GUI
public void customGUI(){
  
  kpTextfield.setText(str(pid.getKp()));
  kiTextfield.setText(str(pid.getKi()));
  kdTextfield.setText(str(pid.getKd()));
  
  manual_slider.setLimits(255, outputMinimum); // corrige a escala do slider para eliminar a banda morta
  hTextfield.setText("10");
  
    // Place your setup code here
  GPointsArray pvArray = new GPointsArray(points);
  GPointsArray spArray = new GPointsArray(points);
  
  GPointsArray coArray = new GPointsArray(points);
  
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
  plotUpper.setPoints(pvArray);
  plotUpper.addLayer("setpointLayer",spArray);
  
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
  plotLower.setPoints(coArray);
  
  // troca a cor da layer
  plotLower.setBoxBgColor(255); // 0 - preto, 255  - branco
  plotLower.setLineColor(color(100,188,57));
 
}

void serialEvent(Serial serialPort) {
  pv = serialPort.read();
  serialPort.write(pwm);
}

void keyPressed() {
  switch(key) {
    case 'p':
      pause_graph();
    break;
    case 'w':
      manual_slider.setValue( manual_slider.getValueI() + int(hTextfield.getText()));
    break;
    case 'q':
      manual_slider.setValue( manual_slider.getValueI() - int(hTextfield.getText()));
    break;
  }
  
  if(key==CODED) { // para detectar teclas especiais - incrementa e decrementa o PWM manual
    if ( (keyCode == UP) && !isAutomaticMode) {
      manual_slider.setValue( manual_slider.getValueF()+1);
    }
    if ( (keyCode == DOWN) && !isAutomaticMode) {
      manual_slider.setValue( manual_slider.getValueF()-1);
    }
  }
    
      
}

void exit() {
  println("saiu do programa...");
  pwm = 0;
  serialPort.write(0);
  serialPort.stop();
  super.exit();
}

void pause_graph() {
  if (!isPaused) {
    isPaused = true;
  } else {
    isPaused = false;
  }  
}
