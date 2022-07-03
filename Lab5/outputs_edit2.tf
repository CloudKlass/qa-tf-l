output "lambda_name" {
  description = "Name of the function."

  value = aws_lambda_function.hello.function_name
}

output "url" {
  description = "URL for API Gateway."

  value = aws_apigatewayv2_stage.lambda_lab5.invoke_url
}
