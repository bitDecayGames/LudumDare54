package loaders;

import echo.util.TileMap.SlopeSize;
import echo.util.TileMap.SlopeAngle;
import echo.util.TileMap.TileShape;

class TileShapes {
	static public var ignored:Array<Int> = [10, 11, 39, 40, 52, 53, 54, 55, 56, 27, 28, 37, 38, 31];

	static public var shapes:Array<TileShape> = [
		{
			index: 4,
			slope_direction: BottomRight,
		},
		{
			index: 5,
			slope_direction: TopRight,
			slope_shape: {
				angle: Gentle,
				size: SlopeSize.Thin,
			}
		},
		{
			index: 8,
			slope_direction: TopLeft,
		},
		{
			index: 9,
			slope_direction: BottomLeft,
		}
	];
}
