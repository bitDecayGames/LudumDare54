package entities;

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


	public function new(x:Float=0, y:Float=0) {
		gridWidth = .5;
		gridLength = .5;
		gridHeight = .5;

		super(x, y);

		stateMachine = new StateMachine<Survivor>(this);
		// sets the initial state
		stateMachine.setNextState(new FloatingState(this));
	}

	public function isFollowing():Bool {
		return stateMachine.getCurrentState() is FollowingState;
	}

	public function startTow() {
		var curAnimName = sprite.animation.curAnim.name;
		if (!StringTools.endsWith(curAnimName, "_tube")) {
			// TODO SFX: Survivor gets into tube and starts town behind boat
			sprite.animation.play('${curAnimName}_tube');
		}
	}

	public function endTow() {
		var curAnimName = sprite.animation.curAnim.name;
		if (StringTools.endsWith(curAnimName, "_tube")) {
			// TODO SFX: Survivor thrown from boat.
			sprite.animation.play(StringTools.replace(curAnimName, "_tube", ""));
		}
	}

	override function configSprite() {
		this.sprite = new FlxSprite();
		Aseprite.loadAllAnimations(this.sprite, AssetPaths.survivors_floating__json);
		var allAnims = sprite.animation.getNameList().filter((a) -> !StringTools.endsWith(a, "_tube"));
		sprite.animation.play(allAnims[FlxG.random.int(0, allAnims.length)]);
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
}
