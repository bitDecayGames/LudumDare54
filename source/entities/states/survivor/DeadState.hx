package entities.states.survivor;
import entities.statemachine.State;

class DeadState extends State<Survivor> {
    public function new(entity:Survivor) {
        super(entity);
    }

    override public function update(delta:Float):State<Survivor> {
        return null;
    }

    override public function onEnter(last:State<Survivor>, current:State<Survivor>, next:State<Survivor>):Void {
        entity.die();
    }
    
    override public function onExit(last:State<Survivor>, current:State<Survivor>, next:State<Survivor>):Void {

    }
}
