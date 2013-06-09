package com.happyshiny.darkarena.entities;

import org.flixel.FlxSprite;

class Lantern extends Powerup
{
    public function new(x, y)
    {
        super(x,y);

        loadGraphic("assets/images/lantern.png", true, false, 32, 64);
        addAnimation("default", [0,1,2,1], 15, true);
        play("default");

        scale.x = 0.5;
        scale.y = 0.5;

        centerOffsets();
    }
}
