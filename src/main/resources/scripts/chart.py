#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm
import io
import base64
from collections import Counter
from datetime import datetime
import traceback
import warnings

warnings.filterwarnings("ignore", category=UserWarning)

# Set font để hỗ trợ tiếng Việt và tránh missing glyph
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = ['Arial', 'DejaVuSans', 'Liberation Sans', 'Bitstream Vera Sans', 'sans-serif']
plt.rcParams['axes.unicode_minus'] = False
plt.rcParams['font.size'] = 12

def log_error(msg):
    print(f"ERROR: {msg}", file=sys.stderr)

try:
    if len(sys.argv) < 2:
        log_error("Thiếu tham số chart_type")
        sys.exit(1)
    chart_type = sys.argv[1]

    data_json = sys.stdin.read().strip()
    if not data_json:
        log_error("Không nhận được dữ liệu JSON từ stdin")
        sys.exit(1)

    data = json.loads(data_json)
    if not isinstance(data, list):
        log_error(f"Dữ liệu không phải list: {type(data)}")
        sys.exit(1)

    def save_to_base64(fig):
        buf = io.BytesIO()
        fig.savefig(buf, format='png', bbox_inches='tight', dpi=100)
        buf.seek(0)
        plt.close(fig)
        return base64.b64encode(buf.read()).decode('utf-8')

    fig, ax = plt.subplots(figsize=(10, 6))

    if chart_type == 'events_by_type':
        labels = [item.get('ten_loai', 'Unknown') for item in data]
        values = [item.get('count', 0) for item in data]
        ax.bar(labels, values, color='#2ecc71')
        ax.set_title('Số Lượng Sự Kiện Theo Loại')
        ax.set_xlabel('Loại Sự Kiện')
        ax.set_ylabel('Số Lượng')
        ax.tick_params(axis='x', rotation=45)

    elif chart_type == 'users_by_role':
        labels = [item.get('vai_tro', 'Unknown') for item in data]
        values = [item.get('count', 0) for item in data]
        ax.bar(labels, values, color='#4a6bff')
        ax.set_title('Số Lượng Người Dùng Theo Vai Trò')
        ax.set_xlabel('Vai Trò')
        ax.set_ylabel('Số Lượng')
        ax.tick_params(axis='x', rotation=45)

    elif chart_type == 'gender_pie':
        labels = [item.get('gioi_tinh', 'Unknown') for item in data]
        values = [item.get('count', 0) for item in data]
        ax.pie(values, labels=labels, autopct='%1.1f%%', colors=['#ff7b54', '#2ecc71', '#f39c12'])
        ax.set_title('Tỷ Lệ Giới Tính Người Dùng')

    elif chart_type == 'request_status_pie':
        labels = [item.get('trang_thai', 'Unknown') for item in data]
        values = [item.get('count', 0) for item in data]
        ax.pie(values, labels=labels, autopct='%1.1f%%', colors=['#f39c12', '#2ecc71', '#e74c3c'])
        ax.set_title('Tỷ Lệ Trạng Thái Yêu Cầu Đăng Sự Kiện')

    elif chart_type == 'registrations_line':
        dates = [item.get('ngay', 'Unknown') for item in data]
        values = [item.get('count', 0) for item in data]
        ax.plot(dates, values, marker='o', color='#ff7b54', linewidth=2)
        ax.set_title('Số Lượng Đăng Ký Sự Kiện Theo Thời Gian')
        ax.set_xlabel('Ngày/Tháng')
        ax.set_ylabel('Số Lượng')
        ax.tick_params(axis='x', rotation=45)
        ax.grid(True, alpha=0.3)

    else:
        log_error(f"Loại biểu đồ không hỗ trợ: {chart_type}")
        sys.exit(1)

    base64_img = save_to_base64(fig)
    print(base64_img)

except Exception as e:
    log_error(f"Python crash: {str(e)}")
    log_error(traceback.format_exc())
    sys.exit(1)