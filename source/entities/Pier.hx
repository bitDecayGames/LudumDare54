package entities;

import iso.IsoEchoSprite;
import echo.Body;
import flixel.FlxSprite;

class Pier extends IsoEchoSprite {
	public function new(x:Float=0, y:Float=0) {
		gridWidth = 1;
		gridLength = 1;
		gridHeight = 1;

		super(x, y);
	}

	override function configSprite() {
		this.sprite = new FlxSprite();
		this.sprite.loadGraphic(AssetPaths.tiles__png, true, 32, 16);
		this.sprite.animation.frameIndex = 73; // Pier tile index
	}

	override function makeBody():Body {
		return this.add_body({
			x: x,
			y: y,
			shapes: [
				{
					type: RECT,
					width: 16,
					height: 16,
				},
			],
			kinematic: true,
		});
	}
}
