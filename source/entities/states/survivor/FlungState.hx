package entities.states.survivor;
import entities.statemachine.State;

import flixel.math.FlxPoint;
class FlungState extends State<Survivor> {

    var directionToBeFlung:FlxPoint;

    public function new(entity:Survivor, directionToBeFlung:FlxPoint) {
        super(entity);
        this.directionToBeFlung = directionToBeFlung;
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
    }
    override public function onExit():Void {
    }
}
