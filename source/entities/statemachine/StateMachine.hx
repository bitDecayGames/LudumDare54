package entities.statemachine;

import entities.states.player.CruisingState;
import entities.states.player.SlidingState;

/**
StateMachine tracks the current, next, and last state.  Calls update on the current state.  Provides functions for switching the current state;
*/
class StateMachine<T> {
    private var entity:T;
    private var current:State<T>;
    private var last:State<T>;
    private var next:State<T>;

    public function new(entity:T) {
        this.entity = entity;

    }

    /**
    Must be maually called by the entity that is holding onto this state machine.
    */
    public function update(delta:Float):Void {

        if (next != null) {
            last = current;
            current = next;
            next = null;
            if (last != null) {
                last.onExit(last, current, next);
            }
            current.onEnter(last, current, next);
        }
        if (current != null) {
            next = current.update(delta);
        }
    }

    public function setNextState(state:State<T>) {
        next = state;
    }

    public function getCurrentState():State<T> {
        return current;
    }
}
