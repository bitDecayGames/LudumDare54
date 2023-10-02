package input;

import input.SimpleController.Button;

class TutorialController implements IController {
    public function new() {}

    public function pressed(button:Button):Bool {
        return false;
    }
}