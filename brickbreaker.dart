import 'dart:html';
import 'dart:math' show PI;
import 'dart:async' show Timer;
import 'brick.dart' show Brick;
import 'sprite_manager.dart' show SpriteManager;

class BrickBreaker
{
    CanvasRenderingContext2D _ctx;

    num _ballY, _ballX;
    num _ballVx = -3;
    num _ballVy = -5;
    num _ballRad = 5;

    num _padY;
    num _padX;
    num _padWidth = 65;
    num _padHeight = 5;
    num _padJump;

    int _height;
    int _width;

    List < Brick > _brickList;

    bool _keyLeftArrow = false, _keyRightArrow = false;

    int _score = 0;
    ParagraphElement scoreDisplay;
    InputElement _slider;

    bool _paused = false;

    DivElement _finalScore, _controls;

    ImageElement _explosionSprite;

    int _level = 2;

    Timer _gameTimer;

    ImageElement get explosionSprite => _explosionSprite;
    CanvasRenderingContext2D get context => _ctx;

    void _generateField()
    {
        num brickW = _width / 20;
        num brickH = _ballRad * 5;
        num by = _height / 10;
        _ctx.fillStyle = "#000";
        for(int i = 0; i < 5; ++i)
        {
            num bx = _width / 15;
            for(int j = 0; j < 5; ++j)
            {
                _brickList.add(new Brick(bx.toInt(), by.toInt(), brickW.toInt(), brickH.toInt(), this));
                bx += 4 * brickW;
            }
            by += 4 * brickH;
        }
    }

    void newGame()
    {
        _stopTimers();
        _finalScore.style.visibility = 'hidden';
        _controls.style.visibility = '';

        _ctx.clearRect(0, 0, _width, _height);
        _ballVx = -(3 + 0.5 * _level);
        _ballVy = -(5 + 0.5 * _level);
        _brickList.clear();
        _generateField();
        _score = 0;
        scoreDisplay.text = "$_score";

        _ballX = _padX + _padWidth / 2;
        _ballY = _padY - _ballRad;

        _ctx.fillRect(_padX, _padY, _padWidth, _padHeight);
        _keyLeftArrow = _keyRightArrow = false;
        _setTimers();
    }

    void _gameTick(Timer t)
    {
        _ctx.clearRect(0, 0, _width, _height);
        if(_keyLeftArrow)
        {
            if(_padX > 0)
                _padX -= _padJump;
        }
        else if(_keyRightArrow)
        {
            if(_padX + _padWidth < _width)
                _padX += _padJump;
        }

        _ctx.fillStyle = "#000000";
        _ctx.fillRect(_padX, _padY, _padWidth, _padHeight);
        _ballX = _ballX + _ballVx;
        _ballY = _ballY + _ballVy;

        _ctx.fillStyle = "#FF0000";
        _ctx.beginPath();
        _ctx.arc(_ballX, _ballY, _ballRad, 0, 2 * PI, false);
        _ctx.fill();
        _ctx.closePath();

        if(_ballX <= _ballRad || _ballX >= _width - _ballRad)
        {
            _ballVx = -_ballVx;
        }
        if(_ballY <= _ballRad)
        {
            _ballVy = -_ballVy;
        }

        if(_ballX >= _padX && _ballX <= _padX + _padWidth && _ballY >= _height - 15) // && ballY<=height-6)
        {
            _ballVy = -_ballVy;
            _ctx.fillStyle = "#000";
        }
        for(Brick b in _brickList)
        {
            if(!b.destroyed && b.collision(_ballX, _ballY, _ballRad))
            {
                _score += 1;
                if(_score == 25)
                {
                    _finalScore.style.visibility = '';
                    querySelector("#scorefin")
                        .text = "$_score";
                    _controls.style.visibility = 'hidden';
                    window.alert("You Win!!!");
                    _stopTimers();
                    return;
                }
                scoreDisplay.text = "$_score";
                if(((_ballX + _ballRad > b.x) && (_ballX - _ballRad < b.x + b.brickW)) && ((_ballY - _ballRad < b.y) || (_ballY + _ballRad > b.y + b.brickH)))
                {
                    _ballVy *= -1;
                }
                else
                {
                    _ballVx *= -1;
                }
            }
            b.gameTick();
        }
        if(_ballY > _height - 3)
        {
            querySelector("#scorefin")
                .text = "$_score";
            _controls.style.visibility = 'hidden';
            _finalScore.style.visibility = '';
            window.alert("You lose!!!");
            _stopTimers();
        }
    }

    void _setTimers()
    {
        _gameTimer = new Timer.periodic(new Duration(milliseconds: 20), _gameTick);
    }

    void _stopTimers()
    {
        if(_gameTimer != null && _gameTimer.isActive)
            _gameTimer.cancel();
    }

    BrickBreaker()
    {
        CanvasElement canvas = querySelector("#canvas");
        _ctx = canvas.getContext("2d");
        _height = canvas.height;
        _width = canvas.width;

        _padX = _width / 2;
        _padY = _height - 5;
        _padJump = _width / 45;

        SpriteManager sm = new SpriteManager();
        sm.loadCallback = (SpriteManager sm)
        {
            _explosionSprite = sm.spriteMap["images/explosion.png"];
            newGame();
        };
        sm.addSprite("images/explosion.png");
        sm.triggerLoad();

        scoreDisplay = querySelector("#score");
        _finalScore = querySelector("#finalScore");
        _brickList = new List();
        _slider = querySelector("#slider");
        _controls = querySelector("#gameplay");

        window.onKeyDown.listen((KeyboardEvent ke)
        {
            switch(ke.keyCode)
            {
            case 37:
                _keyLeftArrow = true;
                break;
            case 39:
                _keyRightArrow = true;
                break;
            }
        });
        window.onKeyUp.listen((KeyboardEvent ke)
        {
            switch(ke.keyCode)
            {
            case 37:
                _keyLeftArrow = false;
                break;
            case 39:
                _keyRightArrow = false;
                break;
            }
        });

        _slider.onChange.listen((Event e)
        {
            _level = int.parse(_slider.value) + 1;
            var sign = 1;
            sign = _ballVx < 0 ? -1 : 1;
            _ballVx = (3 + 0.5 * _level) * sign;
            sign = _ballVy < 0 ? -1 : 1;
            _ballVy = (5 + 0.5 * _level) * sign;
        });

        querySelector('#reset')
            .onClick.listen((e)
            {
                newGame();
            });
        querySelector('#newgame')
            .onClick.listen((e)
            {
                newGame();
            });

        querySelector('#pause')
            .onClick.listen((e)
            {
                if(_paused)
                {
                    _paused = false;
                    _setTimers();
                }
                else
                {
                    _paused = true;
                    _stopTimers();
                }
            });
    }
}

void main()
{
    new BrickBreaker();
}
