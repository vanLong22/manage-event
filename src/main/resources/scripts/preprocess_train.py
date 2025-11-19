# 1_preprocess_train.py
import pandas as pd
from sklearn.preprocessing import LabelEncoder
import pickle
import os

print("Đang đọc train.csv...")
df = pd.read_csv('D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/train.csv')

print(f"Dữ liệu gốc: {df.shape}")
print(df.head())

# Encode categorical features
le_loai = LabelEncoder()
df['loai_su_kien_encoded'] = le_loai.fit_transform(df['loai_su_kien'])

le_dia = LabelEncoder()
df['dia_diem_encoded'] = le_dia.fit_transform(df['dia_diem'])

# Chọn cột cần thiết
df_final = df[['user_id', 'event_id', 'label', 
               'loai_su_kien_encoded', 'dia_diem_encoded', 'thoi_gian_diff_days']]

# Lưu file đã xử lý
df_final.to_csv('D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/preprocessed_train.csv', index=False)
print("Đã lưu: D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/preprocessed_train.csv")

# Lưu encoder để dùng lại khi predict
with open('D:/2022-2026/HOC KI 7/XD HTTT/modelTrained/label_encoder_loai.pkl', 'wb') as f:
    pickle.dump(le_loai, f)
with open('D:/2022-2026/HOC KI 7/XD HTTT/modelTrained/label_encoder_dia_diem.pkl', 'wb') as f:
    pickle.dump(le_dia, f)

print("Đã lưu 2 file encoder vào thư mục modelTrained/")