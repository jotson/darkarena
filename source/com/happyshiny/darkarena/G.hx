package com.happyshiny.darkarena;

import com.happyshiny.darkarena.entities.Lantern;
import com.happyshiny.darkarena.entities.Player;
import com.happyshiny.darkarena.entities.Powerup;
import com.happyshiny.darkarena.entities.Weapon;
import com.happyshiny.darkarena.entities.Zombie;
import com.happyshiny.darkarena.entities.Bullet;
import com.happyshiny.darkarena.states.GameoverState;
import com.happyshiny.util.SoundManager;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxU;
import org.flixel.plugin.photonstorm.FlxBar;

class G
{
    public static var FONT : String = "assets/fonts/ShareTech-Regular.ttf";

    public static var player : Player;

    public static var powerups : FlxGroup;
    public static var zombies : FlxGroup;
    public static var bodies : FlxGroup;
    public static var bullets : FlxGroup;
    public static var particles : FlxGroup;

    public static var hud : FlxGroup;
    public static var hudWeapon : FlxSprite;
    public static var hudTimer : FlxText;
    public static var hudAmmo : FlxBar;
    public static var hudKills : FlxText;

    public static var score = { kills: 0, time: 0.0, shotsHit: 0, shotsFired: 0 };

    public static var zombieTimer : Float = 0;
    public static var zombieSpawnTime : Float = 5;

    public static var weaponTypePistol = { strength: 1, cooldown: 0.5, burst: 1, clip: 30 };
    public static var weaponTypeShotgun = { strength: 3, cooldown: 1, burst: 1, clip: 10 };
    public static var weaponTypeMGBurst = { strength: 1, cooldown: 1, burst: 3, clip: 30 };
    public static var weaponTypeMGAuto = { strength: 1, cooldown: 1, burst: 30, clip: 30 };
    public static var weaponTypeShotgunAuto = { strength: 3, cooldown: 1, burst: 3, clip: 9 };

    public static var weapon : Dynamic;
    public static var weaponTimers : Dynamic;
    public static var powerupTimers : Dynamic;

    public static function reset()
    {
        score.time = 0;
        score.kills = 0;
        score.shotsHit = 0;
        score.shotsFired = 0;
        zombieTimer = 0;
        zombieSpawnTime = 5;

        weapon = weaponTypePistol;
        weaponTimers = { nextShot: 0.0, cooldown: 0.0, burst: 0, ammo: weapon.clip };
        powerupTimers = { timer: 0.0, lanterns: 0, ammo: 0, weapons: 0, maxLanterns: 2, maxAmmo: 2, maxWeapons: 2, cooldown: 15 };

        G.powerups = new FlxGroup();
        G.zombies = new FlxGroup();
        G.bodies = new FlxGroup();
        G.bullets = new FlxGroup();
        G.particles = new FlxGroup();
        G.hud = new FlxGroup();

        FlxG.state.add(G.bodies);
        FlxG.state.add(G.powerups);
        FlxG.state.add(G.zombies);
        FlxG.state.add(G.bullets);
        FlxG.state.add(G.particles);

        // Add player
        G.player = new Player(FlxG.width/2, FlxG.height/2);
        FlxG.state.add(G.player);

        // Add HUD
        hudWeapon = new FlxSprite();
        hudAmmo = new FlxBar(10, 30, FlxBar.FILL_LEFT_TO_RIGHT, 100, 30, weaponTimers, "ammo", 0, weapon.clip, true);
        hudAmmo.createGradientBar([0xff000000,0xff000000], [0xffff0000,0xffff0000], 1, 180, true);

        // Timer
        var t = new FlxText(FlxG.width - 110, 10, 100, "Time");
        t.setFormat("assets/fonts/ShareTech-Regular.ttf", 20, 0xffffffff, "right", 0x000000, true);
        hud.add(t);
        hudTimer = new FlxText(FlxG.width - 110, 30, 100, "");
        hudTimer.setFormat("assets/fonts/ShareTech-Regular.ttf", 30, 0xffff0000, "right", 0x000000, true);

        // Kills
        var t = new FlxText(hudTimer.x - hudTimer.width - 110, 10, 100, "Kills");
        t.setFormat("assets/fonts/ShareTech-Regular.ttf", 20, 0xffffffff, "right", 0x000000, true);
        hud.add(t);
        hudKills = new FlxText(hudTimer.x - hudTimer.width - 110, 30, 100, "");
        hudKills.setFormat("assets/fonts/ShareTech-Regular.ttf", 30, 0xffff0000, "right", 0x000000, true);

        hud.add(hudWeapon);
        hud.add(hudAmmo);
        hud.add(hudTimer);
        hud.add(hudKills);
        FlxG.state.add(G.hud);
    }

    public static function update()
    {
        score.time += FlxG.elapsed;
        zombieTimer -= FlxG.elapsed;
        weaponTimers.cooldown -= FlxG.elapsed;
        weaponTimers.nextShot -= FlxG.elapsed;

        updateHud();

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

        G.addPowerup();
    }

    public static function addPowerup()
    {
        powerupTimers.timer -= FlxG.elapsed;

        if (powerupTimers.timer > 0) return;

        powerupTimers.timer = powerupTimers.cooldown;

        if (powerupTimers.lanterns < powerupTimers.maxLanterns)
        {
            var o = cast(powerups.recycle(Lantern), Powerup);
            o.revive();
        }

        if (powerupTimers.weapons < powerupTimers.maxWeapons)
        {
            var o = cast(powerups.recycle(Weapon), Powerup);
            o.revive();
        }
    }

    public static function addKill()
    {
        score.kills++;
    }

    public static function updateHud()
    {
        G.hudKills.text = Std.string(score.kills);
        G.hudTimer.text = Std.string(FlxU.formatMoney(score.time, true));
    }

    public static function getInput()
    {
        G.player.acceleration.y = 0;
        G.player.acceleration.x = 0;

        if (G.player.flickering) return;

        if (FlxG.keys.pressed("W")) G.player.acceleration.y = -Player.ACCELERATION;
        if (FlxG.keys.pressed("A")) G.player.acceleration.x = -Player.ACCELERATION;
        if (FlxG.keys.pressed("S")) G.player.acceleration.y = Player.ACCELERATION;
        if (FlxG.keys.pressed("D")) G.player.acceleration.x = Player.ACCELERATION;

        if (FlxG.mouse.pressed() && weaponTimers.cooldown <= 0 && weaponTimers.nextShot <= 0 && weaponTimers.ammo > 0)
        {
            if (weaponTimers.nextShot <= -0.2) weaponTimers.burst = 0;

            weaponTimers.nextShot = 0.1;

            weaponTimers.burst += 1;
            if (weaponTimers.burst >= weapon.burst)
            {
                weaponTimers.cooldown = weapon.cooldown;
                weaponTimers.burst = 0;
            }

            FlxG.camera.shake(0.005, 0.08);

            var p = FlxG.mouse.getScreenPosition();
            var bullet = cast(G.bullets.recycle(Bullet), Bullet);
            bullet.revive();
            bullet.strength = weapon.strength;
            bullet.x = G.player.x + G.player.width/2;
            bullet.y = G.player.y + G.player.height/2;
            bullet.fireAt(p);

            score.shotsFired++;
            weaponTimers.ammo -= 1;
        }
    }

    public static function collide()
    {
        FlxG.overlap(player, zombies,
            function(player, zombie)
            {
                var zombie : Zombie = cast(zombie, Zombie);
                G.player.hit(zombie.strength, zombie.getMidpoint());
                zombie.hit(0, player.getMidpoint());
            }
        );

        FlxG.overlap(player, powerups,
            function(player, powerup)
            {
                switch(FlxU.getClassName(powerup, true))
                {
                    case "Lantern":
                        G.player.getLantern();
                        powerup.kill();

                    case "Weapon":
                        var w = cast(powerup, Weapon);
                        G.weaponTimers.ammo = w.weapon.clip;
                        G.weaponTimers.cooldown = w.weapon.cooldown;
                        G.weapon = w.weapon;
                        hudAmmo.setRange(0, w.weapon.clip);
                        powerup.kill();
                }
            }
        );

        FlxG.overlap(bullets, zombies,
            function(bullet, zombie)
            {
                var bullet : Bullet = cast(bullet, Bullet);
                var zombie : Zombie = cast(zombie, Zombie);
                bullet.kill();
                zombie.hit(bullet.strength, bullet.getMidpoint());
                G.score.shotsHit++;
            }
        );
    }

    public static function gameOver()
    {
        FlxG.switchState(new GameoverState());
    }
}
