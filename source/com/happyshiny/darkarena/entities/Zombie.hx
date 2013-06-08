package com.happyshiny.darkarena.entities;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxU;

class Zombie extends org.flixel.FlxSprite
{
    public static var SPEED = 25;

    public var strength = 1;

    public function new(x, y)
    {
        super(x,y);

        revive();
    }

    public override function update()
    {
        super.update();

        if (flickering) return;

        // Find player
        var angle = FlxU.degreesToRadians(FlxU.getAngle(getMidpoint(), G.player.getMidpoint()) - 90);

        velocity.x = SPEED * Math.cos(angle);
        velocity.y = SPEED * Math.sin(angle);        
    }

    public function hit(Damage : Float, p : FlxPoint)
    {
        flicker(1);
        velocity.x = 0;
        velocity.y = 0;

        super.hurt(Damage);

        if (!alive) G.addKill();
    }

    public override function revive()
    {
        super.revive();

        // Create a random zombie type
        makeGraphic(20, 20, 0xff339900);
        health = 3;
        centerOffsets();

        // Random starting position
        switch(Std.random(4))
        {
            case 0:
                x = -50;
                y = Math.random() * FlxG.height;
            case 1:
                x = FlxG.width + 50;
                y = Math.random() * FlxG.height;
            case 2:
                x = Math.random() * FlxG.width;
                y = -50;
            case 3:
                x = Math.random() * FlxG.width;
                y = FlxG.height + 50;
        }
    }
}
