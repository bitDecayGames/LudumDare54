package entities.particle;

import iso.IsoEchoSprite;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import loaders.Aseprite;


class Explosion extends IsoEchoSprite {
    public function new(x:Float, y:Float, cb:Void->Void) {
        gridLength = .5;
        gridWidth = .5;

        super(x, y);
        makeGraphic(10, 10, FlxColor.PINK);

        sprite.animation.finishCallback = (name) -> {
            if (cb != null) cb();
            kill();
            sprite.kill();
        };
    }

    override function configSprite() {
        sprite = new FlxSprite();
        Aseprite.loadAllAnimations(sprite, AssetPaths.explosion__json);
        sprite.offset.set(sprite.width/2, sprite.height);
        sprite.animation.play("Splash");
    }

    override function setBounds() {
        
    }
}