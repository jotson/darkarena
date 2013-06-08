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
            case 1:
                weapon = G.weaponTypeShotgun;
            case 2:
                weapon = G.weaponTypeSemiauto;
            case 3:
                weapon = G.weaponTypeMachinegun;
            case 4:
                weapon = G.weaponTypeAutoShotgun;
        }

        loadGraphic(weapon.graphic);
        centerOffsets();
    }
}
