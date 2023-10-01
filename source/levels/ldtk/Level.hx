package levels.ldtk;

import entities.Survivor;
import entities.Item;
import flixel.group.FlxGroup;
import entities.Player;

class Level {
    public static var project = new LDTKProject();
    public var player: Player;

    public var survivors = new Array<Survivor>();

    public var raw:levels.ldtk.LDTKProject.LDTKProject_Level = null;

    public function new(level:String) {
        
        raw = project.all_worlds.Default.getLevel(level);
        
        // Player
        if (raw.l_Entities.all_Player.length > 1) {
            QuickLog.warn("more than one player loaded for level, defaulting to first one");
        }
        var firstPlayerEnt = raw.l_Entities.all_Player[0];

        player = new Player();
        player.body.x = firstPlayerEnt.pixelX;
        player.body.y = firstPlayerEnt.pixelY;

        // Survivors
        for (s in raw.l_Entities.all_Survivor) {
            var item = new Survivor(s.pixelX, s.pixelY);
            survivors.push(item);
        }
    }
}
