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
    Removes this follower and all its children from the chain, and returns the thing that it WAS following
    */
    public static function stopFollowing(it: Follower):Follower {
        if (it == null) return null;

        if (it.following != null) {
            var f = it.following;
            it.following.leading = null;
            it.following = null;
            return f;
        }
        return null;
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

    /**
    Counts the total number of followers
    */
    public static function countNumberOfFollowersInChain(it: Follower):Int {
        return innerCountNumberOfFollowersInChain(it, 0);
    }
    private static function innerCountNumberOfFollowersInChain(it: Follower, count:Int):Int {
        if (it == null) return count;
        return innerCountNumberOfFollowersInChain(it.leading, count + 1);
    }

    /**
    Gets the last link on the chain
    */
    public static function getLastLinkOnChain(it: Follower):Follower {
        return innerGetLastLinkOnChain(it);
    }
    private static function innerGetLastLinkOnChain(it: Follower):Follower {
        if (it == null) return null;
        if (it.leading == null) return it;
        return innerGetLastLinkOnChain(it.leading);
    }
}
