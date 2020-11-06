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
