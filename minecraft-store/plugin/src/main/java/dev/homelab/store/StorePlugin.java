package dev.homelab.store;

import com.sun.net.httpserver.HttpServer;
import org.bukkit.Bukkit;
import org.bukkit.Material;
import org.bukkit.command.Command;
import org.bukkit.command.CommandSender;
import org.bukkit.configuration.file.YamlConfiguration;
import org.bukkit.entity.Player;
import org.bukkit.inventory.ItemStack;
import org.bukkit.plugin.java.JavaPlugin;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

public class StorePlugin extends JavaPlugin {

    private YamlConfiguration credits;
    private File creditsFile;
    private HttpServer server;

    @Override
    public void onEnable() {
        saveDefaultConfig();
        creditsFile = new File(getDataFolder(), "credits.yml");
        credits = YamlConfiguration.loadConfiguration(creditsFile);
        startHttp();
        getLogger().info("StorePlugin enabled - API on :" + getConfig().getInt("port", 8090));
    }

    @Override
    public void onDisable() {
        if (server != null) server.stop(0);
        saveCredits();
    }

    // ---------- Credits persistence ----------
    private void saveCredits() {
        try { credits.save(creditsFile); } catch (IOException e) { getLogger().warning("credits save failed: " + e.getMessage()); }
    }

    private int getCredits(String uuid) { return credits.getInt("credits." + uuid, 0); }
    private void addCredits(String uuid, int amt) {
        credits.set("credits." + uuid, getCredits(uuid) + amt);
        saveCredits();
    }

    // ---------- Whitelist helpers (offline-mode UUID aware) ----------
    private String offlineUuid(String name) {
        try {
            byte[] digest = java.security.MessageDigest.getInstance("MD5")
                .digest(("OfflinePlayer:" + name).getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) sb.append(String.format("%02x", b));
            String hex = sb.toString();
            return String.format("%s-%s-3%s-8%s-%s",
                hex.substring(0, 8), hex.substring(8, 12), hex.substring(12, 15),
                hex.substring(17, 20), hex.substring(20, 32));
        } catch (java.security.NoSuchAlgorithmException e) {
            return null;
        }
    }

    private void addWhitelist(String name, String uuid) {
        Bukkit.getScheduler().runTask(this, () -> {
            Bukkit.dispatchCommand(Bukkit.getConsoleSender(), "whitelist add " + name);
            getLogger().info("Whitelisted " + name + " (" + uuid + ")");
            Player p = Bukkit.getPlayerExact(name);
            if (p != null) {
                p.kickPlayer("§aAccess granted - reconnect to join!");
            }
        });
    }

    private void removeWhitelist(String name) {
        Bukkit.getScheduler().runTask(this, () -> {
            Bukkit.dispatchCommand(Bukkit.getConsoleSender(), "whitelist remove " + name);
            getLogger().info("Removed whitelist " + name);
            Player p = Bukkit.getPlayerExact(name);
            if (p != null) {
                p.kickPlayer("§cSubscription expired - renew at the store.");
            }
        });
    }

    // ---------- HTTP API ----------
    private void startHttp() {
        try {
            server = HttpServer.create(new InetSocketAddress(getConfig().getInt("port", 8090)), 0);
            String token = getConfig().getString("api-token", "changeme");

            server.createContext("/api/credits/get", ex -> {
                if (!auth(ex, token)) return;
                String name = query(ex, "name");
                Player p = Bukkit.getPlayerExact(name);
                String uuid = p != null ? p.getUniqueId().toString() : null;
                if (uuid == null) { json(ex, 404, "{\"error\":\"player offline\"}"); return; }
                json(ex, 200, "{\"name\":\"" + name + "\",\"credits\":" + getCredits(uuid) + "}");
            });

            server.createContext("/api/credits/add", ex -> {
                if (!auth(ex, token)) return;
                String name = query(ex, "name");
                int amount = intQuery(ex, "amount", 0);
                Player p = Bukkit.getPlayerExact(name);
                String uuid = p != null ? p.getUniqueId().toString() : null;
                if (uuid == null) { json(ex, 404, "{\"error\":\"player offline\"}"); return; }
                addCredits(uuid, amount);
                json(ex, 200, "{\"ok\":true,\"credits\":" + getCredits(uuid) + "}");
            });

            server.createContext("/api/items/give", ex -> {
                if (!auth(ex, token)) return;
                String name = query(ex, "name");
                String item = query(ex, "item");
                int count = Math.max(1, intQuery(ex, "count", 1));
                Player p = Bukkit.getPlayerExact(name);
                if (p == null) { json(ex, 404, "{\"error\":\"player offline\"}"); return; }
                Material m = Material.matchMaterial(item);
                if (m == null) { json(ex, 400, "{\"error\":\"bad item\"}"); return; }
                p.getInventory().addItem(new ItemStack(m, count));
                json(ex, 200, "{\"ok\":true}");
            });

            server.createContext("/api/whitelist/add", ex -> {
                if (!auth(ex, token)) return;
                String name = query(ex, "name");
                addWhitelist(name, offlineUuid(name));
                json(ex, 200, "{\"ok\":true}");
            });

            server.createContext("/api/whitelist/remove", ex -> {
                if (!auth(ex, token)) return;
                String name = query(ex, "name");
                removeWhitelist(name);
                json(ex, 200, "{\"ok\":true}");
            });

            server.start();
        } catch (IOException e) {
            getLogger().severe("HTTP server failed: " + e.getMessage());
        }
    }

    private boolean auth(com.sun.net.httpserver.HttpExchange ex, String token) {
        String h = ex.getRequestHeaders().getFirst("Authorization");
        if (h == null || !h.equals("Bearer " + token)) {
            try { json(ex, 401, "{\"error\":\"unauthorized\"}"); } catch (IOException ignored) {}
            return false;
        }
        return true;
    }

    private String query(com.sun.net.httpserver.HttpExchange ex, String key) {
        String q = ex.getRequestURI().getRawQuery();
        if (q == null) return "";
        for (String kv : q.split("&")) {
            String[] p = kv.split("=", 2);
            if (p.length == 2 && p[0].equals(key))
                return java.net.URLDecoder.decode(p[1], StandardCharsets.UTF_8);
        }
        return "";
    }

    private int intQuery(com.sun.net.httpserver.HttpExchange ex, String key, int def) {
        try { return Integer.parseInt(query(ex, key)); } catch (NumberFormatException e) { return def; }
    }

    private void json(com.sun.net.httpserver.HttpExchange ex, int code, String body) throws IOException {
        byte[] b = body.getBytes(StandardCharsets.UTF_8);
        ex.getResponseHeaders().set("Content-Type", "application/json");
        ex.sendResponseHeaders(code, b.length);
        try (OutputStream os = ex.getResponseBody()) { os.write(b); }
    }

    // ---------- Commands ----------
    @Override
    public boolean onCommand(CommandSender sender, Command cmd, String label, String[] args) {
        if (cmd.getName().equalsIgnoreCase("credits")) {
            if (!(sender instanceof Player p)) { sender.sendMessage("in-game only"); return true; }
            sender.sendMessage("§aCredits: §e" + getCredits(p.getUniqueId().toString()));
            return true;
        }
        if (cmd.getName().equalsIgnoreCase("buy")) {
            if (!(sender instanceof Player p)) { sender.sendMessage("in-game only"); return true; }
            if (args.length < 1) { sender.sendMessage("§cUsage: /buy <item>"); return true; }
            String item = args[0].toLowerCase();
            String uuid = p.getUniqueId().toString();
            int cost = getConfig().getInt("shop." + item, -1);
            if (cost < 0) { sender.sendMessage("§cUnknown item. Available: " + getConfig().getConfigurationSection("shop").getKeys(false)); return true; }
            int bal = getCredits(uuid);
            if (bal < cost) { sender.sendMessage("§cNot enough credits (" + bal + "/" + cost + ")"); return true; }
            Material m = Material.matchMaterial(item.toUpperCase());
            if (m == null) { sender.sendMessage("§cBad item"); return true; }
            p.getInventory().addItem(new ItemStack(m, 1));
            credits.set("credits." + uuid, bal - cost);
            saveCredits();
            sender.sendMessage("§aBought " + item + " for " + cost + " credits. Balance: §e" + (bal - cost));
            return true;
        }
        if (cmd.getName().equalsIgnoreCase("setcredits")) {
            if (args.length < 2) { sender.sendMessage("§c/setcredits <player> <amount>"); return true; }
            Player t = Bukkit.getPlayerExact(args[0]);
            if (t == null) { sender.sendMessage("§cplayer offline"); return true; }
            credits.set("credits." + t.getUniqueId(), Integer.parseInt(args[1]));
            saveCredits();
            sender.sendMessage("§aSet " + args[0] + " credits to " + args[1]);
            return true;
        }
        return false;
    }
}
