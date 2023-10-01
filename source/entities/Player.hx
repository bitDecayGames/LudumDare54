package entities;

import iso.Grid;
import flixel.util.FlxColor;
import bitdecay.flixel.debug.DebugDraw;
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

import entities.statemachine.StateMachine;
import entities.states.player.CruisingState;
import entities.states.player.CrashState;
class Player extends IsoEchoSprite implements Follower {
	public static var anims = AsepriteMacros.tagNames("assets/aseprite/rotation_template.json");
	public static var layers = AsepriteMacros.layerNames("assets/aseprite/characters/player.json");
	public static var eventData = AsepriteMacros.frameUserData("assets/aseprite/characters/player.json", "Layer 1");

	public var speed:Float = 70;
	public var turnSpeed:Float = 130;
	public var turnSpeedSkid:Float = 200;
	public var playerNum = 0;

	public var rawAngle:Float = 0;
	public var calculatedAngle:Float = 0;

	// used for survivor FollowingState
	public var following:Follower;
	public var leading:Follower;

	private var stateMachine:StateMachine<Player>;

	public var isInvincible = false; // TODO: MW need to actually use this boolean to determine if collision causes crash

	public function new(x:Float, y:Float) {
		gridWidth = 1;
		gridLength = 1;
		gridHeight = 1;

		super(x, y);

		rawAngle = -90;

		stateMachine = new StateMachine<Player>(this);
		stateMachine.setNextState(new CruisingState(this));
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
					radius: 10,
				},
				{
					type:RECT,
					width: 15,
					height: 7,
					offset_y: 10,
				},
				{
					type:RECT,
					width: 15,
					height: 7,
					offset_y: -10,
				}
			],
		});
	}

	override public function update(delta:Float) {
		super.update(delta);

		stateMachine.update(delta);

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

		FlxG.watch.addQuick('playerPos:', sprite.getPosition());

		debugDraw(0, FlxColor.MAGENTA);
	}

    public function damageMe(thingBoatRanInto:FlxSprite) {
		if (isInvincible) {
			// ignore this collision because the boat is invincible
			return;
		}

		var directionToFling = FlxPoint.get(thingBoatRanInto.x - x, thingBoatRanInto.y - y);
		stateMachine.setNextState(new CrashState(this, directionToFling));
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
