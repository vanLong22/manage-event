# 4_flask_api.py - Phiên bản cá nhân hóa per-user
from flask import Flask, request, jsonify
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
import os
import pickle

app = Flask(__name__)

# Load tất cả sự kiện sắp diễn ra (đã được preprocess: encoded + thoi_gian_diff_days)
df_events = pd.read_csv('D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/preprocessed_new_events.csv')

# Thư mục lưu lịch sử từng user (do Java export)
HISTORY_DIR = 'D:/2022-2026/HOC KI 7/XD HTTT/quanLySuKien/demo/src/main/webapp/static/csv/'

# Load encoders (để encode history)
with open('D:/2022-2026/HOC KI 7/XD HTTT/modelTrained/label_encoder_loai.pkl', 'rb') as f:
    le_loai = pickle.load(f)
with open('D:/2022-2026/HOC KI 7/XD HTTT/modelTrained/label_encoder_dia_diem.pkl', 'rb') as f:
    le_dia = pickle.load(f)

@app.route('/suggest', methods=['POST'])
def suggest():
    try:
        data = request.get_json()
        user_id = data.get('user_id')
        print(f"Received suggestion request for user_id: {user_id}")
        
        if not user_id:
            return jsonify({"error": "user_id is required"}), 400

        history_file = os.path.join(HISTORY_DIR, f"user_{user_id}_history.csv")
        
        # 1. Trường hợp user có lịch sử
        if os.path.exists(history_file):
            df_history = pd.read_csv(history_file)
            
            # Encode history (thêm cột encoded)
            df_history['loai_su_kien_encoded'] = le_loai.transform(df_history['loai_su_kien'])
            df_history['dia_diem_encoded'] = le_dia.transform(df_history['dia_diem'])
            
            # Chỉ lấy các sự kiện đã tham gia thành công (label=1)
            df_positive = df_history[df_history['label'] == 1]
            
            if not df_positive.empty:
                # Tính profile trung bình của user
                user_profile = df_positive[['loai_su_kien_encoded', 'dia_diem_encoded', 'thoi_gian_diff_days']].mean().values
                user_profile = user_profile.reshape(1, -1)
                
                # Tính similarity với tất cả sự kiện mới
                X_events = df_events[['loai_su_kien_encoded', 'dia_diem_encoded', 'thoi_gian_diff_days']].values
                scores = cosine_similarity(X_events, user_profile).flatten()
                
                df_events['score'] = scores
                top_events = df_events.nlargest(10, 'score')
                suggested = top_events['event_id'].astype(int).tolist()
                
                return jsonify({
                    "user_id": user_id,
                    "suggested_events": suggested,
                    "source": "personalized"  # debug
                })

        # 2. Fallback: User mới hoặc chưa có lịch sử → gợi ý phổ biến nhất
        # Sắp xếp theo số lượng đăng ký hiện tại (giả sử có cột so_luong_da_dang_ky trong df_events)
        # Nếu không có, dùng random hoặc top theo thời gian gần
        top_popular = df_events.nlargest(10, 'so_luong_da_dang_ky') if 'so_luong_da_dang_ky' in df_events.columns else df_events.head(10)
        suggested = top_popular['event_id'].astype(int).tolist()
        
        return jsonify({
            "user_id": user_id,
            "suggested_events": suggested,
            "source": "popular_fallback"
        })
        
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)