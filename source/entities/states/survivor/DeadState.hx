package entities.states.survivor;
import entities.statemachine.State;

class DeadState extends State<Survivor> {
    public function new(entity:Survivor) {
        super(entity);
    }

    override public function update(delta:Float):State<Survivor> {
        return null;
    }

    override public function onEnter():Void {
        entity.sprite.animation.play("Body");
    }
    
    override public function onExit():Void {

    }
}
