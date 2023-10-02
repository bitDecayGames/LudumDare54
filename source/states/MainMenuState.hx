package states;

import flixel.util.FlxTimer;
import input.SimpleController;
import flixel.util.FlxSpriteUtil;
import ui.font.BitmapText.CruiseText;
import flixel.FlxSprite;
import bitdecay.flixel.transitions.TransitionDirection;
import bitdecay.flixel.transitions.SwirlTransition;
import states.AchievementsState;
import com.bitdecay.analytics.Bitlytics;
import config.Configure;
import flixel.FlxG;
import flixel.addons.ui.FlxUICursor;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUITypedButton;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxefmod.flixel.FmodFlxUtilities;

using states.FlxStateExt;

#if windows
import lime.system.System;
#end

class MainMenuState extends FlxUIState {

	var acceptInput = false;

	override public function create():Void {
		super.create();

		bgColor = FlxColor.TRANSPARENT;
		FlxG.camera.pixelPerfectRender = true;

		// Trigger our focus logic as we are just creating the scene
		this.handleFocus();

		// we will handle transitions manually
		transOut = null;

		var bgImage = new FlxSprite(AssetPaths.titleScreen__png);
		add(bgImage);

		var start = new CruiseText("Press Start");
		start.x = (256 - start.width) / 2;
		start.y = FlxG.height - start.height - 15;
		start.borderStyle = OUTLINE;
		start.borderColor = FlxColor.BLACK;
		start.visible = false;

		new FlxTimer().start(1, (t) -> {
			start.visible = true;
			FlxSpriteUtil.flicker(start, 0, 0.5);
			acceptInput = true;
		});

		add(start);
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			var button_action:String = params[0];
			trace('Action: "${button_action}"');

			if (button_action == "play") {
				clickPlay();
			}

			if (button_action == "credits") {
				clickCredits();
			}

			if (button_action == "achievements") {
				clickAchievements();
			}

			#if windows
			if (button_action == "exit") {
				clickExit();
			}
			#end
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.pressed.D && FlxG.keys.justPressed.M) {
			// Keys D.M. for Disable Metrics
			Bitlytics.Instance().EndSession(false);
			FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
			trace("---------- Bitlytics Stopped ----------");
		}

		if (acceptInput) {
			if (SimpleController.just_pressed(A) || SimpleController.just_pressed(START)) {
				clickPlay();
				acceptInput = false;
			}
		}
	}

	function clickPlay():Void {
		FmodFlxUtilities.TransitionToState(new PlayState());
	}

	function clickCredits():Void {
		FmodFlxUtilities.TransitionToState(new CreditsState());
	}

	function clickAchievements():Void {
		FmodFlxUtilities.TransitionToState(new AchievementsState());
	}

	#if windows
	function clickExit():Void {
		System.exit(0);
	}
	#end

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
