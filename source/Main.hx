package;

import openfl.display.BlendMode;
import openfl.text.TextFormat;
import openfl.display.Application;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import haxe.display.FsPath;
import haxe.Timer;
import openfl.system.System;
import openfl.text.TextField;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	public static var watermarks = false; // Whether to put Kade Engine liteartly anywhere

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{

		// quick checks 

		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		game = new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);

		addChild(game);

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		memoryCounter = new MemoryCounter(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		addChild(memoryCounter);
		Settings.Load();
		toggleFPS(_variables.fpsCounter);
		toggleMem(_variables.memory);
		#if STUDIO
		flixel.addons.studio.FlxStudio.create(); // easier offset management
		#end
		watermarks = false; //fuck off kade
		#end
	}

	var game:FlxGame;

	var fpsCounter:FPS;

	public function toggleFPS(fpsEnabled:Bool):Void {
		fpsCounter.visible = fpsEnabled;
	}

	public function toggleMem(memEnabled:Bool):Void {
		memoryCounter.visible = memEnabled;
	}

	public function changeFPSColor(color:FlxColor)
	{
		fpsCounter.textColor = color;
		memoryCounter.textColor = color;
	}

	public function setFPSCap(cap:Float)
	{
		FlxG.updateFramerate = Std.int(cap);
		FlxG.drawFramerate = FlxG.updateFramerate;
	}

	public function getFPSCap():Float
	{
		return FlxG.drawFramerate;
	}

	public function getFPS():Float
	{
		return fpsCounter.currentFPS;
	}

	public static var memoryCounter:MemoryCounter;
}

/**
 * FPS class extension to display memory usage.
 * @author Kirill Poletaev
 */
class MemoryCounter extends TextField
{
	private var times:Array<Float>;
	private var memPeak:Float = 0;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000) 
	{
		super();
		x = inX;
		y = inY;
		selectable = false;
		defaultTextFormat = new TextFormat("_sans", 12, inCol);

		text = "";
		times = [];
		addEventListener(Event.ENTER_FRAME, onEnter);

		width = 150;

		height = 70;
	}

	private function onEnter(_)
	{	
		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100)/100;
		if (mem > memPeak) memPeak = mem;
		if (visible)
		{	
			text = "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB";	
		}
	}
}
