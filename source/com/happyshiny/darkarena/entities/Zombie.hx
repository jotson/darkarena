package com.happyshiny.darkarena.entities;

import org.flixel.FlxG;
import org.flixel.FlxU;

class Zombie extends org.flixel.FlxSprite
{
    public static var SPEED = 25;

    public function new(x, y)
    {
        super(x,y);

        makeGraphic(20, 20, 0xff339900);
        centerOffsets();

        revive();
    }

    public override function update()
    {
        super.update();

        // Find player
        var angle = FlxU.degreesToRadians(FlxU.getAngle(getMidpoint(), G.player.getMidpoint()) - 90);

        velocity.x = SPEED * Math.cos(angle);
        velocity.y = SPEED * Math.sin(angle);        
    }

    public override function revive()
    {
        super.revive();

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
