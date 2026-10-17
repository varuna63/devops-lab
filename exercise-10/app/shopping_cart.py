from flask import Flask, jsonify, request

app = Flask(__name__)
# Learning-demo storage only. Each replica has a separate in-memory cart.
cart = []


@app.get("/cart")
def get_cart():
    return jsonify(cart)


@app.post("/cart")
def add_to_cart():
    item = request.get_json(silent=True)
    if not isinstance(item, dict):
        return jsonify({"error": "Request body must be a JSON object"}), 400
    cart.append(item)
    return jsonify(cart), 201


@app.get("/health")
def health():
    return {"status": "healthy"}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
