package entities;

import flixel.FlxSprite;
import loaders.Aseprite;
import loaders.AsepriteMacros;
import echo.Body;
import iso.IsoEchoSprite;

class Item extends IsoEchoSprite {
	public static var slices = AsepriteMacros.sliceNames("assets/aseprite/items.json");

	public function new() {
		gridWidth = 1;
		gridLength = 1;
		gridHeight = 1;

		super();
	}

	override function configSprite() {
		this.sprite = new FlxSprite();
		Aseprite.loadSlice(this.sprite, AssetPaths.items__json, slices.item1_0);
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
		});
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
