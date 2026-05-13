namespace SampleBeefTetris_raylib;

struct Timer
{
	double _accSec;
	double _targetSec;

	public this(double targetSec)
	{
		_accSec = 0;
		_targetSec = targetSec;
	}

	public bool Tick(double dt) mut
	{
		_accSec += dt;
		if (_accSec < _targetSec)
		{
			return false;
		}
		_accSec = 0;
		return true;
	}

	public bool IsTicked()
	{
		return _accSec == 0;
	}
}