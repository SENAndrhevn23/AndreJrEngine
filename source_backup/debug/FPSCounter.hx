package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
 * Psych 0.6.3 compatible FPS counter with background (H-Slice style)
 */
class FPSCounter extends TextField
{
	public var currentFPS(default, null):Int;
	public var memoryMegas(get, never):Float;

	@:noCompletion private var times:Array<Float>;
	var deltaTimeout:Float = 0.0;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFFFF)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		times = [];

		selectable = false;
		mouseEnabled = false;

		defaultTextFormat = new TextFormat("_sans", 14, color);
		autoSize = LEFT;
		multiline = true;

		// ✅ H-SLICE STYLE BACKGROUND
		background = true;
		backgroundColor = 0x88000000; // semi-transparent black

		text = "FPS:";
	}

	private override function __enterFrame(deltaTime:Float):Void
	{
		if (deltaTimeout > 1000)
		{
			deltaTimeout = 0.0;
			return;
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);

		while (times.length > 0 && times[0] < now - 1000)
			times.shift();

		currentFPS = times.length < FlxG.drawFramerate ? times.length : FlxG.drawFramerate;

		updateText();
		deltaTimeout += deltaTime;
	}

	public dynamic function updateText():Void
	{
		text = 'FPS: ${currentFPS}'
			+ '\nMemory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}';

		// Color logic (same as yours)
		textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.5)
			textColor = 0xFFFF0000;
	}

	inline function get_memoryMegas():Float
		return cast(System.totalMemory, UInt);
}