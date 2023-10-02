package input;

import input.SimpleController.Button;

interface IController {
    public function pressed(button:Button):Bool;
}