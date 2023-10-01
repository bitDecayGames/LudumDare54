package iso;

import echo.util.AABB;
import bitdecay.flixel.debug.DebugDraw;
import debug.Debug;
import debug.DebugLayers;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import echo.Body;
import echo.data.Data.CollisionData;

/**
 * Combination pizza hut/taco bell of EchoSprite & IsoSprite
 */
class IsoEchoSprite extends FlxSprite {
	/**
     * BEGIN Combination
	 */
	
	 @:access(echo.FlxEcho)
	 public function new(X:Float = 0, Y:Float = 0) {
		 super(X, Y);

		 // It is critical that your grid size matches well with your `sprite` graphic so collisions feel correct
		 makeGraphic(Math.ceil(gridWidth * Grid.CELL_SIZE), Math.ceil(gridLength * Grid.CELL_SIZE), FlxColor.GRAY);

		 configSprite();
		 sprite.offset.set(sprite.width/2, sprite.height);
		 body = makeBody();
 
		 // XXX: We want to force position and rotation immediately
		 if (body != null) {
			 body.update_body_object();
		 }
 
		 if (Debug.dbgCam != null) {
			 camera = Debug.dbgCam;
		 }
	 }
	
	/**
     * END Combination
	 * 
	 * ---
	 * 
     * BEGIN IsoSprite
	 */

	public var sprite:FlxSprite;

	public var z:Float = 0;

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

	var bounds:AABB = AABB.get();

	override function draw() {
		super.draw();

		// iso renders based on the bottom left corner
		var tmp = Grid.gridToIso(x + width - z, y + height - z);
		sprite.setPosition(tmp.x, tmp.y);
		tmp.put();
		var dbgDraw = FlxG.debugger.drawDebug;
		FlxG.debugger.drawDebug = false;
		sprite.draw();
		FlxG.debugger.drawDebug = dbgDraw;
	}

	function get_gridXmin():Float {
		return bounds.min_x;
	}

	function get_gridXmax():Float {
		return bounds.max_x;
	}

	function get_gridYmin():Float {
		return bounds.min_y;
	}

	function get_gridYmax():Float {
		return bounds.max_y;
	}

	function get_gridZmin():Float {
		return z + adjust;
	}

	function get_gridZmax():Float {
		return z + gridHeight * Grid.CELL_SIZE - adjust;
	}

	function get_isoXmin():Float {
		return bounds.min_x - z;
	}

	function get_isoXmax():Float {
		return bounds.max_x - z;
	}

	function get_isoYmin():Float {
		return bounds.min_y - z;
	}

	function get_isoYmax():Float {
		return bounds.max_y - z;
	}

	function get_hMin():Float {
		return Grid.gridToIso(bounds.max_x, bounds.max_y).x;
	}

	function get_hMax():Float {
		return Grid.gridToIso(bounds.min_x, bounds.min_y).x;
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

		Grid.gridToIso(isoXmin, isoYmin, start);
		Grid.gridToIso(isoXmax, isoYmin, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_SPACE, color);
		Grid.gridToIso(isoXmin, isoYmax, start);
		Grid.gridToIso(isoXmax, isoYmax, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_SPACE, color);
		Grid.gridToIso(isoXmin, isoYmin, start);
		Grid.gridToIso(isoXmin, isoYmax, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_SPACE, color);
		Grid.gridToIso(isoXmax, isoYmin, start);
		Grid.gridToIso(isoXmax, isoYmax, end);
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

	/**
     * END IsoSprite
	 *
	 * --- 
	 *
     * BEGIN EchoSprite
	 */

	public var body:Body;

	override function kill() {
		super.kill();
		if (body != null) {
			body.active = false;
		}
	}

	public function configSprite() {}

	public function makeBody():Body {
		return null;
	}

	public function handleEnter(other:Body, data:Array<CollisionData>) {

	}

	public function handleStay(other:Body, data:Array<CollisionData>) {

	}

	public function handleExit(other:Body) {
		
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		sprite.update(elapsed);

		setBounds();

		debugDraw(1, FlxColor.MAGENTA);
	}

	function setBounds() {
		body.bounds(bounds);
	}

	/**
     * END EchoSprite
	 */
}
