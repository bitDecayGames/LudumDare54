package entities.states.player;
import entities.statemachine.State;
import entities.Follower.FollowerHelper;

import flixel.math.FlxPoint;
import shaders.Whiten;
import flixel.FlxG;
class CrashState extends State<Player> {

    private static inline var NUM_OF_BLINKS = 5; // the bigger the number, the more blinks that happen
    private static inline var BLINK_SPEED = 0.3; // the smaller the number, the faster the blink rate
    private static inline var CAMERA_SHAKE_INTENSITY = 0.01; // smaller number makes a softer shake
    private static inline var CAMERA_SHAKE_DURATION_SECONDS = .7; // number of seconds to shake

    private var directionToFlingSurvivors:FlxPoint;

    public function new(entity:Player, directionToFlingSurvivors:FlxPoint) {
        super(entity);
        this.directionToFlingSurvivors = directionToFlingSurvivors;
    }

    override public function update(delta:Float):State<Player> {
        return new CruisingState(entity);
    }

    override public function onEnter(last:State<Player>, current:State<Player>, next:State<Player>):Void {
        FmodManager.PlaySoundOneShot(FmodSFX.BoatCrash);

        // blink the boat white to indicate it is invincible
        entity.isInvincible = true;
        Whiten.Blink(entity.sprite, BLINK_SPEED, NUM_OF_BLINKS, (blinkIndex) -> {
            if (blinkIndex >= NUM_OF_BLINKS) {
                entity.isInvincible = false;
            }
        });

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
