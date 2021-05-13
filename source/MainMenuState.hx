package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxRainbowEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.math.FlxMath;
import Alphabet.Alphabet;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var menuItemEffect:FlxTypedGroup<FlxEffectSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end
	var wipShit:Array<Bool> = [false, true, false];

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var descriptiontext:FlxText;
	var descriptiontitle:Alphabet;
	var selection1:FlxText;
	var selection2:FlxText;
	var selection3:FlxText;
	var currSelected:Array<Bool> = [true, false];

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItemEffect = new FlxTypedGroup<FlxEffectSprite>();
		add(menuItemEffect); 

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		var rainbowTexto = new FlxRainbowEffect(1, 1, 7);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(160 + (i * 200), 160 + (i * 200));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			var effectItem:FlxEffectSprite = new FlxEffectSprite(menuItem, [rainbowTexto]);
			effectItem.ID = i;
			effectItem.x -= 500;
			effectItem.antialiasing = true;
			// menuItemEffect.add(effectItem);
			menuItems.add(menuItem);
			// menuItem.scrollFactor.set(); give it some groove for once
			menuItem.x -= 500;
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.04 * (60 / _variables.fps));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer + ' - Shit Engine', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		descriptiontext = new FlxText(0, FlxG.height - 200, "");
    	descriptiontext.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descriptiontext.scrollFactor.set();
		descriptiontext.screenCenter(X);
    	add(descriptiontext);
		
		descriptiontitle = new Alphabet(0, FlxG.height - 200, "", true);
		descriptiontitle.scrollFactor.set();
		descriptiontitle.screenCenter(X);
    	add(descriptiontitle);

		var scoreBG:FlxSprite = new FlxSprite(FlxG.width * 0.7 - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 76, 0xFF000000);
		scoreBG.alpha = 0.6;
		scoreBG.scrollFactor.set();
		add(scoreBG);

		selection1 = new FlxText(FlxG.width * 0.7, 5, 0, "Downscroll: OFF", 32);
		// scoreText.autoSize = false;
		selection1.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
		selection1.scrollFactor.set();
		// scoreText.alignment = RIGHT;
		add(selection1);
		selection2 = new FlxText(FlxG.width * 0.7, 5, 0, "Offset: 0", 32);
		// scoreText.autoSize = false;
		selection2.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
		selection2.scrollFactor.set();
		// scoreText.alignment = RIGHT;
		add(selection2);
		selection3 = new FlxText(FlxG.width * 0.7, 5, 0, "S Frames: 0", 32);
		// scoreText.autoSize = false;
		selection3.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
		selection3.scrollFactor.set();
		// scoreText.alignment = RIGHT;
		add(selection3);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		selection1.text = "Downscroll:" + (FlxG.save.data.downscroll ? " ON" : " OFF") + " (L)";
		selection2.text = "\nOffset: " + _variables.noteOffset + " (Q AND E)";
		selection3.text = "\n\nS Frames: " + FlxG.save.data.frames + " (R AND Y)";
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		descriptiontext.screenCenter(X);
		descriptiontitle.screenCenter(X);

		menuItems.forEach(function(spr:FlxSprite)
			{
				spr.scale.set(FlxMath.lerp(spr.scale.x, 1, 0.5/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 1, 0.4/(_variables.fps/60)));

				if (spr.ID == curSelected)
				{
					spr.scale.set(FlxMath.lerp(spr.scale.x, 1.0, 0.5/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 1.0, 0.4/(_variables.fps/60)));
				}
	
				spr.updateHitbox();
			});

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (FlxG.keys.justPressed.L)
			{
				FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
				FlxG.save.flush();
			}

			if (FlxG.keys.justPressed.E)
			{
				_variables.noteOffset++;
				Settings.Save();
			}

			if (FlxG.keys.justPressed.Q)
			{
				_variables.noteOffset--;
				Settings.Save();
			}

			if (FlxG.keys.justPressed.Y)
			{
				FlxG.save.data.frames++;
				FlxG.save.flush();
			}

			if (FlxG.keys.justPressed.R)
			{
				FlxG.save.data.frames--;
				FlxG.save.flush();
			}

			/*
			if (FlxG.keys.justPressed.CONTROL && controls.LEFT_P)
			{
				currSelected[0] = !currSelected[1];
				currSelected[1] = !currSelected[0];
			}

			if (FlxG.keys.justPressed.CONTROL && controls.RIGHT_P)
			{
				currSelected[0] = !currSelected[1];
				currSelected[1] = !currSelected[0];
			}*/

			/*
			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			} crashes for some reason :/*/

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		/*
		menuItemEffect.forEach(function(spr:FlxEffectSprite)
		{
			var position1:Float = 0;
			var position2:Float = 0;
			menuItems.forEach(function(spr2:FlxSprite)
			{
				if (spr.ID != curSelected)
				{
					position1 = spr2.x;
					position2 = spr2.y;
				}
			});
			spr.setPosition(position1, position2);
			spr.x += FlxG.random.float(-30, 30);
			spr.y += FlxG.random.float(-30, 30);
		});
		*/

		super.update(elapsed);
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.scale.set(0.5, 0.5);
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});

		description(optionShit[curSelected], wipShit[curSelected]);

		/*
		menuItemEffect.forEach(function(spr:FlxEffectSprite)
		{
			if (spr.ID == curSelected)
			{
				var position1:Float = 0;
				var position2:Float = 0;
				menuItems.forEach(function(spr2:FlxSprite)
				{
					if (spr.ID == curSelected)
					{
						position1 = spr2.x;
						position2 = spr2.y;
					}
				});
				spr.setPosition(position1, position2);
				spr.alpha = 1;
			}
		});
		*/
	}

	function description(name:String = "shitass", isWip:Bool = false)
	{
		var description:String = "";
		switch (name)
		{
			case "story mode": 
				description = "Play through\nthe main storyline!";
			case "freeplay": 
				description = "Play any song from a week!";
			case "donate": 
				description = "Donate you coward.";
			case "options": 
				description = "Set your options\nto your content!";
			default: 
				description = "null"; // ha
		}
		if (descriptiontitle != null)
			remove(descriptiontitle);
		descriptiontitle = new Alphabet(0, FlxG.height - 200, name, true);
		descriptiontitle.scrollFactor.set();
		descriptiontitle.screenCenter(X);
    	add(descriptiontitle);
		descriptiontext.text = "\n \n" + description;
	}
}
