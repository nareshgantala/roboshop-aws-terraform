resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = var.component
  type    = "A"
  ttl     = 300
  records = [var.record]
}