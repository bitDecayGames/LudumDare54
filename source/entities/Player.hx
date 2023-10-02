package entities;

import entities.states.player.StationaryState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import signals.Lifecycle;
import input.PlayerInstanceController;
import input.IController;
import echo.math.Vector2;
import flixel.util.FlxTimer;
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

	public var speed:Float;
	public var turnSpeed:Float;
	public var turnSpeedSkid:Float;

	public var crashTurnSpeed:Int;

	public var playerNum = 0;

	public var previousVelocity:Vector2 = new Vector2(0, 0);

	public var rawAngle:Float = 0;
	public var calculatedAngle:Float = 0;

	public var boatShape:Shape;
	public var pickupShape:Shape;

	var timeSpentInLevel:Float = 0;

	// used for survivor FollowingState
	public var following:Follower;
	public var leading:Follower;

	private var stateMachine:StateMachine<Player>;

	public var isInvincible = false; // TODO: MW need to actually use this boolean to determine if collision causes crash

	public var targetX(get, null):Float;
	public var targetY(get, null):Float;

	public var controller:IController;

	public var lastCheckpoint:Null<Checkpoint>;

	public function new(x:Float, y:Float, speed:Float = 70, turnSpeed:Float = 130, turnSpeedSkid:Float = 200, crashTurnSpeed:Int = 200) {
		gridWidth = .8;
		gridLength = 6 / 16;
		gridHeight = 1;

		this.speed = speed;
		this.turnSpeed = turnSpeed;
		this.turnSpeedSkid = turnSpeedSkid;
		this.crashTurnSpeed = crashTurnSpeed;

		FlxG.log.error('Player Stats: speed:${speed}, turnSpeed:${turnSpeed}, turnSpeedSkid:${turnSpeedSkid}, crashTurnSpeed:${crashTurnSpeed}');

		super(x, y);

		sprite.offset.x += 4;
		rawAngle = -90;

		stateMachine = new StateMachine<Player>(this);
		stateMachine.setNextState(new CruisingState(this));

		controller = new PlayerInstanceController();
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
		previousVelocity.copy_from(body.velocity);

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

		#if angle_debug
		FlxG.watch.addQuick('pAngRaw:', rawAngle);
		FlxG.watch.addQuick('pAngCalc:', calculatedAngle);
		FlxG.watch.addQuick('pAngFrame:', spinFrame);
		FlxG.watch.addQuick('playerPos:', sprite.getPosition());
		#end

		FlxG.watch.addQuick('playerVel:', body.velocity);

		#if FLX_DEBUG
		FollowerHelper.drawDebugLines(this);
		#end
	}

	public function damageMe(thingBoatRanInto:FlxSprite, normal:echo.math.Vector2) {
		if (isInvincible) {
			// ignore this collision because the boat is invincible
			return;
		}

		var preVel = FlxPoint.get(previousVelocity.x, previousVelocity.y);
		var normal = FlxPoint.get(normal.x, normal.y);

		var newDir = preVel.bounce(normal);

		stateMachine.setNextState(new CrashState(this, newDir, FlxG.random.bool() ? crashTurnSpeed : -crashTurnSpeed));

		preVel.put();
		normal.put();
		newDir.put();
	}

	public function incrementCheckpoint() {
		iterateFollowers((s) -> {
			s.numCheckpointsHit += 1;
		});
	}

	public function respawn() {
		visible = true;
		if (lastCheckpoint != null) {
			body.x = lastCheckpoint.spawnPoint.x;
			body.y = lastCheckpoint.spawnPoint.y;
		}
	}

	@:access(echo.Shape)
	override function handleEnter(other:Body, data:Array<CollisionData>) {
		super.handleEnter(other, data);

		var collision = data[0];
		// colliding with survivor
		if (other.object is Survivor) {
			var survivor:Survivor = cast other.object;
			if (survivor.isCollectable()) {
				// colliding with boat
				if (collision.sa == boatShape) {
					FmodManager.PlaySoundOneShot(FmodSFX.BoatCollideSurvivor);
					FmodManager.PlaySoundOneShot(FmodSFX.VoiceHit);
					survivor.hitByObject();
					// colliding with pickup area
				} else if (collision.sa == pickupShape) {
					FmodManager.PlaySoundOneShot(FmodSFX.BoatCollectSurvivor);
					new FlxTimer().start(0.75, (t) -> {
						// Maybe no voice lines
						// FmodManager.PlaySoundOneShot(FmodSFX.VoiceRad);
					});

					if (!survivor.isFollowing()) {
						FollowerHelper.addFollower(this, survivor);
					}
				}
			}
		// colliding with debris
		} else if (other.object is Debris) {
			var debris: Debris = cast other.object;
			for (d in data) {
				// colliding with boat
				if (collision.sb == boatShape) {
					damageMe(debris, collision.normal);
					break;
				}
			}
			// colliding with pier
		} else if (other.object is Pier) {
			var pier:Pier = cast other.object;
			dropOffSurvivors(pier);
			// colliding with dam
		} else if (other.object is Dam) {
			var dam:Dam = cast other.object;
			dropOffSurvivors(dam);
			// TODO Switch to next level or end game
		}
	}

	private function removeFollowers(preRemoveCallback:Survivor->Void) {
		var lastFollower = FollowerHelper.getLastLinkOnChain(this);
		while (lastFollower != null && lastFollower != this) {
			if ((lastFollower is Survivor)) {
				var survivor:Survivor = cast lastFollower;
				preRemoveCallback(survivor);
			}
			lastFollower = FollowerHelper.stopFollowing(lastFollower);
		}
	}

	private function iterateFollowers(callback:Survivor->Void) {
		var cur = FollowerHelper.getLastLinkOnChain(this);
        while (cur != null && cur != this) {
			if ((cur is Survivor)) {
				var survivor:Survivor = cast cur;
				callback(survivor);
			}
			cur = cur.following;
        }
	}

	private function dropOffSurvivors(dropoff: IsoEchoSprite) {
		// TODO: Take control from the player
		stateMachine.setNextState(new StationaryState(this));

		// TODO SFX Dropping people off at pier/dam
		// Remove all followers
		// May need to switch animation to be pier/dam specific
		var toTween = new Array<Survivor>();
		removeFollowers((s) -> {
			// TODO This is where we would animate followers
			// being dropped off on the pier,
			toTween.push(s);
			// s.kill();
			// Lifecycle.personDelivered.dispatch(s);
		});

		new FlxTimer().start(0.3, (t) -> {
			if (t.elapsedLoops == toTween.length + 1) {
				// TODO: restore player control
				stateMachine.setNextState(new CruisingState(this));
			} else {
				var person = toTween[t.elapsedLoops-1];
				person.body.active = false;
				person.startFling();
				FlxTween.tween(person.body, {x: dropoff.body.x, y: dropoff.body.y}, 0.5, {
					ease: FlxEase.sineOut,
					onComplete: (tween) -> {
						// TODO SFX: points SFX with better sound based on t.elapsedLoops (bigger is better)
						person.startStanding();
						Lifecycle.personDelivered.dispatch(person);
					}
				});
			}
		}, toTween.length + 1);
	}

	function get_targetX():Float {
		return body.x;
	}

	function get_targetY():Float {
		return body.y;
	}
}
