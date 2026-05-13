namespace SampleBeefTetris;

class ShapeBox
{
	SeedRandom _random;
	int _currIdx;
	RotatedShape* _currShape;
	RotatedShape* _nextShape;

	public this(int seed)
	{
		_random = new SeedRandom(seed);
		_currIdx = 0;
		_currShape = _GetRandomShape(_random);
		_nextShape = _GetRandomShape(_random);
	}

	public ~this()
	{
		delete _random;
	}

	RotatedShape* _GetRandomShape(SeedRandom random)
	{
		int idx = random.Next(1, PRE_ROTATED_SHAPES.Count);
		RotatedShape* shape = &PRE_ROTATED_SHAPES[idx];
		return shape;
	}

	public void SetNextShape()
	{
		_currIdx = 0;
		_currShape = _nextShape;
		_nextShape = _GetRandomShape(_random);
	}

	public void Rotate()
	{
		_currIdx = _GetRotateIndex();
	}

	public Shape* GetCurrShape()
	{
		return &_currShape.arr[_currIdx];
	}

	public Shape* GetCurrRotateShape()
	{
		return &_currShape.arr[_GetRotateIndex()];
	}

	public Shape* GetNextShape()
	{
		return &_nextShape.arr[0];
	}

	int _GetRotateIndex()
	{
		if (_currIdx < _currShape.len - 1)
		{
			return _currIdx + 1;
		}

		return 0;
	}
}

struct RotatedShape
{
	public Shape[4] arr;
	public int len;

	public this(Shape[4] arr, int len)
	{
		this.arr = arr;
		this.len = len;
	}
}

static
{
	const int2[4] SHAPE_POINTS_NONE = .(.(0, 0), .(0, 0), .(0, 0), .(0, 0));
	const int2[4] SHAPE_POINTS_L = .(.(-1, 0), .(0, 0), .(1, 0), .(1, 1));
	const int2[4] SHAPE_POINTS_J = .(.(-1, 0), .(0, 0), .(1, -1), .(1, 0));
	const int2[4] SHAPE_POINTS_T = .(.(0, -1), .(0, 0), .(0, 1), .(1, 0));
	const int2[4] SHAPE_POINTS_S = .(.(0, 0), .(0, 1), .(1, -1), .(1, 0));
	const int2[4] SHAPE_POINTS_Z = .(.(0, -1), .(0, 0), .(1, 0), .(1, 1));
	const int2[4] SHAPE_POINTS_I = .(.(-1, 0), .(0, 0), .(1, 0), .(2, 0));
	const int2[4] SHAPE_POINTS_O = .(.(-1, -1), .(-1, 0), .(0, -1), .(0, 0));

	static Shape SHAPE_NONE = Shape.CreateShape(E_SHAPE.NONE, SHAPE_POINTS_NONE);
	static Shape SHAPE_L = Shape.CreateShape(E_SHAPE.L, SHAPE_POINTS_L);
	static Shape SHAPE_J = Shape.CreateShape(E_SHAPE.J, SHAPE_POINTS_J);
	static Shape SHAPE_T = Shape.CreateShape(E_SHAPE.T, SHAPE_POINTS_T);
	static Shape SHAPE_S = Shape.CreateShape(E_SHAPE.S, SHAPE_POINTS_S);
	static Shape SHAPE_Z = Shape.CreateShape(E_SHAPE.Z, SHAPE_POINTS_Z);
	static Shape SHAPE_I = Shape.CreateShape(E_SHAPE.I, SHAPE_POINTS_I);
	static Shape SHAPE_O = Shape.CreateShape(E_SHAPE.O, SHAPE_POINTS_O);

	static RotatedShape[8] PRE_ROTATED_SHAPES =
		.(
		.(arr: .(
		SHAPE_NONE,
		SHAPE_NONE,
		SHAPE_NONE,
		SHAPE_NONE),
		len: 0), // NONE = 0,
		.(arr: .(
		SHAPE_L,
		SHAPE_L.Rotate(),
		SHAPE_L.Rotate().Rotate(),
		SHAPE_L.Rotate().Rotate().Rotate()),
		len: 4), // L = 1,
		.(arr: .(
		SHAPE_J,
		SHAPE_J.Rotate(),
		SHAPE_J.Rotate().Rotate(),
		SHAPE_J.Rotate().Rotate().Rotate()),
		len: 4), // J = 2,
		.(arr: .(
		SHAPE_T,
		SHAPE_T.Rotate(),
		SHAPE_T.Rotate().Rotate(),
		SHAPE_T.Rotate().Rotate().Rotate()),
		len: 4), // T = 3,
		.(arr: .(
		SHAPE_S,
		SHAPE_S.Rotate(),
		SHAPE_NONE,
		SHAPE_NONE),
		len: 2), // S = 4,
		.(arr: .(
		SHAPE_Z,
		SHAPE_Z.Rotate(),
		SHAPE_NONE,
		SHAPE_NONE),
		len: 2), // Z = 5,
		.(arr: .(
		SHAPE_I,
		SHAPE_I.Rotate(),
		SHAPE_NONE,
		SHAPE_NONE),
		len: 2), // I = 6,
		.(arr: .(
		SHAPE_O,
		SHAPE_NONE,
		SHAPE_NONE,
		SHAPE_NONE),
		len: 1) // O = 7,
		);
}