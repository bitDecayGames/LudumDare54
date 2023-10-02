package entities;

import entities.states.survivor.DeadState;
import entities.states.survivor.FollowingState;
import flixel.FlxG;
import flixel.util.FlxColor;
import echo.Body;
import flixel.FlxSprite;
import loaders.Aseprite;
import loaders.AsepriteMacros;

import entities.statemachine.StateMachine;
import entities.states.survivor.FloatingState;
import entities.states.survivor.FlungState;
import flixel.math.FlxPoint;

class Survivor extends Bobber implements Follower {
	public static var anims = AsepriteMacros.tagNames("assets/aseprite/characters/survivors_floating.json");
	public static var layers = AsepriteMacros.layerNames("assets/aseprite/characters/survivors_floating.json");
	public static var eventData = AsepriteMacros.frameUserData("assets/aseprite/characters/player.json", "Layer 1");

	private var stateMachine:StateMachine<Survivor>;

	public var following:Follower = null;
	public var leading:Follower = null;

	public var targetX(get, null):Float;
	public var targetY(get, null):Float;

	private static inline var FLOAT_ANIM = "Float";
	private static inline var FLY_ANIM = "Fly";
	private static inline var TUBE_ANIM = "Tube";
	private static inline var BODY_ANIM = "Body";

	public var numCheckpointsHit = 0;

	private static var arts = [
		AssetPaths.Lady1__json,
		AssetPaths.Lady2__json,
		AssetPaths.Lady3__json,
		AssetPaths.Lady4__json,
		AssetPaths.Man1__json,
		AssetPaths.Man2__json,
		AssetPaths.Man3__json,
		AssetPaths.Man4__json,
	];

	public function new(x:Float=0, y:Float=0) {
		gridWidth = 6/16;
		gridLength = 6/16;
		gridHeight = .5;

		super(x, y);

		stateMachine = new StateMachine<Survivor>(this);
		// sets the initial state
		stateMachine.setNextState(new FloatingState(this));
	}

	public function isFollowing():Bool {
		return following != null;
	}

	public function startTow() {
		// TODO SFX: Survivor thrown from boat.
		sprite.animation.play(TUBE_ANIM);
		sprite.animation.pause();
	}

	public function startFloat() {
		// TODO SFX: Survivor begins just floating in water waiting rescue.
		sprite.animation.play(FLOAT_ANIM);
	}

	// public function endTow() {
	// 	// TODO SFX: Survivor thrown from boat.
	// 	sprite.animation.play(TUBE_ANIM);
	// }

	override function configSprite() {
		this.sprite = new FlxSprite();
		var asset = FlxG.random.getObject(arts);
		Aseprite.loadAllAnimations(this.sprite, asset);
		startFloat();
	}

	override function makeBody():Body {
		return this.add_body({
			x: x,
			y: y,
			shapes: [
				{
					type:CIRCLE,
					radius: 6,
				}
			],
		});
	}

	override public function update(delta:Float):Void {
		super.update(delta);
		stateMachine.update(delta);
	}

	public function flingMe(directionToBeFlung: FlxPoint) {
		stateMachine.setNextState(new FlungState(this, directionToBeFlung));
	}

	function get_targetX():Float {
		return body.x;
	}

	function get_targetY():Float {
		return body.y;
	}

	public function startFling() {
		// FmodManager.PlaySoundOneShot(FmodSFX.VoiceFling);
		sprite.animation.play(FLY_ANIM);
	}

	public function die() {
		// TODO SFX: Survivor killed.
		sprite.animation.play(BODY_ANIM);
	}

	public function hitByObject() {
		stateMachine.setNextState(new DeadState(this));
	}

	public function isCollectable() {
		return stateMachine.getCurrentState() is FloatingState;
	}
}
