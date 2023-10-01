package entities.states.survivor;
import entities.particle.Splash;
import entities.statemachine.State;

import flixel.math.FlxPoint;

class FlungState extends State<Survivor> {

    private static inline var CRASH_VELOCITY:Float = 30; // bigger number means the survivor gets thrown farther out
    private static inline var BOB_VEL:Float = 2; // bigger number means the survivor gets thrown higher up

    var directionToBeFlung:FlxPoint;

    public function new(entity:Survivor, directionToBeFlung:FlxPoint) {
        super(entity);
        this.directionToBeFlung = directionToBeFlung;
        // MW could maybe base this velocity on the velocity of the boat and just pass that in?
        this.directionToBeFlung.normalize().scale(CRASH_VELOCITY, CRASH_VELOCITY);
    }

    override public function update(delta:Float):State<Survivor> {
        if (entity.z < 0 && entity.bobVel < 0) return new SplashState(entity);
        return null;
    }
    override public function onEnter(last:State<Survivor>, current:State<Survivor>, next:State<Survivor>):Void {
        // start the animation for a flung survivor
        entity.startFling();

        // TODO: SFX guy got thrown from boat: waaaAaaAaaahhh!!! (like mario)

        entity.maxBob = BOB_VEL * 3; // just make the max bob bigger than BOB_VEL so that it doesn't get clamped
        entity.bobVel = BOB_VEL;
        entity.body.velocity.x = directionToBeFlung.x;
        entity.body.velocity.y = directionToBeFlung.y;
    }
    override public function onExit(last:State<Survivor>, current:State<Survivor>, next:State<Survivor>):Void {
        entity.body.velocity.x = 0;
        entity.body.velocity.y = 0;
        entity.z = 0;
        entity.bobVel = 0;
    }
}
