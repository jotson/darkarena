package com.happyshiny.darkarena.entities;

import org.flixel.FlxG;
import org.flixel.FlxParticle;

class ZombieExplosionEmitter extends org.flixel.addons.FlxEmitterExt
{
    public static var LIFESPAN = 0.5;

    public function new()
    {
        super(0, 0, 10);

        particleClass = ZombieExplosionParticle;
        setMotion(0, 0, LIFESPAN);
        minRotation = 0;
        maxRotation = 0;

        width = 50;
        height = 50;

        for(i in 0...maxSize)
        {
            add(new ZombieExplosionParticle());
        }
    }

    public function go()
    {
        start(false, LIFESPAN, 0.1);
        FlxG.tween(this, {}, 1, { complete: function() { this.stop(); } });
    }

    public function stop()
    {
        kill();
    }
}

class ZombieExplosionParticle extends FlxParticle
{
    public function new()
    {
        super();

        loadGraphic("assets/images/explode-particle.png", true, false, 50, 50);
        addAnimation("default", [0,1,2,3,4,5], 12, false);

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
        play("default");
    }
}
