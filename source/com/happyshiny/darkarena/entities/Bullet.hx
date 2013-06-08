package com.happyshiny.darkarena.entities;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxU;

class Bullet extends FlxSprite
{
    public static var SPEED = 600;

    public function new(x, y)
    {
        super(x, y);

        makeGraphic(4, 4, 0xffff0000);
        centerOffsets();
    }

    public override function update()
    {
        super.update();

        // Kill at boundary
        if (!this.onScreen()) kill();
    }

    public override function revive()
    {
        super.revive();
        velocity.x = 0;
        velocity.y = 0;
    }

    public function fireAt(p : FlxPoint)
    {
        var angle = FlxU.degreesToRadians(FlxU.getAngle(getMidpoint(), p) - 90);

        velocity.x = SPEED * Math.cos(angle);
        velocity.y = SPEED * Math.sin(angle);
    }
}
