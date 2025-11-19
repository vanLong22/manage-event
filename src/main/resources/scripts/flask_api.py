# 4_flask_api.py
from flask import Flask, request, jsonify
import pandas as pd
import pickle

app = Flask(__name__)

# Load model và dữ liệu mới khi khởi động
print("Đang tải model và dữ liệu sự kiện mới...")
model = pickle.load(open('D:/2022-2026/HOC KI 7/XD HTTT/modelTrained/dt_model.pkl', 'rb'))
df_events = pd.read_csv('D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/preprocessed_new_events.csv')
print(f"Đã tải {len(df_events)} sự kiện để gợi ý.")

@app.route('/suggest', methods=['POST'])
def suggest():
    try:
        data = request.get_json()
        user_id = data.get('user_id')
        
        if not user_id:
            return jsonify({"error": "user_id is required"}), 400

        X_new = df_events[['loai_su_kien_encoded', 'dia_diem_encoded', 'thoi_gian_diff_days']]
        
        # Dự đoán xác suất
        probs = model.predict_proba(X_new)[:, 1]  # cột 1 = xác suất label=1
        
        df_events['score'] = probs
        # Lấy top 10 sự kiện có điểm cao nhất
        top_events = df_events.nlargest(10, 'score')
        
        result = top_events['event_id'].astype(int).tolist()
        
        return jsonify({
            "user_id": user_id,
            "suggested_events": result,
            "total": len(result)
        })
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health')
def health():
    return jsonify({"status": "OK"})

if __name__ == '__main__':
    print("API đang chạy tại http://127.0.0.1:5000")
    print("Test: curl -X POST http://127.0.0.1:5000/suggest -H 'Content-Type: application/json' -d '{\"user_id\": 123}'")
    app.run(host='0.0.0.0', port=5000, debug=False)