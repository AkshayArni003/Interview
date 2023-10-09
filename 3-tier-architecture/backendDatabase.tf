resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "aurora-cluster-postgres"
  engine                  = "aurora-postgresql"
  database_name           = "Master"
  master_username         = "AWSAdmin"
  master_password         = "Passw0rd123"
  backup_retention_period = 5
}

resource "aws_rds_cluster_instance" "instance1" {
  apply_immediately  = true
  cluster_identifier = aws_rds_cluster.postgresql.id
  identifier         = "instance1"
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.postgresql.engine
  engine_version     = aws_rds_cluster.postgresql.engine_version
}

resource "aws_rds_cluster_instance" "instance2" {
  apply_immediately  = true
  cluster_identifier = aws_rds_cluster.postgresql.id
  identifier         = "instance2"
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.postgresql.engine
  engine_version     = aws_rds_cluster.postgresql.engine_version
}

resource "aws_rds_cluster_endpoint" "eligible" {
  cluster_identifier          = aws_rds_cluster.postgresql.id
  cluster_endpoint_identifier = "reader"
  custom_endpoint_type        = "READER"

  excluded_members = [
    aws_rds_cluster_instance.instance1.id,
    aws_rds_cluster_instance.instance2.id,
  ]
}

resource "aws_rds_cluster_endpoint" "static" {
  cluster_identifier          = aws_rds_cluster.postgresql.id
  cluster_endpoint_identifier = "static"
  custom_endpoint_type        = "READER"

  static_members = [
    aws_rds_cluster_instance.instance1.id
  ]
}
