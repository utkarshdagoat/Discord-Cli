bool isServerNameTaken(dynamic e) {
  return e.toString().contains(
      'duplicate key value violates unique constraint "servers_server_name_key" Detai');
}
