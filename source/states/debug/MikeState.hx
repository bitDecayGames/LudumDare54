package states.debug;

import flixel.FlxG;
import states.PlayState;

class MikeState extends PlayState {
	public function new() {
		initialLevelName = "Mike_01";
		super();
	}

	override public function create() {
		super.create();
		FlxG.debugger.visible = true;
	}
}
