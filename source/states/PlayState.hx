package states;

import iso.Grid;
import entities.Terrain;
import debug.Debug;
import flixel.FlxCamera;
import entities.Item;
import flixel.util.FlxColor;
import debug.DebugLayers;
import achievements.Achievements;
import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import entities.Player;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import bitdecay.flixel.debug.DebugDraw;
import levels.ldtk.Level;

using states.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var level:Level;
	
	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.camera.pixelPerfectRender = true;

		#if FLX_DEBUG
		FlxG.camera.width = Std.int(FlxG.camera.width / 2);
		Debug.dbgCam = new FlxCamera(Std.int(camera.x + camera.width), 0, camera.width, camera.height, camera.zoom);
		Debug.dbgCam.bgColor = FlxColor.RED.getDarkened(0.9);
		FlxG.cameras.add(Debug.dbgCam, false);
		#end

		for (x in 0...5) {
			for (y in 0...5) {
				var tile = 0;
				if (x == 0 || x == 4) {
					tile = 1;
				}
				var bgTile = new Terrain(x * Grid.CELL_SIZE, y * Grid.CELL_SIZE, tile);
				bgTile.alpha = 0.2;
				bgTile.sprite.alpha = 0.5;
				add(bgTile);
			}
		}

		FlxG.camera.bgColor = FlxColor.fromString("0x6495ed"); // cornflower blue

		level = new Level(this);

		#if FLX_DEBUG
		Debug.dbgCam.follow(level.player);
		#end

		FlxG.camera.follow(level.player.sprite);

		// add(Achievements.ACHIEVEMENT_NAME_HERE.toToast(true, true));

		// QuickLog.error('Example error');
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		var cam = FlxG.camera;
		DebugDraw.ME.drawCameraRect(cam.getCenterPoint().x - 5, cam.getCenterPoint().y - 5, 10, 10, DebugLayers.RAYCAST, FlxColor.RED);

		if (FlxG.keys.pressed.P) {
			Grid.drawGrid(5, 5);
		}
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
