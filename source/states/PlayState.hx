package states;

<<<<<<< HEAD
import echo.util.TileMap;
import flixel.addons.editors.tiled.TiledMap;
=======
import iso.IsoEchoSprite;
>>>>>>> 166062bb7eb3204daf7176c91465758ec1a1659c
import entities.Survivor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
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
import echo.FlxEcho;

using states.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var level:Level;

	var playerGroup = new FlxGroup();
	var survivors = new FlxGroup();
	var terrain = new FlxTypedGroup<Terrain>();
	
	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.camera.pixelPerfectRender = true;

		// Echo/physics init
		FlxEcho.init({
			width: FlxG.width,
			height: FlxG.height,
		});

		#if FLX_DEBUG
		FlxG.camera.width = Std.int(FlxG.camera.width / 2);
		FlxG.camera.x += FlxG.camera.width;
		Debug.dbgCam = new FlxCamera(0, 0, camera.width, camera.height, camera.zoom);
		Debug.dbgCam.bgColor = FlxColor.RED.getDarkened(0.9);
		FlxG.cameras.add(Debug.dbgCam, false);
		FlxEcho.drawCamera = Debug.dbgCam;
		#end



		// add(Achievements.ACHIEVEMENT_NAME_HERE.toToast(true, true));

		// QuickLog.error('Example error');

		add(terrain);
		add(survivors);
		add(playerGroup);

		loadLevel("Level_0");
	}

	public function loadLevel(levelName:String) {
		terrain.forEach((t) -> {
			t.destroy();
		});
		terrain.clear();

		playerGroup.forEach((t) -> {
			t.destroy();
		});
		playerGroup.clear();

		survivors.forEach((t) -> {
			t.destroy();
		});
		survivors.clear();

		FlxEcho.clear();

		level = new Level("Level_0");

		for (y in 0...level.raw.l_Terrain.cHei) {
			for (x in 0...level.raw.l_Terrain.cWid) {
				makeTerrainPiece(level, x, y);
			}
		}

		var terrainBodies = TileMap.generate(level.terrainInts, 16, 16, level.terrainTilesWide, level.terrainTilesHigh);

		level.player.add_to_group(playerGroup);

		for (s in level.survivors) {
			s.add_to_group(survivors);
		}

		#if FLX_DEBUG
		Debug.dbgCam.follow(level.player);
		#end

		FlxG.camera.follow(level.player.sprite);

		// collide survivors as second group so they are always on the 'b' side of interaction
		FlxEcho.listen(playerGroup, survivors, {
			separate: false,
			enter: (a, b, o) -> {
				if (a.object is IsoEchoSprite) {
					var aSpr:IsoEchoSprite = cast a.object;
					aSpr.handleEnter(b, o);
				}
				if (b.object is IsoEchoSprite) {
					var bSpr:IsoEchoSprite = cast b.object;
					bSpr.handleEnter(a, o);
				}
			},
			exit: (a, b) -> {
				if (a.object is IsoEchoSprite) {
					var aSpr:IsoEchoSprite = cast a.object;
					aSpr.handleExit(b);
				}
				if (b.object is IsoEchoSprite) {
					var bSpr:IsoEchoSprite = cast b.object;
					bSpr.handleExit(a);
				}
			}
		});
	}

	public function makeTerrainPiece(level:Level, gridX:Int, gridY:Int) {
		var tileId = level.raw.l_Terrain.getTileStackAt(gridX, gridY)[0].tileId;
		terrain.add(new Terrain(gridX * Grid.CELL_SIZE, gridY * Grid.CELL_SIZE, tileId));

		// terrain.add(new Terrain(x * Grid.CELL_SIZE, y * Grid.CELL_SIZE, level.raw.l_Terrain..getInt(x, y)));
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
