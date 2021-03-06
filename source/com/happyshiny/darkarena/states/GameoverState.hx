package com.happyshiny.darkarena.states;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import nme.Lib;
import nme.ui.Mouse;
import nme.events.KeyboardEvent;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;

import com.happyshiny.util.SoundManager;
import org.flixel.tweens.FlxTween;

class GameoverState extends FlxState
{
    private var timer : Float = 3;

    public override function create():Void
    {
        var grid = FlxG.height/16;

        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        // Keyboard events
        FlxG.tween(this, {}, 3,
        {
            complete:
                function()
                {
                    var t = new FlxText(0, grid * 10, FlxG.width, "Press any key to continue");
                    t.setFormat(G.FONT, 30, 0xff990000, "center", 0x000000, true);
                    FlxG.tween(t, { alpha: 0.2 }, 0.5, { type: FlxTween.PINGPONG });
                    add(t);
                }
        });

        FlxG.camera.antialiasing = true;

        #if (web || desktop)
        FlxG.mouse.show();
        #end

        add(new FlxSprite(0, 0, "assets/images/floor.png"));
        var mask = new FlxSprite(FlxG.width/2, FlxG.height/2, "assets/images/darkness-mask.png");
        mask.scale.x = 20;
        mask.scale.y = 20;
        mask.x -= mask.width/2;
        mask.y -= mask.height/2;
        mask.addAnimation('default', [0], 10);
        mask.addAnimationCallback(
            function(name, frame, index)
            {
                mask.scale.x = Math.random()*4 + 20;
                mask.scale.y = mask.scale.x;
            }
        );
        mask.play('default');
        add(mask);

        var t = new FlxText(0, grid * 3, FlxG.width, "Game Over");
        t.setFormat(G.FONT, 60, 0xff990000, "center", 0x000000, true);
        add(t);

        var t = new FlxText(0, grid * 5, FlxG.width, "Time: " + FlxU.formatMoney(G.score.time));
        t.setFormat(G.FONT, 25, 0xff99cc00, "center", 0x000000, true);
        add(t);

        var t = new FlxText(0, grid * 6, FlxG.width, "Kills: " + G.score.kills);
        t.setFormat(G.FONT, 25, 0xff99cc00, "center", 0x000000, true);
        add(t);

        var t = new FlxText(0, grid * 7, FlxG.width, "Accuracy: " + Std.string(Math.round(G.score.shotsHit/G.score.shotsFired * 1000)/10) + "%");
        t.setFormat(G.FONT, 25, 0xff99cc00, "center", 0x000000, true);
        add(t);

        SoundManager.play("deathscream");
    }
    
    public function onKeyUp(e : KeyboardEvent):Void
    {
        if (timer > 0) return;

        // Any key
        FlxG.switchState(new MenuState());
    }

    public override function destroy():Void
    {
        Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        super.destroy();
    }

    public override function update():Void
    {
        super.update();

        timer -= FlxG.elapsed;

        if (timer > 0) return;

        if (FlxG.mouse.justPressed())
        {
            FlxG.switchState(new MenuState());
        }
    }   
}
