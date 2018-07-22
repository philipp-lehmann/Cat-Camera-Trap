import processing.video.*;
 
Capture video;
PImage image;
float threshold = 50;
int imgCount = 0;
 
void setup(){
  size(640,480);
  video = new Capture(this,640,480,30);
  println(video.list());
  video.start();
 
  image = createImage(640,480,RGB);//put the size static 
}
 
void captureEvent(Capture video) {
 //copy the video every time when new frame is available 
 image.copy(video,0,0,video.width,video.height,0,0,image.width,image.height);
 image.updatePixels();
 video.read(); 
}
 
void draw() {
  int count = 0;
  float avgX = 0 ;
  float avgY= 0 ;
 
 video.loadPixels();
 loadPixels();
  for (int i = 0;i<video.width;i++) {
    for (int j = 0;j<video.height;j++) {
      // find the color from current video and copy image:
      int loc = i + j * video.width;
   
      int currentPixels = video.pixels[loc];
      int red = currentPixels << 16 & 0xFF;
      int green = currentPixels << 8 & 0xFF;
      int blue = currentPixels & 0xFF;
   
      int prevPixels = image.pixels[loc];
      int red1 = prevPixels << 16 & 0xFF;
      int green1 = prevPixels << 8 & 0xFF;
      int blue1 = prevPixels & 0xFF;
   
      // once we got this find the distance b/w two :
      float dist = calculateDistance(red, green, blue, red1, green1, blue1);
      
      // thresholdChecking
      if(dist > threshold*threshold){
        avgX += i;
        avgY += j;
        count++;
   
       pixels[loc] = color(255); 
      } else {
        pixels[loc] = color(0);
      }
    }
  }
  
  updatePixels(); 
  if (count > 50) {
      avgX = avgX / count;
      avgY = avgY / count; 
  }
  
  // Motion detected
  if (count > 100) {
    fill(0,0,255);
    ellipse(avgX,avgY,20,20);
    
    // Save Image
    if (frameCount % 20 == 0) {
      imgCount++;
      image.save("data/Capture " + imgCount + ".jpg");
    }
    // saveFrame("data/Capture " + imgCount + ".jpg");
  }
}
 
 
 
float calculateDistance(float x1,float y1,float z1,float x2,float y2,float z2){
  return (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
}