package iso;

import flixel.FlxObject;

class Overlap {
	// returns true if blocks overlap on all 3 axes in iso projection space
	public static function doSpritesOverlapInIsoSpace(a:IsoSprite, b:IsoSprite):Bool {
		var aXMin = a.isoXmin;
		var aXMax = a.isoXmax;
		var aYMin = a.isoYmin;
		var aYMax = a.isoYmax;
		var aHMin = a.hMin;
		var aHMax = a.hMax;

		var bXMin = b.isoXmin;
		var bXMax = b.isoXmax;
		var bYMin = b.isoYmin;
		var bYMax = b.isoYmax;
		var bHMin = b.hMin;
		var bHMax = b.hMax;

		var xOverlap = !(aXMin >= bXMax || bXMin >= aXMax);
		var yOverlap = !(aYMin >= bYMax || bYMin >= aYMax);
		var zOverlap = !(aHMin >= bHMax || bHMin >= aHMax);

		return xOverlap && yOverlap && zOverlap;

		// Hexagons overlap if and only if all axis regions overlap.
		// return ( // test if x regions intersect.
		// 	!(a.gridXmin >= b.gridXmax || b.gridXmin >= a.gridXmax) && // test if y regions intersect.
		// 	!(a.gridYmin >= b.gridYmax || b.gridYmin >= a.gridYmax) && // test if h regions intersect.
		// 	!(a.hMin >= b.hMax || b.hMin >= a.hMax));
	}

	public static function isSpriteInFront(a:IsoSprite, b:IsoSprite) {
		// test for intersection x-axis
		// (larger x value is in front)
		var aGXMin = a.gridXmin;
		var bGXMax = b.gridXmax;
		if (a.gridXmin >= b.gridXmax) {
			return true;
		} else if (b.gridXmin >= a.gridXmax) {
			return false;
		}

		// test for intersection y-axis
		// (larger2 y value is in front)
		if (a.gridYmin >= b.gridYmax) {
			return true;
		} else if (b.gridYmin >= a.gridYmax) {
			return false;
		}

		// // test for intersection z-axis
		// // (higher z value is in front)

		// TODO: This doesn't seem to be operating correctly for the floating cube test.
		// This check should be triggering, but it is not
		var aGZMin = a.gridZmin;
		var aGZMax = a.gridZmax;
		var bGZMin = b.gridZmin;
		var bGZMax = b.gridZmax;
		if (a.gridZmin >= b.gridZmax) {
			return true;
		} else if (b.gridZmin >= a.gridZmax) {
			return false;
		}

		// default response
		return false;
	}

	public static function isoCollide(a:IsoSprite, b:IsoSprite):Bool {
		if (a.gridZmax <= b.gridZmin || b.gridZmax <= a.gridZmin) {
			// if they don't overlap on the z-axis, they don't collide
			return false;
		} else {
			var moved = FlxObject.separate(a, b);
			if (!moved) {
				// crushed?
			}
			return moved;
		}
	}
}
