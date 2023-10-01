package entities;

import bitdecay.flixel.debug.DebugDraw;
import bitdecay.flixel.system.QuickLog;
import debug.Debug;

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
        FollowerHelper.innerAddFollower(it, follower, []);
    }
    private static function innerAddFollower(it:Follower, follower:Follower, followerArray:Array<Follower>):Array<Follower> {
        if (it == null || follower == null) {
            return followerArray;
        }
        if (followerArray.indexOf(it) >= 0) {
            QuickLog.critical('You just created an infinite loop by adding ${follower} to the follow chain');
            return followerArray;
        }
        followerArray.push(it);
        if (it.leading != null) {
            innerAddFollower(it.leading, follower, followerArray);
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

    public static function drawDebugLines(it:Follower) {
        var f = getLastLinkOnChain(it);
        while (f != null && f.following != null) {
            DebugDraw.ME.drawWorldLine(Debug.dbgCam, f.x, f.y, f.following.x, f.following.y, null, 0x03fc41);
            f = f.following;
        }
    }
}
