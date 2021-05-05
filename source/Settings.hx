package;
import openfl.display.FPS;
import lime.utils.Assets;
import haxe.Json;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import openfl.Lib;
import flixel.FlxG;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
import haxe.io.Path;
import openfl.filters.ColorMatrixFilter;
import openfl.filters.BitmapFilter;

typedef Variables =
{
    var resolution:Float;
    var fullscreen:Bool;
    var fps:Int;
    var noteOffset:Int;
    var spamPrevention:Bool;
    var filter:String;
    var brightness:Int;
    var gamma:Float;
    var fpsCounter:Bool;
    var memory:Bool;
    var scroll:String;
}

// THIS IS FOR JSON TYPE IMPORTANT SETTINGS
// all minor settings go to KadeEngineData.hx
class Settings
{
    public static var _variables:Variables;

    public static var filters:Array<BitmapFilter> = [];
    public static var matrix:Array<Float>;

    public static function Save():Void
    {
        #if sys
        File.saveContent('assets/data/config.json', Json.stringify(_variables, null, "  "));
        #end
    }

    public static function Load():Void
    {
        if (#if sys !FileSystem.exists('assets/data/config.json') #else !lime.utils.Assets.exists('assets/data/config.json', TEXT) #end)
        {
            _variables = {
                resolution: 1,
                fullscreen: false,
                fps: 60,
                noteOffset: 0,
                spamPrevention: true,
                filter: 'none',
                brightness: 0,
                gamma: 1,
                fpsCounter: true,
                memory: true,
                //up to do in week 7 update
                scroll: 'up'
            };
            
            Save();
        }
        else
        {
            #if sys
            var data:String = File.getContent('assets/data/config.json');
            _variables = Json.parse(data);
            #end
        }

        FlxG.resizeWindow(Math.round(FlxG.width*_variables.resolution), Math.round(FlxG.height*_variables.resolution));
        FlxG.fullscreen = _variables.fullscreen;
        FlxG.drawFramerate = _variables.fps;
        FlxG.updateFramerate = _variables.fps;
        (cast (Lib.current.getChildAt(0), Main)).toggleFPS(_variables.fpsCounter);
        (cast (Lib.current.getChildAt(0), Main)).toggleMem(_variables.memory);

        UpdateColors();
    }

    public static function UpdateColors():Void
    {
        filters = [];
        
        switch (_variables.filter)
        {
            case 'none':
                matrix = [
                    1 * _variables.gamma, 0, 0, 0, _variables.brightness,
                    0, 1 * _variables.gamma, 0, 0, _variables.brightness,
                    0, 0, 1 * _variables.gamma, 0, _variables.brightness,
                    0, 0, 0, 1, 0,
                ];
            case 'tritanopia':
                matrix = [
                    0.20 * _variables.gamma, 0.99 * _variables.gamma, -.19 * _variables.gamma, 0, _variables.brightness,
                    0.16 * _variables.gamma, 0.79 * _variables.gamma, 0.04 * _variables.gamma, 0, _variables.brightness,
                    0.01 * _variables.gamma, -.01 * _variables.gamma,    1 * _variables.gamma, 0, _variables.brightness,
                       0,    0,    0, 1, 0,
                ];
            case 'protanopia':
                matrix = [
                    0.20 * _variables.gamma, 0.99 * _variables.gamma, -.19 * _variables.gamma, 0, _variables.brightness,
                    0.16 * _variables.gamma, 0.79 * _variables.gamma, 0.04 * _variables.gamma, 0, _variables.brightness,
                    0.01 * _variables.gamma, -.01 * _variables.gamma,    1 * _variables.gamma, 0, _variables.brightness,
                       0,    0,    0, 1, 0,
                ];
            case 'deutranopia':
                matrix = [
                    0.43 * _variables.gamma, 0.72 * _variables.gamma, -.15 * _variables.gamma, 0, _variables.brightness,
                    0.34 * _variables.gamma, 0.57 * _variables.gamma, 0.09 * _variables.gamma, 0, _variables.brightness,
                    -.02 * _variables.gamma, 0.03 * _variables.gamma,    1 * _variables.gamma, 0, _variables.brightness,
                       0,    0,    0, 1, 0,
                ];
            default: // when its null or doesnt exist
                matrix = [
                    1 * _variables.gamma, 0, 0, 0, _variables.brightness,
                    0, 1 * _variables.gamma, 0, 0, _variables.brightness,
                    0, 0, 1 * _variables.gamma, 0, _variables.brightness,
                    0, 0, 0, 1, 0,
                ];
        }

        filters.push(new ColorMatrixFilter(matrix));
        FlxG.game.filtersEnabled = true;
        FlxG.game.setFilters(filters);
    }
}