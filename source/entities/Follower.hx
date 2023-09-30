package entities;

interface Follower {
    public var following:Follower;
    public var leading:Follower;

    public var x(default, set):Float;
    public var y(default, set):Float;
}

class FollowerHelper {
    /**
    Adds a the follower (and its potential chain) to the end of the follow list

    You can definitely get into an infinite loop here if you make a loop in the chain, be careful!
    */
    public static function addFollower(it:Follower, follower:Follower):Void {
        if (follower == null) return;
        if (it.leading != null) {
            FollowerHelper.addFollower(it.leading, follower);
        } else {
            it.leading = follower;
            follower.following = it;
        }
    }

    /**
    Removes this follower and all its children from the chain
    */
    public static function stopFollwing(it: Follower):Void {
        if (it == null) return;

        if (it.following != null) {
            it.following.leading = null;
            it.following = null;
        }
    }

    /**
    Removes this follower from the chain while maintaining the chain itself
    */
    public static function softDetatch(it: Follower):Void {
        if (it == null) return;

        if (it.following != null) {
            it.following.leading = null;
        }
        if (it.leading != null) {
            it.leading.following = null;
        }

        if (it.following != null && it.leading != null) {
            it.following.leading = it.leading;
            it.leading.following = it.following;
        }

        it.following = null;
        it.leading = null;
    }
}
