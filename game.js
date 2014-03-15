var img_paddle = new Image();
var img_ball = new Image();
var img_pwup1 = new Image();
var img_pwup2 = new Image();
var img_heart = new Image();
var img_e = new Image();
var img_r = new Image();
var img_i = new Image();
var img_c = new Image();

img_paddle.src = "";
img_ball.src = "";
img_pwup1.src = "img/angel.png";
img_pwup2.src = "img/evil.png";
img_heart.src = "img/heart.png";
img_e.src = "img/E.png";
img_r.src = "img/R.png";
img_i.src = "img/I.png";
img_c.src = "img/C.png";

function Game(){
	this.ctx;
	this.width;
	this.height;

	this.x = 150;
	this.y = 200;
	this.r = 10;
	this.dx = 1;
	this.dy = 3;

	this.paddlex;
	this.paddleh = 15;
	this.paddlew = 150;
    
	this.row = 5;
	this.col = 5;
	this.brickw;
	this.brickh = 20;
	this.padding = 1;
	this.big_padding = 80;
    
	this.bricks = new Array(this.row);
    
	this.bricksnum = this.row * this.col;
	this.status = 0;//0 for in progress, 1 for win, 2 for lose, 3 for pause
	this.score = 0;

	this.ballcolor = "#FFFFFF";
	this.backgroundcolor = "pink";
	this.brickscolor = new Array("#e01561", "#a941f9", "#5dafe3", "#99e35d", "#ec7d3e");

	this.pwupx = new Array(0,0);
	this.pwupy = new Array(this.height + 50,this.height + 50);
	//this.pwupw = new Array(20,20);
	//this.pwuph = new Array(20,20);
	this.pwupdy = new Array(0,0);

	this.ericx = new Array(0,0,0,0);
	this.ericy = new Array(this.height + 50,this.height + 50,this.height + 50,this.height + 50);
	this.ericw = new Array(20,20,20,20);
	this.erich = new Array(20,20,20,20);
	this.ericdy = new Array(0,0,0,0);
	this.text = new Array("E","R","I","C");

	this.pwuprow1 = new Array(Math.floor(Math.random()*this.row),Math.floor(Math.random()*this.row));
    this.pwupcol1 = new Array(Math.floor(Math.random()*this.col),Math.floor(Math.random()*this.col));

	this.pwuprow2 = new Array(Math.floor(Math.random()*this.row),Math.floor(Math.random()*this.row));
    this.pwupcol2 = new Array(Math.floor(Math.random()*this.col),Math.floor(Math.random()*this.col));

	this.ericrandomx = new Array(0,1,2,4);
	this.ericrandomy = new Array(0,3,1,2);

	this.l = this.paddlew/2;
	this.wordcount = 0;

	this.heartx={};
	this.hearty = {};
	this.heartdy = 3;

	this.heartrow;
	this.heartcol;
	this.flag = 0;

}

Game.prototype.init = function(){
	var canvas = $('#mainCanvas')[0];
    if(canvas.getContext){
    	/* This is the 2d rendering context you will be drawing on. */
		this.ctx = canvas.getContext('2d');
		this.width  = $("#mainCanvas").width();
  		this.height  = $("#mainCanvas").height();
		this.paddlex = this.width / 2;
		this.brickw = ((this.width-160)/this.col)- 1;

		this.initbricks();
		return true;
	}
	return false;
}
Game.prototype.initbricks = function(){
	for (i=0; i < this.row; i++) {
		this.bricks[i] = new Array(this.col);
			for (j=0; j < this.col; j++) {
				this.bricks[i][j] = 1;
			}
        }
}


Game.prototype.circle = function(x,y,r){
	this.ctx.fillStyle=this.ballcolor;
	this.ctx.beginPath();
  	this.ctx.arc(x, y, r, 0, Math.PI*2, true); 
  	this.ctx.closePath();
  	this.ctx.fill();
}

Game.prototype.rect = function(x,y,w,h){
	this.ctx.fillStyle="#72212e";
	this.ctx.beginPath();
  	this.ctx.rect(x,y,w,h);
  	this.ctx.closePath();
  	this.ctx.fill();
}


Game.prototype.drawpwup = function(img,x,y,w,h){
	this.ctx.drawImage(img,0,0,300,300,x,y,w,h);
}


Game.prototype.clear = function(){
    this.ctx.clearRect(0, 0, this.width, this.height);
}

Game.prototype.drawbg = function(w,h){
    this.ctx.fillStyle=this.backgroundcolor;
	this.ctx.beginPath();
  	this.ctx.rect(0,0,w,h);
  	this.ctx.closePath();
  	this.ctx.fill();
}

Game.prototype.drawbricks = function(row,col,bricks,brickw,brickh,padding,big_padding){
	for (i=0; i < row; i++) {
		for (j=0; j < col; j++) {
		if(bricks[i][j] == 1) {
			this.ctx.fillStyle=this.brickscolor[i];
			this.ctx.beginPath();  	
			this.ctx.rect((j * (brickw + padding)) + big_padding, (i * (brickh + padding)) + big_padding, brickw, brickh);
			this.ctx.closePath();
			this.ctx.fill();
		}
		else if(bricks[i][j] == 2) {
			this.ctx.fillStyle="grey";
			this.ctx.beginPath();  	
			this.ctx.rect((j * (brickw + padding)) + big_padding, (i * (brickh + padding)) + big_padding, brickw, brickh);
			this.ctx.closePath();
			this.ctx.fill();
		}
		}
	}	
}

Game.prototype.showText = function(text){
	this.ctx.fillStyle = "#aa0000";
	this.ctx.font = 'italic bold 30px sans-serif';
	this.ctx.textBaseline = 'bottom';
	this.ctx.fillText(text,320,300);
}


Game.prototype.showVText = function(text){
	this.ctx.fillStyle = "#aa0000";
	this.ctx.font = 'italic bold 30px sans-serif';
	this.ctx.textBaseline = 'bottom';
	this.ctx.fillText(text,100,300);
}

Game.prototype.showScore = function(){
	this.ctx.fillStyle = "#aa0000";
	this.ctx.font = 'italic bold 30px sans-serif';
	this.ctx.textBaseline = 'bottom';
	this.ctx.fillText("Final Score: " + this.score,300,330);
}

Game.prototype.draw = function(){    
    this.drawbg(this.width,this.height);
	this.circle(this.x,this.y,this.r);
	//this.rect(img_paddle,this.x-this.r,this.y-this.r,this.r * 2 - 4,this.r * 2 - 4);
	//draw powerup
	this.drawpwup(img_pwup1,this.pwupx[0],this.pwupy[0],40,40);
	this.drawpwup(img_pwup2,this.pwupx[1],this.pwupy[1],40,40);
	this.drawpwup(img_e,this.ericx[0],this.ericy[0],40,40);
	this.drawpwup(img_r,this.ericx[1],this.ericy[1],40,40);
	this.drawpwup(img_i,this.ericx[2],this.ericy[2],40,40);
	this.drawpwup(img_c,this.ericx[3],this.ericy[3],40,40);
	for(var j =0;j<20;j++){
		for(var i = 0;i<20;i++){
			for(var i = 0;i<20;i++){
				this.drawpwup(img_heart,this.heartx[i],this.hearty[i]-j*200,40,40);
			}		
		}		
	}


  	this.rect(this.paddlex,this.height-this.paddleh,this.paddlew,this.paddleh);    
    this.drawbricks(this.row,this.col,this.bricks,this.brickw,this.brickh,this.padding,this.big_padding);

  }

Game.prototype.updatebricks = function(){
	var rowheight = this.brickh + this.padding;
	var colwidth = this.brickw + this.padding;

	var rown = Math.floor((this.y-this.big_padding)/rowheight);
	var coln = Math.floor((this.x-this.big_padding)/colwidth);

	var tmp_h = this.y-this.big_padding; 
	if ((tmp_h < (this.row * rowheight)) && tmp_h > 0 && (rown >= 0) && (coln >= 0) && (this.bricks[rown][coln] > 0)) {
	    this.dy = -this.dy;
	    this.bricks[rown][coln] = this.bricks[rown][coln] - 1;
	    this.score = this.score + 5;
		for(var i=0;i<2;i++){
			if((rown == this.pwuprow1[i])&&(coln == this.pwupcol1[i])){
				this.pwupx[0] = Math.min(this.x,this.width - this.brickw/2);
				this.pwupy[0] = this.y;
				this.pwupdy[0] = 3; 
			}
			if((rown == this.pwuprow2[i])&&(coln == this.pwupcol2[i])){
				this.pwupx[1] = Math.min(this.x,this.width - this.brickw/2);
				this.pwupy[1] = this.y;
				this.pwupdy[1] = 3; 
			}
		}
	   for(var i = 0; i<4;i++){
		   if(rown == this.ericrandomx[i] && coln == this.ericrandomy[i]){
				this.ericx[i] = Math.min(this.x,this.width - this.brickw/2);
				this.ericy[i] = this.y;
				this.ericdy[i] = 2;
			}
		}
		this.bricksnum--;
		if(this.bricksnum == 0){
			this.status = 1;
		}   
	}
	this.pwupy[0] += this.pwupdy[0];
	this.pwupy[1] += this.pwupdy[1];

	for(var i = 0;i<4;i++){
		this.ericy[i] += this.ericdy[i];
	}
}

Game.prototype.updatepaddle = function(){
	for(var i = 0; i < 2; i ++){
		if(this.pwupy[i] + this.pwupdy[i] > this.height - this.paddleh){
			if((this.pwupx[i] > this.paddlex)&&(this.pwupx[i]<(this.paddlex + this.paddlew))){
				this.paddlew += (-40*i + 20);
				this.score += (-8*i + 4);
				this.pwupx[i] = 0;
				this.pwupy[i] = this.height + 50;
				this.pwupdy[i] = 0;
			}	
		}
	}
	for(var i = 0; i < 4; i ++){
		if(this.ericy[i] + this.ericdy[i] > this.height - this.paddleh){
			if((this.ericx[i] > this.paddlex)&&(this.ericx[i]<(this.paddlex + this.paddlew))){
				var nametext = document.getElementById("nametext"+this.text[i]);
				nametext.innerHTML = this.text[i];
				this.ericx[i] = 0;
				this.ericy[i] = this.height + 50;
				this.ericdy[i] = 0;
				this.wordcount ++;
			}	
		}
	}	
	if(this.wordcount == 4){
		for(var i = 0;i<20; i++){
			this.heartx[i] = 20 + i*70;
			this.hearty[i] = 300 +i*60;
			this.heartdy[i] = 1.5;
		}
		this.dy = 0;
		this.dx = 0;

		this.wordcount = 5;
	/*	
		for(var i=0;i<this.row;i++){
			for(var j=0;j<this.col;j++){
				this.bricks[i][j] =0;
			}
		}
	*/
	}

	if (this.x + this.dx > this.width || this.x + this.dx < 0){
		this.dx = -this.dx;
	}
  	if (this.y + this.dy < 0){
  		this.dy = -this.dy;
  	}
	else if(this.y + this.dy > this.height - this.paddleh){
    	if((this.x > this.paddlex)&&(this.x<(this.paddlex + this.paddlew))){		
			var delta = this.x - this.paddlex;
			var diff = Math.max(delta - this.l,this.l-delta);
			if(this.dx < 0)
				this.dx = Math.max(this.dx + this.dx * (diff/this.l),-4.5);
			else
				this.dx = Math.min(this.dx + this.dx * (diff/this.l),4.5);

			this.dy = -this.dy;
		}
		else
			this.status = 2;                                     
	}
	var scoretext = document.getElementById("scoreboard");
	scoretext.innerHTML = this.score;	    
}

Game.prototype.update = function(keys){
	// TODO: put all logical updates here
	this.x += this.dx;
  	this.y += this.dy;
	for(var i =0;i<20;i++){
	this.hearty[i] += this.heartdy;}
    
	this.ctx.clearRect(0,0,this.width,this.height);
	if(keys[37])
	    this.paddlex = Math.max(this.paddlex - 10,0);
	if(keys[39])
	    this.paddlex = Math.min(this.paddlex + 10, this.width-this.paddlew);

	this.updatebricks();
	this.updatepaddle();

	if(keys[27])
	{
		this.status = 5; //Valentine's ending
	}

}

Game.prototype.showimage = function(status){
	var endimage = document.getElementById("endimage");
	if(status == 1)
		endimage.src = "img/smile.png";
	else if(status == 2)
		endimage.src = "img/evil_small.png";
	else if(status == 0)
		endimage.src = "img/bg.png";

}

function MediumGame() {}
MediumGame.prototype = new Game();
MediumGame.prototype.paddlew = 120;
MediumGame.prototype.dx = 3.5;
MediumGame.prototype.dy = 3.5;
MediumGame.prototype.ballcolor = "#6077db";

MediumGame.prototype.initbricks = function(){
	for (i=0; i < this.row; i++) {
		this.bricks[i] = new Array(this.col);
			for (j=0; j < this.col; j++) {
				if(i == 2 && j!=2)
					this.bricks[i][j] = 2;
				else
					this.bricks[i][j] = 1;
			}
        }

}
MediumGame.prototype.bricksnum = (MediumGame.prototype.row + 1)* MediumGame.prototype.col - 1;


function HardGame(){}
HardGame.prototype = new Game();
HardGame.prototype.paddlew = 100;
HardGame.prototype.dx = 4;
HardGame.prototype.dy = 4;
HardGame.prototype.ballcolor = "#69a669";

HardGame.prototype.initbricks = function(){
	for (i=0; i < this.row; i++) {
		this.bricks[i] = new Array(this.col);
			for (j=0; j < this.col; j++) {
				if(i == 3)
					this.bricks[i][j] = 2;
				else
					this.bricks[i][j] = 1;
			}
        }

}
HardGame.prototype.bricksnum = (HardGame.prototype.row + 1)* HardGame.prototype.col;
