class PIDController {
  
  float ci, co, error; //controllerInput, controllerOutput
  
  float kp, ki, kd;
  int controllerDirection;
  long lastTime, sampleTime;
  float iTerm, lastInput, outMin, outMax;
  boolean inAuto;

  
  // controllerDirection 1 = REVERSE
  //                     0 = DIRECT
  
  // mode                1 = AUTOMATIC
  //                     0 = MANUAL
  
   
  // CONSTRUCTOR
  PIDController(float kp, float ki, float kd, int direction) {
        
        co = pwm;
        
        setOutputLimits(0, 255);  // padrão
        
        sampleTime = 20; // tempo de amostragem padrão 0.1 sec
        
        setControllerDirection(direction);
        
        setTunings(kp, ki, kd);
        
        lastTime = millis() - sampleTime;
        
  }

boolean compute() {
  
  if (!inAuto) {
    return false;
  }
  
  long now = millis();
  long timeChange = (now - lastTime);
  
  if(timeChange>=sampleTime) {
    error = setpoint - pv;
    iTerm += (ki * error);
    
    if(iTerm > outMax) {
      iTerm= outMax;
    } else if(iTerm < outMin) {
      iTerm= outMin;
    }
    
    float dInput = (pv - lastInput);
    co = kp * error + iTerm - kd * dInput;
    
    if(co > outMax) co = outMax;
      else if(co < outMin) co = outMin;
    
      
      /*Remember some variables for next time*/
      lastInput = pv;
      lastTime = now; 
      
      return true;
    
  } else {
    return false;
  }
  
}



  
  void setOutputLimits(float min, float max) {
    if (min >= max) return;
    outMin = min;
    outMax = max;
    
    if(inAuto) {
      if (co > outMax) {
        co = outMax;
      } else if (co < outMin) {
        co = outMin;
      }
      
      if (iTerm > outMax) {
        iTerm = outMax;
      } else if (iTerm < outMin) {
        iTerm = outMin;
      }
    }
  }
  
  void setControllerDirection(int Direction) {
    if(inAuto && Direction !=controllerDirection) {
      kp = (0 - kp);
      ki = (0 - ki);
      kd = (0 - kd);
    }   
    controllerDirection = Direction;
  }

  void setTunings(float Kp, float Ki, float Kd) {
     if (Kp<0 || Ki<0 || Kd<0) return;

     float SampleTimeInSec = ((float)sampleTime)/1000;  
     kp = Kp;
     ki = Ki * SampleTimeInSec;
     kd = Kd / SampleTimeInSec;
   
    if(controllerDirection ==1) // REVERSE
     {
        kp = (0 - kp);
        ki = (0 - ki);
        kd = (0 - kd);
     }
  }

  void setSampleTime(int newSampleTime) {
    if (newSampleTime > 0) {
       float ratio  = (float)newSampleTime
                       / (float)sampleTime;
       ki *= ratio;
       kd /= ratio;
       sampleTime = (long)newSampleTime;
    }
  }

  void setMode(int mode) {
    boolean newAuto = (mode == 1); // 1 = AUTOMATIC
    if(newAuto == !inAuto) {  /*we just went from manual to auto*/
          initialize();
    }
      inAuto = newAuto;
  }
  
  void initialize() {
     iTerm = co;
     lastInput = pv;
     if(iTerm > outMax) {
       iTerm = outMax;
     } else if(iTerm < outMin) {
       iTerm = outMin;
     }
  }
  
  float getKp() {
    return kp;
  }
  
  float getKi() {
    return ki;
  }
  
  float getKd() {
    return kd;
  }
  
  
  float getCO() {
    return co;
  }
  
}
