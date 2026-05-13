namespace SampleBeefTetris_raylib;

using RaylibBeef;

struct Time
{
	const int TARGET_FPS = 60;

	public double FixedDt { get; private set mut; }
	double _accumulator;
	double _prev;

	public this(int target_fps)
	{
		float fixed_dt = 1.0f / target_fps;

		FixedDt = fixed_dt;
		_accumulator = 0;
		_prev = Raylib.GetTime();
	}

	public void Update() mut
	{
		double now = Raylib.GetTime();
		double frameTime = now - _prev;
		_prev = now;
		_accumulator += frameTime;
	}

	public bool ShouldTick()
	{
		return _accumulator >= FixedDt;
	}

	public void ConsumeTick() mut
	{
		_accumulator -= FixedDt;
	}
}