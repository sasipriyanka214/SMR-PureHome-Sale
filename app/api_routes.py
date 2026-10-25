from flask import Blueprint, jsonify, request


api_bp = Blueprint("api", __name__, url_prefix="/api")


@api_bp.route("/status", methods=["GET"])
def api_status():
    return jsonify(
        {
            "status": "success",
            "message": "SMR PureHome API is running successfully with Supabase!",
            "version": "V18",
        }
    )


@api_bp.route("/login", methods=["POST"])
def api_login():
    data = request.get_json(silent=True) or {}
    email = data.get("email") if isinstance(data, dict) else None
    password = data.get("password") if isinstance(data, dict) else None

    if not email or not password:
        return jsonify(
            {"status": "error", "message": "Email and password are required"}
        ), 400

    return jsonify(
        {"status": "success", "message": "API Login endpoint template ready"}
    )
