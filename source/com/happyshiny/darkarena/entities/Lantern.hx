package com.happyshiny.darkarena.entities;

import org.flixel.FlxSprite;

class Lantern extends Powerup
{
    public function new(x, y)
    {
        super(x,y);

        makeGraphic(10, 10, 0xffffff00);
        centerOffsets();
    }
}
