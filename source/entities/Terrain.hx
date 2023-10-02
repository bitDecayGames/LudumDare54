package entities;

import iso.IsoEchoSprite;
import flixel.FlxSprite;


class Terrain extends IsoEchoSprite {
    public function new(X:Float, Y:Float, frameIndex:Int) {
        gridLength = 1;
        gridWidth = 1;
        // Some tiles may have height to them
        gridHeight = 0;
        super(X, Y);
        alpha = .5;

        sprite.animation.frameIndex = frameIndex;
    }

    override function configSprite() {
        sprite = new FlxSprite();
        sprite.loadGraphic(AssetPaths.tiles__png, true, 32, 16);
        sprite.offset.set(sprite.width/2, sprite.height);
    }

    override function setBounds() {
        
    }
}