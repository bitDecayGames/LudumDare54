package entities.states.survivor;
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

        return null;
    }
    override public function onEnter():Void {
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
    override public function onExit():Void {
        entity.endTow();
    }
}
