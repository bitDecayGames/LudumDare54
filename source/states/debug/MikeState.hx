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

		var survivor1 = new Survivor();
		add(survivor1);
		var survivor2 = new Survivor();
		add(survivor2);
		var survivor3 = new Survivor();
		add(survivor3);
		var survivor4 = new Survivor();
		add(survivor4);

		FollowerHelper.addFollower(level.player, survivor1);
		FollowerHelper.addFollower(level.player, survivor2);
		FollowerHelper.addFollower(level.player, survivor3);
		FollowerHelper.addFollower(level.player, survivor4);

		var current = new Current(100, 100, 300, 300, 50);
		add(current);
	}
}
