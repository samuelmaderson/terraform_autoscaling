output "lb_dns" {
    description = "dns name of load balance"
    value       = aws_elb.prodweb.dns_name
}
