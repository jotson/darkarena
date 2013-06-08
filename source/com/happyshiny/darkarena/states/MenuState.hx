package com.happyshiny.darkarena.states;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import nme.Lib;
import nme.ui.Mouse;
import nme.events.KeyboardEvent;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;

import com.happyshiny.util.SoundManager;
import org.flixel.tweens.FlxTween;

class MenuState extends FlxState
{
    public override function create():Void
    {
        // Keyboard events
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

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

        // Start
        var t = new FlxText(0, FlxG.height * 0.7, FlxG.width, "Press any key to start");
        t.setFormat(G.FONT, 30, 0xffffffff, "center");
        FlxG.tween(t, { alpha: 0.2 }, 0.5, { type: FlxTween.PINGPONG });
        add(t);

        var t = new FlxText(0, FlxG.height * 0.4, FlxG.width, "WASD to move, mouse to aim/shoot, survive as long as possible.");
        t.setFormat(G.FONT, 25, 0xffffffff, "center");
        add(t);

        var t = new FlxText(0, FlxG.height * 0.2, FlxG.width, "Dark Arena");
        t.setFormat(G.FONT, 60, 0xffffffff, "center");
        add(t);

        // SoundManager.playMusic("music");
    }
    
    public function onKeyUp(e : KeyboardEvent):Void
    {
        // Escape key (also Android back button)
        if (e.keyCode == 27)
        {
            Lib.exit();
            return;
        }

        // Any key
        FlxG.switchState(new GameState());
    }

    public override function destroy():Void
    {
        Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        super.destroy();
    }

    public override function update():Void
    {
        super.update();
    }   
}
