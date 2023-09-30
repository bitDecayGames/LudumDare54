package iso;

import bitdecay.flixel.debug.DebugDraw;
import debug.Debug;
import debug.DebugLayers;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Grid {
	// pixels per grid space. This drives the ratio of cartesian movement
	// to isometric movement
	public static final CELL_SIZE = 16;

	public static final TILE_WIDTH = 32;
	public static final TILE_HEIGHT = 16;

	public static function gridToIso(x:Float, y:Float, ?p:FlxPoint):FlxPoint {
		if (p == null) {
			p = FlxPoint.get();
		}

		var isoX = (x - y) / CELL_SIZE * (TILE_WIDTH / 2);
		var isoY = (x + y) / CELL_SIZE * (TILE_HEIGHT / 2);

		p.set(isoX, isoY);
		return p;
	}

	public static function isoToGrid(x:Float, y:Float, ?p:FlxPoint):FlxPoint {
		if (p == null) {
			p = FlxPoint.get();
		}

		p.x = (y / TILE_HEIGHT + x / TILE_WIDTH) * CELL_SIZE;
		p.y = (y / TILE_HEIGHT - x / TILE_WIDTH) * CELL_SIZE;

		return p;
	}

	public static function drawGrid(xs:Int, ys:Int) {
		var start = FlxPoint.get();
		var end = FlxPoint.get();
		for (i in 0...xs) {
			start.set(i * Grid.CELL_SIZE, 0);
			end.set(i * Grid.CELL_SIZE, ys * Grid.CELL_SIZE);
			DebugDraw.ME.drawWorldLine(Debug.dbgCam, start.x, start.y, end.x, end.y, DebugLayers.SQUARE_GRID, FlxColor.CYAN);

			Grid.gridToIso(i * Grid.CELL_SIZE, 0, start);
			Grid.gridToIso(i * Grid.CELL_SIZE, 50, end);
			DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_GRID);
		}

		for (i in 0...ys) {
			start.set(0, i * Grid.CELL_SIZE);
			end.set(xs * Grid.CELL_SIZE, i * Grid.CELL_SIZE);
			DebugDraw.ME.drawWorldLine(Debug.dbgCam, start.x, start.y, end.x, end.y, DebugLayers.SQUARE_GRID, FlxColor.CYAN);

			Grid.gridToIso(0, i * Grid.CELL_SIZE, start);
			Grid.gridToIso(50, i * Grid.CELL_SIZE, end);
			DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_GRID);
		}

		start.put();
		end.put();
	}
}
