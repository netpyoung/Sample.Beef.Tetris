using System;
using System.Collections;
namespace SampleBeefTetris;

struct Shape : IEnumerable<int2>
{
	public E_SHAPE name;
	public int pointlen;
	public int2[16] points;

	public static Shape CreateShape(E_SHAPE name, Span<int2> points)
	{
		Shape ret = ?;
		ret.name = name;
		ret.pointlen = points.Length;
		ret.points.SetAll(int2.ZERO);
		points.CopyTo(ret.points);

		return ret;
	}

	public Shape Rotate()
	{
		Shape ret = ?;
		ret.name = name;
		ret.pointlen = pointlen;
		ret.points.SetAll(int2.ZERO);
		for (int i in 0 ..< pointlen)
		{
			ret.points[i] = points[i].Rotate();
		}
		return ret;
	}

	public static Shape operator +(Shape origin, int2 y)
	{
		int2[16] buff = ?;
		Span<int2> buffSpan = buff;
		buffSpan = buffSpan[0 ..< origin.pointlen];

		Span<int2> originPoints = origin.points;
		originPoints.CopyTo(buffSpan);
		for (ref int2 valRef in ref buffSpan)
		{
			valRef.x += y.x;
			valRef.y += y.y;
		}
		return CreateShape(origin.name, buffSpan);
	}

	public static int operator <=>(Shape lhs, Shape rhs)
	{
		int cmp_name = lhs.name <=> rhs.name;
		if (cmp_name != 0)
		{
			return cmp_name;
		}
		int cmp_len = lhs.pointlen <=> rhs.pointlen;
		if (cmp_name != 0)
		{
			return cmp_len;
		}

		for (int i in 0 ..< lhs.pointlen)
		{
			int cmp = lhs.points[i] <=> rhs.points[i];
			if (cmp != 0)
			{
				return cmp;
			}
		}
		return 0;
	}



	public override void ToString(String strBuffer)
	{
		strBuffer.Append(scope $"{name} [");
		for (int i in 0 ..< pointlen)
		{
			points[i].ToString(strBuffer);
			if (i != pointlen - 1)
			{
				strBuffer.Append(", ");
			}
		}
		strBuffer.Append("]");
	}

	public Enumerator GetEnumerator()
	{
		return Enumerator(points, pointlen);
	}

	public struct Enumerator : IEnumerator<int2>
	{
		private Span<int2> _arr;
		private int _idxCur;
		private int _idxEnd;

		[Inline]
		public this(Span<int2> arr, int end)
		{
			_arr = arr;
			_idxCur = 0;
			_idxEnd = end;
		}

		[Inline]
		public Result<int2> GetNext() mut
		{
			if (_idxCur >= _idxEnd)
			{
				return .Err;
			}
			int2 ret = _arr[_idxCur];
			_idxCur++;
			return ret;
		}
	}
}