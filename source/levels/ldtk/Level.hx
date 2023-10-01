package levels.ldtk;

import entities.Log;
import entities.Survivor;
import entities.Item;
import flixel.group.FlxGroup;
import entities.Player;

class Level {
    public static var project = new LDTKProject();
    public var player: Player;

    public var survivors = new Array<Survivor>();
    public var logs = new Array<Log>();

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
