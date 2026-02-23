{ ... }:

{
  # Keeps memory usage down for idle connections
  services.postgresql.settings.idle_in_transaction_session_timeout = "15min";
}
