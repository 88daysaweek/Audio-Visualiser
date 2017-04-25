import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

FFT fft;
float vol;
float amp;


void setup()


    {
      size(2048,1024); 
      minim = new Minim(this);
       //ai = minim.getLineIn(Minim.STEREO,width,sampleRate,resolution); 
       //ai = minim.loadFile("Aphex Twin - Vordhosbn.mp3", sampleRate);
       //ai = minim.loadFile("CLYDE McPHATTER don't let go.mp3", sampleRate);
       //ai = minim.loadFile("Hiroshi Yoshimura - Creek [1986].wav", sampleRate);
       //ai = minim.loadFile("Crossing Souls - Mercury.mp3", sampleRate);
       //ai = minim.loadFile("Flim - Bad Plus.mp3", sampleRate);
       //ai = minim.loadFile("Debussy, Clair de lune (piano music).mp3", sampleRate);
      ai = minim.loadFile("Debussy, Clair de lune (piano music).wav", sampleRate);
       //ai = minim.loadFile("Tank And The Bangas- NPR Music Tiny Desk Concert.wav", sampleRate);
       //ai = minim.loadFile("Angel Olsen - Free.mp3", sampleRate);
      
      halfHeight = height/2;
      vizHeight = height/3;
      newBackColor();
      ai.loop();
      fft = new FFT( ai.bufferSize(), ai.sampleRate());
      amp = fft.specSize();
      
    }
    
    void newBackColor() 
    {  
      backColor = color(random(150, 255), random(150, 255), random(150, 255)              );
    } 
    
Minim minim;
//AudioInput ai;
AudioPlayer ai;
int sampleRate = 1024;//44100;//4096;//2048;//
int resolution = 16;
float halfHeight;
float vizHeight;
float radius = 0; 
float threshold = 0.2;//0.09;//0.2; 
color backColor; 

  void draw()
  
       {  
          background(0);
          strokeWeight (4);
          stroke(backColor); 
          float total = 0;
         
          
          pushMatrix();
          translate (width/2, vizHeight);
          beginShape();
          noFill();
    
      for (int i = 0; i < 360; i ++)
          {
           
            float  r =degrees(ai.mix.get(i)*10);
            total += abs(ai.left.get(i));
            float x = r*cos(i);
            float y = r*sin(i);
            vertex (x,y);
           
            float average = total / ai.bufferSize();
            
            if (average > threshold/5)
            //if (average > threshold/4)
              {
                background(backColor);
                stroke(0);
                strokeWeight(.02);
                line(x,y,x,y);
                line(y,x, x,y);
              }
          }
          endShape();
          popMatrix();
      
      for (int i = 0; i < ai.bufferSize(); i ++) 
     
      { 
      
        total += abs(ai.left.get(i));  
      } 
        float average = total / ai.bufferSize();  
        
        if (average > threshold)  
    
          { 
             for(int i = 0; i < ai.bufferSize() - 1; i++)
      {
        
          float angle = 0;
          float offset = 60;
          float scalar = 2;
          float speed = .05;
          float x = offset + cos(angle) * scalar;
          float y = offset + sin(angle) * scalar;
          translate (ai.right.get(i)*5000, ai.left.get(i)*1500);
          rotate (angle);
          angle += .1;
          angle += speed;
          scalar+= speed;
          fill (backColor);
          //rect(i,i,random (i,i-x),i);
          //rect(i,i,i,random (i,i-y));
          //rect(i,i,random (i,i-x),random (i,i-y));
          rect(i,i,i,i);
          ellipse (x,y, y,x);
          newBackColor();  
          
          } 
       
     }
    
           radius = lerp(radius, average, 0.1f);  
           ellipse(width/2, vizHeight, radius * height, radius * height); 
 
           stroke(255);
           translate (width/9, height/9.1);
  
           beginShape();
              for(int i = 0; i < fft.specSize(); i++)
           {
             
             color backColor = color(random(0, 255), random(0, 255), random(0, 255)              );
             fill(backColor);
             float  r =(ai.left.get(i) * height/2);
             vertex (r,i*i);
            }
            endShape();
            
                 beginShape();
                  for(int i = 0; i < fft.specSize(); i++)
               {
                 
                 color backColor = color(random(0, 255), random(0, 255), random(0, 255)              );
                 fill(backColor);
                float  r =(ai.left.get(i) * height/2);
                
                vertex (r+250,i*i);
               
                }
                endShape();
                
                  beginShape();
                  for(int i = 0; i < fft.specSize(); i++)
               {
                  color backColor = color(random(0, 255), random(0, 255), random(0, 255)              );
                 fill(backColor);
                float  r =(ai.right.get(i) * height/2);
                 
                vertex (r+1350,i*i);
     
                }
                endShape();
           
}