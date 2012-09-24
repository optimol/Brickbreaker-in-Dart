
#import('dart:html');
#source('Brick.dart');
CanvasRenderingContext2D ctx;

var ballY;
var ballX;
var ballVx = -3;
var ballVy = -5;
var ballRad=5;

var padY;
var padX;
var padWidth=65;
var padHeight=5;
var padJump;

num height;
num width;

var ballInterval;
var keyInterval;

var img;

var rand;

List<Brick> brickList;
//var ballSprite;

bool keyLeftArrow=false,keyRightArrow=false;

num score=0;
var scoreDisplay;
InputElement slider;


bool paused=false;

var finalScore,controls;

var exploimg;

var level=2;

void run()
{
  
    CanvasElement canvas = document.query("#canvas");
    ctx = canvas.getContext("2d");
    height= canvas.height;
    width= canvas.width;
    
    padX=width/2;
    padY=height-5;
    padJump=width/37;
    
   
    rand=  '0123456789ABCDEF'.split('');
    
    exploimg = new ImageElement();
    exploimg.src="images/explosion.png";
    
    scoreDisplay=  document.query("#score");
    finalScore= document.query("#finalScore");
   brickList= new List();
    //ctx.fillRect(padX, padY, padWidth, padHeight);
   slider = query("#slider");
   controls = query("#gameplay");
   
    //img = new Element.tag("img");
    //img = new ImageElement();
    //img.src="images/flame_spritefin.png";
    
    document.on.keyDown.add((Event e){
      KeyboardEvent ke=e;
      switch(ke.keyCode){
        case 37:
          keyLeftArrow=true;
          break;
        case 39:
          keyRightArrow=true;
          break;
       }     
    });
    document.on.keyUp.add((Event e){
      KeyboardEvent ke=e;
      switch(ke.keyCode){
        case 37:
          keyLeftArrow=false;
          break;
        case 39:
          keyRightArrow=false;
          break;
       }     
    });
    exploimg.on.load.add((e){
      newGame();
    });
    slider.on.change.add((Event e) {
      level=Math.parseInt(slider.value)+1;
      var sign=1; 
      sign=ballVx<0?-1:1;      
      ballVx = (3 + 0.5*level)*sign;
      sign=ballVy<0?-1:1;      
      ballVy = (5 + 0.5*level)*sign;
    }, true);
    /*
    img.on.load.add((e){
      ctx.fillRect(padX, padY, padWidth, padHeight);
      ballInterval=window.setInterval(ballTick,30);
      keyInterval=window.setInterval(keyTick,30);
    });*/
    query('#reset').on.click.add((e) {
      window.clearInterval(ballInterval);
      window.clearInterval(keyInterval);
      //window.clearInterval(randBrickInterval);
      newGame();
    });
    query('#newgame').on.click.add((e) {
      window.clearInterval(ballInterval);
      window.clearInterval(keyInterval);
      //window.clearInterval(randBrickInterval);
      
      newGame();
    });

    query('#pause').on.click.add((e) {
      if(paused)
      {
      paused=false;
      ballInterval=window.setInterval(ballTick,30);
      keyInterval=window.setInterval(keyTick,30);
      
      //randBrickInterval=window.setInterval(randBrickTick,1000);
      
      }
      else
      {
        paused=true;
        window.clearInterval(ballInterval);
        window.clearInterval(keyInterval);
        //window.clearInterval(randBrickInterval);
        
      }
   });
}


void generateField()
{
  Brick.brickW=width/20; Brick.brickH=ballRad*5;
  num by=height/10;
  ctx.fillStyle="#000";
  for(var i=0;i<5;++i)
  {
    num bx=width/15;
    //brickList[i].x=bx;
    //brickList[i].y=by;
    //brickList[i].setBrick(bx,by);
    for(var j=0;j<5;++j)
    {
    brickList.add(new Brick(bx,by));
    bx+=4*Brick.brickW;
    }
    by+=4*Brick.brickH;
  }
}
void keyTick()
{
    if (keyLeftArrow) {
      if(padX > 0)
      { 
        ctx.clearRect(padX-2, padY-1, padWidth+3, padHeight+1);
        padX -= padJump;
        ctx.fillStyle = "#000";
        ctx.fillRect(padX, padY, padWidth,padHeight);        
      }
    } 
    else if (keyRightArrow) {
      if(padX+padWidth <width)
      {
        ctx.clearRect(padX-1, padY-1, padWidth+1, padHeight+1);
        padX += padJump;
        ctx.fillStyle = "#000";
        ctx.fillRect(padX, padY, padWidth, padHeight);
      }
    }

}

/*void randBrickTick()
{
  ctx.fillStyle="#000";
  num by=height/10;
  brickList.add(new Brick(width/10 * (Math.random()*width/1.25).toInt(),height/10 * (Math.random()*height/1.25).toInt()));
}*/
void ballTick()
{ 
  
  /*ctx.save();
  ctx.rotate(oldAng);  
  ctx.beginPath();
  ctx.clearRect(ballX-frameSize/2, ballY-frameSize/2, frameSize, frameSize);
  //ctx.fillStyle = "#000";
  //ctx.fillRect(ballX,ballY,frameSize,frameSize);
  ctx.closePath();
  ctx.restore();
  */
  ctx.beginPath();
  
  ctx.clearRect(ballX-ballRad-1, ballY-ballRad-1, ballRad*2+2, ballRad*2+2);
  ctx.closePath();
  ctx.fillStyle = "#000000";
  ctx.fillRect(padX, padY, padWidth,padHeight);  
  ballX = ballX+ballVx;
  ballY = ballY+ballVy;
  
  ctx.fillStyle = "#FF0000";
  ctx.beginPath();
  ctx.arc(ballX, ballY, ballRad, 0, 2*Math.PI,false);
  ctx.fill();
  ctx.closePath();
  
  if(ballX <= ballRad || ballX >= width-ballRad)
  {
      ballVx=-ballVx;
  }
  if( ballY<=ballRad)
  {
      ballVy=-ballVy;
  }
    
  
  if(ballX>=padX && ballX <=padX+padWidth && ballY>=height-15)// && ballY<=height-6)
  {
    ballVy = -ballVy;
    ctx.fillStyle="#000";
    //ctx.fillRect(padX, padY, padWidth,padHeight);  
    //ballX+=Math.random()/100;
  }
  int n;
  for(Brick b in brickList)
  {
    b.collision(ballX, ballY);
  }
  if(ballY >height-3)
  { 

  query("#scorefin").text="$score";
  controls.style.visibility='hidden';
  finalScore.style.visibility='';
  window.alert("You lose!!!");
  window.clearInterval(ballInterval);
  window.clearInterval(keyInterval);
  //window.clearInterval(randBrickInterval); 
  }
  
}

void newGame()
{
  finalScore.style.visibility='hidden';
  controls.style.visibility='';
  
  ctx.clearRect(0, 0, width, height);
  ballVx = -(3 + 0.5*level);
  ballVy = -(5 + 0.5*level);
  brickList.clear();
  generateField();
  score=0;
  scoreDisplay.text="$score";
  
  ballX=padX+padWidth/2;
  ballY=padY-ballRad;
  
  ctx.fillRect(padX, padY, padWidth, padHeight);
  keyLeftArrow= keyRightArrow=false;
  ballInterval=window.setInterval(ballTick,30);
  keyInterval=window.setInterval(keyTick,30);
  
}

void main() {
  run();
  //newGame();
}
