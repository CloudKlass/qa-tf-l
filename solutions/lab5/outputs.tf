output "lambda_name" {
  description = "Name of the function."

  value = aws_lambda_function.hello.function_name
}
