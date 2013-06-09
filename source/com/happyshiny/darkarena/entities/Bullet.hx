package com.happyshiny.darkarena.entities;

import com.happyshiny.util.SoundManager;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxU;

class Bullet extends FlxSprite
{
    public static var SPEED = 600;
    public var strength : Float = 1.0;

    public function new(x, y)
    {
        super(x, y);

        loadGraphic("assets/images/bullet.png");
        centerOffsets();

    }

    public override function update()
    {
        super.update();

        // Kill at boundary
        if (!this.onScreen())
        {
            SoundManager.play("ricochet");
            kill();
        }
    }

    public override function revive()
    {
        super.revive();
        velocity.x = 0;
        velocity.y = 0;
    }

    public function fireAt(p : FlxPoint)
    {
        // Move bullet to gun muzzle
        x = G.player.muzzlePosition.x - width/2;
        y = G.player.muzzlePosition.y - height/2;

        // Fire bullet in the right direction
        var degrees = FlxU.getAngle(getMidpoint(), p);
        var radians = FlxU.degreesToRadians(degrees - 90);

        velocity.x = SPEED * Math.cos(radians);
        velocity.y = SPEED * Math.sin(radians);
        angle = degrees;
    }
}
