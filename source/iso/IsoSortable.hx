package iso;

import flixel.math.FlxPoint;

interface IsoSortable {
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

    public function update(elapsed:Float):Void;
    public function draw():Void;
    public function centerPoint(?p:FlxPoint):FlxPoint;
}