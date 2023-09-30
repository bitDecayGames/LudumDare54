package entities;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import iso.IsoSprite;
import flixel.FlxSprite;
import input.InputCalcuator;
import input.SimpleController;
import loaders.Aseprite;
import loaders.AsepriteMacros;

class Player extends IsoSprite {
	public static var anims = AsepriteMacros.tagNames("assets/aseprite/rotation_template.json");
	public static var layers = AsepriteMacros.layerNames("assets/aseprite/characters/player.json");
	public static var eventData = AsepriteMacros.frameUserData("assets/aseprite/characters/player.json", "Layer 1");

	var speed:Float = 70;
	var turnSpeed:Float = 130;
	var playerNum = 0;

	public function new() {
		gridWidth = 1;
		gridLength = 1;
		gridHeight = 1;

		super();
		// This call can be used once https://github.com/HaxeFlixel/flixel/pull/2860 is merged
		// FlxAsepriteUtil.loadAseAtlasAndTags(this, AssetPaths.player__png, AssetPaths.player__json);
		this.sprite = new FlxSprite();
		Aseprite.loadAllAnimations(this.sprite, AssetPaths.boat__json);
		animation.callback = (anim, frame, index) -> {
			if (eventData.exists(index)) {
				trace('frame $index has data ${eventData.get(index)}');
			}
		};
	}

	override public function update(delta:Float) {
		super.update(delta);

		if (SimpleController.pressed(LEFT)) {
			angle -= turnSpeed * delta;
		}

		if (SimpleController.pressed(RIGHT)) {
			angle += turnSpeed * delta;
		}

		// aka 16 segments
		var segmentSize = 360 / 16;
		var halfSegment = segmentSize / 2;

		var angleDeg = angle;
		var intAngle = FlxMath.wrap(cast angleDeg + halfSegment, 0, 359);
		var segments = Std.int(intAngle / segmentSize);
		sprite.animation.frameIndex = segments;

		var movement = FlxPoint.weak(speed, 0);
		movement.rotateByDegrees(angle);
		velocity.copyFrom(movement);
	}
}
