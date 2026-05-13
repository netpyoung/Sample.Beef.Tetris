using System;
using SampleBeefTetris;
namespace SampleBeefTetris_Test;

class Shape_Test
{
	[Test]
	public static void TestAPI()
	{
		Shape s = Shape.CreateShape(.I, int2[](.(1, 2)));
		Assert.True(s.name == .I, s.name);
		Shape s2 = s + int2(1, 2);
		Shape s3 = Shape.CreateShape(.I, int2[](.(2, 4)));
		Assert.Equals(s2, s3);
	}
}