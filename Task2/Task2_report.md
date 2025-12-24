# Домашнее задание 2: Установка и настройка ClickHouse

**Студент:** Баскаков Сергей

### Установка и запуск
Задание выполнялось на маке через Docker(ресурсы Docker'a: 4 CPU, 8 RAM).

Использовалась версия образа latest.

Запуск контейнера производился следующей командой:

```bash
docker run -d \
    --name clickhouse-server \
    --ulimit nofile=262144:262144 \
    -p 8123:8123 -p 9000:9000 \
    -v $(pwd)/data:/var/lib/clickhouse \
    -v $(pwd)/config.d:/etc/clickhouse-server/config.d \
    -v $(pwd)/users.d:/etc/clickhouse-server/users.d \
    clickhouse/clickhouse-server
```

## Тестирование производительности

Для тестирования использовалась утилита clickhouse-benchmark.
**Тестовый запрос:** Агрегация среднего чека по количеству пассажиров.
```sql
SELECT passenger_count, avg(total_amount) FROM trips GROUP BY passenger_count
```

**Результаты ДО оптимизации:**

Тест проводился на дефолтных настройках контейнера.

```text
localhost:9000, queries: 100, QPS: 70.527, RPS: 141030735.957, MiB/s: 672.487
result RPS: 705.275, result MiB/s: 0.006
```

*   **QPS (Queries Per Second):** 70.527
*   **Скорость обработки:** 672.487 MiB/s



#### **Изменения в users.d/my_settings.xml:**

max_threads = 4

max_memory_usage = 6GB (адаптировано под объем RAM)

#### **Изменения в config.d/my_server_config.xml:**

logger/level = warning.

*Причина:* снижает нагрузку на I/O подсистему и CPU.


### Результаты после оптимизации:

```text
localhost:9000, queries: 100, QPS: 83.051, RPS: 166072836.030, MiB/s: 791.897
result RPS: 830.507, result MiB/s: 0.007
```

*   **QPS:** 83.051
*   **Скорость обработки:** 791.897 MiB/s

### Итоговое сравнение

| Метрика | До настройки | После настройки | Прирост |
| :--- | :--- | :--- | :--- |
| QPS | 70.527 | 83.051 | +17.75% |
| MiB/s | 672.487 | 791.897 | +17.75% |

### Вывод
Корректировка конфигурации позволила увеличить производительность системы почти на 18%.
