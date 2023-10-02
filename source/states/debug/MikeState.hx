package states.debug;

import flixel.FlxG;
import states.PlayState;

class MikeState extends PlayState {
	override public function create() {
		initialLevelName = "Mike_01";
		super.create();
		FlxG.debugger.visible = true;
	}
}
