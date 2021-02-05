import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer player;
AudioBuffer buffer;
AudioInput ai;

float lerpedAverage = 0;

float[] lerpedBuffer;

float x = 0;

int frameSize = 512;
float halfWidth;
float drawable;
float halfDrawable;

void setup()
{
  //size(1000, 512);
  fullScreen(P3D);
  colorMode(HSB);
  minim = new Minim(this);
  player = minim.loadFile("Etherwood.mp3", frameSize);
  smooth();
  frameRate(60);
  //player.play();
  ai = minim.getLineIn(Minim.MONO, width, 44100, 16);
  buffer = ai.mix;

  lerpedBuffer = new float[buffer.size()];
  drawable = width;
  halfDrawable = drawable / 2;
  
  halfWidth = width / 2;
}

int which = 0;
float offset = 0;

void draw()
{
  background(0);
  float halfH = height / 2;
  
  float sum = 0;
  for (int i = 0; i < buffer.size(); i ++)
  {
    sum += abs(buffer.get(i));
  }
  float average = sum / buffer.size();
  lerpedAverage = lerp(lerpedAverage, average, 0.1f);

  
  if (which == 1)
  {
    strokeWeight(2);
    for (int i = 0; i < buffer.size(); i ++)
    {
      float sample = buffer.get(i) * halfH;
      stroke(map(i, 0, buffer.size(), 0, 255), 255, 255);
      //line(i, halfH + sample, i, halfH - sample); 

      lerpedBuffer[i] = lerp(lerpedBuffer[i], buffer.get(i), 0.02f);

      sample = lerpedBuffer[i] * width * 6;    
      stroke(map(i, 0, buffer.size(), 0, 255), 255, 255);
      float x = (int) map(i, 0, buffer.size(), halfWidth - halfDrawable, halfWidth + halfDrawable);
      line(x, height / 2 - sample, x, height/2 + sample); 
    }
  }
  if (which == 0)
  {
    strokeWeight(2);
    for (int i = 0; i < buffer.size(); i ++)
    {
      float sample = buffer.get(i) * halfH;
      stroke(map(i, 0, buffer.size(), 0, 255), 255, 255);
      //line(i, halfH + sample, i, halfH - sample); 

      lerpedBuffer[i] = lerp(lerpedBuffer[i], buffer.get(i), 0.01f);

      sample = lerpedBuffer[i] * width * 6;    
      if (i < buffer.size()/2)
      {
        float c = map((i+offset) % buffer.size(), 0, buffer.size()/2, 0, 127) % 255; 
        stroke(c, 255, 255);
      }
      else
      {
        float c = map((abs(i-offset)) % buffer.size(), buffer.size(), buffer.size()/2, 255, 128);         
        stroke(c, 255, 255);
      }
      //offset += lerpedAverage * 0.01f;
      float x = (int) map(i, 0, buffer.size(), halfWidth - halfDrawable, halfWidth + halfDrawable);
      float y = (int) map(i, 0, buffer.size(), 0, height);
      line(x, height / 2 - sample, width/2 + sample, y); 
    }
  }
  
  if (which == 2)
  {
    strokeWeight(2);
    for (int i = 0; i < buffer.size(); i ++)
    {
      float sample = buffer.get(i) * halfH;
      stroke(map(i, 0, buffer.size(), 0, 255), 255, 255);
      //line(i, halfH + sample, i, halfH - sample); 

      lerpedBuffer[i] = lerp(lerpedBuffer[i], buffer.get(i), 0.01f);

      sample = lerpedBuffer[i] * width * 6;    
      stroke(map(i, 0, buffer.size(), 0, 255), 255, 255);
      
      float x = map(i, 0, buffer.size(), 0, width);
      float y = map(i, 0, buffer.size(), 0, height);
          
      line(0, y, sample, y); 
      line(width, y, width - sample, y); 
      line(x, 0, x, sample); 
      line(x, height, x, height - sample);
    }
  }

  

  
  if (which == 3)
  {
    noFill();
    strokeWeight(2);
    stroke(map(lerpedAverage, 0, 1, 0, 255), 255, 255);
    ellipse(width / 2, halfH, lerpedAverage * width * 2, lerpedAverage * width * 2);
  } 
  
  if (which == 4)
  {
    noFill();
    strokeWeight(2);
    stroke(map(lerpedAverage, 0, 1, 0, 255), 255, 255);
    rectMode(CENTER);
    rect(width / 2, halfH, lerpedAverage * width * 2, lerpedAverage * width * 2);
  }  
  
  
}

void keyPressed()
{
  if (keyCode >= '0' && keyCode <= '5')
  {
    which = keyCode - '0';
  }
  if (keyCode == ' ')
  {
    if ( player.isPlaying() )
    {
      player.pause();
    }
    else
    {
      player.rewind();
      player.play();
    }
  }
}
