package levels.ldtk;

import entities.Item;
import flixel.group.FlxGroup;
import entities.Player;

class Level {
    public var project: LDTKProject;
    public var player: Player;

    public function new(g: FlxGroup) {
        project = new LDTKProject();
        
        // Iterate all world levels
        for (level in project.all_worlds.Default.levels) {
            // Player
            if (level.l_Entities.all_Player.length > 1) {
                QuickLog.warn("more than one player loaded for level, defaulting to first one");
            }
            var firstPlayerEnt = level.l_Entities.all_Player[0];

            player = new Player();
            player.body.x = firstPlayerEnt.pixelX;
            player.body.y = firstPlayerEnt.pixelY;
            g.add(player);

            // Survivors
            // for (s in level.l_Entities.all_Survivor) {
            //     var item = new Item();
            //     item.x = s.pixelX;
            //     item.y = s.pixelY;
            //     g.add(item);
            // }
        }
    }
}
