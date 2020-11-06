void GUIinit() {
  cp5 = new ControlP5(this);  

  cp5.addButton("load_image").setCaptionLabel("OPEN  IMAGE").setPosition(10, 10).setSize(100, 25);

  cp5.addButton("save_image").setCaptionLabel("SAVE  RESULT").setPosition(120, 10).setSize(100, 25);

  sizeSlider = cp5.addSlider("img_width").setCaptionLabel("IMG  SIZE").setPosition(10, 40).setSize(210, 25).setRange(2, 400).setValue(64).setNumberOfTickMarks(998-1).showTickMarks(false);
  cp5.getController("img_width").getCaptionLabel().setPaddingX(-40);

  cp5.addSlider("img_rotate").setCaptionLabel("ROTATE").setPosition(10, 70).setSize(210, 25).setRange(0, 360).setValue(0);
  cp5.getController("img_rotate").getCaptionLabel().setPaddingX(-35);

  cp5.addSlider("bright").setCaptionLabel("BRIGHTNESS").setPosition(10, 100).setSize(150, 25).setRange(-128, 128).setValue(0);
  cp5.getController("bright").getCaptionLabel().setPaddingX(-55);

  cp5.addSlider("contr").setCaptionLabel("CONTRAST").setPosition(10, 130).setSize(150, 25).setRange(0, 5).setValue(1);
  cp5.getController("contr").getCaptionLabel().setPaddingX(-45);
  
  cp5.addButton("rnd").setCaptionLabel("RANDOM").setPosition(170, 100).setSize(50, 55);

  cp5.addToggle("grayscale").setPosition(10, 160).setSize(45, 25).setMode(ControlP5.SWITCH).setValue(true);

  cp5.addToggle("numbers").setPosition(65, 160).setSize(45, 25).setMode(ControlP5.SWITCH).setValue(true);

  cp5.addSlider("p_value").setCaptionLabel("COLORS").setPosition(120, 160).setSize(100, 25).setRange(2, 10).setValue(4).setNumberOfTickMarks(9);
  cp5.getController("p_value").getCaptionLabel().setPaddingX(-35);

  cp5.addSlider("result_width").setCaptionLabel("RESULT  WIDTH").setPosition(10, 220).setSize(210, 25).setRange(1, 32*4).setValue(64).setNumberOfTickMarks(32*4-1).showTickMarks(false);
  cp5.getController("result_width").getCaptionLabel().setPaddingX(-65);

  cp5.addSlider("result_height").setCaptionLabel("RESULT  HEIGHT").setPosition(10, 250).setSize(210, 25).setRange(1, 32*4).setValue(64).setNumberOfTickMarks(32*4-1).showTickMarks(false);
  cp5.getController("result_height").getCaptionLabel().setPaddingX(-65);
}
