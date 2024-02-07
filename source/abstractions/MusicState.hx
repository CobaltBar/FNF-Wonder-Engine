package abstractions;

import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;

class MusicState extends FlxTransitionableState
{
	var curStep:Int = 0;
	var curBeat:Int = 0;

	var bpm:Float = 100;

	var curTime:Float = 0;

	var timeScale:Float = 1;
	var transitioningOut:Bool = false;

	var beatsMS:Float = 0;
	var stepsMS:Float = 0;

	var transitionFromPoint:FlxPoint;
	var transitionToPoint:FlxPoint;

	var camerasToBop:Array<FlxCamera> = [];
	var shouldBop:Bool = true;
	var shouldZoom:Bool = true;
	var targetZoom:Float = 1;

	public override function create():Void
	{
		transitionFromPoint = new FlxPoint(-1, 0);
		transitionToPoint = new FlxPoint(1, 0);

		camerasToBop.push(FlxG.camera);

		beatsMS = ((60 / bpm) * 1000);
		stepsMS = beatsMS * 0.25;

		transIn = FlxTransitionableState.defaultTransIn = new TransitionData(FADE, 0xff000000, 0.5, transitionFromPoint);
		transOut = FlxTransitionableState.defaultTransOut = new TransitionData(FADE, 0xff000000, 0.5, transitionToPoint);
		super.create();
	}

	public override function update(elapsed:Float)
	{
		curTime += elapsed * 1000 * timeScale;
		updateCurStep();
		if (shouldZoom)
			for (cam in camerasToBop)
			{
				if (cam == null)
					continue;
				cam.zoom = FlxMath.lerp(cam.zoom, targetZoom, elapsed * 3.25);
			}
		super.update(elapsed);
	}

	private function updateCurStep():Void
	{
		if (curStep != Math.floor(curTime / stepsMS))
		{
			curStep = Math.floor(curTime / stepsMS);
			onStep();
		}
	}

	public function onStep():Void
		if (curStep % 4 == 0 && curStep > 0)
			onBeat();

	public function onBeat():Void
	{
		if (!transitioningOut && shouldBop)
			for (cam in camerasToBop)
			{
				if (cam == null)
					continue;
				cam.zoom = 1.05;
			}
		curBeat++;
	}

	public static function switchState(state:FlxState, skipTransitionIn:Bool = false, skipTransitionOut:Bool = false):Void
	{
		FlxTransitionableState.skipNextTransIn = skipTransitionIn;
		FlxTransitionableState.skipNextTransOut = skipTransitionOut;
		FlxG.switchState(state);
	}
}