from prometheus_client import start_http_server, Summary, Gauge
import random
import time

# Metrics Definition
total_deliveries = Gauge("total_deliveries", "Total number of deliveries")
pending_deliveries = Gauge("pending_deliveries", "Number of pending deliveries")
on_the_way_deliveries = Gauge("on_the_way_deliveries", "Number of deliveries on the way")
average_delivery_time = Summary("average_delivery_time", "Average delivery time in seconds")

def simulate_alert_spike():
    # Spiking pending deliveries between 50 and 100 to breach alert threshold (> 10)
    pending = random.randint(50, 100)
    on_the_way = random.randint(5, 20)
    delivered = random.randint(30, 70)
    # Average delivery time exceeding 30s to trigger HighAverageDeliveryTime
    avg_time = random.uniform(35, 60)
    total = pending + on_the_way + delivered

    print(f"[ALERT-SIMULATION] Total: {total} | PENDING SPIKE: {pending} (threshold > 10) | Avg Time: {avg_time:.2f}s")

    total_deliveries.set(total)
    pending_deliveries.set(pending)
    on_the_way_deliveries.set(on_the_way)
    average_delivery_time.observe(avg_time)

if __name__ == "__main__":
    print("[INFO] Starting High-Load Alert Simulation on port 8000...")
    start_http_server(8000, addr="0.0.0.0")
    while True:
        simulate_alert_spike()
        time.sleep(1)
