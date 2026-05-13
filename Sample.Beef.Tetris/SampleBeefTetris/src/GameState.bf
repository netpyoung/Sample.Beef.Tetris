using System;

namespace SampleBeefTetris;

class GameState
{
	public enum E_COMMAND
	{
		LEFT,
		RIGHT,
		DOWN,
		ROTATE,
		DROP,
		SOFT_DROP_TICK,
		UPDATE_SHADOW_POS,
	}

	const int2 P_DOWN = int2(0, 1);

	public Table Table { get; private set; }
	public int2 CurrPos { get; private set; }
	public int2? ShadowPosOrNull { get; private set; }
	public bool IsGameOver { get; private set; }
	int _initialSeed;
	int2 _initPos;
	ShapeBox _shapeBox;

	public this(int seed, int w, int h)
	{
		int initX = w / 2 - 1;
		int initY = 2;
		int2 initP = int2(initX, initY);
		int2 curP = initP;

		Table = new Table(w, h);
		_shapeBox = new ShapeBox(seed);
		_initialSeed = seed;
		_initPos = initP;
		CurrPos = curP;
		ShadowPosOrNull = null;
		IsGameOver = false;
	}

	public ~this()
	{
		delete Table;
		delete _shapeBox;
	}

	public Shape* GetCurrShape()
	{
		return _shapeBox.GetCurrShape();
	}

	public Shape* GetNextShape()
	{
		return _shapeBox.GetNextShape();
	}

	public int2? GetHardDropPosOrNull()
	{
		Shape* currShape = _shapeBox.GetCurrShape();

		int2 tempP = CurrPos;
		while (true)
		{
			int2 moveP = tempP + P_DOWN;
			Shape moveShape = *currShape + moveP;
			if (Table.IsCollision(&moveShape))
			{
				break;
			}
			tempP = moveP;
		}

		if (tempP == CurrPos)
		{
			return null;
		}

		return tempP;
	}

	public void ProcessCommand(E_COMMAND cmd)
	{
		switch (cmd) {
		case .LEFT:
			{
				_DoMove(int2.LEFT);
			}
		case .RIGHT:
			{
				_DoMove(int2.RIGHT);
			}
		case .DOWN:
			{
				_SoftDrop();
			}
		case .ROTATE:
			{
				_DoRotate();
			}
		case .DROP:
			{
				_HardDrop();
			}
		case .SOFT_DROP_TICK:
			{
				_SoftDropTick();
				ShadowPosOrNull = GetHardDropPosOrNull();
			}
		case .UPDATE_SHADOW_POS:
			{
				ShadowPosOrNull = GetHardDropPosOrNull();
				ShadowPosOrNull = GetHardDropPosOrNull();
			}
		}
	}

	bool _DoMove(int2 p)
	{
		int2? movepOrNull = ?;
		if (!_TryMove(p, out movepOrNull))
		{
			return false;
		}
		CurrPos = movepOrNull.Value;
		return true;
	}

	bool _TryMove(int2 p, out int2? outMovep)
	{
		Shape* currShape = _shapeBox.GetCurrShape();
		int2 moveP = CurrPos + p;
		Shape moveShape = *currShape + moveP;
		if (Table.IsCollision(&moveShape))
		{
			outMovep = null;
			return false;
		}
		outMovep = moveP;
		return true;
	}

	bool _DoRotate()
	{
		Shape* curRotShape = _shapeBox.GetCurrRotateShape();
		Shape shape = *curRotShape + CurrPos;
		if (Table.IsCollision(&shape))
		{
			return false;
		}

		_shapeBox.Rotate();
		return true;
	}

	void _SoftDrop()
	{
		_DoMove(P_DOWN);
	}

	void _HardDrop()
	{
		while (_DoMove(P_DOWN))
		{
		}

		_PutShape();
	}

	void _SoftDropTick()
	{
		if (_DoMove(P_DOWN))
		{
			return;
		}

		_PutShape();
	}

	void _PutShape()
	{
		if (IsGameOver)
		{
			return;
		}

		int2 currPos = CurrPos;
		Shape* currShape = _shapeBox.GetCurrShape();
		Table.ShapeIntoTable(currPos, currShape);
		_shapeBox.SetNextShape();
		CurrPos = _initPos;

		Table.RemoveFulledRows();
		// int removedCount = Table.RemoveFulledRows();
		// _ = removedCount;

		int2? movep = ?;
		if (_TryMove(int2.ZERO, out movep))
		{
			return;
		}
		IsGameOver = true;
	}
}