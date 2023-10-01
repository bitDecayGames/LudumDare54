package entities;

import flixel.util.FlxColor;
import echo.Body;
import flixel.FlxSprite;
import loaders.Aseprite;
import loaders.AsepriteMacros;

import entities.statemachine.StateMachine;
import entities.states.survivor.FloatingState;
class Survivor extends Bobber implements Follower {
	public static var anims = AsepriteMacros.tagNames("assets/aseprite/characters/survivors_floating.json");
	public static var layers = AsepriteMacros.layerNames("assets/aseprite/characters/survivors_floating.json");
	public static var eventData = AsepriteMacros.frameUserData("assets/aseprite/characters/player.json", "Layer 1");

	private var stateMachine:StateMachine<Survivor>;

	public var following:Follower = null;
	public var leading:Follower = null;

	public function new(x:Float=0, y:Float=0) {
		gridWidth = 1;
		gridLength = 1;
		gridHeight = 1;

		super(x, y);

		stateMachine = new StateMachine<Survivor>(this);
		// sets the initial state
		stateMachine.setNextState(new FloatingState(this));
	}


	override function configSprite() {
		this.sprite = new FlxSprite();
		Aseprite.loadAllAnimations(this.sprite, AssetPaths.survivors_floating__json);
		animation.play(anims.Lady1);
	}

	override function makeBody():Body {
		return this.add_body({
			x: x,
			y: y,
			shapes: [
				{
					type:CIRCLE,
					radius: 12,
				}
			],
		});
	}

	override public function update(delta:Float):Void {
		super.update(delta);
		stateMachine.update(delta);
	}
}
