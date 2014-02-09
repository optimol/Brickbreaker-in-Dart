import 'brickbreaker.dart' show BrickBreaker;
import 'dart:html' show CanvasRenderingContext2D;
import 'dart:math' show Random;

class Brick
{
    bool _destroyed = false, _postDestroy = false;
    int _x, _y;
    int _brickW, _brickH;
    var color;
    static final Random _random = new Random();
    static final List < String > _randchars = '0123456789ABCDEF'.split('');
    BrickBreaker _mParent;
    int _postDestroyTicks;
    String _mColor;

    int get x => _x;
    int get y => _y;
    int get brickW => _brickW;
    int get brickH => _brickH;
    bool get destroyed => _destroyed;

    Brick(this._x, this._y, this._brickW, this._brickH, this._mParent)
    {
        _destroyed = _postDestroy = false;
        _postDestroyTicks = 0;
        var sb = new StringBuffer();
        sb.write("#");
        for(var i = 0; i < 6; ++i)
            sb.write(_randchars[_random.nextInt(_randchars.length)]);
        _mColor = sb.toString();
        this._x = _x;
        this._y = _y;
    }

    void gameTick()
    {
        if(_destroyed)
        {
            if(_postDestroyTicks < 3)
            {
                _mParent.context.drawImage(_mParent.explosionSprite, _x, _y);
                ++_postDestroyTicks;
            }
            return;
        }
        else
        {
            CanvasRenderingContext2D ctx = _mParent.context;
            ctx.fillStyle = _mColor;
            ctx.beginPath();
            ctx.fillRect(_x, _y, _brickW, _brickH);
        }
    }

    bool collision(num ballX, num ballY, num ballRad)
    {
        if(ballX + ballRad < _x || ballX - ballRad > _x + _brickW)
            return false;

        if(ballY + ballRad < _y || ballY - ballRad > _y + _brickH)
            return false;

        _destroyed = true;
        return true;
    }

}
