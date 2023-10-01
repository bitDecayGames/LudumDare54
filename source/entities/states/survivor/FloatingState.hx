package entities.states.survivor;
import entities.statemachine.State;

class FloatingState extends State<Survivor> {
    override public function update(delta:Float):State<Survivor> {
        if (entity.following != null) {
            return new FollowingState(entity);
        }
        return null;
    }
    override public function onEnter():Void {
        // TODO: MW start the animation for a floating, non-saved survivor
        entity.maxBob = 1;
        entity.minBob = .5;
        entity.bobVel = entity.minBob;
        entity.bobGravity = .02;
        entity.bobDampening = .99;
        entity.bobbingEnabled = true;
        entity.startFloat();
    }
    
    override public function onExit():Void {

    }
}
