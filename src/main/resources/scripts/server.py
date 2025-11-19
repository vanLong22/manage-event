# train_and_save_model.py
import pandas as pd
import pickle
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier  # TỐT HƠN Decision Tree đơn
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from sklearn.model_selection import train_test_split


import pandas as pd

df_preprocessed = pd.read_csv('preprocessed_data.csv')
print("Shape of data:", df_preprocessed.shape)  # Kiểm tra số hàng/cột
print("Head of data:\n", df_preprocessed.head())  # Xem sample
print("Missing values:\n", df_preprocessed.isnull().sum())  # Kiểm tra null
print("Label distribution:\n", df_preprocessed['label'].value_counts(normalize=True))  # Kiểm tra imbalance (nên ~50% label=1 nếu balanced)
print("Unique values in encoded columns:\n", df_preprocessed['loai_su_kien_encoded'].unique())  # Xác nhận encode đúng

#chia train-test 
X = df_preprocessed[['loai_su_kien_encoded', 'dia_diem_encoded', 'thoi_gian_diff_days']]  # Features
y = df_preprocessed['label']  # Target

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)  # Stratify để giữ tỷ lệ label
print("Train size:", X_train.shape, "Test size:", X_test.shape)

#huấn luyện mô hình
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score, f1_score, classification_report
import pickle

# Train
model = DecisionTreeClassifier(max_depth=3, random_state=42)  # Giới hạn depth để đơn giản
model.fit(X_train, y_train)

# Đánh giá trên test set
y_pred = model.predict(X_test)
print("Accuracy:", accuracy_score(y_test, y_pred))
print("F1-Score:", f1_score(y_test, y_pred))
print("Classification Report:\n", classification_report(y_test, y_pred))

# Save model
with open('dt_model.pkl', 'wb') as f:
    pickle.dump(model, f)
print("Model saved to dt_model.pkl")