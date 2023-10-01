package entities.states.survivor;
import flixel.math.FlxMath;
import entities.statemachine.State;

import flixel.math.FlxPoint;
class FollowingState extends State<Survivor> {
    private static inline var FOLLOW_DISTANCE:Float = 10;
    private static inline var FOLLOW_DAMPENER:Float = 0.05; // smaller value equals looser spring movement

    private var _diff:FlxPoint = FlxPoint.get(0, 0);

    override public function update(delta:Float):State<Survivor> {
        if (entity.following == null) {
            // TODO: MW instead of returning a floating state directly, you could return a 'Knocked Around' state that represented the survivor getting thrown around a bit before going back to floating?
            return new FloatingState(entity);
        }

        _diff.set(entity.following.targetX - entity.body.x, entity.following.targetY - entity.body.y);
        if (_diff.length > FOLLOW_DISTANCE) {
            entity.body.x += _diff.x * FOLLOW_DAMPENER;
            entity.body.y += _diff.y * FOLLOW_DAMPENER;
        }

        // aka 16 segments
		var segmentSize = 360.0 / 16;
		var halfSegment = segmentSize / 2;

        var angleDeg = _diff.degrees;
		var intAngle = FlxMath.wrap(cast angleDeg + halfSegment, 0, 359);
		var spinFrame = Std.int(intAngle / segmentSize);
		entity.sprite.animation.frameIndex = spinFrame;

        return null;
    }
    override public function onEnter(last:State<Survivor>, current:State<Survivor>, next:State<Survivor>):Void {
        // TODO: SFX survivor was just added to the saved chain
        // TODO: MW start the animation for saved survivor
        entity.maxBob = 1;
        entity.minBob = .5;
        entity.bobVel = entity.minBob;
        entity.bobGravity = .04;
        entity.bobDampening = .99;
        entity.bobbingEnabled = true;
        entity.startTow();
    }
    override public function onExit(last:State<Survivor>, current:State<Survivor>, next:State<Survivor>):Void {
    }
}
