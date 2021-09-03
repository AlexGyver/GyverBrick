// *** GyverBrick ***
// Программа для создания карты для сборки картинки из лего-деталек 
// AlexGyver, 2020, https://alexgyver.ru/
// v1.0 - поехали
// v1.1 - поправлен масштаб колесом, добавлены координаты, русский интерфейс, пост-яркость

// constants
int offsetWidth = 230;     // оффсет панели управления
int maxWidth = 650;
int maxHeight = 650;

// ControlP5
// http://www.sojamo.de/libraries/controlP5/reference/index.html
import controlP5.*;
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
float contrastValue = 1.0;
float brightnessValue = 0;
boolean changeFlag = true;
int overlapAmount;
float subtractWidth;
int subtractAlpha;
int imgX, imgY;
int resultWidth, resultHeight, rectX, rectY;
float resultBright = 1.0;
float rectSize;
boolean mouseState = false;
int draggedX, draggedY;
int draggedXadd, draggedYadd;
boolean dimension = false;

int amounts[];
color colors[];

void setup() {  
  surface.setTitle("GyverBrick v1.1");
  size(1200, 700);
  frameRate(60);
  smooth();
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

void draw() {
  drawImage();    // обработка и вывод картинки
  drawGUI();        // выводим интерфейс
  //println(mouseX + " " + mouseY);
}

// ===============================================================

void drawGUI() {
  // панель управления
  fill(90);
  noStroke();
  rect(0, 0, offsetWidth, height);
  fill(255);
  textSize(18);
  text("Количество: "+(resultHeight*resultWidth), 10, 340);
  for (int i = 0; i < posterizeValue; i++) {
    stroke(0);
    fill(colors[i]);
    rect(10, 348 + i*20, 20, 20);
    fill(255);
    text(/*"#" + (i+1) + ": " + */amounts[i], 10+30, 365 + i*20);
  }
  //rect(0, 225, offsetWidth, 3);
  //rect(0, 440, offsetWidth, 3);
  //rect(0, height-45, offsetWidth, 3);
}
