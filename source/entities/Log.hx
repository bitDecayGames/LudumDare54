package entities;

import echo.Body;
import flixel.FlxSprite;
import loaders.Aseprite;
import loaders.AsepriteMacros;

class Log extends Bobber {
	public function new(x:Float=0, y:Float=0) {
		gridWidth = 28/16;
		gridLength = 0.5;
		gridHeight = 1;

		super(x, y);
	}

	override function configSprite() {
		this.sprite = new FlxSprite();
		Aseprite.loadAllAnimations(this.sprite, AssetPaths.log__json);
	}

	override function makeBody():Body {
		return this.add_body({
			x: x,
			y: y,
			shapes: [
				{
					type:RECT,
					width: 28,
					height: 8,
				},
			],
			kinematic: true,
		});
	}
}
