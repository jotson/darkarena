package com.happyshiny.darkarena.entities;

import org.flixel.FlxSprite;

class Lantern extends Powerup
{
    public function new(x, y)
    {
        super(x,y);

        loadGraphic("assets/images/lantern.png", true, false, 16, 32    );
        addAnimation("default", [0,1,2,3,2,1,2,3,2,1,2,3,2,3,2,3,2,1,2,3,2,3,2,3], 15, true);
        play("default");

        centerOffsets();
    }
}
