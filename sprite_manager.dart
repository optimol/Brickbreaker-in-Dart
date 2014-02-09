import 'dart:html' show ImageElement;

class SpriteManager
{
    Map < String, ImageElement > _mSpriteMap;
    var _mCallback;
    int _mLoadCount;

    Map < String, ImageElement > get spriteMap => _mSpriteMap;

    set loadCallback(var loadCallback)
    {
        _mCallback = loadCallback;
    }

    SpriteManager()
    {
        _mSpriteMap = new Map < String, ImageElement > ();
        _mLoadCount = 0;
    }

    void setLoadCallback(var
            function)
    {
        _mCallback = function;
    }

    void addSprite(String path)
    {
        _mSpriteMap[path] = new ImageElement();
    }

    void triggerLoad()
    {
        for(String path in _mSpriteMap.keys)
        {
            ImageElement ie = _mSpriteMap[path];
            ie.onLoad.listen(_loaded);
            ie.src = path;
        }
    }

    void _loaded(_)
    {
        ++_mLoadCount;
        if(_mLoadCount == _mSpriteMap.length)
        {
            loadComplete();
        }
    }

    void loadComplete()
    {
        _mCallback(this);
    }

}
