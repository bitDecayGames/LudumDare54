package shaders;

import openfl.display.ShaderParameter;
import flixel.system.FlxAssets.FlxShader;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Whiten extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform bool isShaderActive;

        void main()
        {
            vec4 pixel = texture2D(bitmap, openfl_TextureCoordv);

			if (!isShaderActive)
			{
				gl_FragColor = pixel;
				return;
            }

            if (pixel.a != 0.0) {
                gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
            }
        }')

    public function new() {
        super();
    }

    public static function Blink(sprite:FlxSprite, blinkSpeed:Float = .1, blinkCount:Int = 3, ?blinkCallback:(blinkCount:Int) -> Void) {
        var realBlinkSpeed = blinkSpeed/2;
        var realBlinkCount = blinkCount*2;
        var blinkShader = new Whiten();
        var isShaderActive = false;
        blinkShader.isShaderActive.value = [isShaderActive];
        sprite.shader = blinkShader;

        var blinkCount = 0;
        new FlxTimer().start(realBlinkSpeed, (t) -> {
            isShaderActive = !isShaderActive;
            if(isShaderActive){
                blinkCount++;
                if (blinkCallback != null){
                    blinkCallback(blinkCount);
                }
            }
            blinkShader.isShaderActive.value = [isShaderActive];
        }, realBlinkCount);
    }
}
