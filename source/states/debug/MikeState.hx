package states.debug;

import flixel.FlxG;
import states.PlayState;

class MikeState extends PlayState {
	override public function create() {
		initialLevelName = "Jake_01";
		super.create();
		FlxG.debugger.visible = true;
	}
}
