package entities.states.survivor;

import entities.particle.Splash;
import states.PlayState;
import entities.statemachine.State;
import flixel.math.FlxPoint;

class SplashState extends State<Survivor> {

    var done = false;

    public function new(entity:Survivor) {
        super(entity);
    }

    override public function update(delta:Float):State<Survivor> {
        if (done) return new FloatingState(entity);
        return null;
    }
    override public function onEnter():Void {
        entity.visible = false;
        PlayState.ME.addParticle(new Splash(entity.body.x, entity.body.y, () -> { done = true; }));
    }
    override public function onExit():Void {
        entity.visible = true;

        entity.body.velocity.x = 0;
        entity.body.velocity.y = 0;
    }
}