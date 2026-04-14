# Auto Scaling Group for Web/App EC2
# ---------------------------------------------------------
resource "aws_autoscaling_group" "web_asg" {
  #ASGの基本設定
  name                      = "web-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300

  #どのサブネットをEC2に置くか
  vpc_zone_identifier = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]
  #ALBのターゲットグループをASGに紐付ける
  target_group_arns = [
    aws_lb_target_group.web_tg.arn
  ]
  #Launch TemplateをASGに紐付ける
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
  #ASGのインスタンスにタグを付ける
  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}
