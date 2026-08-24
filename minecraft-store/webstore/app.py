from flask import Flask, render_template, request, jsonify
import os, requests, time, hashlib, logging

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

# Config
PLUGIN_URL = os.getenv("PLUGIN_URL", "http://minecraft-plugin:8090")
PLUGIN_TOKEN = os.getenv("PLUGIN_TOKEN", "changeme")
PRICE_USD = float(os.getenv("PRICE_USD", "5.00"))
PAYMENT_PROVIDER = os.getenv("PAYMENT_PROVIDER", "xrp")  # xrp | stripe

# XRP config
XRP_ADDRESS = os.getenv("XRP_ADDRESS", "")  # seller wallet (receiving)
XRP_AMOUNT_DROPS = int(os.getenv("XRP_AMOUNT_DROPS", "5000000"))  # 5 XRP = 5,000,000 drops
XRP_NODE = os.getenv("XRP_NODE", "https://s1.ripple.com:51234")

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
                    and not t.get("validated") in (False, None)):
                return True
    except Exception as e:
        app.logger.error("xrp verify failed: %s", e)
    return False

@app.route("/")
def index():
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
    if xrp_verify(XRP_ADDRESS, XRP_AMOUNT_DROPS):
        ok, _ = plugin_call("POST", "/api/whitelist/add", {"name": username})
        plugin_call("POST", "/api/credits/add", {"name": username, "amount": 100})
        return jsonify({"status": "ok", "whitelisted": ok, "credits": 100})
    return jsonify({"status": "pending"}), 202

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
