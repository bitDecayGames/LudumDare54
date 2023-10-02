package states.substate;

import input.SimpleController;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxColor;
import ui.font.BitmapText.CruiseText;
import flixel.FlxSprite;
import flixel.FlxSubState;

class LevelEndSubState extends FlxSubState {
	var acceptInput:Bool = false;

    public function new() {
        super();
    }

    override function create() {
        super.create();

        FmodManager.SetEventParameterOnSong("lowpass", 1);

        var bg = new FlxSprite(AssetPaths.tallyScreen__png);
        bg.scrollFactor.set();
        add(bg);

        var deliveries = PlayState.ME.deliveries;
        var thrillScore = PlayState.ME.getScore();
        var total = deliveries + thrillScore;
        var max = 25; // TODO: load this from level

        var ridesGiven = new CruiseText('Tubers ${deliveries}');
        ridesGiven.scrollFactor.set();
        ridesGiven.borderStyle = OUTLINE;
        ridesGiven.borderColor = FlxColor.BLACK;
        var thrillPoints = new CruiseText('Thrill ${thrillScore}');
        thrillPoints.scrollFactor.set();
        thrillPoints.borderStyle = OUTLINE;
        thrillPoints.borderColor = FlxColor.BLACK;
        var finalScore = new CruiseText('Total  ${total} of ${max}');
        finalScore.scrollFactor.set();
        finalScore.borderStyle = OUTLINE;
        finalScore.borderColor = FlxColor.BLACK;

        var baseX = 30;
        var baseY = 30;
        var spacingVert = 10;

        ridesGiven.setPosition(baseX, baseY);
        thrillPoints.setPosition(baseX, ridesGiven.y + ridesGiven.height + spacingVert);
        finalScore.setPosition(baseX, thrillPoints.y + thrillPoints.height + spacingVert);

        add(ridesGiven);
        add(thrillPoints);
        add(finalScore);

        var start = new CruiseText("Press Start");
        start.scrollFactor.set();
		start.x = (256 - start.width) / 2;
		start.y = FlxG.height - start.height - 15;
		start.borderStyle = OUTLINE;
		start.borderColor = FlxColor.BLACK;
		start.visible = false;

		new FlxTimer().start(1, (t) -> {
			start.visible = true;
			FlxSpriteUtil.flicker(start, 0, 0.5);
			acceptInput = true;
		});

        add(start);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (acceptInput) {
			if (SimpleController.just_pressed(A) || SimpleController.just_pressed(START)) {
				acceptInput = false;
                close();
			}
		}
    }
}