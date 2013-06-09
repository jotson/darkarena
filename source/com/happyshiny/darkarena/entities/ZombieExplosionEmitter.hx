package com.happyshiny.darkarena.entities;

import org.flixel.FlxG;
import org.flixel.FlxParticle;
import org.flixel.FlxSprite;

class ZombieExplosionEmitter extends org.flixel.addons.FlxEmitterExt
{
    public static var LIFESPAN = 0.25;

    public function new()
    {
        super(0, 0, 3);

        particleClass = ZombieExplosionParticle;
        setMotion(0, 0, LIFESPAN);
        minRotation = 0;
        maxRotation = 0;

        width = 25;
        height = 25;

        for(i in 0...maxSize)
        {
            add(new ZombieExplosionParticle());
        }
    }

    public function go()
    {
        start(true, LIFESPAN);
        for(i in 1...6)
        {
            var t : FlxSprite = cast(G.bodies.recycle(FlxSprite), FlxSprite);
            t.loadGraphic("assets/images/blood-splatters.png", false, false, 50, 50);
            t.frame = Std.random(t.frames);
            t.x = x + Math.random() * 50 - 25;
            t.y = y + Math.random() * 50 - 25;
            t.alpha = 0;
            angle = Std.random(360);
            FlxG.tween(t, { alpha: 0.5 }, 0.2);
            G.bodies.add(t);
        }

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
        addAnimation("default", [0,1,2,3,4,5], 24, false);

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
        angle = Std.random(360);
        play("default", true);
    }
}
