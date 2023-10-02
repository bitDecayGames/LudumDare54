package entities;

import flixel.util.FlxTimer;
import score.ScoreManager;
import iso.Grid;
import flixel.util.FlxColor;
import bitdecay.flixel.debug.DebugDraw;
import entities.statemachine.StateMachine;
import echo.data.Data.CollisionData;
import entities.Follower.FollowerHelper;
import iso.IsoEchoSprite;
import echo.Body;
import echo.Shape;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import iso.IsoSprite;
import flixel.FlxSprite;
import input.InputCalcuator;
import input.SimpleController;
import loaders.Aseprite;
import loaders.AsepriteMacros;

import flixel.FlxObject;

import entities.statemachine.StateMachine;
import entities.states.player.CruisingState;
import entities.states.player.CrashState;
import bitdecay.flixel.debug.DebugDraw;
class Player extends IsoEchoSprite implements Follower {
	public static var anims = AsepriteMacros.tagNames("assets/aseprite/rotation_template.json");
	public static var layers = AsepriteMacros.layerNames("assets/aseprite/characters/player.json");
	public static var eventData = AsepriteMacros.frameUserData("assets/aseprite/characters/player.json", "Layer 1");

	public var speed:Float = 70;
	public var turnSpeed:Float = 130;
	public var turnSpeedSkid:Float = 200;
	public var playerNum = 0;

	public var rawAngle:Float = 0;
	public var calculatedAngle:Float = 0;

	public var boatShape: Shape;
	public var pickupShape: Shape;

	var timeSpentInLevel:Float = 0;

	// used for survivor FollowingState
	public var following:Follower;
	public var leading:Follower;

	private var stateMachine:StateMachine<Player>;

	public var isInvincible = false; // TODO: MW need to actually use this boolean to determine if collision causes crash

	public var targetX(get, null):Float;
	public var targetY(get, null):Float;


	public function new(x:Float, y:Float) {
		gridWidth = .8;
		gridLength = 6/16;
		gridHeight = 1;

		super(x, y);

		sprite.offset.x += 4;
		rawAngle = -90;

		stateMachine = new StateMachine<Player>(this);
		stateMachine.setNextState(new CruisingState(this));
	}


	override function configSprite() {
		this.sprite = new FlxSprite();
		Aseprite.loadAllAnimations(this.sprite, AssetPaths.boat__json);
		animation.callback = (anim, frame, index) -> {
			if (eventData.exists(index)) {
				trace('frame $index has data ${eventData.get(index)}');
			}
		};
	}

	override function makeBody():Body {
		var body = this.add_body({
			x: x,
			y: y,
			shapes: [
				// Boat collision shape
				{
					type: RECT,
					width: gridWidth * 16,
					height: gridLength * 16,
				},
				// Survivor pickup area
				{
					type: RECT,
					width: 18,
					height: 28,
					offset_x: -8,
					solid: false,
				}
			],
		});

		boatShape = body.shapes[0];
		pickupShape = body.shapes[1];

		return body;
	}

	override function setBounds() {
		boatShape.bounds(bounds);
	}

	override public function update(delta:Float) {
		super.update(delta);

		timeSpentInLevel += delta;

		stateMachine.update(delta);

		// aka 16 segments
		var segmentSize = 360.0 / 16;
		var halfSegment = segmentSize / 2;

		var angleDeg = rawAngle;
		var intAngle = FlxMath.wrap(cast angleDeg + halfSegment, 0, 359);
		var spinFrame = Std.int(intAngle / segmentSize);
		sprite.animation.frameIndex = spinFrame;
		body.rotation = calculatedAngle;

		FlxG.watch.addQuick('pAngRaw:', rawAngle);
		FlxG.watch.addQuick('pAngCalc:', calculatedAngle);
		FlxG.watch.addQuick('pAngFrame:', spinFrame);

		FlxG.watch.addQuick('playerPos:', sprite.getPosition());

		#if FLX_DEBUG
		FollowerHelper.drawDebugLines(this);
		#end
	}

    public function damageMe(thingBoatRanInto:FlxSprite) {
		if (isInvincible) {
			// ignore this collision because the boat is invincible
			return;
		}

		var directionToFling = FlxPoint.get(thingBoatRanInto.x - x, thingBoatRanInto.y - y);
		stateMachine.setNextState(new CrashState(this, directionToFling));
    }

	@:access(echo.Shape)
	override function handleEnter(other:Body, data:Array<CollisionData>) {
		super.handleEnter(other, data);

		var collision = data[0];
		// colliding with survivor
		if (other.object is Survivor) {
			var survivor: Survivor = cast other.object;
			if (survivor.isCollectable()) {
				// colliding with boat
				if (collision.sa == boatShape) {
					FmodManager.PlaySoundOneShot(FmodSFX.BoatCollideSurvivor);
					FmodManager.PlaySoundOneShot(FmodSFX.VoiceHit);
					ScoreManager.survivorKilled();
					survivor.hitByObject();
				// colliding with pickup area
				} else if (collision.sa == pickupShape) {
					FmodManager.PlaySoundOneShot(FmodSFX.BoatCollectSurvivor);
					new FlxTimer().start(0.75, (t) -> {
						FmodManager.PlaySoundOneShot(FmodSFX.VoiceRad);
					});

					if (!survivor.isFollowing()) {
						FollowerHelper.addFollower(this, survivor);
					}
				}
			}
		// colliding with log
		} else if (other.object is Log) {
			var log: Log = cast other.object;
			// colliding with boat
			if (collision.sb == boatShape) { 
				ScoreManager.playerCrashed();
				damageMe(log);
			}
		// colliding with pier
		} else if (other.object is Pier) {
			var pier: Pier = cast other.object;
			dropOffSurvivors();
		// colliding with dam
		} else if (other.object is Dam) {
			var dam: Dam = cast other.object;
			dropOffSurvivors();
			ScoreManager.endCurrentLevel(timeSpentInLevel);
			// TODO Switch to next level or end game
		}
	}

	private function dropOffSurvivors() {
		// TODO SFX Dropping people off at pier/dam
		var followerCount = FollowerHelper.countNumberOfFollowersInChain(this);
		ScoreManager.maybeUpdateLongestChain(followerCount);

		// Remove all followers
		// May need to switch animation to be pier/dam specific
		var lastFollower = FollowerHelper.getLastLinkOnChain(this);
		while (lastFollower != null && lastFollower != this) {
			if (lastFollower is Survivor) {
				var survivor: Survivor = cast lastFollower;
				// TODO This is where we would animate followers
				// being dropped off on the pier
				survivor.kill();
				ScoreManager.survivorSaved(followerCount);
			}
			lastFollower = FollowerHelper.stopFollowing(lastFollower);
		}
	}

	function get_targetX():Float {
		return body.x;
	}

	function get_targetY():Float {
		return body.y;
	}
}
