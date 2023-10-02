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
            counter.text = "READY";
            FmodManager.PlaySoundOneShot(FmodSFX.ReadySetGo1);
            // counter.screenCenter();
            timer = 0.75;
        } else if (timer <= 0 && counter.text == "READY") {
            counter.text = "SET";
            FmodManager.PlaySoundOneShot(FmodSFX.ReadySetGo1);
            // counter.screenCenter();
            timer = 0.75;
        } else if (timer <= 0 && counter.text == "SET") {
            counter.text = "GO!";
            FmodManager.PlaySoundOneShot(FmodSFX.ReadySetGo2);
            // counter.screenCenter();
            timer = 0.5;
        } else if (timer <= 0 && counter.text == "GO!") {
            close();
        }
    }
}