package entities;

import echo.Body;
import echo.data.Data.CollisionData;
import flixel.math.FlxPoint;
import iso.IsoEchoSprite;

#if FLX_DEBUG
import bitdecay.flixel.debug.DebugDraw;
import debug.Debug;
#end

import flixel.FlxSprite;
import echo.Echo;
import echo.Line;
class Checkpoint extends FlxSprite {
	public var line:Line;
	public var spawnPoint:FlxPoint;
	public var player:Player;
	public var checked:Bool = false;

	public function new(player:Player, x:Float, y:Float, x2:Float, y2:Float, spawnPointX:Float, spawnPointY:Float) {
		line = Line.get(x, y, x2, y2);
		this.player = player;
		visible = false;
		spawnPoint = FlxPoint.get(spawnPointX, spawnPointY);
		super(x, y);
	}

	override public function update(delta:Float):Void {
		super.update(delta);

		var thing = Echo.linecast(line, player.body);
		var lineColor = checked ? 0x6e5585 : 0x556c85;
		if (thing != null) {
			lineColor = 0xffffff;
			if (player != null && !checked) {
				player.lastCheckpoint = this;
				checked = true;
				// TODO: MW figure out a way to update the flag sprite to be a lifted flag
			}
		}
		#if FLX_DEBUG
		DebugDraw.ME.drawWorldLine(Debug.dbgCam, line.x, line.y, line.dx, line.dy, null, lineColor);
		#end
	}

	override public function destroy() {
		player = null;
		line = null;
	}
}
