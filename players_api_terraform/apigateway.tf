locals {
  dev_port_number = 3000
  prd_port_number = 5000
}


# VPC link ################################################################################################
resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "vpclink"
  target_arns = [aws_lb.api_lb.arn]
}


# api key ################################################################################################
resource "aws_api_gateway_api_key" "mykey" {
  name = "mykey"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.mykey.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.example.id
}


# API ################################################################################################
resource "aws_api_gateway_rest_api" "players_api" {
  body = templatefile("players_api_3.json",
    {
      "vpc_link" = aws_api_gateway_vpc_link.vpc_link.id
      # "lb_dns"   = "http://${aws_lb.api_lb.dns_name}:5000/players"
  })

  name = "players_api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}


# deployment ################################################################################################
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.players_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.players_api.body)) #meaning redeploy when there is change in json file
  }

  lifecycle {
    create_before_destroy = true
  }
}


# STAGES ################################################################################################
resource "aws_api_gateway_stage" "development" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.players_api.id
  stage_name    = "development"

  variables = {
    VPC_LINK_URI_pl = "${aws_lb.api_lb.dns_name}:${local.dev_port_number}/players"
    VPC_LINK_URI_mi = "${aws_lb.api_lb.dns_name}:${local.dev_port_number}/moreinfo"
  }
}

resource "aws_api_gateway_stage" "production" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.players_api.id
  stage_name    = "production"

  variables = {
    VPC_LINK_URI_pl = "${aws_lb.api_lb.dns_name}:${local.prd_port_number}/players"
    VPC_LINK_URI_mi = "${aws_lb.api_lb.dns_name}:${local.dev_port_number}/moreinfo"
  }
}


# usage plan ################################################################################################
resource "aws_api_gateway_usage_plan" "example" {
  name         = "my-usage-plan"
  description  = "my description"
  product_code = "MYCODE"

  api_stages {
    api_id = aws_api_gateway_rest_api.players_api.id
    stage  = aws_api_gateway_stage.development.stage_name
  }

  api_stages {
    api_id = aws_api_gateway_rest_api.players_api.id
    stage  = aws_api_gateway_stage.production.stage_name
  }

  quota_settings {
    limit  = 20
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 1
    rate_limit  = 1
  }
}