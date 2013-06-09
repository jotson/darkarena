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
    public static var absoluteMovement : Bool = false;

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

    public static var weaponTypePistol = { strength: 1.0, cooldown: 0.5, burst: 1, clip: 30, graphic: "assets/images/pistol.png" };
    public static var weaponTypeShotgun = { strength: 3.0, cooldown: 1.0, burst: 1, clip: 8, graphic: "assets/images/shotgun.png" };
    public static var weaponTypeSemiauto = { strength: 1.0, cooldown: 1.0, burst: 3, clip: 30, graphic: "assets/images/semiauto.png" };
    public static var weaponTypeMachinegun = { strength: 0.5, cooldown: 1.0, burst: 30, clip: 30, graphic: "assets/images/machinegun.png" };
    public static var weaponTypeAutoShotgun = { strength: 3.0, cooldown: 1.0, burst: 4, clip: 12, graphic: "assets/images/autoshotgun.png" };

    public static var weapon : Dynamic;
    public static var weaponTimers : Dynamic;
    public static var powerupTimers : Dynamic;

    public static var muzzleFlash : FlxSprite;

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
        powerupTimers = { timer: 0.0, lanterns: 0, ammo: 0, weapons: 0, maxLanterns: 2, maxAmmo: 2, maxWeapons: 2, cooldown: 10 };

        G.powerups = new FlxGroup();
        G.zombies = new FlxGroup();
        G.bodies = new FlxGroup(250);
        G.bullets = new FlxGroup();
        G.particles = new FlxGroup();
        G.hud = new FlxGroup();

        FlxG.state.add(G.bodies);
        FlxG.state.add(G.powerups);
        FlxG.state.add(G.zombies);
        FlxG.state.add(G.bullets);
        FlxG.state.add(G.particles);

        muzzleFlash = new FlxSprite(0, 0, "assets/images/muzzle-flash.png");
        muzzleFlash.visible = false;
        G.particles.add(muzzleFlash);

        // Add player
        G.player = new Player(FlxG.width/2, FlxG.height/2);
        FlxG.state.add(G.player);

        // Add HUD
        hudWeapon = new FlxSprite(120, 30);
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

        updateHud();
        updateHudWeapon();
    }

    public static function update()
    {
        score.time += FlxG.elapsed;
        zombieTimer -= FlxG.elapsed;
        weaponTimers.cooldown -= FlxG.elapsed;
        weaponTimers.nextShot -= FlxG.elapsed;

        muzzleFlash.x = G.player.muzzlePosition.x - muzzleFlash.width/2;
        muzzleFlash.y = G.player.muzzlePosition.y - muzzleFlash.height/2;
        muzzleFlash.angle = G.player.angle;
        muzzleFlash.visible = false;

        updateHud();

        if (zombieTimer <= 0)
        {
            zombieTimer = zombieSpawnTime;
            zombieSpawnTime -= 0.1;
            if (zombieSpawnTime < 2) zombieSpawnTime = 2;

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

    public static function updateHudWeapon()
    {
        hudAmmo.setRange(0, weapon.clip);

        hudWeapon.loadGraphic(weapon.graphic);
    }

    public static function getInput()
    {
        G.player.acceleration.y = 0;
        G.player.acceleration.x = 0;

        if (G.player.flickering) return;

        if (G.absoluteMovement)
        {
            // Absolute movement directions
            if (FlxG.keys.pressed("W")) G.player.acceleration.y = -Player.ACCELERATION;
            if (FlxG.keys.pressed("A")) G.player.acceleration.x = -Player.ACCELERATION;
            if (FlxG.keys.pressed("S")) G.player.acceleration.y = Player.ACCELERATION;
            if (FlxG.keys.pressed("D")) G.player.acceleration.x = Player.ACCELERATION;
        }
        else
        {
            // Move based on facing
            // Strafing ("A" and "D" feel weird)
            var angle = FlxU.degreesToRadians(FlxU.getAngle(G.player.getMidpoint(), FlxG.mouse.getScreenPosition()) - 90);
            if (FlxG.keys.pressed("W"))
            {
                G.player.acceleration.x = Player.ACCELERATION * Math.cos(angle);
                G.player.acceleration.y = Player.ACCELERATION * Math.sin(angle);
            }
            if (FlxG.keys.pressed("S"))
            {
                angle += Math.PI;
                G.player.acceleration.x = Player.ACCELERATION * Math.cos(angle);
                G.player.acceleration.y = Player.ACCELERATION * Math.sin(angle);
            }
        }

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
            bullet.fireAt(p);

            muzzleFlash.visible = true;

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
                if (!zombie.flickering)
                {
                    G.player.hit(zombie.strength, zombie.getMidpoint());
                    zombie.hit(0, player.getMidpoint());
                }
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
                        powerup.kill();

                        updateHudWeapon();
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
