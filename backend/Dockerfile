# 🐳 Dockerfile для FastAPI (без проблем с правами)

# === Этап 1: Сборка ===
FROM python:3.11-slim AS builder

WORKDIR /app

# Установка зависимостей для psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Копируем и устанавливаем зависимости ГЛОБАЛЬНО (без --user)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# === Этап 2: Финальный образ ===
FROM python:3.11-slim

WORKDIR /app

# Runtime-зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Создаём безопасного пользователя
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Копируем зависимости и код
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --chown=appuser:appgroup . .

# Переключаемся на appuser
USER appuser

# Запуск
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]