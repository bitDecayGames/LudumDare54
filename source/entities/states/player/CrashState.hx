package entities.states.player;
import entities.statemachine.State;
import entities.Follower.FollowerHelper;

import flixel.math.FlxPoint;
class CrashState extends State<Player> {

    private var directionToFlingSurvivors:FlxPoint;

    public function new(entity:Player, directionToFlingSurvivors:FlxPoint) {
        super(entity);
        this.directionToFlingSurvivors = directionToFlingSurvivors;
    }

    override public function update(delta:Float):State<Player> {
        return new CruisingState(entity);
    }
    override public function onEnter():Void {
        // TODO: SFX boat ran into something
        // TODO: MW blink the boat white
        // TODO: MW screen shake

        if (entity.leading == null) return;

        // throw off the back half of the follow chain
        var followerCount = FollowerHelper.countNumberOfFollowersInChain(entity);
        if (followerCount > 1) {
            var numberOfFollowersToThrowOff = followerCount / 2;
            var i = 0;
            var lastFollower = FollowerHelper.getLastLinkOnChain(entity);
            while (i < numberOfFollowersToThrowOff && lastFollower != null) {
                i++;
                var survivor = cast (lastFollower, Survivor);
                if (survivor != null) {
                    survivor.flingMe(directionToFlingSurvivors);
                }
                lastFollower = FollowerHelper.stopFollowing(lastFollower);
            }
        }
    }
    override public function onExit():Void {}
}
