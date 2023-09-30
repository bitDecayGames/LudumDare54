package states.debug;

import entities.Survivor;
import states.PlayState;
import entities.Follower;

class MikeState extends PlayState {

	override public function create() {
		super.create();

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
	}
}
