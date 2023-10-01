package entities.states.survivor;
import entities.statemachine.State;

import flixel.math.FlxPoint;
class FlungState extends State<Survivor> {
    
    private static inline var CRASH_VELOCITY:Float = 0.3;

    var directionToBeFlung:FlxPoint;

    public function new(entity:Survivor, directionToBeFlung:FlxPoint) {
        super(entity);
        this.directionToBeFlung = directionToBeFlung;
        // MW could maybe base this velocity on the velocity of the boat and just pass that in?
        this.directionToBeFlung.normalize().scale(CRASH_VELOCITY, CRASH_VELOCITY);
    }

    override public function update(delta:Float):State<Survivor> {
        if (entity.z < 0 && entity.bobVel < 0) return new FloatingState(entity);
        return null;
    }
    override public function onEnter():Void {
        // TODO: MW start the animation for a flung survivor
        // TODO: SFX waaaAaaAaaahhh!!! (like mario)
        entity.maxBob = 10;
        entity.bobVel = 3;
        entity.body.velocity.x = directionToBeFlung.x;
        entity.body.velocity.y = directionToBeFlung.y;
    }
    override public function onExit():Void {
    }
}
