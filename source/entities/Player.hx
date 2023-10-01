package entities;

import entities.statemachine.StateMachine;
import echo.data.Data.CollisionData;
import entities.Follower.FollowerHelper;
import iso.IsoEchoSprite;
import echo.Body;
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

import flixel.FlxObject;

class Player extends IsoEchoSprite implements Follower {
	public static var anims = AsepriteMacros.tagNames("assets/aseprite/rotation_template.json");
	public static var layers = AsepriteMacros.layerNames("assets/aseprite/characters/player.json");
	public static var eventData = AsepriteMacros.frameUserData("assets/aseprite/characters/player.json", "Layer 1");

	var speed:Float = 70;
	var turnSpeed:Float = 130;
	var turnSpeedSkid:Float = 200;
	var playerNum = 0;

	var rawAngle:Float = 0;
	var calculatedAngle:Float = 0;

	// how far off (in degrees) the direction of travel will snap to the 45 degree angles
	var snapToleranceDegrees = 10;

	var initialSkidAngle = Math.POSITIVE_INFINITY;
	var skidDuration = 0.0;

	var MAX_SKID_INPUT_TIME = 1;
	var MAX_SKID_MOVE_TIME = 1.5;

	// used for survivor FollowingState
	public var following:Follower;
	public var leading:Follower;

	public function new() {
		gridWidth = 1;
		gridLength = 1;
		gridHeight = 1;

		super();

		rawAngle = -90;
	}


	override function configSprite() {
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

	override function makeBody():Body {
		return this.add_body({
			x: x,
			y: y,
			shapes: [
				{
					type:CIRCLE,
					radius: 15,
				},
				{
					type:RECT,
					width: 30,
					height: 7,
					offset_y: 7,
				},
				{
					type:RECT,
					width: 30,
					height: 7,
					offset_y: -7,
				}
			],
		});
	}

	override public function update(delta:Float) {
		super.update(delta);

		if (SimpleController.pressed(A)) {
			skidControl(delta);
		} else {
			if (skidDuration > 0) {
				// TODO SFX: Skid ended
				// TODO: We likely want some sort of cooldown as a way to reset when the player can drift/skid again
				skidDuration = 0;
				initialSkidAngle = Math.POSITIVE_INFINITY;
			}
			normalControl(delta);
		}

		// aka 16 segments
		var segmentSize = 360.0 / 16;
		var halfSegment = segmentSize / 2;

		var angleDeg = rawAngle;
		var intAngle = FlxMath.wrap(cast angleDeg + halfSegment, 0, 359);
		var spinFrame = Std.int(intAngle / segmentSize);
		sprite.animation.frameIndex = spinFrame;
		body.rotation = calculatedAngle;

		FlxG.watch.addQuick('pAngRaw:', rawAngle);
		FlxG.watch.addQuick('pAngCalc:', calculatedAngle);
		FlxG.watch.addQuick('pAngFrame:', spinFrame);



	}

	function skidControl(delta:Float) {
		if (initialSkidAngle == Math.POSITIVE_INFINITY) {
			initialSkidAngle = rawAngle;
			skidDuration = 0.0;

			// TODO SFX: Start boat skid
		}

		skidDuration = Math.min(skidDuration + delta, MAX_SKID_MOVE_TIME);
		var inputLerp = Math.min(skidDuration / MAX_SKID_INPUT_TIME, 1);
		var moveLerp = skidDuration / MAX_SKID_MOVE_TIME;

		var inputImpact = 1 - inputLerp;

		if (SimpleController.pressed(LEFT)) {
			rawAngle -= inputImpact * (turnSpeedSkid * delta);
		}

		if (SimpleController.pressed(RIGHT)) {
			rawAngle += inputImpact * (turnSpeedSkid * delta);
		}

		calculatedAngle = rawAngle;

		var movement = FlxPoint.weak(FlxMath.lerp(speed, 0, moveLerp), 0);

		var influenceAngle = FlxMath.lerp(initialSkidAngle, rawAngle, inputLerp);
		movement.rotateByDegrees(influenceAngle + (influenceAngle - rawAngle));
		body.velocity.set(movement.x, movement.y);
	}

	function normalControl(delta:Float) {
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
		if (rawAngle < 0) rawAngle += 360;
		if (rawAngle >= 360) rawAngle -= 360;

		if (rawAngle % 45 <= snapToleranceDegrees) {
			calculatedAngle = rawAngle - (rawAngle % 45);
		} else if (rawAngle % 45 >= (45 - snapToleranceDegrees)) {
			calculatedAngle = rawAngle + (45 - (rawAngle % 45));
		} else {
			calculatedAngle = rawAngle;
		}

		var movement = FlxPoint.weak(speed, 0);
		movement.rotateByDegrees(calculatedAngle);
		body.velocity.set(movement.x, movement.y);
	}

    public function damaged(thingBoatRanInto:FlxObject) {
        // TODO: SFX boat ran into something
        // TODO: MW blink the boat white

        if (leading == null) return;

        // throw off the back half of the follow chain
        var followerCount = FollowerHelper.countNumberOfFollowersInChain(this);
        if (followerCount > 1) {
            var numberOfFollowersToThrowOff = followerCount / 2;
            var i = 0;
            var lastFollower = FollowerHelper.getLastLinkOnChain(this);
            while (i < numberOfFollowersToThrowOff) {
                i++;
                lastFollower = FollowerHelper.stopFollowing(lastFollower);
            }
        }
    }

	@:access(echo.Shape)
	override function handleEnter(other:Body, data:Array<CollisionData>) {
		super.handleEnter(other, data);

		if (other.object is Survivor) {
			var survivor: Survivor = cast other.object;
			if (!survivor.isFollowing()) {
				FollowerHelper.addFollower(this, survivor);
			}
		}
	}
}
