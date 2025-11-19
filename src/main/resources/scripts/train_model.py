# 2_train_model.py
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score, f1_score, classification_report
import pickle

print("Đang đọc dữ liệu đã tiền xử lý...")
df = pd.read_csv('D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/preprocessed_train.csv')

X = df[['loai_su_kien_encoded', 'dia_diem_encoded', 'thoi_gian_diff_days']]
y = df['label']

# Chia train/test
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

print(f"Train: {X_train.shape}, Test: {X_test.shape}")

# Huấn luyện Decision Tree
model = DecisionTreeClassifier(
    max_depth=5,
    min_samples_split=10,
    min_samples_leaf=5,
    random_state=42
)
model.fit(X_train, y_train)

# Đánh giá
y_pred = model.predict(X_test)
print("Accuracy:", accuracy_score(y_test, y_pred))
print("F1-Score:", f1_score(y_test, y_pred))
print("\nClassification Report:\n", classification_report(y_test, y_pred))

# Lưu model
with open('D:/2022-2026/HOC KI 7/XD HTTT/modelTrained/dt_model.pkl', 'wb') as f:
    pickle.dump(model, f)

print("Model đã được lưu: modelTrained/dt_model.pkl")
print("Hoàn tất huấn luyện!")