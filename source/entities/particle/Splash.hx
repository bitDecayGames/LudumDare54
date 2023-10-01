package entities.particle;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import loaders.Aseprite;
import iso.IsoSprite;

class Splash extends IsoSprite {
    public function new(x:Float, y:Float, cb:Void->Void) {
        gridLength = .5;
        gridWidth = .5;

        super(x, y);
        makeGraphic(10, 10, FlxColor.PINK);
        sprite = new FlxSprite();
        Aseprite.loadAllAnimations(sprite, AssetPaths.splash__json);
        sprite.offset.set(sprite.width/2, sprite.height/2);
        sprite.animation.play("Splash");
        sprite.animation.finishCallback = (name) -> {
            if (cb != null) cb();
            kill();
            sprite.kill();
        };
    }
}