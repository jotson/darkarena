package com.happyshiny.darkarena.entities;

import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Powerup extends FlxSprite
{
    private var timer : Float;

    public function new(x, y)
    {
        super(x, y);

        revive();        
    }

    public override function update()
    {
        timer -= FlxG.elapsed;

        if (timer <= 0) kill();
    }

    public override function revive()
    {
        super.revive();

        x = Math.random() * FlxG.width * 0.8 + FlxG.width * 0.1;
        y = Math.random() * FlxG.height * 0.8 + FlxG.height * 0.1;
        timer = 10;
    }
}
