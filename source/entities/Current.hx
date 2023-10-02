package entities;

import echo.Body;
import flixel.math.FlxPoint;
import echo.data.Data.CollisionData;
import flixel.FlxG;
import iso.IsoEchoSprite;

#if FLX_DEBUG
import bitdecay.flixel.debug.DebugDraw;
import debug.Debug;
#end

class Current extends EchoSprite {
	public var start:FlxPoint = FlxPoint.get();
	public var end:FlxPoint = FlxPoint.get();
	public var radius: Float;
	public var stength:Float; // if this number is higher, then the objects in the current move faster
	private var length:Float;
	private var currentRotation:Float;
	private var entitiesInCurrent: Array<IsoEchoSprite> = [];
	private var diff:FlxPoint = FlxPoint.get();

	public function new(x:Float=0, y:Float=0, x2:Float=1, y2:Float=1, radius:Float=10, strength:Float=0.25) {
		start.set(x, y);
		end.set(x2, y2);
		diff.set(x2 - x, y2 - y).normalize().scale(strength, strength); // MW might need to move this to the update if the current needs to change at all
		length = start.dist(end);
		currentRotation = start.degreesTo(end);
		this.radius = radius;
		entitiesInCurrent = [];
		visible = false;
		super(x, y);
	}

	public override function makeBody():Body {
		return this.add_body({
			x: x,
			y: y,
			rotation: currentRotation,
			shapes: [
				{
					type:CIRCLE,
					solid: false,
					radius: radius,
				},
				{
					type:CIRCLE,
					solid: false,
					radius: radius,
					offset_x: length,
					offset_y: 0,
				},
				{
					type:RECT,
					solid: false,
					width: length,
					height: radius * 2.0,
					offset_x: length / 2.0,
					offset_y: 0,
				},
			],
		});
	}

	override public function update(delta:Float):Void {
		super.update(delta);
		for (entity in entitiesInCurrent) {
			if (entity != null && entity.alive) {
				entity.body.x += diff.x;
				entity.body.y += diff.y;
				#if FLX_DEBUG
				// MW This is pretty noisy on screen
				//DebugDraw.ME.drawWorldLine(Debug.dbgCam, x, y, entity.x, entity.y, null, 0x0377fc);
				#end
			}
		}

	}

	override public function destroy() {
		entitiesInCurrent = null;
		start.destroy();
		end.destroy();
	}

	@:access(echo.Shape)
	override function handleEnter(other:Body, data:Array<CollisionData>) {
		super.handleEnter(other, data);

		if ((other.object is IsoEchoSprite)) {
			var entity: IsoEchoSprite = cast other.object;
			if (!entitiesInCurrent.contains(entity)) {
				entitiesInCurrent.push(entity);
			}
		}
	}

	@:access(echo.Shape)
	override function handleExit(other:Body) {
		super.handleExit(other);

		if ((other.object is IsoEchoSprite)) {
			var entity: IsoEchoSprite = cast other.object;
			if (entitiesInCurrent.contains(entity)) {
				entitiesInCurrent.remove(entity);
			}
		}
	}
}
