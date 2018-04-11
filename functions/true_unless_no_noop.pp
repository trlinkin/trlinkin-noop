function noop::true_unless_no_noop() {
  $facts['noop_cli_value'] ? {
    false   => $facts['noop_cli_value'],
    default => true,
  }
}
