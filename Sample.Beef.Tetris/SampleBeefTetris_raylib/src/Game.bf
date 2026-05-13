namespace SampleBeefTetris_raylib;
using RaylibBeef;
using SampleBeefTetris;

class Game
{
	GameState _gameState;
	Keyboard _keyboard;
	Timer _logicTimer;

	public this(int seed)
	{
		_gameState = new GameState(seed, Const.FIELD_WIDTH, Const.FIELD_HEIGHT);
		_logicTimer = Timer(1);
	};

	public ~this()
	{
		delete _gameState;
	}

	public void UpdateKey()
	{
		_keyboard.Update();
	}

	public void ProcessInput(double dt)
	{
		if (_keyboard.IsKeyPressed(Keyboard.E_KEY.LEFT))
		{
			_gameState.ProcessCommand(GameState.E_COMMAND.LEFT);
		}

		if (_keyboard.IsKeyPressed(Keyboard.E_KEY.RIGHT))
		{
			_gameState.ProcessCommand(GameState.E_COMMAND.RIGHT);
		}

		if (_keyboard.IsKeyPressed(Keyboard.E_KEY.DOWN))
		{
			_gameState.ProcessCommand(GameState.E_COMMAND.DOWN);
		}

		if (_keyboard.IsKeyPressed(Keyboard.E_KEY.ROTATE))
		{
			_gameState.ProcessCommand(GameState.E_COMMAND.ROTATE);
		}

		if (_keyboard.IsKeyPressed(Keyboard.E_KEY.DROP))
		{
			_gameState.ProcessCommand(GameState.E_COMMAND.DROP);
		}
	}

	public void FixedUpdate(double fixed_dt)
	{
		if (_gameState.IsGameOver)
		{
			return;
		}

		ProcessInput(fixed_dt);
		_gameState.ProcessCommand(GameState.E_COMMAND.UPDATE_SHADOW_POS);

		if (!_logicTimer.Tick(fixed_dt))
		{
			return;
		}

		_gameState.ProcessCommand(GameState.E_COMMAND.SOFT_DROP_TICK);
	}

	public void Render()
	{
		Table table = _gameState.Table;
		_RenderTable(table);

		if (!_gameState.IsGameOver)
		{
			_RenderShape(_gameState.CurrPos, _gameState.GetCurrShape());

			int2 shadowPos;
			if (_gameState.ShadowPosOrNull.TryGetValue(out shadowPos))
			{
				_RenderShadowShape(shadowPos, _gameState.GetCurrShape());
			}

			_RenderShape(int2(12, 2), _gameState.GetNextShape());
			return;
		}

		// render GameOver
		char8* text = Raylib.TextFormat("GAME OVER");
		int32 fontSize = 40;
		int textWidth = Raylib.MeasureText(text, fontSize);
		int32 x = (int32)(Const.WINDOW_WIDTH / 2 - textWidth / 2);
		int32 y = Const.WINDOW_HEIGHT / 3;
		Raylib.DrawText(text, x, y, fontSize, Raylib.RED);
	}

	void _RenderTable(Table table)
	{
		{
			// render bg
			Rectangle r_bg = Rectangle(0, 0, Const.BLOCK_SIZE * Const.FIELD_WIDTH, Const.BLOCK_SIZE * Const.FIELD_HEIGHT);
			Raylib.DrawRectangleRec(r_bg, Const.COLOR_BACKGROUND);
		}

		// render shape
		int screenOffset = 2;
		Rectangle r_shape = ?;
		r_shape.width = Const.BLOCK_SIZE - screenOffset;
		r_shape.height = Const.BLOCK_SIZE - screenOffset;

		for (Table.Item item in table)
		{
			E_SHAPE e = item.e;
			if (e == E_SHAPE.NONE)
			{
				continue;
			}

			int x = item.x;
			int y = item.y;
			Color color = _E_SHAPE_ToColor(e);
			float screenX = x * Const.BLOCK_SIZE + screenOffset;
			float screenY = y * Const.BLOCK_SIZE + screenOffset;
			r_shape.x = screenX;
			r_shape.y = screenY;

			Raylib.DrawRectangleRec(r_shape, color);
		}
	}

	void _RenderShape(int2 pos, Shape* shape)
	{
		__RenderShape(pos, shape, 255);
	}

	void _RenderShadowShape(int2 pos, Shape* shape)
	{
		__RenderShape(pos, shape, 128);
	}

	void __RenderShape(int2 pos, Shape* shape, uint8 alpha)
	{
		Rectangle r = ?;
		int screenOffset = 2;
		r.width = Const.BLOCK_SIZE - screenOffset;
		r.height = Const.BLOCK_SIZE - screenOffset;

		E_SHAPE e = shape.name;
		Color color = _E_SHAPE_ToColor(e);
		color.a = alpha;

		for (int2 p in *shape)
		{
			int x = pos.x + p.x;
			int y = pos.y + p.y;
			float screenX = x * Const.BLOCK_SIZE + screenOffset;
			float screenY = y * Const.BLOCK_SIZE + screenOffset;
			r.x = screenX;
			r.y = screenY;
			Raylib.DrawRectangleRec(r, color);
		}
	}

	Color _E_SHAPE_ToColor(E_SHAPE eShape)
	{
		switch (eShape)
		{
		case E_SHAPE.NONE: return Const.COLOR_BACKGROUND;
		case E_SHAPE.L: return Const.COLOR_L;
		case E_SHAPE.J: return Const.COLOR_J;
		case E_SHAPE.T: return Const.COLOR_T;
		case E_SHAPE.S: return Const.COLOR_S;
		case E_SHAPE.Z: return Const.COLOR_Z;
		case E_SHAPE.I: return Const.COLOR_I;
		case E_SHAPE.O: return Const.COLOR_O;
		default: return  Const.COLOR_BACKGROUND;
		}
	}
}