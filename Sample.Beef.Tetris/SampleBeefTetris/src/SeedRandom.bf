using System;
namespace SampleBeefTetris;

class SeedRandom
{
	private Random _rand;

	public this(int seed)
	{
		_rand = new Random(seed);
	}

	public ~this()
	{
		delete _rand;
	}

	public int Next(int min, int max)
	{
		return _rand.Next(min, max);
	}
}