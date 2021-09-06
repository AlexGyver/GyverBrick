// применение фильтров
PImage filtered(PImage image) {  
  image.resize(imageWidth, 0);
  if (colorState) image.filter(GRAY);
  ContrastAndBrightness(image, image, contrastValue, brightnessValue);
  if (colorState) image.filter(POSTERIZE, posterizeValue);
  else {
    QImage poster = new QImage(image, posterizeValue);    
    image = poster.getImage();
  }  
  return image;
}

void mouseWheel(MouseEvent event) {
  if (mouseX > offsetWidth) {
    imageWidth -= event.getCount() * 2;
    imageWidth = constrain(imageWidth, 2, 1000);
    cp5.getController("img_width").setValue(imageWidth);
    changeFlag = true;
  }
}

// вывод изображения
void drawImage() {
  if (mousePressed && mouseButton == CENTER) {
    if (mouseX > offsetWidth) {
      if (!mouseState) {
        mouseState = true;  // фиксируем нажатие
        draggedX = mouseX;
        draggedY = mouseY;
      } else {
        draggedXadd = (mouseX - draggedX)/5;
        draggedYadd = (mouseY - draggedY)/5;
      }
    }
    changeFlag = true;
  } else {
    if (mouseState) {
      mouseState = false;  // фиксируем отпускание      
      imageXresult += draggedXadd;
      imageYresult += draggedYadd;
      draggedXadd = 0;
      draggedYadd = 0;
    }
  }

  if (changeFlag) {
    image = loadImage(imagePath);
    image = filtered(image);

    imageXadd = 0;
    imageYadd = 0;

    imageXoffs = imageXresult+imageXadd+draggedXadd;
    imageYoffs = imageYresult+imageYadd+draggedYadd;

    imgX = centerX - image.width/2 + imageXoffs;
    imgY = centerY - image.height/2 + imageYoffs; 
    changeFlag = false;
  }
  background(255);

  // рисуем картинку
  hiddenLayer.beginDraw();
  hiddenLayer.background(255);
  hiddenLayer.imageMode(CENTER);
  hiddenLayer.pushMatrix();
  hiddenLayer.translate(width/2, height/2);
  hiddenLayer.rotate(rotAngle);
  hiddenLayer.image(image, 0, 0);
  hiddenLayer.endDraw();    
  hiddenLayer.popMatrix();

  // отрисовка результата
  int maxSide = max(resultHeight, resultWidth);
  rectSize = maxHeight / maxSide;
  textSize(rectSize);

  noStroke();
  fill(0);
  rect(rectX - rectSize*resultWidth/2, rectY - rectSize*resultHeight/2, rectSize*resultWidth, rectSize*resultHeight);

  strokeWeight(rectSize/25.0);
  float r = rectSize/8.0;
  amounts = new int[10];
  colors = new color[10];

  for (int i = 0; i < resultWidth; i++) {
    for (int j = 0; j < resultHeight; j++) {
      color col = hiddenLayer.get(width/2 - resultWidth/2+i-imageXoffs, centerY - resultHeight/2+j-imageYoffs);
      col = color(red(col)*resultBright, green(col)*resultBright, blue(col)*resultBright);
      int brCol = int(constrain(brightness(col), 30, 240));
      //if (brightness(col) == 0) col = color(30);
      //if (brightness(col) == 255) col = color(250);


      stroke(10);
      fill(col);
      int x = int(rectX + i * rectSize - rectSize*resultWidth/2);
      int y = int(rectY + j * rectSize - rectSize*resultHeight/2); 
      rect(x, y, rectSize, rectSize, r);

      if (!numbersFlag) {
        fill(0, 80);
        noStroke();
        float shift = rectSize/10.0;
        circle(x+rectSize/2-shift, y+rectSize/2+shift, rectSize/2);

        stroke(0, 10);
        //fill(brCol + 5);

        fill(fade(col, 270));
        circle(x+rectSize/2, y+rectSize/2, rectSize/2);
      }

      int textCol = brCol - 128;
      fill(textCol > 0 ? textCol : 255 + textCol);
      int num = 0;
      for (int k = 0; k < posterizeValue; k++) {
        if (colors[k] == col) {
          num = k;
          break;
        } else if (colors[k] == 0) {
          colors[k] = col;
          num = k;
          break;
        }
      }
      amounts[num]++;
      if (numbersFlag) text(num + 1, x+rectSize*0.2, y+rectSize*0.9);
    }
  }

  // рамка
  noFill();
  stroke(255, 0, 0);
  strokeWeight(2);
  rect(rectX - rectSize*resultWidth/2, rectY - rectSize*resultHeight/2, rectSize*resultWidth, rectSize*resultHeight, 2);
}

color fade(color col, int val) {
  int B = col & 0xFF;
  int G = (col & 0xFF00) >> 8;
  int R = (col & 0xFF0000) >> 16;
  R = constrain((R * val) >> 8, 5, 250);
  G = constrain((G * val) >> 8, 5, 250);
  B = constrain((B * val) >> 8, 5, 250);
  return color(R, G, B);
}
