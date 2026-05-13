namespace SampleBeefTetris;

struct int2
{
	public int x;
	public int y;

	public this(int x, int y)
	{
		this.x = x;
		this.y = y;
	}

	public const int2 MINUSONE = int2(-1, -1);
	public const int2 ONE = int2(1, 1);
	public const int2 ZERO = int2(0, 0);
	public const int2 LEFT = int2(-1, 0);
	public const int2 RIGHT = int2(1, 0);
	public const int2 UP = int2(0, 1);
	public const int2 DOWN = int2(0, -1);

	public static int2 operator +(int2 lhs, int2 rhs)
	{
		return int2(lhs.x + rhs.x, lhs.y + rhs.y);
	}

	public static int operator <=>(int2 lhs, int2 rhs)
	{
		int cmp = lhs.x <=> rhs.x;
		if (cmp != 0)
		{
			return cmp;
		}

		return lhs.y <=> rhs.y;
	}

	public int2 Rotate()
	{
		return int2(-this.y, this.x);
	}

	public override void ToString(System.String strBuffer)
	{
		strBuffer.Append(scope $"x={this.x} y={this.y}");
	}
}
