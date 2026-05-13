namespace SampleBeefTetris;
using System;
using System.Diagnostics;
using System.Collections;

class Table : IEnumerable<Item>
{
	int _width;
	int _height;
	int[] _arr;
	int[] _buffForIndex;
	Span<int> _arrView;
	Span<int> _buffView;

	public this(int width, int height)
	{
		_width = width;
		_height = height;

		int size = width * height;
		_arr = new int[size];
		_buffForIndex = new int[height];
		_arrView = _arr;
		_buffView = _buffForIndex;
	}

	public ~this()
	{
		delete _arr;
		delete _buffForIndex;
	}

	public override void ToString(String strBuffer)
	{
		for (let item in this)
		{
			if (item.e == .NONE)
			{
				strBuffer.Append(".");
			}
			else
			{
				item.e.ToString(strBuffer);
			}

			if (item.x == _width - 1)
			{
				strBuffer.Append("\n");
			}
		}
	}

	public E_SHAPE GetValue(int x, int y)
	{
		Debug.Assert(0 <= x && x < _width);
		Debug.Assert(0 <= y && y < _height);

		int idx = x + y * _width;
		int curr = _arr[idx];
		E_SHAPE e = (E_SHAPE)curr;
		return e;
	}

	public void ShapeIntoTable(int2 p, Shape* shape)
	{
		int v = (int)shape.name;
		for (int2 shapep in *shape)
		{
			int x = p.x + shapep.x;
			int y = p.y + shapep.y;
			Debug.Assert(x >= 0);
			Debug.Assert(y >= 0);
			Debug.Assert(x < _width);
			Debug.Assert(y < _height);

			int w = _width;
			int idx = x + y * w;
			_arr[idx] = v;
		}
	}

	public bool IsCollision(Shape* shape)
	{
		for (int2 p in *shape)
		{
			int x = p.x;
			int y = p.y;

			if (x < 0 || _width <= x)
			{
				return true;
			}
			if (y < 0 || _height <= y)
			{
				return true;
			}
			int w = _width;
			int idx = (int)(x + y * w);
			int v = _arr[idx];
			E_SHAPE e = (E_SHAPE)v;
			if (e != E_SHAPE.NONE)
			{
				return true;
			}
		}

		return false;
	}

	public int RemoveFulledRows()
	{
		Span<int> fulledIndexes = _FindFulledRowIndexes();
		if (fulledIndexes.Length == 0)
		{
			return 0;
		}

		int w = _width;

		// compact
		for (int fulledIndex in fulledIndexes)
		{
			if (fulledIndex == 0)
			{
				_arrView[0 ..< w].Clear();
				continue;
			}

			int y = fulledIndex;
			while (y > 0)
			{
				int idx_0 = y * w;
				int idx_1 = (y - 1) * w;

				Span<int> src = _arrView[idx_1 ..< (idx_1 + w)];
				Span<int> dst = _arrView[idx_0 ..< (idx_0 + w)];
				src.CopyTo(dst);

				y -= 1;
			}
		}
		return fulledIndexes.Length;
	}

	Span<int> _FindFulledRowIndexes()
	{
		int w = _width;

		int count = 0;
		for (int y in 0 ..< _height)
		{
			int idx = y * _width;
			int indexOf = _arrView[idx ..< (idx + w)].IndexOf(0);
			if (indexOf == -1)
			{
				_buffForIndex[count] = y;
				count += 1;
			}
		}

		return _buffView[0 ..< count];
	}

	bool _IsRowFull(int[] fulled_rows, int row)
	{
		return fulled_rows.IndexOf(row) != -1;
	}

	public Enumerator GetEnumerator()
	{
		return Enumerator.Get(_arr, _width);
	}

	public struct Item
	{
		public E_SHAPE e;
		public int x;
		public int y;

		public this(E_SHAPE e, int x, int y)
		{
			this.e = e;
			this.x = x;
			this.y = y;
		}
	}

	public struct Enumerator : IEnumerator<Item>
	{
		Span<int> _slice;
		int _x;
		int _y;
		int _width;

		[Inline]
		public static Enumerator Get(Span<int> arr, int width)
		{
			Enumerator ret = ?;
			ret._slice = arr;
			ret._width = width;
			ret._x = 0;
			ret._y = 0;
			return ret;
		}


		[Inline]
		public Result<Item> GetNext() mut
		{
			if (_slice.Length == 0)
			{
				return .Err;
			}

			int v = _slice[0];
			_slice.Adjust(1);
			E_SHAPE e = (E_SHAPE)v;
			int x = _x;
			int y = _y;

			_x += 1;
			if (_x == _width)
			{
				_x = 0;
				_y += 1;
			}
			return Item(e, x, y);
		}
	}
}