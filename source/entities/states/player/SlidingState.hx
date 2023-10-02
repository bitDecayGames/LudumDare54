package entities.states.player;
import entities.statemachine.State;
import input.SimpleController;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
class SlidingState extends State<Player> {
    private static inline var MAX_SKID_INPUT_TIME = 1;
    private static inline var MAX_SKID_MOVE_TIME = 1.5;

    var initialSkidAngle = Math.POSITIVE_INFINITY;
    var skidDuration = 0.0;

	public var boatDriftId = "boatDriftId";

    override public function update(delta:Float):State<Player> {
        // if you stop pressing the button, switch back to cruising state
        if (!entity.controller.pressed(A)) {
            return new CruisingState(entity);
        }
        if (initialSkidAngle == Math.POSITIVE_INFINITY) {
            initialSkidAngle = entity.rawAngle;
            skidDuration = 0.0;
        }

        skidDuration = Math.min(skidDuration + delta, MAX_SKID_MOVE_TIME);
        var inputLerp = Math.min(skidDuration / MAX_SKID_INPUT_TIME, 1);
        var moveLerp = skidDuration / MAX_SKID_MOVE_TIME;

        var inputImpact = 1 - inputLerp;

        if (entity.controller.pressed(LEFT)) {
            entity.rawAngle -= inputImpact * (entity.turnSpeedSkid * delta);
        }

        if (entity.controller.pressed(RIGHT)) {
            entity.rawAngle += inputImpact * (entity.turnSpeedSkid * delta);
        }

        entity.calculatedAngle = entity.rawAngle;

        var movement = FlxPoint.weak(FlxMath.lerp(entity.speed, 0, moveLerp), 0);

        var influenceAngle = FlxMath.lerp(initialSkidAngle, entity.rawAngle, inputLerp);
        movement.rotateByDegrees(influenceAngle + (influenceAngle - entity.rawAngle));
        entity.body.velocity.set(movement.x, movement.y);

        return null;
    }
    override public function onEnter(last:State<Player>, current:State<Player>, next:State<Player>):Void {
        trace("entering boat drift");
        FmodManager.PlaySoundAndAssignId(FmodSFX.BoatDriftComposite, boatDriftId);
    }
    override public function onExit(last:State<Player>, current:State<Player>, next:State<Player>):Void {
        if (skidDuration > 0) {
            // TODO: We likely want some sort of cooldown as a way to reset when the player can drift/skid again
            skidDuration = 0;
            initialSkidAngle = Math.POSITIVE_INFINITY;
            FmodManager.StopSoundImmediately(boatDriftId);
        }
    }
}
