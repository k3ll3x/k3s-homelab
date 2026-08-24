from flask import Flask, render_template, request, jsonify
import os, requests, time, hashlib, json, threading, logging

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

# Config
PLUGIN_URL = os.getenv("PLUGIN_URL", "http://minecraft-plugin:8090")
PLUGIN_TOKEN = os.getenv("PLUGIN_TOKEN", "changeme")
PRICE_USD = float(os.getenv("PRICE_USD", "5.00"))
PAYMENT_PROVIDER = os.getenv("PAYMENT_PROVIDER", "xrp")  # xrp | stripe
DATA_DIR = os.getenv("DATA_DIR", "/app/data")
SUBS_FILE = os.path.join(DATA_DIR, "subscriptions.json")
SUB_DAYS = int(os.getenv("SUB_DAYS", "30"))

# XRP config
XRP_ADDRESS = os.getenv("XRP_ADDRESS", "")  # seller wallet (receiving)
XRP_AMOUNT_DROPS = int(os.getenv("XRP_AMOUNT_DROPS", "5000000"))  # 5 XRP = 5,000,000 drops
XRP_NODE = os.getenv("XRP_NODE", "https://s1.ripple.com:51234")

def load_subs():
    try:
        with open(SUBS_FILE) as f:
            return json.load(f)
    except Exception:
        return {}

def save_subs(subs):
    os.makedirs(DATA_DIR, exist_ok=True)
    with open(SUBS_FILE, "w") as f:
        json.dump(subs, f, indent=2)

def offline_uuid(name):
    h = hashlib.md5(("OfflinePlayer:" + name).encode()).hexdigest()
    return f"{h[0:8]}-{h[8:12]}-3{h[12:15]}-8{h[17:20]}-{h[20:32]}"

def plugin_call(method, path, payload=None):
    try:
        r = requests.request(method, f"{PLUGIN_URL}{path}",
                             json=payload, headers={"Authorization": f"Bearer {PLUGIN_TOKEN}"},
                             timeout=5)
        return r.ok, r.json() if r.ok else {}
    except Exception as e:
        app.logger.error("plugin call failed: %s", e)
        return False, {}

def xrp_verify(address, amount_drops):
    """Check ledger for a recent payment of amount to address (last 50 tx)."""
    payload = {"method": "account_tx", "params": [{"account": address, "limit": 50}]}
    try:
        r = requests.post(XRP_NODE, json=payload, timeout=10)
        txs = r.json().get("result", {}).get("transactions", [])
        for t in reversed(txs):
            tx = t.get("tx", {})
            if (tx.get("TransactionType") == "Payment"
                    and tx.get("Destination") == address
                    and int(tx.get("Amount", 0)) >= amount_drops
                    and t.get("validated", True)):
                return True
    except Exception as e:
        app.logger.error("xrp verify failed: %s", e)
    return False

def expire_check():
    """Background: revoke access for expired subscriptions."""
    while True:
        time.sleep(3600)  # hourly
        subs = load_subs()
        now = time.time()
        for name, sub in list(subs.items()):
            if sub.get("paid_until", 0) < now:
                plugin_call("POST", f"/api/whitelist/remove?name={name}")
                subs.pop(name, None)
                app.logger.info("expired subscription revoked: %s", name)
        save_subs(subs)

threading.Thread(target=expire_check, daemon=True).start()

@app.route("/")
def index():
    subs = load_subs()
    return render_template("index.html", price=PRICE_USD, provider=PAYMENT_PROVIDER)

@app.route("/subscribe", methods=["POST"])
def subscribe():
    username = request.form.get("username", "").strip()
    if not username:
        return "username required", 400
    if PAYMENT_PROVIDER == "stripe":
        return jsonify({"error": "stripe checkout not configured yet"}), 501
    # XRP mode: show address + amount, payment must arrive
    return render_template("pay_xrp.html",
                           username=username,
                           address=XRP_ADDRESS,
                           amount_drops=XRP_AMOUNT_DROPS,
                           amount_xrp=XRP_AMOUNT_DROPS / 1e6)

@app.route("/verify_xrp", methods=["POST"])
def verify_xrp():
    username = request.form.get("username", "").strip()
    if not username:
        return "username required", 400
    if xrp_verify(XRP_ADDRESS, XRP_AMOUNT_DROPS):
        ok, _ = plugin_call("POST", f"/api/whitelist/add?name={username}")
        plugin_call("POST", f"/api/credits/add?name={username}&amount=100")
        subs = load_subs()
        subs[username] = {"paid_until": time.time() + SUB_DAYS * 86400,
                          "amount_drops": XRP_AMOUNT_DROPS,
                          "last_paid": int(time.time())}
        save_subs(subs)
        return jsonify({"status": "ok", "whitelisted": ok, "credits": 100,
                        "valid_until": subs[username]["paid_until"]})
    return jsonify({"status": "pending"}), 202

@app.route("/api/status")
def status():
    subs = load_subs()
    return jsonify({"provider": PAYMENT_PROVIDER, "subscriptions": len(subs)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
