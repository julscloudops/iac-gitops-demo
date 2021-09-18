output "kibana_sc_id" {
    value = aws_security_group.kibana.id
}

output "elasticsearch_sc_id" {
    value = aws_security_group.elasticsearch.id
}