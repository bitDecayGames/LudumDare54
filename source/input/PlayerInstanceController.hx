package input;

import input.SimpleController.Button;

class PlayerInstanceController implements IController {
    public function new() {}
    
    public function pressed(button:Button):Bool {
        return SimpleController.pressed(button);
    }
}