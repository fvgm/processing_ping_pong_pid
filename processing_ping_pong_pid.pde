// carrega as bibliotecas
import g4p_controls.*;
import grafica.*;
import processing.serial.*;

GPlot plotUpper, plotLower;
PIDController pid;
Serial serialPort;
String comPort = "COM6";   // porta serial do Arduino

int pv, pwm, setpoint;
int outputMinimum = 80;    // banda morta do motor. Valor mínimo para bola subir

// inicialização das variáveis de plotagem
int i = 0;              // contador
int points = 1000;      // numero de pontos a exibir
int totalPoints = 1000; // numero de pontos no eixo x
long previousMillis = 0;
int duration = 20;
boolean isPaused = false;  // flag para implementação do PAUSE

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
  
  //desenha o gráfico superior
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
  
    //desenha o gráfico inferior
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
  
  // verifica se a área de plotagem já está cheia
  if (i > totalPoints){
    
    i=0; // reseta para zero se estiver cheia
    
    plotUpper.setPoints(new GPointsArray(points));
    plotUpper.getLayer("setpointLayer").setPoints(new GPointsArray(points));
    
    plotLower.setPoints(new GPointsArray(points));
    
    println(millis());
 
  } 
  
  if (isAutomaticMode == true) {  // verifica se está no modo automático
    pid.compute();
    pwm = (int)pid.getCO();
  } else {
    pwm = manual_slider.getValueI();   // se estiver no manual, recebe o valor do slider
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
  
    // inicializar o array dos pontos dos gráficos
  GPointsArray pvArray = new GPointsArray(points);
  GPointsArray spArray = new GPointsArray(points);
  
  GPointsArray coArray = new GPointsArray(points);
  
  // Cria o gráfico superior
  plotUpper = new GPlot(this);
  plotUpper.setPos(420, 0); // posição do ponto superior esquerdo do gráfico
  plotUpper.setDim(750, 300); // tamanho do gráfico
  plotUpper.getXAxis().setNTicks(20);  // divisões da grade
  
  // colo os limites no gráfico
  plotUpper.setXLim(0, totalPoints); // limite em X
  plotUpper.setYLim(0, 100); // limite em Y
  
  // Coloca o título no gráfico e os rótulos nos eixos
  plotUpper.setTitleText("Distância vs. Tempo"); // set plot title
  //plotUpper.getYAxis().setAxisLabelText("Distancia (mm)"); // set y axis label
  
  // Adiciona os pontos vazios no gráfico
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
  plotLower.setPos(420, 350); 
  plotLower.setDim(750, 300); 

  plotLower.getXAxis().setNTicks(20);
  
   plotLower.setXLim(0, totalPoints); 
  plotLower.setYLim(0, 255); 
  
  plotLower.getXAxis().setAxisLabelText("Amostras (1 s/div)"); 
  
  plotLower.setPoints(coArray);
  
  // troca a cor da layer
  plotLower.setBoxBgColor(255); // 0 - preto, 255  - branco
  plotLower.setLineColor(color(100,188,57));
 
}

void serialEvent(Serial serialPort) {   // evento executado ao receber dado serial
  pv = serialPort.read();
  serialPort.write(pwm);
}

void keyPressed() {     // captura os eventos to teclado
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

void exit() {   // essa função é chamada ao fechar o programa; garante o desligamento do motor
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
