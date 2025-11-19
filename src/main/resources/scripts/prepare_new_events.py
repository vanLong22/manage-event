# 3_prepare_new_events.py
import pandas as pd
import pickle

print("Đang tiền xử lý sự kiện mới (new_events.csv)...")
df_new = pd.read_csv('D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/new_events.csv')  # do Java export

# Load encoder đã train trước đó
with open('D:/2022-2026/HOC KI 7/XD HTTT/modelTrained/label_encoder_loai.pkl', 'rb') as f:
    le_loai = pickle.load(f)
with open('D:/2022-2026/HOC KI 7/XD HTTT/modelTrained/label_encoder_dia_diem.pkl', 'rb') as f:
    le_dia = pickle.load(f)

# Encode dùng cùng encoder cũ
df_new['loai_su_kien_encoded'] = le_loai.transform(df_new['loai_su_kien'])
df_new['dia_diem_encoded'] = le_dia.transform(df_new['dia_diem'])

# Chỉ giữ các cột cần thiết
df_final = df_new[['event_id', 'loai_su_kien_encoded', 'dia_diem_encoded', 'thoi_gian_diff_days']]

df_final.to_csv('D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/preprocessed_new_events.csv', index=False)
print("Đã tạo: dataForModel/preprocessed_new_events.csv")