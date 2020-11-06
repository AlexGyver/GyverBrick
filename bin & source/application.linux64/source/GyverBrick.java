import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GyverBrick extends PApplet {

// *** GyverBrick ***
// Программа для создания карты для сборки картинки из лего-деталек 
// AlexGyver, 2020, https://alexgyver.ru/
// v1.0 - поехали

// constants
int offsetWidth = 230;     // оффсет панели управления
int maxWidth = 650;
int maxHeight = 650;

// ControlP5
// http://www.sojamo.de/libraries/controlP5/reference/index.html

ControlP5 cp5;
Slider sizeSlider;

// image
PImage image;
PGraphics hiddenLayer;
int sizeX, sizeY;
int imageWidth = 100;
int imageXoffs = 0, imageYoffs = 0;
int imageXadd = 0, imageYadd = 0;
int imageXresult = 0, imageYresult = 0;
String imagePath;
int centerX;
int centerY;

// settings
float rotAngle = 0;
boolean colorState = false;
boolean numbersFlag = false;
int posterizeValue = 4;
float contrastValue = 1.0f;
float brightnessValue = 0;
boolean changeFlag = true;
int overlapAmount;
float subtractWidth;
int subtractAlpha;
int imgX, imgY;
int resultWidth, resultHeight, rectX, rectY;
float rectSize;
boolean mouseState = false;
int draggedX, draggedY;
int draggedXadd, draggedYadd;
boolean dimension = false;

int amounts[];
int colors[];

public void setup() {  
  surface.setTitle("GyverBrick v1.0");
  
  frameRate(60);
  
  noStroke();

  imagePath = "noImage.jpg";
  image = loadImage(imagePath);
  imageWidth = image.width;

  GUIinit();
  centerX = offsetWidth+150;
  centerY = height/2;
  rectX = (offsetWidth + width) / 2;
  rectY = height/2;
  hiddenLayer = createGraphics(width, height);
}

public void draw() {
  drawImage();    // обработка и вывод картинки
  drawGUI();        // выводим интерфейс
  //println(mouseX + " " + mouseY);
}

// ===============================================================

public void drawGUI() {
  // панель управления
  fill(90);
  noStroke();
  rect(0, 0, offsetWidth, height);
  fill(255);
  textSize(18);
  text("Amount: "+(resultHeight*resultWidth), 10, 300);
  for (int i = 0; i < posterizeValue; i++) {
    text("#" + (i+1) + ": " + amounts[i], 10, 320 + i*20);
  }
  //rect(0, 225, offsetWidth, 3);
  //rect(0, 440, offsetWidth, 3);
  //rect(0, height-45, offsetWidth, 3);
}
// ================ MOVE ==================

public void load_image() {
  selectInput("Select a file to process:", "fileSelected");
  changeFlag = true;
}

public void fileSelected(File selection) {
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

public void save_image() {
  // отрисовка результата
  rectSize = 20;
  int rectPrev = 40; 
  int correctW = max((posterizeValue)*(rectPrev+20)+12, resultWidth*20+1);
  PGraphics result = createGraphics(correctW, resultHeight*20 + 200);    
  result.noStroke();
  result.beginDraw();
  result.background(255);
  result.textSize(18);
  for (int i = 0; i < resultWidth; i++) {
    for (int j = 0; j < resultHeight; j++) {
      int col = hiddenLayer.get(width/2 - resultWidth/2+i-imageXoffs, centerY - resultHeight/2+j-imageYoffs);
      int brCol = PApplet.parseInt(constrain(brightness(col), 30, 240));
      //if (brightness(col) == 0) col = color(30);
      //if (brightness(col) == 255) col = color(250);
      result.fill(col);
      result.stroke(0);
      int x = PApplet.parseInt(result.width/2+ i * rectSize - rectSize*resultWidth/2);
      int y = PApplet.parseInt(result.height/2+ j * rectSize - rectSize*resultHeight/2);      
      result.rect(x, y, rectSize, rectSize);

      float textCol = brightness(col) - 128.0f;
      result.fill(textCol > 0 ? textCol : 255 + textCol);
      int num = 0;
      for (int k = 0; k < posterizeValue; k++) {
        if (colors[k] == col) {
          num = k;
          break;
        }
      }
      result.text(num + 1, x+rectSize*0.3f, y+rectSize*0.9f);
    }
  }

  for (int i = 0; i < posterizeValue; i++) {
    int col = PApplet.parseInt(brightness(i * 255 / (posterizeValue-1)));
    result.fill(colors[i]);
    result.rect(i*(rectPrev+20), resultHeight*20 + 120, rectPrev, rectPrev);

    byte textCol = PApplet.parseByte(brightness(colors[i]) - 128);
    result.fill(textCol > 0 ? textCol : (255 + textCol));
    result.textSize(25);
    result.text(i+1, i*(rectPrev+20)+12, resultHeight*20 + 120+30);

    result.fill(0); 
    result.textSize(18);
    result.text(amounts[i], i*(rectPrev+20), resultHeight*20 + 120+60);
  }
  result.endDraw();
  PImage save = createImage(result.width, result.height, RGB);
  save = result.get();
  save.save("outputImage.bmp");
}

public void img_width(int size) {
  imageWidth = size;
  changeFlag = true;
}

public void img_rotate(int val) {
  rotAngle = radians(val);
}

// ============== EFFECTS ==============

public void bright(int val) {
  brightnessValue = val;
  changeFlag = true;
}

public void contr(float val) {
  contrastValue = val;
  changeFlag = true;
}

public void rnd() {
  brightnessValue = random(-60, 60);
  contrastValue = random(0.5f, 1.4f);
  cp5.getController("bright").setValue(brightnessValue);
  cp5.getController("contr").setValue(contrastValue);
  changeFlag = true;
}

public void grayscale(boolean state) {
  colorState = !state;
  changeFlag = true;
}

public void numbers(boolean state) {
  numbersFlag = !state;
  changeFlag = true;
}

public void p_value(int val) {
  posterizeValue = val;
  changeFlag = true;
}

// ============== ENCODING ==============

public void result_width(int val) {
  resultWidth = val;
}
public void result_height(int val) {
  resultHeight = val;
}
public void GUIinit() {
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
// ================== ФИЛЬТР ЯРКОСТЬ/КОНТРАСТ ==================
// https://forum.processing.org/one/topic/increase-contrast-of-an-image.html
public void ContrastAndBrightness(PImage input, PImage output, float cont, float bright) {
  int w = input.width;
  int h = input.height;

  //our assumption is the image sizes are the same
  //so test this here and if it's not true just return with a warning
  if (w != output.width || h != output.height)
  {
    println("error: image dimensions must agree");
    return;
  }

  //this is required before manipulating the image pixels directly
  input.loadPixels();
  output.loadPixels();

  //loop through all pixels in the image
  for (int i = 0; i < w*h; i++)
  {  
    //get color values from the current pixel (which are stored as a list of type 'color')
    int inColor = input.pixels[i];

    //slow version for illustration purposes - calling a function inside this loop
    //is a big no no, it will be very slow, plust we need an extra cast
    //as this loop is being called w * h times, that can be a million times or more!
    //so comment this version and use the one below
    int r = (int) red(input.pixels[i]);
    int g = (int) green(input.pixels[i]);
    int b = (int) blue(input.pixels[i]);

    //here the much faster version (uses bit-shifting) - uncomment to try
    //int r = (inColor >> 16) & 0xFF; //like calling the function red(), but faster
    //int g = (inColor >> 8) & 0xFF;
    //int b = inColor & 0xFF;      

    //apply contrast (multiplcation) and brightness (addition)
    r = (int)(r * cont + bright); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
    g = (int)(g * cont + bright);
    b = (int)(b * cont + bright);

    //slow but absolutely essential - check that we don't overflow (i.e. r,g and b must be in the range of 0 to 255)
    //to explain: this nest two statements, sperately it would be r = r < 0 ? 0 : r; and r = r > 255 ? 255 : 0;
    //you can also do this with if statements and it would do the same just take up more space
    r = r < 0 ? 0 : r > 255 ? 255 : r;
    g = g < 0 ? 0 : g > 255 ? 255 : g;
    b = b < 0 ? 0 : b > 255 ? 255 : b;

    //and again in reverse for illustration - calling the color function is slow so use the bit-shifting version below
    output.pixels[i] = color(r, g, b);
    //output.pixels[i]= 0xff000000 | (r << 16) | (g << 8) | b; //this does the same but faster
  }

  //so that we can display the new image we must call this for each image
  input.updatePixels();
  output.updatePixels();
}
// применение фильтров
public PImage filtered(PImage image) {  
  image.resize(imageWidth, 0);
  ContrastAndBrightness(image, image, contrastValue, brightnessValue);
  //image.filter(INVERT);
  if (colorState) image.filter(GRAY);
  //image.filter(POSTERIZE, posterizeValue);
  QImage poster = new QImage(image, posterizeValue);
  image = poster.getImage();
  return image;
}

public void mouseWheel(MouseEvent event) {
  if (mouseX > offsetWidth) {
    imageWidth -= event.getCount();
    imageWidth = constrain(imageWidth, 2, 1000);
    cp5.getController("img_width").setValue(imageWidth);
    changeFlag = true;
  }
}

// вывод изображения
public void drawImage() {
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

  strokeWeight(rectSize/25.0f);
  float r = rectSize/8.0f;
  amounts = new int[10];
  colors = new int[10];

  for (int i = 0; i < resultWidth; i++) {
    for (int j = 0; j < resultHeight; j++) {
      int col = hiddenLayer.get(width/2 - resultWidth/2+i-imageXoffs, centerY - resultHeight/2+j-imageYoffs);
      int brCol = PApplet.parseInt(constrain(brightness(col), 30, 240));
      //if (brightness(col) == 0) col = color(30);
      //if (brightness(col) == 255) col = color(250);
      

      stroke(10);
      fill(col);
      int x = PApplet.parseInt(rectX + i * rectSize - rectSize*resultWidth/2);
      int y = PApplet.parseInt(rectY + j * rectSize - rectSize*resultHeight/2); 
      rect(x, y, rectSize, rectSize, r);

      if (!numbersFlag) {
        fill(0, 80);
        noStroke();
        float shift = rectSize/10.0f;
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
      if (numbersFlag) text(num + 1, x+rectSize*0.2f, y+rectSize*0.9f);
    }
  }

  // рамка
  noFill();
  stroke(255, 0, 0);
  strokeWeight(2);
  rect(rectX - rectSize*resultWidth/2, rectY - rectSize*resultHeight/2, rectSize*resultWidth, rectSize*resultHeight, 2);
}

public int fade(int col, int val) {
  int B = col & 0xFF;
  int G = (col & 0xFF00) >> 8;
  int R = (col & 0xFF0000) >> 16;
  R = constrain((R * val) >> 8, 5, 250);
  G = constrain((G * val) >> 8, 5, 250);
  B = constrain((B * val) >> 8, 5, 250);
  return color(R, G, B);
}
// https://discourse.processing.org/t/how-to-apply-color-quantization-to-an-image/4849/21

public class QImage {
  final int[][] pixels;
  final int w, h;
  final int[] colortable;
  final PImage reducedImage;

  /**
   img = the PImage we want to quantize
   maxNbrColors - color table size
   */
  public QImage(PImage img, int maxNbrColors) {
    // Pixel data needs to be in 2D array for Quantize class.
    w = img.width;
    h = img.height;
    pixels = new int[h][w];
    img.loadPixels();
    int[] p = img.pixels;
    int n = 0;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        pixels[y][x] = p[n++];
      }
    } 
    // Quantize the image
    colortable = Quantize.quantizeImage(pixels, maxNbrColors);
    //Create a PImage with the reduced color pallette
    reducedImage = createImage(w, h, ARGB);
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        reducedImage.set(x, y, colortable[pixels[y][x]]);
      }
    }
  }

  /**
   Convenience method to draw the quatized image at a 
   given position.
   */
  public void displayRAW(int px, int py) {
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        set(px + x, py+y, colortable[pixels[y][x]]);
      }
    }
  }

  /**
   Get the pixel color index data
   */
  public int[][] getPixels() {
    return pixels;
  }

  /**
   Get the color table data
   */
  public int[] getColorTable() {
    return colortable;
  }

  /**
   Get the maximum number of colors in the reduced image.
   The actual number of unique colors maybe less than this.
   */
  public int nbrColors() {
    return colortable.length;
  }

  /**
   Convenience method to get the quatized image as a PImage
   that can be used directly in processing
   */
  public PImage getImage() {
    return reducedImage;
  }
}
  public void settings() {  size(1200, 700);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GyverBrick" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
