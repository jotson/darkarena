package com.happyshiny.darkarena.entities;

import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Player extends FlxSprite
{
    public static var ACCELERATION = 300;
    public static var DRAG = 300;

    private var darkness : FlxSprite;

    public function new(x, y)
    {
        super(x, y);

        makeGraphic(15, 15, 0xffff0000);
        centerOffsets();

        this.drag.x = Player.DRAG;
        this.drag.y = Player.DRAG;

        darkness = new FlxSprite(x, y);
        darkness.loadGraphic("assets/images/darkness-mask.png");
        darkness.centerOffsets();
        darkness.scale.x = 8;
        darkness.scale.y = 8;
        FlxG.state.add(darkness);
    }

    public override function update()
    {
        super.update();

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
}
