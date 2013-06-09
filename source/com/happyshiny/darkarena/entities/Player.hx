package com.happyshiny.darkarena.entities;

import com.happyshiny.util.SoundManager;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxU;

class Player extends FlxSprite
{
    public static var ACCELERATION = 300;
    public static var DRAG = 1000;
    public static var MAX_HEALTH = 3;

    public var lanternTimer : Float = 0;
    public var lanternArea : Float;

    private var darkness : FlxSprite;

    public var muzzlePosition : FlxPoint;

    public function new(x, y)
    {
        super(x, y);

        loadGraphic("assets/images/player.png", true, false, 15, 15);

        centerOffsets();
        scale.x = 3;
        scale.y = 3;

        addAnimation("default", [0], 1, true);
        addAnimation("running", [0,1,0,2], 10, true);
        play("default");

        this.addAnimationCallback(
            function(name, frame, index)
            {
                if (index == 1 || index == 3)
                {
                    SoundManager.play("footsteps");
                }
            }
        );

        drag.x = Player.DRAG;
        drag.y = Player.DRAG;

        health = MAX_HEALTH;

        muzzlePosition = new FlxPoint(0,0);

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

        angle = FlxU.getAngle(getMidpoint(), FlxG.mouse.getScreenPosition());
        if (acceleration.x == 0 && acceleration.y == 0)
        {
            play("default");
        }
        else
        {
            play("running");
        }

        muzzlePosition = FlxU.rotatePoint(x + width/2 + 3 * scale.x, y + height/2 + 10 * scale.y, x + width/2, y + width/2, angle);

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

        flicker(0.5);

        SoundManager.play("playerhurt");

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
