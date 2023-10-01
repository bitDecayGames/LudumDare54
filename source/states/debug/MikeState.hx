package states.debug;

import entities.Survivor;
import states.PlayState;
import entities.Follower;

import entities.Current;
import flixel.FlxG;
class MikeState extends PlayState {

	override public function create() {
		super.create();

		FlxG.debugger.visible = true;

		var current = new Current(100, 100, 300, 300, 50);
		add(current);
	}
}
