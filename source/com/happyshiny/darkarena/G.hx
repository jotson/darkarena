package com.happyshiny.darkarena;

import com.happyshiny.darkarena.entities.Player;
import com.happyshiny.darkarena.entities.Zombie;
import com.happyshiny.darkarena.entities.Bullet;
import com.happyshiny.darkarena.states.GameoverState;
import com.happyshiny.util.SoundManager;
import org.flixel.FlxG;
import org.flixel.FlxGroup;

class G
{
    public static var FONT : String = "assets/fonts/ShareTech-Regular.ttf";

    public static var player : Player;

    public static var zombies : FlxGroup;
    public static var bodies : FlxGroup;
    public static var bullets : FlxGroup;
    public static var particles : FlxGroup;

    public static var zombieTimer : Float = 0;
    public static var zombieSpawnTime : Float = 5;


    public static function reset()
    {
        zombieSpawnTime = 5;
    }

    public static function update()
    {
        zombieTimer -= FlxG.elapsed;

        if (zombieTimer <= 0)
        {
            zombieTimer = zombieSpawnTime;
            zombieSpawnTime -= 0.1;
            if (zombieSpawnTime < 0.5) zombieSpawnTime = 0.5;

            var z = cast(G.zombies.recycle(Zombie), Zombie);
            z.revive();
        }

        G.getInput();
        G.collide();
    }

    public static function getInput()
    {
        G.player.acceleration.y = 0;
        G.player.acceleration.x = 0;
        if (FlxG.keys.pressed("W")) G.player.acceleration.y = -Player.ACCELERATION;
        if (FlxG.keys.pressed("A")) G.player.acceleration.x = -Player.ACCELERATION;
        if (FlxG.keys.pressed("S")) G.player.acceleration.y = Player.ACCELERATION;
        if (FlxG.keys.pressed("D")) G.player.acceleration.x = Player.ACCELERATION;

        if (FlxG.mouse.justPressed())
        {
            FlxG.camera.shake(0.005, 0.08);

            var p = FlxG.mouse.getScreenPosition();
            var bullet = cast(G.bullets.recycle(Bullet), Bullet);
            bullet.revive();
            bullet.x = G.player.x + G.player.width/2;
            bullet.y = G.player.y + G.player.height/2;
            bullet.fireAt(p);
        }
    }

    public static function collide()
    {
        FlxG.overlap(player, zombies, function(player, zombie) { player.hurt(1); zombie.kill(); });
        FlxG.overlap(bullets, zombies, function(bullet, zombie) { bullet.kill(); zombie.kill(); });
    }

    public static function gameOver()
    {
        FlxG.switchState(new GameoverState());
    }
}
