namespace SampleBeefTetris_raylib;

using RaylibBeef;

struct Keyboard
{
	public enum E_KEY
	{
		LEFT = 0,
		RIGHT = 1,
		DOWN = 2,
		ROTATE = 3,
		DROP = 4,
	}

	const int KEY_COUNT = 5;

	bool[KEY_COUNT] _isKeyDownPrev;
	bool[KEY_COUNT] _isKeyDownCurr;
	bool[KEY_COUNT] _isKeyPressed;
	bool[KEY_COUNT] _isKeyReleased;

	public void Update() mut
	{
		for (int i in 0 ..< KEY_COUNT)
		{
			E_KEY e = (E_KEY)i;
			_isKeyDownCurr[i] = _IsKeyDown(e);
		}

		for (int i in 0 ..< KEY_COUNT)
		{
			if (_isKeyDownCurr[i])
			{
				if (!_isKeyDownPrev[i])
				{
					_isKeyPressed[i] = true;
					continue;
				}
			}
			if (_isKeyDownPrev[i])
			{
				if (!_isKeyDownCurr[i])
				{
					_isKeyReleased[i] = true;
					continue;
				}
			}
			_isKeyPressed[i] = false;
			_isKeyReleased[i] = false;
		}

		for (int i in 0 ..< KEY_COUNT)
		{
			_isKeyDownPrev[i] = _isKeyDownCurr[i];
		}
	}

	public bool IsKeyDown(E_KEY key)
	{
		int idx = (int)key;
		return _isKeyDownCurr[idx];
	}

	public bool IsKeyPressed(E_KEY key)
	{
		int idx = (int)key;
		return _isKeyPressed[idx];
	}

	public bool IsKeyReleased(E_KEY key)
	{
		int idx = (int)key;
		return _isKeyReleased[idx];
	}

	int32 _ToRayKeyCode(E_KEY key)
	{
		switch (key) {
		case E_KEY.LEFT: return KeyboardKey.KEY_LEFT;
		case E_KEY.RIGHT: return KeyboardKey.KEY_RIGHT;
		case E_KEY.DOWN: return KeyboardKey.KEY_DOWN;
		case E_KEY.ROTATE: return KeyboardKey.KEY_UP;
		case E_KEY.DROP: return KeyboardKey.KEY_SPACE;
		}
	}

	bool _IsKeyDown(E_KEY key)
	{
		return Raylib.IsKeyDown(_ToRayKeyCode(key));
	}
}