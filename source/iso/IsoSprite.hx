package iso;

import bitdecay.flixel.debug.DebugDraw;
import debug.Debug;
import debug.DebugLayers;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class IsoSprite extends FlxSprite implements IsoSortable {
	public var sprite:FlxSprite;

	public var z:Float;

	// an adjustment modifier when computing
	// grid size to ensure rendering is nice.
	// Objects are shrunk by this amount on
	// all sides.
	public static inline var adjust = 1;

	// size of the block
	public var gridWidth:Float;
	public var gridLength:Float;
	public var gridHeight:Float;

	// these give the footprint of the block
	public var gridXmin(get, never):Float;
	public var gridXmax(get, never):Float;
	public var gridYmin(get, never):Float;
	public var gridYmax(get, never):Float;
	public var gridZmin(get, never):Float;
	public var gridZmax(get, never):Float;

	// these give the screenspace occupied by the block
	public var isoXmin(get, never):Float;
	public var isoXmax(get, never):Float;
	public var isoYmin(get, never):Float;
	public var isoYmax(get, never):Float;
	public var hMin(get, never):Float;
	public var hMax(get, never):Float;

	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);

		// It is critical that your grid size matches well with your `sprite` graphic so collisions feel correct
		makeGraphic(Math.ceil(gridWidth * Grid.CELL_SIZE), Math.ceil(gridLength * Grid.CELL_SIZE), FlxColor.TRANSPARENT);

		if (Debug.dbgCam != null) {
			camera = Debug.dbgCam;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		sprite.update(elapsed);
	}

	override function draw() {
		#if !debug
		super.draw();
		#end

		// iso renders based on the bottom left corner
		var tmp = Grid.gridToIso(x + width - z, y + height - z);
		sprite.setPosition(tmp.x, tmp.y);
		tmp.put();
		var dbgDraw = FlxG.debugger.drawDebug;
		FlxG.debugger.drawDebug = false;
		if (sprite.visible) {
			sprite.draw();
		}
		FlxG.debugger.drawDebug = dbgDraw;
	}

	function get_gridXmin():Float {
		return x + adjust;
	}

	function get_gridXmax():Float {
		return x + (gridWidth * Grid.CELL_SIZE) - adjust;
	}

	function get_gridYmin():Float {
		return y + adjust;
	}

	function get_gridYmax():Float {
		return y + (gridLength * Grid.CELL_SIZE) - adjust;
	}

	function get_gridZmin():Float {
		return z + adjust;
	}

	function get_gridZmax():Float {
		return z + gridHeight * Grid.CELL_SIZE - adjust;
	}

	function get_isoXmin():Float {
		return x - gridHeight * Grid.CELL_SIZE - z;
	}

	function get_isoXmax():Float {
		return x + gridWidth * Grid.CELL_SIZE - z;
	}

	function get_isoYmin():Float {
		return y - gridHeight * Grid.CELL_SIZE - z;
	}

	function get_isoYmax():Float {
		return y + gridLength * Grid.CELL_SIZE - z;
	}

	function get_hMin():Float {
		return Grid.gridToIso(x, y + gridLength * Grid.CELL_SIZE).x;
	}

	function get_hMax():Float {
		return Grid.gridToIso(x + gridWidth * Grid.CELL_SIZE, y).x;
	}

	public function debugDraw(i:Int, color:FlxColor) {
		var start = FlxPoint.get();
		var end = FlxPoint.get();
		Grid.gridToIso(gridXmin, -i, start);
		Grid.gridToIso(gridXmax, -i, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.GRID_SPACE, color);

		Grid.gridToIso(-i, gridYmin, start);
		Grid.gridToIso(-i, gridYmax, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.GRID_SPACE, color);

		Grid.gridToIso(isoXmin, -i, start);
		Grid.gridToIso(isoXmax, -i, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_SPACE, color);

		Grid.gridToIso(-i, isoYmin, start);
		Grid.gridToIso(-i, isoYmax, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_SPACE, color);

		start.put();
		end.put();

		DebugDraw.ME.drawWorldLine(hMin, -i, hMax, -i, null, color);
	}

	public function centerPoint(?p:FlxPoint) {
		if (p == null) {
			p = FlxPoint.get();
		}
		return p.set(isoXmin + ((isoXmax - isoXmin) / 2), isoYmin + ((isoYmax - isoYmin) / 2));
	}
}
