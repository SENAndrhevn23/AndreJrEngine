package;

#if cpp
import cpp.vm.Gc;
#end

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;

class SaveVariables {
	// ---------------- BEHAVIOR ----------------
	public var autoPause:Bool = true;
	public var showFPS:Bool = true;
	public var flashing:Bool = true;
	public var camZooms:Bool = true;
	public var globalAntialiasing:Bool = true;

	// ---------------- GAMEPLAY ----------------
	public var downScroll:Bool = false;
	public var middleScroll:Bool = false;
	public var ghostTapping:Bool = true;
	public var opponentStrums:Bool = true;
	public var noReset:Bool = false;
	public var noteOffset:Int = 0;

	public var ratingOffset:Int = 0;
	public var sickWindow:Float = 45;
	public var goodWindow:Float = 90;
	public var badWindow:Float = 135;
	public var safeFrames:Float = 10;

	// ---------------- VISUAL ----------------
	public var hideHud:Bool = false;
	public var noteSplashes:Bool = true;

	public var arrowHSV:Array<Array<Int>> = [
		[0,0,0],[0,0,0],[0,0,0],[0,0,0]
	];

	public var comboOffset:Array<Int> = [0,0,0,0];
	public var timeBarType:String = 'Time Left';
	public var healthBarAlpha:Float = 1;
	public var lowQuality:Bool = false;
	public var shaders:Bool = true;
	public var framerate:Int = 60;

	// ---------------- COMBO POPUPS (NEW SYSTEM) ----------------
	public var showCombo:Bool = true;
	public var showComboNum:Bool = true;
	public var showRating:Bool = true;

	// ---------------- OPTIMIZATION ----------------
	public var reducedGC:Bool = false;

	// ---------------- FEEDBACK ----------------
	public var scoreZoom:Bool = true;
	public var comboStacking:Bool = true;
	public var pauseMusic:String = 'Tea Time';
	public var hitsoundVolume:Float = 0;

	// ---------------- OTHER ----------------
	public var checkForUpdates:Bool = true;
	public var discordRPC:Bool = #if cpp true #else false #end;

	// ---------------- GAMEPLAY MODIFIERS ----------------
	public var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative',
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public function new() {}
}

class ClientPrefs {
	public static var data:SaveVariables = null;
	public static var defaultData:SaveVariables = null;

	public static var keyBinds:Map<String, Array<FlxKey>> = [
		'note_up' => [W, UP],
		'note_left' => [A, LEFT],
		'note_down' => [S, DOWN],
		'note_right' => [D, RIGHT],

		'ui_up' => [W, UP],
		'ui_left' => [A, LEFT],
		'ui_down' => [S, DOWN],
		'ui_right' => [D, RIGHT],

		'accept' => [SPACE, ENTER],
		'back' => [BACKSPACE, ESCAPE],
		'pause' => [ENTER, ESCAPE],
		'reset' => [R],

		'volume_mute' => [ZERO],
		'volume_up' => [NUMPADPLUS, PLUS],
		'volume_down' => [NUMPADMINUS, MINUS],

		'debug_1' => [SEVEN],
		'debug_2' => [EIGHT]
	];

	public static var gamepadBinds:Map<String, Array<FlxGamepadInputID>> = [
		'note_up' => [DPAD_UP, Y],
		'note_left' => [DPAD_LEFT, X],
		'note_down' => [DPAD_DOWN, A],
		'note_right' => [DPAD_RIGHT, B],

		'ui_up' => [DPAD_UP],
		'ui_left' => [DPAD_LEFT],
		'ui_down' => [DPAD_DOWN],
		'ui_right' => [DPAD_RIGHT],

		'accept' => [A, START],
		'back' => [B],
		'pause' => [START],
		'reset' => [BACK]
	];

	public static var defaultKeys:Map<String, Array<FlxKey>> = null;
	public static var defaultButtons:Map<String, Array<FlxGamepadInputID>> = null;

	// ---------------- FIX 1: KEY RESET SUPPORT ----------------
	public static function loadDefaultKeys()
	{
		defaultKeys = keyBinds.copy();
		defaultButtons = gamepadBinds.copy();
	}

	// ---------------- FIX 2: GAMEPLAY SETTINGS ACCESS ----------------
	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic = null):Dynamic
	{
		if (defaultValue == null)
			defaultValue = defaultData.gameplaySettings.get(name);

		return (data.gameplaySettings.exists(name)
			? data.gameplaySettings.get(name)
			: defaultValue);
	}

	// ---------------- SAVE ----------------
	public static function saveSettings()
	{
		for (key in Reflect.fields(data))
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));

		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());
		save.data.keyboard = keyBinds;
		save.data.gamepad = gamepadBinds;
		save.flush();
	}

	// ---------------- LOAD ----------------
	public static function loadPrefs()
	{
		if (data == null) data = new SaveVariables();
		if (defaultData == null) defaultData = new SaveVariables();

		for (key in Reflect.fields(data))
			if (Reflect.hasField(FlxG.save.data, key))
				Reflect.setField(data, key, Reflect.field(FlxG.save.data, key));

		if (Main.fpsVar != null)
			Main.fpsVar.visible = data.showFPS;

		#if (!html5 && !switch)
		FlxG.autoPause = data.autoPause;
		#end

		FlxG.drawFramerate = data.framerate;
		FlxG.updateFramerate = data.framerate;

		// ---------------- GC ----------------
		#if cpp
		if (data.reducedGC)
			Gc.setMinimumFreeSpace(1024 * 1024 * 128);
		else
			Gc.setMinimumFreeSpace(0);
		#end

		// ---------------- gameplay settings restore ----------------
		if (FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
				data.gameplaySettings.set(name, value);
		}

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		// controls
		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());

		if (save.data.keyboard != null)
		{
			var loaded:Map<String, Array<FlxKey>> = save.data.keyboard;
			for (c => k in loaded)
				if (keyBinds.exists(c))
					keyBinds.set(c, k);
		}

		if (save.data.gamepad != null)
		{
			var loaded2:Map<String, Array<FlxGamepadInputID>> = save.data.gamepad;
			for (c => k in loaded2)
				if (gamepadBinds.exists(c))
					gamepadBinds.set(c, k);
		}
	}
}