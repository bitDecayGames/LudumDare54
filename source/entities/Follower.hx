package entities;

import bitdecay.flixel.debug.DebugDraw;
import bitdecay.flixel.system.QuickLog;
import debug.Debug;

interface Follower {
    public var following:Follower;
    public var leading:Follower;

    public var targetX(get, null):Float;
    public var targetY(get, null):Float;

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
        if (followerArray.contains(it)) {
            QuickLog.error('You just tried to add a follower to the chain that would create a loop');
            return followerArray;
        }
        followerArray.push(it);
        if (it.leading != null) {
            return innerAddFollower(it.leading, follower, followerArray);
        } else {
            it.leading = follower;
            follower.following = it;
            return followerArray;
        }
        return followerArray;
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
        return innerCountNumberOfFollowersInChain(it, 0, []);
    }
    private static function innerCountNumberOfFollowersInChain(it: Follower, count:Int, visited:Array<Follower>):Int {
        if (it == null || visited.contains(it)) return count;
        visited.push(it);
        return innerCountNumberOfFollowersInChain(it.leading, count + 1, visited);
    }

    /**
    Gets the last link on the chain
    */
    public static function getLastLinkOnChain(it: Follower):Follower {
        return innerGetLastLinkOnChain(it, []);
    }
    private static function innerGetLastLinkOnChain(it: Follower, visited:Array<Follower>):Follower {
        if (it == null) return null;
        if (it.leading == null || visited.contains(it)) return it;
        visited.push(it);
        return innerGetLastLinkOnChain(it.leading, visited);
    }

    public static function drawDebugLines(it:Follower) {
        var f = getLastLinkOnChain(it);
        var visited:Array<Follower> = [];
        while (f != null && f.following != null && !visited.contains(f)) {
            visited.push(f);
            DebugDraw.ME.drawWorldLine(Debug.dbgCam, f.x, f.y, f.following.x, f.following.y, null, 0x03fc41);
            f = f.following;
        }
    }
}
