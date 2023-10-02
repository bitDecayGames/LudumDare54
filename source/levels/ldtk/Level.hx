package levels.ldtk;

import entities.Debris;
import iso.IsoEchoSprite;
import entities.Dam;
import entities.Pier;
import entities.Survivor;
import flixel.group.FlxGroup;
import entities.Player;
import entities.Current;
import entities.Checkpoint;

class Level {
	public static var project = new LDTKProject();

	private static inline var CELL_PIXEL_WIDTH = 16;
	private static inline var CELL_PIXEL_HEIGHT = 16;

	public var player:Player;

	public var survivors = new Array<Survivor>();
	public var debris = new Array<IsoEchoSprite>();
	public var currents = new Array<Current>();
	public var piers = new Array<Pier>();
	public var dams = new Array<Dam>();
	public var checkpoints = new Array<Checkpoint>();

	public var raw:levels.ldtk.LDTKProject.LDTKProject_Level = null;

	public var terrainInts = new Array<Int>();
	public var terrainTilesHigh = 0;
	public var terrainTilesWide = 0;

	public function new(level:String) {
		raw = project.all_worlds.Default.getLevel(level);

		// Player
		if (raw.l_Entities.all_Player.length > 1) {
			QuickLog.warn("more than one player loaded for level, defaulting to first one");
		}
		var firstPlayerEnt = raw.l_Entities.all_Player[0];

		player = new Player(firstPlayerEnt.pixelX, firstPlayerEnt.pixelY, firstPlayerEnt.f_Speed, firstPlayerEnt.f_TurnSpeed, firstPlayerEnt.f_TurnSpeedSkid);

		// Survivors
		for (s in raw.l_Entities.all_Survivor) {
			var ent = new Survivor(s.pixelX, s.pixelY);
			survivors.push(ent);
		}

		// Debris (Logs, etc.)
		for (l in raw.l_Entities.all_Log) {
			var ent = new Debris(l.pixelX, l.pixelY);
			debris.push(ent);
		}

		// Piers
		for (p in raw.l_Entities.all_Pier) {
			var ent = new Pier(p.pixelX, p.pixelY);
			piers.push(ent);
		}

		// Dam
		for (d in raw.l_Entities.all_Dam) {
			var ent = new Dam(d.pixelX, d.pixelY);
			dams.push(ent);
		}

		// Checkpoints
		for (cp in raw.l_Entities.all_Checkpoint) {
			var ent = new Checkpoint(player, cp.pixelX, cp.pixelY, cp.f_EndPoint.cx * CELL_PIXEL_WIDTH + CELL_PIXEL_WIDTH / 2.0, cp.f_EndPoint.cy * CELL_PIXEL_HEIGHT + CELL_PIXEL_HEIGHT / 2.0, cp.f_SpawnPoint.cx * CELL_PIXEL_WIDTH + CELL_PIXEL_WIDTH / 2.0, cp.f_SpawnPoint.cy * CELL_PIXEL_HEIGHT + CELL_PIXEL_HEIGHT / 2.0);
			checkpoints.push(ent);
		}

		// Currents
		for (c in raw.l_Entities.all_Current) {
			// only create a current if it has a Next value and it can be found in the current entities
			if (c.f_Next != null && c.f_Next.entityIid != null && c.f_Next.entityIid != "") {
				var nextId = c.f_Next.entityIid;
				for (c2 in raw.l_Entities.all_Current) {
					if (c2.iid == nextId) {
						var ent = new Current(c.pixelX, c.pixelY, c2.pixelX, c2.pixelY, c.f_Radius, c.f_Strength);
						currents.push(ent);
						break;
					}
				}
			}
		}

		var rawTerrainLayer = raw.l_Terrain;
		terrainTilesWide = rawTerrainLayer.cWid;
		terrainTilesHigh = rawTerrainLayer.cHei;
		for (ch in 0...rawTerrainLayer.cHei) {
			for (cw in 0...rawTerrainLayer.cWid) {
				if (rawTerrainLayer.hasAnyTileAt(cw, ch)) {
					var tileStack = rawTerrainLayer.getTileStackAt(cw, ch);
					terrainInts.push(tileStack[tileStack.length - 1].tileId);
				} else {
					terrainInts.push(0);
				}
			}
		}
	}
}
