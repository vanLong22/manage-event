import pandas as pd
from sklearn.preprocessing import LabelEncoder

df = pd.read_csv('D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/train.csv')
le_loai = LabelEncoder()
df['loai_su_kien_encoded'] = le_loai.fit_transform(df['loai_su_kien'])
le_dia = LabelEncoder()
df['dia_diem_encoded'] = le_dia.fit_transform(df['dia_diem'])
df = df[['user_id', 'event_id', 'label', 'loai_su_kien_encoded', 'dia_diem_encoded', 'thoi_gian_diff_days']]
df.to_csv('D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/preprocessed_data.csv', index=False)  # Sẵn cho train