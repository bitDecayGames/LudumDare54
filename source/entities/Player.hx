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

	var rawAngle:Float = 0;
	var calculatedAngle:Float = 0;

	var snapToleranceDegrees = 10;

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
			rawAngle -= turnSpeed * delta;
		}

		if (SimpleController.pressed(RIGHT)) {
			rawAngle += turnSpeed * delta;
		}

		if (rawAngle < 0) rawAngle += 360;
		if (rawAngle >= 360) rawAngle -= 360;

		if (rawAngle % 45 <= snapToleranceDegrees) {
			calculatedAngle = rawAngle - (rawAngle % 45);
		} else if (rawAngle % 45 >= (45 - snapToleranceDegrees)) {
			calculatedAngle = rawAngle + (45 - (rawAngle % 45));
		} else {
			calculatedAngle = rawAngle;
		}

		// aka 16 segments
		var segmentSize = 360.0 / 16;
		var halfSegment = segmentSize / 2;

		var angleDeg = rawAngle;
		var intAngle = FlxMath.wrap(cast angleDeg + halfSegment, 0, 359);
		var spinFrame = Std.int(intAngle / segmentSize);
		sprite.animation.frameIndex = spinFrame;

		var movement = FlxPoint.weak(speed, 0);
		movement.rotateByDegrees(calculatedAngle);
		velocity.copyFrom(movement);

		FlxG.watch.addQuick('pAngRaw:', rawAngle);
		FlxG.watch.addQuick('pAngCalc:', calculatedAngle);
		FlxG.watch.addQuick('pAngFrame:', spinFrame);
	}
}
