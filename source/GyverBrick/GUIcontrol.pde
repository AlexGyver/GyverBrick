// ================ MOVE ==================

void load_image() {
  selectInput("Select a file to process:", "fileSelected");
  changeFlag = true;
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Not selected");
  } else {
    imagePath = selection.getAbsolutePath();
    println("Select: " + imagePath);
    image = loadImage(imagePath);
    imageWidth = 256;
    image.resize(imageWidth, 0);    
    sizeSlider.setValue(128);
    cp5.getController("img_rotate").setValue(0);
  }
  changeFlag = true;
}

void save_image() {
  // отрисовка результата
  rectSize = 20;
  int rectPrev = 40; 
  int resOffsX = 50;
  int resOffsY = 150;
  int topOffs = 30;
  int correctW = max((posterizeValue)*(rectPrev+20)+12, resultWidth*20+1);
  PGraphics result = createGraphics(correctW+resOffsX, int(resultHeight*rectSize + resOffsY));    
  result.noStroke();
  result.beginDraw();
  result.background(255);
  result.textSize(18);
  for (int i = 0; i < resultWidth; i++) {
    for (int j = 0; j < resultHeight; j++) {
      color col = hiddenLayer.get(width/2 - resultWidth/2+i-imageXoffs, centerY - resultHeight/2+j-imageYoffs);
      col/*or showCol*/ = color(red(col)*resultBright, green(col)*resultBright, blue(col)*resultBright);
      int brCol = int(constrain(brightness(col), 30, 240));
      //if (brightness(col) == 0) col = color(30);
      //if (brightness(col) == 255) col = color(250);
      result.fill(col);
      result.stroke(0);
      int x = int(result.width/2+resOffsX/2-5 + i * rectSize - rectSize*resultWidth/2);
      int y = int(result.height/2-resOffsY/2+topOffs + j * rectSize - rectSize*resultHeight/2);      
      result.rect(x, y, rectSize, rectSize);

      float textCol = brightness(col) - 128.0;
      result.fill(textCol > 0 ? textCol : 255 + textCol);
      int num = 0;
      for (int k = 0; k < posterizeValue; k++) {
        if (colors[k] == col) {
          num = k;
          break;
        }
      }
      result.text(num + 1, x+rectSize*0.3, y+rectSize*0.9);
    }
  }

  result.fill(0); 
  result.textSize(15);
  result.textAlign(RIGHT, TOP);
  for (int j = 0; j < resultHeight; j++) {
    int x = int(result.width/2+resOffsX/2-10 + 0 * rectSize - rectSize*resultWidth/2);
    int y = int(result.height/2-resOffsY/2+topOffs+1 + j * rectSize - rectSize*resultHeight/2); 
    result.text(j+1, x, y);
  }
  result.pushMatrix();
  result.rotate(radians(-90));
  result.translate(-27, 47);
  result.textAlign(LEFT, TOP);
  for (int i = 0; i < resultWidth; i++) {
    int x = int(/*result.width*/ 0 + 0 * rectSize);
    int y = int(/*result.height*/0 + i * rectSize); 
    result.text(i+1, x, y);
  }
  result.popMatrix();
  result.textAlign(LEFT, BASELINE);

  int legendOffs = 30;
  for (int i = 0; i < posterizeValue; i++) {
    color col = int(brightness(i * 255 / (posterizeValue-1)));
    result.fill(colors[i]);
    //result.rect(i*(rectPrev+20) + legendOffs, resultHeight*20 + 120, rectPrev, rectPrev);
    result.rect(i*(rectPrev+20) + legendOffs, result.height - 80, rectPrev, rectPrev);

    byte textCol = byte(brightness(colors[i]) - 128);
    result.fill(textCol > 0 ? textCol : (255 + textCol));
    result.textSize(25);
    result.text(i+1, i*(rectPrev+20)+12 + legendOffs, result.height-80+30);

    result.fill(0); 
    result.textSize(18);
    result.text(amounts[i], i*(rectPrev+20) + legendOffs, result.height-80+60);
  }
  result.endDraw();
  PImage save = createImage(result.width, result.height, RGB);
  save = result.get();
  save.save("outputImage.bmp");
}

void img_width(int size) {
  imageWidth = size;
  changeFlag = true;
}

void img_rotate(int val) {
  rotAngle = radians(val);
}

// ============== EFFECTS ==============

void bright(int val) {
  brightnessValue = val;
  changeFlag = true;
}


void contr(float val) {
  contrastValue = val;
  changeFlag = true;
}

void rnd() {
  brightnessValue = random(-60, 60);
  contrastValue = random(0.5, 1.4);
  cp5.getController("bright").setValue(brightnessValue);
  cp5.getController("contr").setValue(contrastValue);
  changeFlag = true;
}

void grayscale(boolean state) {
  colorState = !state;
  changeFlag = true;
}

void numbers(boolean state) {
  numbersFlag = !state;
  changeFlag = true;
}

void p_value(int val) {
  posterizeValue = val;
  changeFlag = true;
}

// ============== ENCODING ==============

void result_width(int val) {
  resultWidth = val;
}
void result_height(int val) {
  resultHeight = val;
}

void result_bright(int val) {
  resultBright = val / 100.0;
  changeFlag = true;
}
