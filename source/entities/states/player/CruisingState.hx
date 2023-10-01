package entities.states.player;
import entities.statemachine.State;
import input.SimpleController;
import flixel.math.FlxPoint;
#if FLX_DEBUG
import flixel.FlxG;
#end

class CruisingState extends State<Player> {

    // how far off (in degrees) the direction of travel will snap to the 45 degree angles
    private static inline var SNAP_TOLERANCE_DEGREES = 10;

    override public function update(delta:Float):State<Player> {
        if (SimpleController.pressed(A)) {
            return new SlidingState(entity);
        }

        #if FLX_DEBUG
        if (FlxG.keys.justPressed.K) {
            return new CrashState(entity, FlxPoint.get(10, 10));
        }
        #end

        if (SimpleController.pressed(LEFT)) {
            entity.rawAngle -= entity.turnSpeed * delta;
        }

        if (SimpleController.pressed(RIGHT)) {
            entity.rawAngle += entity.turnSpeed * delta;
        }

        if (entity.rawAngle < 0) entity.rawAngle += 360;
        if (entity.rawAngle >= 360) entity.rawAngle -= 360;

        if (entity.rawAngle % 45 <= SNAP_TOLERANCE_DEGREES) {
            entity.calculatedAngle = entity.rawAngle - (entity.rawAngle % 45);
        } else if (entity.rawAngle % 45 >= (45 - SNAP_TOLERANCE_DEGREES)) {
            entity.calculatedAngle = entity.rawAngle + (45 - (entity.rawAngle % 45));
        } else {
            entity.calculatedAngle = entity.rawAngle;
        }
        if (entity.rawAngle < 0) entity.rawAngle += 360;
        if (entity.rawAngle >= 360) entity.rawAngle -= 360;

        if (entity.rawAngle % 45 <= SNAP_TOLERANCE_DEGREES) {
            entity.calculatedAngle = entity.rawAngle - (entity.rawAngle % 45);
        } else if (entity.rawAngle % 45 >= (45 - SNAP_TOLERANCE_DEGREES)) {
            entity.calculatedAngle = entity.rawAngle + (45 - (entity.rawAngle % 45));
        } else {
            entity.calculatedAngle = entity.rawAngle;
        }

        var movement = FlxPoint.weak(entity.speed, 0);
        movement.rotateByDegrees(entity.calculatedAngle);
        entity.body.velocity.set(movement.x, movement.y);

        return null;
    }
    override public function onEnter():Void {}
    override public function onExit():Void {}
}