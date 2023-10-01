package score;

// Score for a level
typedef LevelScore = {
    levelName: String,
    survivorsSaved: Int,
    survivorsKilled: Int,
    survivorsLongestChain: Int,
    playerCrashes: Int,
    timeTaken: Int,
};

class ScoreManager {
    static var completedLevelScores: Array<LevelScore> = [];
    static var currentScore: LevelScore = null;

    public static function getAllScores(): Array<LevelScore> {
        return completedLevelScores;
    }

    public static function createEmptyScore(levelName: String): LevelScore {
        return {
            levelName: levelName,
            survivorsSaved: 0,
            survivorsKilled: 0,
            survivorsLongestChain: 0,
            playerCrashes: 0,
            timeTaken: 0,
        }
    }

    public static function startLevel(levelName: String) {
        currentScore = createEmptyScore(levelName);
    }

    public static function endCurrentLevel(timeTaken: Int) {
        currentScore.timeTaken = timeTaken;
        completedLevelScores.push(currentScore);
    }

    public static function survivorSaved() {
        currentScore.survivorsSaved += 1;
    }

    public static function survivorKilled() {
        currentScore.survivorsKilled += 1;
    }

    public static function maybeUpdateLongestChain(chainLen: Int) {
        if (currentScore.survivorsLongestChain < chainLen) {
            currentScore.survivorsLongestChain = chainLen;
        }
    }

    public static function playerCrashed() {
        currentScore.playerCrashes += 1;
    }
}