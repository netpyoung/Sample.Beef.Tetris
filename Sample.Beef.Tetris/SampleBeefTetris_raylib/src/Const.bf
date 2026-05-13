namespace SampleBeefTetris_raylib;
using System;
using RaylibBeef;

class Const
{
	public const String WINDOW_TITLE = "Hello Beef Tetris";
	public const int WINDOW_WIDTH = 400;
	public const int WINDOW_HEIGHT = 600;

	public const int FIELD_WIDTH = 10;
	public const int FIELD_HEIGHT = 20;

	public const int BLOCK_SIZE = 25;
	public const int SEC_PER_PROCESS_GAME_INIT = 1;

	public const Color COLOR_L = Color(128,   0, 128, 255);
	public const Color COLOR_J = Color(255, 255, 255, 255);
	public const Color COLOR_T = Color(255, 255,   0, 255);
	public const Color COLOR_S = Color(  0, 255,   0, 255);
	public const Color COLOR_Z = Color(  0, 255, 255, 255);
	public const Color COLOR_I = Color(255,   0,   0, 255);
	public const Color COLOR_O = Color(  0,   0, 255, 255);
	public const Color COLOR_BACKGROUND = Color(0,  0,  0, 255);
}