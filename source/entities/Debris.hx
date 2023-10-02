package entities;

import echo.Body;
import flixel.FlxSprite;
import loaders.Aseprite;

class Debris extends Bobber {
	public function new(x:Float=0, y:Float=0) {
		gridWidth = 28/16;
		gridLength = 0.5;
		gridHeight = 1;

		super(x, y);
		sprite.offset.x += 8;
	}

	override function configSprite() {
		this.sprite = new FlxSprite();
		var heads = Math.random() >= 0.5;
		var assetPath = heads ?	
			AssetPaths.log__json :
			AssetPaths.canoe__json;
		Aseprite.loadAllAnimations(this.sprite, assetPath);
	}

	override function makeBody():Body {
		return this.add_body({
			x: x,
			y: y,
			shapes: [
				{
					type:RECT,
					width: 28,
					height: 6,
				},
			],
			rotation: 5,
			kinematic: true,
		});
	}
}
