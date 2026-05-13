using System;
using System.IO;
namespace SampleBeefTetris_Test;

class Assert
{
	public static void FatalError(String msg = "Test fatal error encountered", String filePath = Compiler.CallerFilePath, int line = Compiler.CallerLineNum)
	{
		String failStr = scope .()..AppendF("{} at line {} in {}", msg, line, filePath);
		if (Compiler.IsComptime)
			Internal.FatalError(failStr);
		else
			Internal.[Friend]Test_Error(failStr);
	}

	public static void True(bool condition, String msg, String error = Compiler.CallerExpression[0], String filePath = Compiler.CallerFilePath, int line = Compiler.CallerLineNum)
	{
		if (!condition)
		{
			if ((!Compiler.IsComptime) && (Runtime.CheckAssertError != null) && (Runtime.CheckAssertError(.Test, error, filePath, line) == .Ignore))
				return;
			String failStr = scope .()..AppendF("Assert failed: {}\n{}:{}\n{}", error, filePath, line, msg);
			if (Compiler.IsComptime)
				Internal.FatalError(failStr);
			else
				Internal.[Friend]Test_Error(failStr);
		}
	}

	public static void True(bool condition, Object obj, String error = Compiler.CallerExpression[0], String filePath = Compiler.CallerFilePath, int line = Compiler.CallerLineNum)
	{
		if (!condition)
		{
			if ((!Compiler.IsComptime) && (Runtime.CheckAssertError != null) && (Runtime.CheckAssertError(.Test, error, filePath, line) == .Ignore))
				return;
			String failStr = scope .()..AppendF("Assert failed: {}\n{}:{}\n{}", obj, filePath, line, error);
			if (Compiler.IsComptime)
				Internal.FatalError(failStr);
			else
				Internal.[Friend]Test_Error(failStr);
		}
	}

	public static void Equals<T>(T obj1, T obj2, String error = Compiler.CallerExpression[0], String filePath = Compiler.CallerFilePath, int line = Compiler.CallerLineNum)
	{
		if (obj1 != obj2)
		{
			if ((!Compiler.IsComptime) && (Runtime.CheckAssertError != null) && (Runtime.CheckAssertError(.Test, error, filePath, line) == .Ignore))
				return;
			String failStr = scope .()..AppendF("Assert failed: {} != {}\n{}:{}\n{}", obj1, obj2, filePath, line, error);
			if (Compiler.IsComptime)
				Internal.FatalError(failStr);
			else
				Internal.[Friend]Test_Error(failStr);
		}
	}
}
