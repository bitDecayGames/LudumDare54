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
	public var player:Player;

	public function new(player:Player, x:Float=0, y:Float=0, x2:Float=1, y2:Float=1) {
		line = new Line(x, y, x2, y2);
		this.player = player;
		visible = false;
		super(x, y);
	}

	override public function update(delta:Float):Void {
		super.update(delta);

		Echo.linecast(line, player.body);
	}

	override public function destroy() {
		player = null;
		line = null;
	}
}
