package entities.states.player;
import flixel.util.FlxTimer;
import entities.particle.Explosion;
import states.PlayState;
import entities.particle.Splash;
import entities.statemachine.State;
import entities.Follower.FollowerHelper;

import flixel.math.FlxPoint;
import shaders.Whiten;
import flixel.FlxG;
class CrashState extends State<Player> {

    private static inline var NUM_OF_BLINKS = 5; // the bigger the number, the more blinks that happen
    private static inline var BLINK_SPEED = 0.2; // the smaller the number, the faster the blink rate
    private static inline var CAMERA_SHAKE_INTENSITY = 0.01; // smaller number makes a softer shake
    private static inline var CAMERA_SHAKE_DURATION_SECONDS = .7; // number of seconds to shake

    private var spinMod:Float;
    private var initialCrashDir:FlxPoint;
    private var directionToFlingSurvivors:FlxPoint;

    private var moveDecay = 1.0;
    private var duration = 1.0;

    public function new(entity:Player, crashDir:FlxPoint, angleMod:Float) {
        super(entity);
        initialCrashDir = crashDir.copyTo();
        directionToFlingSurvivors = FlxPoint.get(entity.previousVelocity.x, entity.previousVelocity.y);
        spinMod = angleMod;
    }

    override public function update(delta:Float):State<Player> {
        entity.body.velocity.set(0, 0);
        
        // duration -= delta;
        // moveDecay -= delta;

        // FlxG.watch.addQuick('moveDecay:', moveDecay);

        // if (duration <= 0) {
        //     return new CruisingState(entity);
        // }

        // entity.rawAngle += spinMod * delta * Math.max(0, moveDecay);

        // var decaySpeed = FlxPoint.get(initialCrashDir.x, initialCrashDir.y);
        // decaySpeed.scale(Math.max(0, moveDecay));

        // FlxG.watch.addQuick('crashVelocityMod: ', decaySpeed);

        // entity.body.velocity.set(decaySpeed.x, decaySpeed.y);

        // decaySpeed.put();
        
        return null;
    }

    override public function onEnter(last:State<Player>, current:State<Player>, next:State<Player>):Void {
        FmodManager.PlaySoundOneShot(FmodSFX.BoatCrash);

        entity.sprite.visible = false;
        entity.body.active = false;
        PlayState.ME.addParticle(new Explosion(entity.body.x, entity.body.y, () -> { 
            new FlxTimer().start(1.0, (t) -> {
        		entity.respawn();
            });
        }));
		

        // initialCrashDir.scale(entity.speed * .5);

        // entity.body.velocity.set(initialCrashDir.x, initialCrashDir.y);

        // // blink the boat white to indicate it is invincible
        // entity.isInvincible = true;
        // Whiten.Blink(entity.sprite, BLINK_SPEED, NUM_OF_BLINKS, (blinkIndex) -> {
        //     if (blinkIndex >= NUM_OF_BLINKS) {
        //         entity.isInvincible = false;
        //     }
        // });

        // screen shake
        FlxG.camera.shake(CAMERA_SHAKE_INTENSITY, CAMERA_SHAKE_DURATION_SECONDS);

        if (entity.leading == null) return;

        // throw off the back half of the follow chain
        var followerCount = FollowerHelper.countNumberOfFollowersInChain(entity);
        if (followerCount > 1) {
            var numberOfFollowersToThrowOff = Math.floor(followerCount / 2);
            var i = 0;
            var lastFollower = FollowerHelper.getLastLinkOnChain(entity);
            while (i < numberOfFollowersToThrowOff && lastFollower != null) {
                var survivor = cast (lastFollower, Survivor);
                if (survivor != null) {
                    survivor.flingMe(directionToFlingSurvivors);
                }
                lastFollower = FollowerHelper.stopFollowing(lastFollower);
                i++;
            }
        }
    }

    override public function onExit(last:State<Player>, current:State<Player>, next:State<Player>):Void {}
}
