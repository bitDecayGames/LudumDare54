package entities;

import loaders.Aseprite;
import loaders.AsepriteMacros;
import echo.Body;
import flixel.FlxSprite;

class Item extends EchoSprite {
	public static var slices = AsepriteMacros.sliceNames("assets/aseprite/items.json");

	public function new() {
		super(x, y);
	}

	override function configSprite() {
		Aseprite.loadSlice(this, AssetPaths.items__json, slices.item1_0);
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
			],
			// kinematic: true,
		});
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
