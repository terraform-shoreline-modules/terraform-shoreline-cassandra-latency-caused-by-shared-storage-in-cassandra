resource "shoreline_notebook" "latency_caused_by_shared_storage_in_cassandra" {
  name       = "latency_caused_by_shared_storage_in_cassandra"
  data       = file("${path.module}/data/latency_caused_by_shared_storage_in_cassandra.json")
  depends_on = [shoreline_action.invoke_ping_cassandra_nodes,shoreline_action.invoke_cassandra_storage_migration]
}

resource "shoreline_file" "ping_cassandra_nodes" {
  name             = "ping_cassandra_nodes"
  input_file       = "${path.module}/data/ping_cassandra_nodes.sh"
  md5              = filemd5("${path.module}/data/ping_cassandra_nodes.sh")
  description      = "Check the network latency between Cassandra nodes"
  destination_path = "/agent/scripts/ping_cassandra_nodes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cassandra_storage_migration" {
  name             = "cassandra_storage_migration"
  input_file       = "${path.module}/data/cassandra_storage_migration.sh"
  md5              = filemd5("${path.module}/data/cassandra_storage_migration.sh")
  description      = "Split the shared storage into separate storage units to reduce contention for resources. It is recommended to avoid shared storage like EBS, SAN, NAS. Shared storage degrades performance and creates a single point of failure."
  destination_path = "/agent/scripts/cassandra_storage_migration.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ping_cassandra_nodes" {
  name        = "invoke_ping_cassandra_nodes"
  description = "Check the network latency between Cassandra nodes"
  command     = "`chmod +x /agent/scripts/ping_cassandra_nodes.sh && /agent/scripts/ping_cassandra_nodes.sh`"
  params      = ["CASSANDRA_NODE2","CASSANDRA_NODE1"]
  file_deps   = ["ping_cassandra_nodes"]
  enabled     = true
  depends_on  = [shoreline_file.ping_cassandra_nodes]
}

resource "shoreline_action" "invoke_cassandra_storage_migration" {
  name        = "invoke_cassandra_storage_migration"
  description = "Split the shared storage into separate storage units to reduce contention for resources. It is recommended to avoid shared storage like EBS, SAN, NAS. Shared storage degrades performance and creates a single point of failure."
  command     = "`chmod +x /agent/scripts/cassandra_storage_migration.sh && /agent/scripts/cassandra_storage_migration.sh`"
  params      = ["NEW_STORAGE_PATH","SHARED_STORAGE","SHARED_STORAGE_PATH"]
  file_deps   = ["cassandra_storage_migration"]
  enabled     = true
  depends_on  = [shoreline_file.cassandra_storage_migration]
}

