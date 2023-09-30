package entities;

import flixel.FlxSprite;
import loaders.Aseprite;
import loaders.AsepriteMacros;

class Log extends Bobber {
	public static var anims = AsepriteMacros.tagNames("assets/aseprite/rotation_template.json");
	public static var layers = AsepriteMacros.layerNames("assets/aseprite/characters/player.json");
	public static var eventData = AsepriteMacros.frameUserData("assets/aseprite/characters/player.json", "Layer 1");

	public function new(x:Float=0, y:Float=0) {
		gridWidth = 1;
		gridLength = 1;
		gridHeight = 1;

		super(x, y);
		// This call can be used once https://github.com/HaxeFlixel/flixel/pull/2860 is merged
		// FlxAsepriteUtil.loadAseAtlasAndTags(this, AssetPaths.player__png, AssetPaths.player__json);
		this.sprite = new FlxSprite();
		Aseprite.loadAllAnimations(this.sprite, AssetPaths.rotation_template__json);
		// animation.play(anims.right);
		animation.callback = (anim, frame, index) -> {
			if (eventData.exists(index)) {
				trace('frame $index has data ${eventData.get(index)}');
			}
		};
	}

	override private function initBobbingValues() {
		this.maxBob = .5;
		this.minBob = .2;
		this.bobVel = minBob;
		this.bobGravity = .01;
		this.bobDampening = .999;
		this.bobEnabled = true;
	}
}
