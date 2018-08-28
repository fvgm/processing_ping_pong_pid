/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void setpointSlider_change1(GCustomSlider source, GEvent event) { //_CODE_:setpointSlider:541758:
  setpoint = setpointSlider.getValueI();
  
} //_CODE_:setpointSlider:541758:

public void kpTextfield_change(GTextField source, GEvent event) { //_CODE_:kpTextfield:369426:
  println("textfield1 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:kpTextfield:369426:

public void kiTextfield_change(GTextField source, GEvent event) { //_CODE_:kiTextfield:870370:
  println("textfield2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:kiTextfield:870370:

public void kdTextfield_change(GTextField source, GEvent event) { //_CODE_:kdTextfield:979035:
  println("textfield3 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:kdTextfield:979035:

public void auto_option_clicked(GOption source, GEvent event) { //_CODE_:auto_option:556855:
  println("Modo automático selecionado.");
  isAutomaticMode = true;
  pid.setMode(1); // modo manual
  plotLower.setLineColor(color(100,188,57));
  manual_slider.setEnabled(false);
  manual_slider.setAlpha(30);
} //_CODE_:auto_option:556855:

public void manual_option_clicked(GOption source, GEvent event) { //_CODE_:manual_option:705268:
  println("Modo manual selecionado.");
  isAutomaticMode = false;
  pid.setMode(0); // modo manual
  plotLower.setLineColor(color(59,212,252));
  manual_slider.setEnabled(true);
  manual_slider.setAlpha(255);
} //_CODE_:manual_option:705268:

public void updateButton_click(GButton source, GEvent event) { //_CODE_:updateButton:434548:
  println("Atualizado!");
  pid.setTunings( float(kpTextfield.getText()),
                  float(kiTextfield.getText()),
                  float(kdTextfield.getText()) );
} //_CODE_:updateButton:434548:

public void manual_slider_change(GCustomSlider source, GEvent event) { //_CODE_:manual_slider:284471:
  println("custom_slider1 - GCustomSlider >> GEvent." + event + " @ " + millis());
} //_CODE_:manual_slider:284471:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("Sketch Window");
  setpointSlider = new GCustomSlider(this, 460, 30, 320, 70, "grey_blue");
  setpointSlider.setShowValue(true);
  setpointSlider.setShowLimits(true);
  setpointSlider.setTextOrientation(G4P.ORIENT_LEFT);
  setpointSlider.setRotation(PI/2, GControlMode.CORNER);
  setpointSlider.setLimits(0, 100, 0);
  setpointSlider.setNumberFormat(G4P.INTEGER, 0);
  setpointSlider.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  setpointSlider.setOpaque(false);
  setpointSlider.addEventHandler(this, "setpointSlider_change1");
  label8 = new GLabel(this, 20, 30, 80, 20);
  label8.setText("SIMULAÇÃO");
  label8.setTextBold();
  label8.setOpaque(false);
  label9 = new GLabel(this, 20, 60, 80, 20);
  label9.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label9.setText("Setpoint");
  label9.setOpaque(false);
  label10 = new GLabel(this, 120, 60, 80, 20);
  label10.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label10.setText("Entrada");
  label10.setOpaque(false);
  label11 = new GLabel(this, 220, 60, 80, 20);
  label11.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label11.setText("Saída");
  label11.setOpaque(false);
  label12 = new GLabel(this, 320, 60, 80, 20);
  label12.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label12.setText("Erro");
  label12.setOpaque(false);
  label13 = new GLabel(this, 20, 180, 300, 20);
  label13.setText("PARÂMETROS DO CONTROLADOR");
  label13.setTextBold();
  label13.setOpaque(false);
  label14 = new GLabel(this, 20, 210, 80, 20);
  label14.setText("Kp");
  label14.setOpaque(false);
  label15 = new GLabel(this, 160, 210, 80, 20);
  label15.setText("Ki");
  label15.setOpaque(false);
  label16 = new GLabel(this, 290, 210, 80, 20);
  label16.setText("Kd");
  label16.setOpaque(false);
  kpTextfield = new GTextField(this, 20, 240, 80, 30, G4P.SCROLLBARS_NONE);
  kpTextfield.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  kpTextfield.setOpaque(true);
  kpTextfield.addEventHandler(this, "kpTextfield_change");
  kiTextfield = new GTextField(this, 160, 240, 80, 30, G4P.SCROLLBARS_NONE);
  kiTextfield.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  kiTextfield.setOpaque(true);
  kiTextfield.addEventHandler(this, "kiTextfield_change");
  kdTextfield = new GTextField(this, 290, 240, 80, 30, G4P.SCROLLBARS_NONE);
  kdTextfield.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  kdTextfield.setOpaque(true);
  kdTextfield.addEventHandler(this, "kdTextfield_change");
  togGroup1 = new GToggleGroup();
  auto_option = new GOption(this, 20, 310, 120, 20);
  auto_option.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  auto_option.setText("Automático");
  auto_option.setOpaque(false);
  auto_option.addEventHandler(this, "auto_option_clicked");
  manual_option = new GOption(this, 20, 330, 120, 20);
  manual_option.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  manual_option.setText("Manual");
  manual_option.setOpaque(false);
  manual_option.addEventHandler(this, "manual_option_clicked");
  togGroup1.addControl(auto_option);
  auto_option.setSelected(true);
  togGroup1.addControl(manual_option);
  label17 = new GLabel(this, 20, 290, 120, 20);
  label17.setText("Modo de Operação");
  label17.setTextBold();
  label17.setOpaque(false);
  updateButton = new GButton(this, 290, 320, 80, 30);
  updateButton.setText("Atualizar");
  updateButton.setTextBold();
  updateButton.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  updateButton.addEventHandler(this, "updateButton_click");
  spLabel = new GLabel(this, 20, 90, 80, 20);
  spLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  spLabel.setText("spLabel");
  spLabel.setTextItalic();
  spLabel.setOpaque(false);
  inputLabel = new GLabel(this, 120, 90, 80, 20);
  inputLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  inputLabel.setText("inputLabel");
  inputLabel.setOpaque(false);
  outputLabel = new GLabel(this, 220, 90, 80, 20);
  outputLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  outputLabel.setText("outputLabel");
  outputLabel.setOpaque(false);
  errorLabel = new GLabel(this, 320, 90, 80, 20);
  errorLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  errorLabel.setText("errorLabel");
  errorLabel.setOpaque(false);
  manual_slider = new GCustomSlider(this, 90, 410, 300, 70, "blue18px");
  manual_slider.setShowValue(true);
  manual_slider.setShowLimits(true);
  manual_slider.setTextOrientation(G4P.ORIENT_LEFT);
  manual_slider.setRotation(PI/2, GControlMode.CORNER);
  manual_slider.setLimits(0, 255, 0);
  manual_slider.setNbrTicks(255);
  manual_slider.setNumberFormat(G4P.INTEGER, 0);
  manual_slider.setOpaque(false);
  manual_slider.addEventHandler(this, "manual_slider_change");
  label1 = new GLabel(this, 20, 390, 70, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("SAÍDA");
  label1.setTextBold();
  label1.setOpaque(false);
}

// Variable declarations 
// autogenerated do not edit
GCustomSlider setpointSlider; 
GLabel label8; 
GLabel label9; 
GLabel label10; 
GLabel label11; 
GLabel label12; 
GLabel label13; 
GLabel label14; 
GLabel label15; 
GLabel label16; 
GTextField kpTextfield; 
GTextField kiTextfield; 
GTextField kdTextfield; 
GToggleGroup togGroup1; 
GOption auto_option; 
GOption manual_option; 
GLabel label17; 
GButton updateButton; 
GLabel spLabel; 
GLabel inputLabel; 
GLabel outputLabel; 
GLabel errorLabel; 
GCustomSlider manual_slider; 
GLabel label1; 
