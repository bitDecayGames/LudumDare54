package states.substate;

import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.util.FlxColor;
import flixel.addons.text.FlxTypeText;
import loaders.Aseprite;
import flixel.FlxSprite;
import flixel.FlxSubState;

class TalkerOverlay extends FlxSubState {
    public static var who = [
        "COP" => 1,
        "Lady1" => 4,
        "Lady2" => 6,
        "Lady3" => 8,
        "Lady4" => 10,
        "Man1" => 3,
        "Man2" => 5,
        "Man3" => 7,
        "Man4" => 9,
        "Empty" => 2,
    ];

	var display:Float = 0;
	var cb:Void->Void;
    var persona:String;

	public function new(persona:String, displayTime:Float, cb:Void->Void = null) {
		super();
		display = displayTime;
		this.cb = cb;
        this.persona = persona;
	}

	override function create() {
		super.create();

		var banner = new FlxSprite(0, 10);
        Aseprite.loadAllAnimations(banner, AssetPaths.banner__json);
        banner.animation.frameIndex = 6;
		banner.scrollFactor.set();
		add(banner);

		var portrait = new FlxSprite(banner.x + 3, banner.y + 7);
        Aseprite.loadAllAnimations(portrait, AssetPaths.profiles__json);
		portrait.animation.frameIndex = who[persona];
		portrait.scrollFactor.set();

        if (persona == "COP") {
            // TODO SFX: static radio mumbling
            var fx = new FlxEffectSprite(portrait, [new FlxGlitchEffect(2, 1, 0.1)]);
            fx.setPosition(portrait.x, portrait.y);
            fx.scrollFactor.set();
            add(fx);
        } else {
            // TODO SFX: Normal chatter sfx?
            add(portrait);
        }

        var text = new FlxTypeText(portrait.x + portrait.width + 8, banner.y + 10, cast(banner.width - (portrait.x + portrait.width) - 30),
            "Hey man, what are you trying to do here? Get out there and save those people! Last I counted, there were 6 reports of people who fell in.");
        text.setTypingVariation();
        text.color = FlxColor.BLACK;
        text.scrollFactor.set();
        text.start();
        add(text);

		// var quip = quips[portrait.animation.frameIndex];
		// var flavorText = new Trooper(portrait.x + portrait.width + 10, portrait.y, quip);
		// flavorText.autoSize = false;
		// flavorText.fieldWidth = cast (FlxG.width - flavorText.x - 10);
		// flavorText.scrollFactor.set();
		// add(flavorText);

		// switch (quip) {
		// 	case "one for the core!":
		// 		FmodManager.PlaySoundOneShot(FmodSFX.VoiceOneForeTheCore);
		// 	case "we will not be stopped!":
		// 		FmodManager.PlaySoundOneShot(FmodSFX.VoiceWeWillNotBeStopped);
		// 	case "prepare yourself!":
		// 		FmodManager.PlaySoundOneShot(FmodSFX.VoicePrepareYourself);

		// 	default: 
		// }
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		display -= elapsed;

		if (display <= 0) {
			close();
			if (cb != null) cb();
		}
	}
}