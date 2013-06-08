package com.happyshiny.darkarena.entities;

import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxU;

class Weapon extends Powerup
{
    public var weapon : Dynamic;

    public function new(x, y)
    {
        super(x,y);

        revive();
    }

    public override function revive()
    {
        super.revive();

        switch(Std.random(5))
        {
            case 0:
                weapon = G.weaponTypePistol;
                makeGraphic(5, 5, 0xffff0000);
            case 1:
                weapon = G.weaponTypeShotgun;
                makeGraphic(10, 10, 0xffff0000);
            case 2:
                weapon = G.weaponTypeMGBurst;
                makeGraphic(15, 15, 0xffff0000);
            case 3:
                weapon = G.weaponTypeMGAuto;
                makeGraphic(20, 20, 0xffff0000);
            case 4:
                weapon = G.weaponTypeShotgunAuto;
                makeGraphic(25, 25, 0xffff0000);
        }

        centerOffsets();
    }
}
