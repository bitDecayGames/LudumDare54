package states.debug;

import entities.Survivor;
import states.PlayState;
class MikeState extends PlayState {

	override public function create() {
		super.create();

		var survivor1 = new Survivor();
		add(survivor1);
		survivor1.following = level.player;

		var survivor2 = new Survivor();
		add(survivor2);
		survivor2.following = survivor1;

		var survivor3 = new Survivor();
		add(survivor3);
		survivor3.following = survivor2;

		var survivor4 = new Survivor();
		add(survivor4);
		survivor4.following = survivor3;
	}
}
