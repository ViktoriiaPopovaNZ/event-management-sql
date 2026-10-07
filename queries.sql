-- Enable foreign-key enforcement for this connection.
PRAGMA foreign_keys = ON;

-- 1. Outstanding client invoices, including partial payments.
SELECT
    Client.company_name,
    Event.title,
    Invoice.invoice_number,
    Invoice.total_amount,
    COALESCE(SUM(Payment.amount_paid), 0) AS amount_paid,
    Invoice.total_amount
        - COALESCE(SUM(Payment.amount_paid), 0) AS outstanding_amount
FROM Invoice
JOIN Event
    ON Invoice.event_id = Event.event_id
JOIN Client
    ON Event.client_id = Client.client_id
LEFT JOIN Payment
    ON Invoice.invoice_number = Payment.invoice_number
GROUP BY
    Invoice.invoice_number,
    Client.company_name,
    Event.title,
    Invoice.total_amount
HAVING outstanding_amount > 0
ORDER BY outstanding_amount DESC;

-- 2. Lowest invoiced revenue less selected event costs.
-- This is not complete accounting profit or cash received.
-- Aggregate each source before joining to avoid double counting.
SELECT
    Event.title,
    COALESCE(invoice_revenue.total_invoice_revenue, 0) AS event_revenue,
    COALESCE(service_costs.total_service_cost, 0) AS service_cost,
    COALESCE(speaker_costs.total_speaker_cost, 0) AS speaker_cost,
    COALESCE(invoice_revenue.total_invoice_revenue, 0)
        - COALESCE(service_costs.total_service_cost, 0)
        - COALESCE(speaker_costs.total_speaker_cost, 0) AS estimated_profit
FROM Event
LEFT JOIN (
    SELECT event_id, SUM(total_amount) AS total_invoice_revenue
    FROM Invoice
    GROUP BY event_id
) AS invoice_revenue
    ON Event.event_id = invoice_revenue.event_id
LEFT JOIN (
    SELECT event_id, SUM(quoted_cost) AS total_service_cost
    FROM Event_Service
    GROUP BY event_id
) AS service_costs
    ON Event.event_id = service_costs.event_id
LEFT JOIN (
    SELECT event_id, SUM(booking_fee) AS total_speaker_cost
    FROM Speaker_Booking
    GROUP BY event_id
) AS speaker_costs
    ON Event.event_id = speaker_costs.event_id
ORDER BY estimated_profit ASC
LIMIT 1;
