package entities;

import iso.IsoEchoSprite;

class Bobber extends IsoEchoSprite {
    public var maxBob:Float;
    public var minBob:Float;
    public var bobVel:Float;
    public var bobGravity:Float;
    public var bobDampening:Float;
    public var bobbingEnabled:Bool = true;

    public function new(x:Float = 0, y:Float = 0) {
        bobVel = minBob;
        super(x, y);
        initBobbingValues();
    }

	// this function should be overridden by the child class, these values are decent to start with
    private function initBobbingValues() {
        this.maxBob = 1;
        this.minBob = .5;
        this.bobVel = minBob;
        this.bobGravity = .02;
        this.bobDampening = .99;
        this.bobbingEnabled = true;
    }

    override public function update(delta:Float) {
        super.update(delta);

        if (bobbingEnabled) {
            // clamp the bobbing velocity to +/-maxBob
            if (bobVel < 0) {
                bobVel = Math.max(bobVel, -maxBob);

                // dampen the bob velocity if outside the minimum, else 100% bob elasticity
                if (bobVel < -minBob) {
                    bobVel *= bobDampening;
                }
            } else if (bobVel > 0) {
                bobVel = Math.min(bobVel, maxBob);

                // dampen the bob velocity if outside the minimum, else 100% bob elasticity
                if (bobVel > minBob) {
                    bobVel *= bobDampening;
                }
            }

            // bobbing gravity always brings the bobber back to the 0 plane (the surface of the water)
            if (z > 0) {
                bobVel -= bobGravity;
            } else {
                bobVel += bobGravity;
            }

            // add the velocity to the z
            z += bobVel;


            // for testing the applyForce function
//            if (FlxG.keys.pressed.SPACE) {
//                applyForceToBobbing(.5);
//            }
        }
    }

    // Apply a force to the bobber (think of a wave coming off of the boat to jostle the bobber more)
    public function applyForceToBobbing(magnitude:Float) {
        if (bobVel > 0) {
            bobVel += magnitude;
        } else {
            bobVel -= magnitude;
        }
    }
}
