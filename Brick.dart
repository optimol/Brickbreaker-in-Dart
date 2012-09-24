
class Brick {
  //var ctx;
  bool destroyed=false;
  
  var destroyInterval;
  
  num x,y;
  static num brickW,brickH;
  var color;
  Brick(num x, num y)
  {
    var sb = new StringBuffer();
    sb.add("#");
    for(var i=0;i<6;++i)
    {
    sb.add(rand[(Math.random() * 15).toInt()]);
    }
    ctx.fillStyle=sb.toString();
    ctx.beginPath();
    ctx.fillRect(x, y, brickW, brickH);
    this.x=x;
    this.y=y;
  }
  void collision(num ballX, num ballY)
  {
    if(destroyed)
      return;
    
    if (ballX + ballRad < x || ballX - ballRad > x + brickW)
      return;
    
    if (ballY + ballRad < y || ballY - ballRad > y + brickH)
      return;
    
    // destroy
    destroyed=true;
    ctx.clearRect(x, y, brickW, brickH);
    score+=1;
    if(score==25)
    {
      finalScore.style.visibility='';
      query("#scorefin").text="$score";
      controls.style.visibility='hidden';
      window.alert("You Win!!!");
      window.clearInterval(ballInterval);
      window.clearInterval(keyInterval);
      window.clearInterval(randBrickInterval);
      return;
    }
    scoreDisplay.text="$score";
    if( ( ( ballX+ballRad > x) && ( ballX-ballRad < x+brickW) )
        && ( (ballY-ballRad<y) || (ballY+ballRad>y+brickH) ) )
      {
        ballVy*=-1;
      }
    else
      {
        ballVx*=-1; 
      }   
    destroy();
  }
  void destroy()
  {
    ctx.drawImage(exploimg, x,y);
    destroyInterval=window.setInterval(destroyTick,65);
  }
  void destroyTick()
  {
    ctx.clearRect(x, y, 50, 50);
    window.clearInterval(destroyInterval);
  }
  
}
