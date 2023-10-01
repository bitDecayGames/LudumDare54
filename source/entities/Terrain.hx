package entities;

import flixel.FlxSprite;

import iso.IsoSprite;

class Terrain extends IsoSprite {
    public function new(X:Float, Y:Float, frameIndex:Int) {
        gridLength = 1;
        gridWidth = 1;
        // Some tiles may have height to them
        gridHeight = 0;
        super(X, Y);
        alpha = .1;

        sprite = new FlxSprite();
        sprite.loadGraphic(AssetPaths.tiles__png, true, 32, 16);
        sprite.animation.frameIndex = frameIndex;
    }
}