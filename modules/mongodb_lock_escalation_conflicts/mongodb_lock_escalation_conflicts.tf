resource "shoreline_notebook" "mongodb_lock_escalation_conflicts" {
  name       = "mongodb_lock_escalation_conflicts"
  data       = file("${path.module}/data/mongodb_lock_escalation_conflicts.json")
  depends_on = [shoreline_action.invoke_mongodb_connection_optimization,shoreline_action.invoke_disable_mongodb_lock_escalation]
}

resource "shoreline_file" "mongodb_connection_optimization" {
  name             = "mongodb_connection_optimization"
  input_file       = "${path.module}/data/mongodb_connection_optimization.sh"
  md5              = filemd5("${path.module}/data/mongodb_connection_optimization.sh")
  description      = "Increase the number of available connections to the MongoDB server and optimize the queries to reduce contention and reduce the likelihood of lock escalation conflicts."
  destination_path = "/tmp/mongodb_connection_optimization.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "disable_mongodb_lock_escalation" {
  name             = "disable_mongodb_lock_escalation"
  input_file       = "${path.module}/data/disable_mongodb_lock_escalation.sh"
  md5              = filemd5("${path.module}/data/disable_mongodb_lock_escalation.sh")
  description      = "Configure MongoDB to use lock escalation sparingly or disable it altogether if it is causing too many conflicts."
  destination_path = "/tmp/disable_mongodb_lock_escalation.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_mongodb_connection_optimization" {
  name        = "invoke_mongodb_connection_optimization"
  description = "Increase the number of available connections to the MongoDB server and optimize the queries to reduce contention and reduce the likelihood of lock escalation conflicts."
  command     = "`chmod +x /tmp/mongodb_connection_optimization.sh && /tmp/mongodb_connection_optimization.sh`"
  params      = ["MONGODB_PORT","MAX_CONNECTIONS","MONGODB_USER","MONGODB_PASSWORD","MONGODB_HOST","BATCH_SIZE"]
  file_deps   = ["mongodb_connection_optimization"]
  enabled     = true
  depends_on  = [shoreline_file.mongodb_connection_optimization]
}

resource "shoreline_action" "invoke_disable_mongodb_lock_escalation" {
  name        = "invoke_disable_mongodb_lock_escalation"
  description = "Configure MongoDB to use lock escalation sparingly or disable it altogether if it is causing too many conflicts."
  command     = "`chmod +x /tmp/disable_mongodb_lock_escalation.sh && /tmp/disable_mongodb_lock_escalation.sh`"
  params      = []
  file_deps   = ["disable_mongodb_lock_escalation"]
  enabled     = true
  depends_on  = [shoreline_file.disable_mongodb_lock_escalation]
}

