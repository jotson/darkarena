package com.happyshiny.darkarena.entities;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxU;

class Player extends FlxSprite
{
    public static var ACCELERATION = 300;
    public static var DRAG = 300;
    public static var MAXHEALTH = 3;

    public var lanternTimer : Float = 0;
    public var lanternArea : Float;

    private var darkness : FlxSprite;

    public function new(x, y)
    {
        super(x, y);

        makeGraphic(15, 15, 0xffff0000);
        centerOffsets();

        drag.x = Player.DRAG;
        drag.y = Player.DRAG;

        health = MAXHEALTH;

        darkness = new FlxSprite(x, y);
        darkness.loadGraphic("assets/images/darkness-mask.png");
        darkness.centerOffsets();
        darkness.scale.x = 8;
        darkness.scale.y = 8;
        darkness.addAnimation('default', [0], 10);
        darkness.addAnimationCallback(
            function(name, frame, index)
            {
                darkness.scale.x = Math.random() * 3 + G.player.lanternArea;
                darkness.scale.y = darkness.scale.x;
            }
        );
        darkness.play('default');
        FlxG.state.add(darkness);
    }

    public override function update()
    {
        super.update();

        lanternTimer -= FlxG.elapsed;
        if (lanternTimer <= 0)
        {
            lanternArea = 8;
        }

        darkness.x = x - darkness.width/2 + width/2;
        darkness.y = y - darkness.height/2 + height/2;

        // Keep in bounds
        if (x + width > FlxG.width)
        {
            x = FlxG.width - width;
            velocity.x = -velocity.x;
        }
        if (x < 0)
        {
            x = 0;
            velocity.x = -velocity.x;
        }
        if (y + height > FlxG.height)
        {
            y = FlxG.height - height;
            velocity.y = -velocity.y;
        }
        if (y < 0)
        {
            y = 0;
            velocity.y = -velocity.y;
        }
    }

    public function getLantern()
    {
        lanternTimer = 8;
        lanternArea = 16;
    }

    public function hit(Damage : Float, p : FlxPoint)
    {
        FlxG.camera.shake(0.01, 0.2);

        flicker(1);

        // Push back
        var angle = FlxU.degreesToRadians(FlxU.getAngle(getMidpoint(), p) - 90);
        x += -10 * Math.cos(angle);
        y += -10 * Math.sin(angle);
        velocity.x = 0;
        velocity.y = 0;

        super.hurt(Damage);

        if (!alive) G.gameOver();
    }
}
