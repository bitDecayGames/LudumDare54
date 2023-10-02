package states.substate;

import flixel.util.FlxColor;
import ui.font.BitmapText.CruiseText;
import flixel.FlxSubState;

class CountdownOverlay extends FlxSubState {
	var counter:CruiseText;

    var timer = 1.0;

    public function new() {
        super();
    }

    override function create() {
        super.create();

        counter = new CruiseText("");
        counter.fieldWidth = camera.width;
        counter.autoSize = false;
        counter.alignment = CENTER;
        counter.borderStyle = OUTLINE;
        counter.borderColor = FlxColor.BLACK;
        counter.screenCenter();
        counter.scrollFactor.set();
        add(counter);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        timer -= elapsed;
        if (timer <= 0 && counter.text == "") {
            // TODO SFX: "READY!"
            counter.text = "READY";
            // counter.screenCenter();
            timer = 0.75;
        } else if (timer <= 0 && counter.text == "READY") {
            // TODO SFX: "SET!"
            counter.text = "SET";
            // counter.screenCenter();
            timer = 0.75;
        } else if (timer <= 0 && counter.text == "SET") {
            // TODO SFX: "GO!"
            counter.text = "GO!";
            // counter.screenCenter();
            timer = 0.5;
        } else if (timer <= 0 && counter.text == "GO!") {
            close();
        }
    }
}