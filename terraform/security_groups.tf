# terraform/security_groups.tf

resource "aws_security_group_rule" "allow_alb_to_nodes" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1" # Allow all traffic
  security_group_id        = module.eks.node_security_group_id
  source_security_group_id = module.vpc.default_security_group_id
  description              = "Allow traffic from the ALB to the EKS nodes"
}