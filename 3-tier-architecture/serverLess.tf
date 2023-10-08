resource "aws_s3_bucket" "websiteStorage" {
  bucket = "website-1-bucket"
}

resource "aws_s3_object" "storage" {
  bucket = "${aws_s3_bucket.websiteStorage.bucket}"
  key    = "codeBase.zip"
  source = "website/"
}

resource "aws_lambda_function" "CRUDAPI" {
  function_name = "crudOperationsPreformer"
  s3_bucket = "${aws_s3_bucket.websiteStorage.bucket}"
  s3_key    = "${aws_s3_object.storage.source}/${aws_s3_object.storage.key}"
  handler = "main.handler"
  runtime = "nodejs16.x"

  role = "${aws_iam_role.lambda_exec.arn}"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_api_gateway_rest_api" "gateway" {
  name = "Website1Gateway"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.gateway.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri  = "${aws_lambda_function.CRUDAPI.invoke_arn}"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id   = "${aws_api_gateway_rest_api.gateway.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri  = "${aws_lambda_function.CRUDAPI.invoke_arn}"
}

resource "aws_api_gateway_deployment" "websiteGateway" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
}

resource "aws_api_gateway_stage" "websiteGateway" {
  deployment_id = aws_api_gateway_deployment.websiteGateway.id
  rest_api_id   = aws_api_gateway_rest_api.gateway.id
  stage_name    = "websiteGateway"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.CRUDAPI.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.gateway.execution_arn}/*/*"
}