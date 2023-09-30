package states;

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
import levels.ldtk.TestLDTKProject;

using states.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var player:FlxSprite;

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

		player = new Player();
		add(player);

		add(Achievements.ACHIEVEMENT_NAME_HERE.toToast(true, true));

		QuickLog.error('Example error');

		loadLevel();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		var cam = FlxG.camera;
		DebugDraw.ME.drawCameraRect(cam.getCenterPoint().x - 5, cam.getCenterPoint().y - 5, 10, 10, DebugLayers.RAYCAST, FlxColor.RED);
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}

	private function loadLevel() {
		// Create project instance
		var project = new TestLDTKProject();
		// Iterate all world levels
		for (level in project.all_worlds.Default.levels) {
			// Create a FlxGroup for all level layers
			var container = new FlxSpriteGroup();
			add(container);

			// Place it using level world coordinates (in pixels)
			container.x = level.worldX;
			container.y = level.worldY;

			// Attach level background image, if any
			if (level.hasBgImage()) {
				container.add(level.getBgSprite());
			}

			// Player
			if (level.l_Entities.all_Player.length > 1) {
				QuickLog.warn("more than one player loaded for level, defaulting to first one");
			}
			var firstPlayerEnt = level.l_Entities.all_Player[0];
			player.x = firstPlayerEnt.pixelX;
			player.y = firstPlayerEnt.pixelY;

			// Rescuees
			for (r in level.l_Entities.all_Rescuee) {
				var item = new Item();
				item.x = r.pixelX;
				item.y = r.pixelY;
				add(item);
			}
		}
	}
}
