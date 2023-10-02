package signals;

import entities.Survivor;
import flixel.util.FlxSignal;

class Lifecycle {
	/**
	 * Startup signals will be called once the game is loaded and Flixel is initialized
	 */
	public static var startup:FlxSignal = new FlxSignal();

	public static var personPickedUp:FlxTypedSignal<(Survivor)->Void> = new FlxTypedSignal<(Survivor)->Void>();
	public static var personHit:FlxTypedSignal<(Survivor)->Void> = new FlxTypedSignal<(Survivor)->Void>();
	public static var personDelivered:FlxTypedSignal<(Survivor)->Void> = new FlxTypedSignal<(Survivor)->Void>();
}
