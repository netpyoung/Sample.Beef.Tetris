using System;
using RaylibBeef;
using SampleBeefTetris;

namespace SampleBeefTetris_raylib;

class Program
{
	public static int Main(String[] args)
	{
		Raylib.SetConfigFlags(.FLAG_WINDOW_RESIZABLE);
		Raylib.InitWindow(Const.WINDOW_WIDTH, Const.WINDOW_HEIGHT, Const.WINDOW_TITLE);
		defer Raylib.CloseWindow();

		Raylib.SetTargetFPS(99);
		//Raylib.SetTargetFPS(60);
		//Raylib.InitAudioDevice();

		Time time = Time(60);

		Game game = _MakeGame();
		defer delete game;

		while (!Raylib.WindowShouldClose())
		{
			time.Update();

			while (time.ShouldTick())
			{
				game.UpdateKey();
				game.FixedUpdate(time.FixedDt);
				time.ConsumeTick();
			}

			Raylib.BeginDrawing();
			{
				Raylib.ClearBackground(Raylib.DARKBROWN);
				{
					game.Render();
				}
				Raylib.DrawFPS(10, 10);
			}
			Raylib.EndDrawing();
		}

		return 0;
	}

	static Game _MakeGame()
	{
#if DEBUG
		Game game = new Game(100);
#else
		int gameSeed = ?;
		{
			Random random = new Random((int32)Platform.BfpSystem_GetTimeStamp());
			defer delete random;
			gameSeed = random.NextI32();
		}
		Game game = new Game(gameSeed);
#endif
		return game;
	}
}
