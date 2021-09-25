void GUIinit() {
  cp5 = new ControlP5(this);  
  
  ControlFont menuFont = new ControlFont(createFont("Arial", 12));
  cp5.setFont(menuFont);

  cp5.addButton("load_image").setCaptionLabel("ОТКРЫТЬ").setPosition(10, 10).setSize(100, 25);

  cp5.addButton("save_image").setCaptionLabel("СОХРАНИТЬ").setPosition(120, 10).setSize(100, 25);

  sizeSlider = cp5.addSlider("img_width").setCaptionLabel("РАЗМЕР").setPosition(10, 70).setSize(210, 25).setRange(2, 400).setValue(64).setNumberOfTickMarks(998-1).showTickMarks(false);
  cp5.getController("img_width").getCaptionLabel().setPaddingX(-55);

  //cp5.addSlider("img_rotate").setCaptionLabel("ВРАЩАТЬ").setPosition(10, 70).setSize(210, 25).setRange(0, 360).setValue(0);
  //cp5.getController("img_rotate").getCaptionLabel().setPaddingX(-65);

  cp5.addSlider("bright").setCaptionLabel("ЯРКОСТЬ").setPosition(10, 100).setSize(150, 25).setRange(-128, 128).setValue(0);
  cp5.getController("bright").getCaptionLabel().setPaddingX(-65);

  cp5.addSlider("contr").setCaptionLabel("КОНТРАСТ").setPosition(10, 130).setSize(150, 25).setRange(0, 5).setValue(1);
  cp5.getController("contr").getCaptionLabel().setPaddingX(-70);
  
  cp5.addSlider("blur").setCaptionLabel("РАЗМЫТИЕ").setPosition(10, 160).setSize(210, 25).setRange(0, 2).setValue(0.5).setNumberOfTickMarks(9).showTickMarks(false);
  cp5.getController("blur").getCaptionLabel().setPaddingX(-75);
  
  cp5.addButton("rnd").setCaptionLabel("СЛУЧ.").setPosition(170, 100).setSize(50, 55);

  cp5.addToggle("grayscale").setCaptionLabel("Ч/Б").setPosition(10, 190).setSize(45, 25).setMode(ControlP5.SWITCH).setValue(true);

  cp5.addToggle("edges").setCaptionLabel("КРАЯ").setPosition(65, 190).setSize(45, 25).setMode(ControlP5.SWITCH).setValue(true);

  cp5.addSlider("p_value").setCaptionLabel("ЦВЕТОВ").setPosition(120, 190).setSize(100, 25).setRange(2, 10).setValue(4).setNumberOfTickMarks(9);
  cp5.getController("p_value").getCaptionLabel().setPaddingX(-55);

  cp5.addSlider("result_width").setCaptionLabel("ШИРИНА").setPosition(10, 250).setSize(210, 25).setRange(1, 32*4).setValue(64).setNumberOfTickMarks(32*4-1).showTickMarks(false);
  cp5.getController("result_width").getCaptionLabel().setPaddingX(-60);

  cp5.addSlider("result_height").setCaptionLabel("ВЫСОТА").setPosition(10, 280).setSize(210, 25).setRange(1, 32*4).setValue(64).setNumberOfTickMarks(32*4-1).showTickMarks(false);
  cp5.getController("result_height").getCaptionLabel().setPaddingX(-60);
  
  cp5.addSlider("result_bright").setCaptionLabel("ЯРКОСТЬ").setPosition(10, 310).setSize(210, 25).setRange(1, 200).setValue(100);
  cp5.getController("result_bright").getCaptionLabel().setPaddingX(-65);
}
