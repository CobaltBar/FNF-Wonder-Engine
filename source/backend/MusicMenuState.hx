package backend;

import flixel.FlxObject;

class MusicMenuState extends MusicState
{
	var curSelected:Int = 0;
	var menuOptions:Array<FlxSprite> = [];

	var menuCam:FlxCamera;
	var optionsCam:FlxCamera;
	var otherCam:FlxCamera;

	var menuFollow:FlxObject;
	var optionsFollow:FlxObject;

	var bg:FlxSprite;

	@:noCompletion var handleInput:Bool = true;
	@:noCompletion var skipCamerasSetup:Bool = false;

	public override function create():Void
	{
		if (!skipCamerasSetup)
		{
			menuCam = Util.createCamera(false, true);
			optionsCam = Util.createCamera(false, true);
			otherCam = Util.createCamera(false, true);
			menuFollow = new FlxObject(FlxG.width * .5, FlxG.height * .5);
			optionsFollow = new FlxObject(FlxG.width * .5, FlxG.height * .5);
			menuCam.follow(menuFollow, LOCKON, .1);
			optionsCam.follow(optionsFollow, LOCKON, .15);
			camerasToBop.push(menuCam);
			camerasToBop.push(optionsCam);
		}
		super.create();
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.sound.music != null && FlxG.sound.music.volume < .8)
			FlxG.sound.music.volume += .5 * elapsed;

		if (handleInput && !transitioningOut)
		{
			if (Controls.ui_down)
				changeSelection(1);

			if (Controls.ui_up)
				changeSelection(-1);

			if (Controls.accept)
				exitState();

			if (Controls.back)
				returnState();
		}
	}

	public function changeSelection(change:Int):Void
	{
		if (change != 0)
			FlxG.sound.play(Path.sound('Scroll'), .7);

		curSelected += change;

		if (curSelected < 0)
			curSelected = menuOptions.length - 1;
		if (curSelected >= menuOptions.length)
			curSelected = 0;
	}

	public function exitState():Void
	{
		transitioningOut = true;
		FlxG.sound.play(Path.sound('Confirm'), .7);
	}

	public function returnState():Void
	{
		transitioningOut = true;
		FlxG.sound.play(Path.sound('Cancel'), .7);
	}
}
