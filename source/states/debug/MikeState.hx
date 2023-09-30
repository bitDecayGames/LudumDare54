package states.debug;

import entities.Survivor;
import states.PlayState;
import entities.Log;
class MikeState extends PlayState {

	override public function create() {
		super.create();

		add(new Survivor());
		add(new Log(100, 0));
	}
}
