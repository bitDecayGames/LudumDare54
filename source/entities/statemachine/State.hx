package entities.statemachine;
abstract class State<T> {
    public var entity:T;
    public function new(entity:T) {
        this.entity = entity;
    }

    public function update(delta:Float):State<T> {
        return null;
    }
    public function onEnter(last:State<T>, current:State<T>, next:State<T>):Void {}
    public function onExit(last:State<T>, current:State<T>, next:State<T>):Void {}
}
