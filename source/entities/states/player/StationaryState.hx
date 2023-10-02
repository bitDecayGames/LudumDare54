package entities.states.player;
import entities.statemachine.State;
import input.SimpleController;
import flixel.math.FlxPoint;
#if FLX_DEBUG
import flixel.FlxG;
#end

class StationaryState extends State<Player> {

    override public function update(delta:Float):State<Player> {
        return null;
    }

    override public function onEnter(last:State<Player>, current:State<Player>, next:State<Player>):Void {
        entity.body.velocity.set(0,0);
    }

    override public function onExit(last:State<Player>, current:State<Player>, next:State<Player>):Void {
        
    }
}
