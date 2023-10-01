package levels.ldtk;

import entities.Pier;
import entities.Log;
import entities.Survivor;
import entities.Item;
import flixel.group.FlxGroup;
import entities.Player;
import entities.Current;

class Level {
	public static var project = new LDTKProject();

	public var player:Player;

	public var survivors = new Array<Survivor>();
	public var logs = new Array<Log>();
	public var currents = new Array<Current>();
    public var piers = new Array<Pier>();

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

		player = new Player(firstPlayerEnt.pixelX, firstPlayerEnt.pixelY);

		// Survivors
		for (s in raw.l_Entities.all_Survivor) {
			var ent = new Survivor(s.pixelX, s.pixelY);
			survivors.push(ent);
		}

		// Logs
		for (l in raw.l_Entities.all_Log) {
			var ent = new Log(l.pixelX, l.pixelY);
			logs.push(ent);
		}

        // Piers
        for (p in raw.l_Entities.all_Pier) {
            var ent = new Pier(p.pixelX, p.pixelY);
            piers.push(ent);
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
					terrainInts.push(tileStack[0].tileId);
				} else {
					terrainInts.push(0);
				}
			}
		}
	}
}
