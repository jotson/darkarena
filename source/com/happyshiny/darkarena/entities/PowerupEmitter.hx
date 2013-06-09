package com.happyshiny.darkarena.entities;

import org.flixel.FlxG;
import org.flixel.FlxParticle;
import org.flixel.FlxSprite;

class PowerupEmitter extends org.flixel.addons.FlxEmitterExt
{
    public static var LIFESPAN = 0.5;

    public function new()
    {
        super(0, 0, 50);

        particleClass = PowerupParticle;
        setMotion(0, 50, LIFESPAN, 360, 100);

        width = 0;
        height = 0;

        for(i in 0...maxSize)
        {
            add(new PowerupParticle());
        }
    }

    public function go()
    {
        start(true, LIFESPAN);
    }

    public function stop()
    {
        kill();
    }
}

class PowerupParticle extends FlxParticle
{
    public function new()
    {
        super();

        loadGraphic("assets/images/powerup-particle.png");

        visible = false;
    }

    public override function onEmit()
    {
        super.onEmit();

        revive();
    }

    public override function revive()
    {
        super.revive();

        visible = true;
        alpha = 1;
        scale.x = 0;
        scale.y = 0;

        FlxG.tween(this, { alpha: 0 }, PowerupEmitter.LIFESPAN);
        FlxG.tween(this.scale, { x: 1, y: 1 }, PowerupEmitter.LIFESPAN);
    }
}
