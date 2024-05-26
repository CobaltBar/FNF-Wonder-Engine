package objects;

import flixel.graphics.frames.FlxFilterFrames;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;

class StrumNote extends Note
{
	var strumRGB:RGBPalette = new RGBPalette();
	var blurSpr:Note;

	public var glowAlphaTarget:Float = 0;

	public function new(noteData:Int = 2, ?mod:Mod)
	{
		super(noteData, mod);
		shader = strumRGB.shader;
		strumRGB.set(0x87A3AD, -1, 0);
		blurSpr = new Note(noteData, mod);
		blurSpr.targetSprite = this;
		blurSpr.shader = rgb.shader;
		blurSpr.blend = ADD;
		blurSpr.alpha = glowAlphaTarget;
		FlxFilterFrames.fromFrames(blurSpr.frames, 64, 64, [new BlurFilter(72, 72)]).applyToSprite(blurSpr, false, true);
	}

	public override function update(elapsed:Float)
	{
		if (blurSpr.x != x)
			blurSpr.x = x;
		if (blurSpr.y != y)
			blurSpr.y = y;
		blurSpr.alpha = FlxMath.lerp(blurSpr.alpha, glowAlphaTarget, FlxMath.bound(elapsed * (glowAlphaTarget > blurSpr.alpha ? 40 : 10), 0, 1));
		super.update(elapsed);
	}

	public override function draw()
	{
		super.draw();
		blurSpr.draw();
	}

	@:noCompletion override function set_cameras(val:Array<FlxCamera>):Array<FlxCamera>
	{
		blurSpr.cameras = val;
		return super.set_cameras(val);
	}

	@:noCompletion override function set_angle(val:Float):Float
	{
		blurSpr.angle = val;
		return super.set_angle(val);
	}
}
