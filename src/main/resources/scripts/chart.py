#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json
import matplotlib.pyplot as plt
import io
import base64
from collections import Counter
from datetime import datetime
import traceback

# CÀI ĐẶT: pip install python-dateutil
try:
    from dateutil import parser
except ImportError:
    print("ERROR: Thiếu thư viện python-dateutil. Cài bằng: pip install python-dateutil", file=sys.stderr)
    sys.exit(1)

def log(msg):
    print(f"[DEBUG] {msg}", file=sys.stderr)  # Chỉ in ra stderr

def log_error(msg):
    print(f"ERROR: {msg}", file=sys.stderr)  # Chỉ in ra stderr

try:
    # === 1. Đọc tham số ===
    if len(sys.argv) < 2:
        log_error("Thiếu tham số chart_type")
        sys.exit(1)
    chart_type = sys.argv[1]
    log(f"Chart type: {chart_type}")

    # === 2. Đọc JSON từ stdin ===
    data_json = sys.stdin.read().strip()
    if not data_json:
        log_error("Không nhận được dữ liệu JSON từ stdin")
        sys.exit(1)

    try:
        data = json.loads(data_json)
    except json.JSONDecodeError as e:
        log_error(f"JSON parse error: {e}\nData: {data_json[:200]}...")
        sys.exit(1)

    if not isinstance(data, list):
        log_error(f"Dữ liệu không phải list: {type(data)}")
        sys.exit(1)

    log(f"Loaded {len(data)} records")

    # === 3. Hàm lưu base64 ===
    def save_to_base64(fig):
        buf = io.BytesIO()
        fig.savefig(buf, format='png', bbox_inches='tight', dpi=100)
        buf.seek(0)
        plt.close(fig)
        return base64.b64encode(buf.read()).decode('utf-8')

    fig, ax = plt.subplots(figsize=(10, 6))

    # === 4. XỬ LÝ TỪNG LOẠI BIỂU ĐỒ ===
    if chart_type == 'events_by_status':
        if not data:
            log_error("Không có dữ liệu sự kiện")
            sys.exit(1)
        statuses = [event.get('trangThai', 'Unknown') for event in data]
        status_count = Counter(statuses)
        labels = list(status_count.keys())
        values = list(status_count.values())
        ax.bar(labels, values, color=['#2ecc71', '#f39c12', '#e74c3c', '#95a5a6'])
        ax.set_title('Số Lượng Sự Kiện Theo Trạng Thái')
        ax.set_xlabel('Trạng Thái')
        ax.set_ylabel('Số Lượng')
        ax.tick_params(axis='x', rotation=45)

    elif chart_type == 'registrations_by_event':
        events = [event.get('tenSuKien', 'Unknown') for event in data]
        registrations = [event.get('soLuongDaDangKy', 0) for event in data]
        ax.bar(events, registrations, color='#4a6bff')
        ax.set_title('Số Lượng Đăng Ký Theo Sự Kiện')
        ax.set_xlabel('Sự Kiện')
        ax.set_ylabel('Đăng Ký')
        ax.tick_params(axis='x', rotation=45)

    elif chart_type == 'registrations_over_time':
        times = []
        for reg in data:
            time_val = reg.get('thoiGianDangKy')
            if time_val is None:
                continue

            try:
                if isinstance(time_val, (int, float)):
                    # Timestamp (ms)
                    dt = datetime.fromtimestamp(time_val / 1000)
                else:
                    # Chuỗi ngày giờ (bất kỳ format nào)
                    dt = parser.isoparse(str(time_val).split('+')[0].split('Z')[0])
                times.append(dt.strftime('%Y-%m'))
            except Exception as e:
                log(f"Không parse được thời gian: {time_val} -> {e}")
                continue

        if not times:
            log_error("Không có dữ liệu thời gian hợp lệ")
            sys.exit(1)

        month_count = Counter(times)
        sorted_months = sorted(month_count.keys())
        values = [month_count[m] for m in sorted_months]

        ax.plot(sorted_months, values, marker='o', color='#ff7b54', linewidth=2)
        ax.set_title('Đăng Ký Theo Thời Gian')
        ax.set_xlabel('Tháng')
        ax.set_ylabel('Số Lượng')
        ax.tick_params(axis='x', rotation=45)
        ax.grid(True, alpha=0.3)

    else:
        log_error(f"Loại biểu đồ không hỗ trợ: {chart_type}")
        sys.exit(1)

    # === 5. XUẤT BASE64 (CHỈ DÒNG NÀY RA STDOUT) ===
    base64_img = save_to_base64(fig)
    print(base64_img)  # DUY NHẤT DÒNG NÀY RA STDOUT! Không in gì khác

except Exception as e:
    log_error(f"Python crash: {str(e)}")
    log_error(traceback.format_exc())
    sys.exit(1)