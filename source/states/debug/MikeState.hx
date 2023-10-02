package states.debug;

import flixel.FlxG;
import states.PlayState;

class MikeState extends PlayState {
	override public function create() {
		initialLevelName = "Mike_01";
		super.create();
		#if FLX_DEBUG
		FlxG.debugger.visible = true;
		#end
	}
}
